from rest_framework import serializers
from .models import Booking, PurchaseItem, Destination

class PurchaseItemSerializer(serializers.ModelSerializer):
    amount = serializers.SerializerMethodField()
    label = serializers.CharField()
    is_discount = serializers.BooleanField()

    class Meta:
        model = PurchaseItem
        fields = ['label', 'amount', 'is_discount']
    
    def get_amount(self, obj):
        prefix = "-" if obj.is_discount else ""
        return f"{prefix}Rp {obj.amount_rp:,}"

class DestinationSerializer(serializers.ModelSerializer):
    final_price = serializers.DecimalField(max_digits=12, decimal_places=2, read_only=True)
    is_favorite = serializers.SerializerMethodField()

    class Meta:
        model = Destination
        fields = [
            'id', 'title', 'category', 'image_url', 'location', 
            'rating', 'original_price', 'discount_percentage', 
            'description', 'advantages', 'tags', 'section_tag', 'final_price', 'is_favorite',
            'latitude', 'longitude'
        ]

    def get_is_favorite(self, obj):
        request = self.context.get('request')
        if request and request.user.is_authenticated:
            return obj.wishlisted_by.filter(user=request.user).exists()
        return False

class CartTicketSerializer(serializers.ModelSerializer):
    type = serializers.SerializerMethodField()
    booking_id = serializers.CharField(source='id')
    class_label = serializers.CharField()
    price_rp = serializers.IntegerField()
    
    # Transport fields
    from_loc = serializers.CharField(source='from_location', required=False, allow_null=True)
    to_loc = serializers.CharField(source='to_location', required=False, allow_null=True)
    departure = serializers.CharField(source='departure_time', required=False, allow_null=True)
    arrive = serializers.CharField(source='arrival_time', required=False, allow_null=True)
    train = serializers.CharField(source='train_number', required=False, allow_null=True)
    
    # Accommodation fields
    location = serializers.CharField(source='location_name', required=False, allow_null=True)

    class Meta:
        model = Booking
        fields = [
            'type', 'booking_id', 'class_label', 'price_rp',
            'from_loc', 'to_loc', 'date', 'departure', 'arrive',
            'train', 'carriage', 'seat', 'image_url', 'stay_date', 
            'stay_duration', 'bed_type', 'location',
            'operator', 'flight_number', 'terminal', 'flight_class',
            'bus_class', 'bus_number', 'car_plate', 'driver_name',
            'flight_route', 'latitude', 'longitude', 'service_fee', 'discount_rp'
        ]

    def get_type(self, obj):
        mapping = {
            'CAR_TICKET': 'Car Ticket',
            'BUS_TICKET': 'Bus Ticket',
            'TRAIN_TICKET': 'Train Ticket',
            'PLANE_TICKET': 'Plane Ticket',
            'ACCOMMODATION': 'Accommodation Ticket',
        }
        return mapping.get(obj.booking_type, 'Unknown')

    def to_representation(self, instance):
        ret = super().to_representation(instance)
        # Rename specific mapping for Flutter CartTicket
        mapping = {
            'from_loc': 'from',
            'to_loc': 'to'
        }
        for old_key, new_key in mapping.items():
            if old_key in ret:
                ret[new_key] = ret.pop(old_key)
        return ret

class TicketModelSerializer(serializers.ModelSerializer):
    class_type = serializers.CharField(source='class_label')
    from_loc = serializers.CharField(source='from_location')
    to_loc = serializers.CharField(source='to_location')
    departure_time = serializers.CharField()
    arrival_time = serializers.CharField()
    train_number = serializers.CharField()

    class Meta:
        model = Booking
        fields = [
            'class_type', 'from_loc', 'to_loc', 'date',
            'departure_time', 'arrival_time', 'train_number',
            'carriage', 'seat_number', 'seat', 'operator',
            'flight_number', 'terminal', 'flight_class',
            'bus_class', 'bus_number', 'car_plate', 'driver_name',
            'flight_route', 'latitude', 'longitude', 'service_fee', 'discount_rp'
        ]

    def to_representation(self, instance):
        ret = super().to_representation(instance)
        mapping = {
            'from_loc': 'from',
            'to_loc': 'to'
        }
        for old_key, new_key in mapping.items():
            if old_key in ret:
                ret[new_key] = ret.pop(old_key)
        return ret

class CheckoutDetailsSerializer(serializers.ModelSerializer):
    ticket = TicketModelSerializer(source='*')
    purchase_items = PurchaseItemSerializer(many=True, read_only=True)
    total_price = serializers.SerializerMethodField()

    class Meta:
        model = Booking
        fields = ['ticket', 'purchase_items', 'total_price']

    def get_total_price(self, obj):
        return f"Rp {obj.price_rp:,}"
