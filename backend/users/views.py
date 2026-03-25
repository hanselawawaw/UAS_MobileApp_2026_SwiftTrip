import random
import os
from django.core.cache import cache
from django.contrib.auth import get_user_model, authenticate
from django.core.mail import send_mail
from rest_framework import viewsets, status, permissions
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework_simplejwt.tokens import RefreshToken
import resend

from .serializers import (
    UserSerializer, RegisterSerializer, LoginSerializer,
    OTPSerializer, OTPVerifySerializer, PasswordResetSerializer,
    ProfileUpdateSerializer
)

User = get_user_model()

class AuthViewSet(viewsets.GenericViewSet):
    permission_classes = [permissions.AllowAny]

    @action(detail=False, methods=['post'], url_path='send-otp')
    def send_otp(self, request):
        serializer = OTPSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        email = serializer.validated_data['email']
        is_password_reset = serializer.validated_data['is_password_reset']

        if is_password_reset and not User.objects.filter(email=email).exists():
            return Response({'detail': "Email hasn't been registered."}, status=status.HTTP_404_NOT_FOUND)

        otp = str(random.randint(100000, 999999))
        cache.set(f"otp_{email}", otp, timeout=600)

        # Resend Email Integration
        resend_api_key = os.environ.get("RESEND_API_KEY")
        if resend_api_key and "YOUR_RESEND_API_KEY" not in resend_api_key:
            resend.api_key = resend_api_key
            try:
                resend.Emails.send({
                    "from": "SwiftTrip <onboarding@resend.dev>",
                    "to": email,
                    "subject": "Your SwiftTrip Verification Code",
                    "html": f"<h1>{otp}</h1><p>Your code is valid for 10 minutes.</p>"
                })
                return Response({'detail': 'Verification code sent.'})
            except Exception as e:
                return Response({'detail': f'Resend error: {str(e)}'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        else:
            # Console Fallback
            send_mail(
                'Your SwiftTrip Verification Code',
                f'Your code is: {otp}',
                'onboarding@swifttrip.com',
                [email],
                fail_silently=False,
            )
            return Response({'detail': 'Verification code processed locally.'})

    @action(detail=False, methods=['post'], url_path='verify-otp')
    def verify_otp(self, request):
        serializer = OTPVerifySerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        email = serializer.validated_data['email']
        otp = serializer.validated_data['otp']
        
        cached_otp = cache.get(f"otp_{email}")
        if cached_otp and str(cached_otp) == str(otp):
            cache.set(f"pwd_reset_verified_{email}", True, timeout=600)
            return Response({'detail': 'Email verified successfully.'})
        return Response({'detail': 'Invalid or expired code.'}, status=status.HTTP_400_BAD_REQUEST)

    @action(detail=False, methods=['post'], url_path='registration')
    def register(self, request):
        serializer = RegisterSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.save()
        refresh = RefreshToken.for_user(user)
        return Response({
            'refresh': str(refresh),
            'access': str(refresh.access_token),
            'user': UserSerializer(user).data
        }, status=status.HTTP_201_CREATED)

    @action(detail=False, methods=['post'], url_path='login')
    def login(self, request):
        serializer = LoginSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        user = authenticate(email=serializer.validated_data['email'], password=serializer.validated_data['password'])
        if user:
            refresh = RefreshToken.for_user(user)
            return Response({
                'refresh': str(refresh),
                'access': str(refresh.access_token),
                'user': UserSerializer(user).data
            })
        return Response({'detail': 'Invalid credentials.'}, status=status.HTTP_401_UNAUTHORIZED)

    @action(detail=False, methods=['post'], url_path='update-password')
    def update_password(self, request):
        serializer = PasswordResetSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        email = serializer.validated_data['email']
        if not cache.get(f"pwd_reset_verified_{email}"):
            return Response({'detail': 'OTP verification required.'}, status=status.HTTP_403_FORBIDDEN)
        
        user = User.objects.filter(email=email).first()
        if user:
            user.set_password(serializer.validated_data['new_password'])
            user.save()
            cache.delete(f"pwd_reset_verified_{email}")
            return Response({'detail': 'Password updated successfully.'})
        return Response({'detail': 'User not found.'}, status=status.HTTP_404_NOT_FOUND)

    @action(detail=False, methods=['get', 'patch'], url_path='user', permission_classes=[permissions.IsAuthenticated])
    def user_profile(self, request):
        if request.method == 'GET':
            serializer = UserSerializer(request.user)
            return Response(serializer.data)
        
        # PATCH
        serializer = ProfileUpdateSerializer(request.user, data=request.data, partial=True, context={'request': request})
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(serializer.data)

    @action(detail=False, methods=['delete'], url_path='delete-account', permission_classes=[permissions.IsAuthenticated])
    def delete_account(self, request):
        request.user.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)

class RequestProfileUpdateView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        new_name = request.data.get('full_name')
        new_email = request.data.get('email')
        user = request.user

        # 1. Update Name Immediately
        if new_name:
            user.first_name = new_name
            user.save()

        # 2. Check if Email is actually different
        if new_email and new_email != user.email:
            otp = str(random.randint(100000, 999999))
            # Store in cache for 10 mins: { 'user_1_pending_email': 'new@mail.com', 'user_1_otp': '123456' }
            cache.set(f"user_{user.id}_pending_email", new_email, timeout=600)
            cache.set(f"user_{user.id}_otp", otp, timeout=600)

            send_mail(
                'Verify Your New Email',
                f'Your SwiftTrip OTP is: {otp}',
                None,
                [new_email]
            )
            return Response({"message": "OTP sent to new email", "step": "verify_otp"})

        return Response({"message": "Profile updated successfully", "step": "completed"})