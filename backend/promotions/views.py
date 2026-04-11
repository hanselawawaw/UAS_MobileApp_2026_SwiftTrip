from rest_framework import generics, status
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from .models import Promotion
from .serializers import PromotionSerializer


class PromotionListView(generics.ListAPIView):
    """Returns only promotions the authenticated user has collected."""
    serializer_class = PromotionSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        """Returns only promotions the authenticated user has collected."""
        return Promotion.objects.filter(collected_by=self.request.user)


class CollectCouponView(APIView):
    """POST { "code": "RAYA10" } — adds the coupon to the user's collection."""
    permission_classes = [IsAuthenticated]

    def post(self, request):
        code = request.data.get('code', '').strip()
        if not code:
            return Response(
                {'detail': 'Coupon code is required.'},
                status=status.HTTP_400_BAD_REQUEST,
            )

        try:
            promotion = Promotion.objects.get(code__iexact=code)
        except Promotion.DoesNotExist:
            return Response(
                {'detail': 'Coupon not found.'},
                status=status.HTTP_404_NOT_FOUND,
            )

        promotion.collected_by.add(request.user)
        return Response({'detail': 'Coupon collected successfully.'})
