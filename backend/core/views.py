import random
import os
from django.core.cache import cache
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from rest_framework import status
from django.core.mail import send_mail
from django.contrib.auth import get_user_model
import resend

User = get_user_model()

@api_view(['POST'])
@permission_classes([AllowAny])
def send_otp(request):
    """
    Generates a 6-digit OTP, saves it to Django cache for 10 minutes,
    and sends it to the user's email using Resend (or prints to console in dev).
    """
    email = request.data.get('email')
    is_password_reset = request.data.get('is_password_reset', False)
    
    if not email:
        return Response({'detail': 'Email is required.'}, status=status.HTTP_400_BAD_REQUEST)

    if is_password_reset:
        if not User.objects.filter(email=email).exists():
            return Response({'detail': "Email hasn't been registered."}, status=status.HTTP_404_NOT_FOUND)

    # Generate a random 6-digit code
    otp = str(random.randint(100000, 999999))
    
    # Save the OTP in the cache with the email as part of the key. Expiry is 600 seconds (10 minutes)
    cache_key = f"otp_{email}"
    cache.set(cache_key, otp, timeout=600)

    resend_api_key = os.environ.get("RESEND_API_KEY")

    # If the user has a real Resend API key, try using it
    if resend_api_key and "YOUR_RESEND_API_KEY" not in resend_api_key:
        resend.api_key = resend_api_key
        try:
            # Send the email
            resend.Emails.send({
                # Change this to a verified domain on Resend later; "onboarding@resend.dev" only works if sending to the registered Resend account email
                "from": "Acme <onboarding@resend.dev>",
                "to": email,
                "subject": "Your SwiftTrip Verification Code",
                "html": f"""
                    <div style="font-family: Arial, sans-serif; text-align: center;">
                        <h2>SwiftTrip Verification</h2>
                        <p>Your 6-digit verification code is:</p>
                        <h1 style="color: #2B99E3; letter-spacing: 5px;">{otp}</h1>
                        <p>This code will expire in 10 minutes.</p>
                    </div>
                """
            })
            return Response({'detail': 'Verification code sent to your email.'}, status=status.HTTP_200_OK)
        except Exception as e:
            print(f"Resend error: {e}")
            return Response({'detail': 'Failed to send verification email via Resend.'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    else:
        # Fallback to Django console email backend
        try:
            send_mail(
                subject='Your SwiftTrip Verification Code',
                message=f'Your 6-digit verification code is: {otp}\n\nThis code will expire in 10 minutes.',
                from_email='onboarding@swifttrip.com',
                recipient_list=[email],
                fail_silently=False,
            )
            print("OTP processed locally via console because RESEND_API_KEY is missing or invalid.")
            return Response({'detail': 'Verification code processed locally.'}, status=status.HTTP_200_OK)
        except Exception as e:
            print(f"Django send_mail error: {e}")
            return Response({'detail': 'Failed to send verification code locally.'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(['POST'])
@permission_classes([AllowAny])
def verify_otp(request):
    """
    Checks if the submitted 6-digit code matches the one cached for the email.
    """
    email = request.data.get('email')
    otp = request.data.get('otp')

    if not email or not otp:
        return Response({'detail': 'Email and OTP are required.'}, status=status.HTTP_400_BAD_REQUEST)

    cache_key = f"otp_{email}"
    cached_otp = cache.get(cache_key)

    if not cached_otp:
        return Response({'detail': 'The verification code has expired or was not requested.'}, status=status.HTTP_400_BAD_REQUEST)

    if str(cached_otp) == str(otp):
        # Set a short-lived verified token/flag so we can securely update the password next
        cache.set(f"pwd_reset_verified_{email}", True, timeout=600)
        # Keeping the OTP in cache so it can be verified again during the 10min window
        # in case the user encounters validation errors further down the flow (e.g. signup)
        
        return Response({'detail': 'Email verified successfully.'}, status=status.HTTP_200_OK)
    else:
        return Response({'detail': 'Invalid verification code.'}, status=status.HTTP_400_BAD_REQUEST)

from django.contrib.auth import get_user_model

@api_view(['POST'])
@permission_classes([AllowAny])
def update_password(request):
    """
    Updates the user's password using the provided email and new password.
    Requires that the email was successfully verified via OTP recently.
    """
    email = request.data.get('email')
    new_password = request.data.get('new_password')

    if not email or not new_password:
        return Response({'detail': 'Email and new password are required.'}, status=status.HTTP_400_BAD_REQUEST)

    verified_key = f"pwd_reset_verified_{email}"
    if not cache.get(verified_key):
        return Response({'detail': 'Unauthorized. Please verify your OTP first.'}, status=status.HTTP_403_FORBIDDEN)

    User = get_user_model()
    try:
        user = User.objects.get(email=email)
        user.set_password(new_password)
        user.save()
        # Remove the verification flag so it can't be reused immediately
        cache.delete(verified_key)
        return Response({'detail': 'Password updated successfully.'}, status=status.HTTP_200_OK)
    except User.DoesNotExist:
        return Response({'detail': 'User with this email not found.'}, status=status.HTTP_404_NOT_FOUND)


@api_view(['DELETE'])
@permission_classes([IsAuthenticated])
def delete_account(request):
    user = request.user
    try:
        user.delete() 
        return Response({"detail": "User deleted successfully."}, status=204)
    except Exception as e:
        return Response({"detail": str(e)}, status=500)