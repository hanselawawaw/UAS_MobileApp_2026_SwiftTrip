from rest_framework import viewsets, status, decorators
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated, AllowAny
from django.db.models import Q
from .models import Booking, PurchaseItem, Destination, Wishlist
from .serializers import CartTicketSerializer, CheckoutDetailsSerializer, DestinationSerializer

class BookingViewSet(viewsets.ModelViewSet):
    permission_classes = [IsAuthenticated]
    queryset = Booking.objects.all()

    def get_queryset(self):
        return self.queryset.filter(user=self.request.user)

    @decorators.action(detail=False, methods=['get'])
    def cart(self, request):
        cart_items = self.get_queryset().filter(status='IN_CART')
        serializer = CartTicketSerializer(cart_items, many=True)
        return Response(serializer.data)

    @decorators.action(detail=False, methods=['post'], url_path='cart/add')
    def add_to_cart(self, request):
        # In a real app, we'd validate against real travel data
        # Here we'll just create a booking from the provided data
        
        booking = Booking.objects.create(
            user=request.user,
            status='IN_CART',
            booking_type=request.data.get('booking_type', 'TRAIN_TICKET'),
            price_rp=request.data.get('price_rp', 0),
            from_location=request.data.get('from'),
            to_location=request.data.get('to'),
            date=request.data.get('date'),
            departure_time=request.data.get('departure'),
            arrival_time=request.data.get('arrive'),
            train_number=request.data.get('train'),
            carriage=request.data.get('carriage'),
            seat_number=request.data.get('seat'),
            class_label=request.data.get('class_label'),
            image_url=request.data.get('image_url'),
            stay_date=request.data.get('stay_date'),
            stay_duration=request.data.get('stay_duration'),
            bed_type=request.data.get('bed_type'),
            location_name=request.data.get('location'),
        )
        
        # Add default purchase items for price breakdown
        PurchaseItem.objects.create(booking=booking, label='Ticket Price', amount_rp=booking.price_rp)
        PurchaseItem.objects.create(booking=booking, label='Service Fee', amount_rp=25000)
        
        return Response({"message": "Added to cart", "id": booking.id}, status=status.HTTP_201_CREATED)

    @decorators.action(detail=True, methods=['get'])
    def checkout(self, request, pk=None):
        booking = self.get_object()
        print(f"DEBUG: Checkout for booking: {booking}")
        serializer = CheckoutDetailsSerializer(booking)
        try:
            data = serializer.data
            return Response(data)
        except Exception as e:
            print(f"DEBUG: Serializer error: {e}")
            import traceback
            traceback.print_exc()
            raise

    @decorators.action(detail=True, methods=['post'])
    def pay(self, request, pk=None):
        booking = self.get_object()
        if booking.status == 'PAID':
            return Response({"error": "Already paid"}, status=status.HTTP_400_BAD_REQUEST)
        
        booking.status = 'PAID'
        booking.save()
        return Response({"message": "Payment successful", "status": booking.status})

class DestinationViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Destination.objects.all()
    serializer_class = DestinationSerializer
    permission_classes = [AllowAny]

    def get_queryset(self):
        queryset = super().get_queryset()
        category = self.request.query_params.get('category')
        tag = self.request.query_params.get('tag')
        section_tag = self.request.query_params.get('section_tag')
        ordering = self.request.query_params.get('ordering')
        search = self.request.query_params.get('search')

        if category:
            queryset = queryset.filter(category=category)
        if tag:
            queryset = queryset.filter(tags__icontains=tag)
        if section_tag:
            queryset = queryset.filter(section_tag=section_tag)
        if search:
            queryset = queryset.filter(
                Q(title__icontains=search) | Q(location__icontains=search)
            )
        if ordering:
            queryset = queryset.order_by(ordering)
            
        return queryset

    @decorators.action(detail=False, methods=['get'], permission_classes=[AllowAny])
    def home_sections(self, request):
        destinations = self.get_queryset()
        
        discount = destinations.filter(section_tag='Discount', discount_percentage__gt=0)
        favorite = destinations.filter(section_tag='Favorite')
        hot = destinations.filter(section_tag='Hot')

        return Response({
            'discount_destinations': DestinationSerializer(discount, many=True).data,
            'favorite_destinations': DestinationSerializer(favorite, many=True).data,
            'hot_destinations': DestinationSerializer(hot, many=True).data,
        })

    @decorators.action(detail=False, methods=['get'], permission_classes=[AllowAny])
    def recommendations(self, request):
        destinations = self.get_queryset()
        
        if request.user.is_authenticated:
            # Exclude destinations already in the user's wishlist
            destinations = destinations.exclude(wishlisted_by__user=request.user)

        # Get top 4 highest rated
        recommendations = destinations.order_by('-rating')[:4]
        return Response(DestinationSerializer(recommendations, many=True).data)

    @decorators.action(detail=True, methods=['post'], permission_classes=[IsAuthenticated])
    def toggle_wishlist(self, request, pk=None):
        destination = self.get_object()
        wishlist, created = Wishlist.objects.get_or_create(user=request.user)
        
        if destination in wishlist.destinations.all():
            wishlist.destinations.remove(destination)
            status_msg = "removed"
        else:
            wishlist.destinations.add(destination)
            status_msg = "added"
            
        return Response({
            "message": f"Successfully {status_msg} destination to wishlist.",
            "status": status_msg
        })

    @decorators.action(detail=False, methods=['get'], permission_classes=[IsAuthenticated])
    def wishlist(self, request):
        wishlist, created = Wishlist.objects.get_or_create(user=request.user)
        queryset = wishlist.destinations.all()
        serializer = DestinationSerializer(queryset, many=True)
        return Response(serializer.data)

    @decorators.action(detail=False, methods=['get'], permission_classes=[IsAuthenticated])
    def my_wishlist_ids(self, request):
        wishlist, created = Wishlist.objects.get_or_create(user=request.user)
        ids = wishlist.destinations.values_list('id', flat=True)
        return Response({"ids": list(ids)})
