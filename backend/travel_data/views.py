from rest_framework import viewsets, views, status, permissions
from rest_framework.response import Response
from rest_framework.decorators import action
from .models import Destination, Recommendation, Schedule, Coupon, RideOption, UserFavorite
from .serializers import (
    DestinationSerializer, RecommendationSerializer, 
    ScheduleSerializer, CouponSerializer, RideOptionSerializer
)

class HomeView(views.APIView):
    """
    Returns recommendations and schedules for the home screen.
    """
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        recommendations = Recommendation.objects.all()
        schedules = Schedule.objects.filter(user=request.user)
        
        return Response({
            'recommendations': RecommendationSerializer(recommendations, many=True).data,
            'schedules': ScheduleSerializer(schedules, many=True).data
        })

class DestinationViewSet(viewsets.ReadOnlyModelViewSet):
    """
    ViewSet for viewing and favoriting destinations.
    """
    queryset = Destination.objects.all()
    serializer_class = DestinationSerializer
    permission_classes = [permissions.IsAuthenticatedOrReadOnly]

    def get_queryset(self):
        queryset = super().get_queryset()
        category_label = self.request.query_params.get('category')
        if category_label:
            queryset = queryset.filter(category__iexact=category_label)
        
        is_hot = self.request.query_params.get('is_hot')
        if is_hot:
            queryset = queryset.filter(is_hot=True)

        has_discount = self.request.query_params.get('has_discount')
        if has_discount:
            queryset = queryset.filter(has_discount=True)

        return queryset

    @action(detail=True, methods=['post'], permission_classes=[permissions.IsAuthenticated])
    def favorite(self, request, pk=None):
        destination = self.get_object()
        favorite, created = UserFavorite.objects.get_or_create(user=request.user, destination=destination)
        
        if not created:
            favorite.delete()
            return Response({'isFavorite': False}, status=status.HTTP_200_OK)
        
        return Response({'isFavorite': True}, status=status.HTTP_201_CREATED)

from .services.amadeus_service import AmadeusService

class SearchView(views.APIView):
    """
    Returns search-related data: ride options, coupons, and structured flight search.
    """
    permission_classes = [permissions.IsAuthenticatedOrReadOnly]

    def get(self, request):
        origin = request.query_params.get('origin')
        destination = request.query_params.get('destination')
        date = request.query_params.get('date')
        
        if origin and destination and date:
            if len(origin) != 3 or len(destination) != 3:
                return Response(
                    {'error': 'origin and destination must be 3-letter IATA codes'}, 
                    status=status.HTTP_400_BAD_REQUEST
                )
                
            passengers = request.query_params.get('passengers', 1)
            travel_class = request.query_params.get('class', 'ECONOMY')
            
            amadeus = AmadeusService()
            flights = amadeus.search_flights(origin, destination, date, passengers, travel_class)
            return Response({'flights': flights})

        # Base behavior
        rides = RideOption.objects.all()
        coupons = Coupon.objects.all()
        
        return Response({
            'rideOptions': RideOptionSerializer(rides, many=True).data,
            'coupons': CouponSerializer(coupons, many=True).data
        })
