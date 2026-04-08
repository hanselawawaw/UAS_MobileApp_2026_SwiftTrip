from django.db import models
from django.conf import settings

class Booking(models.Model):
    STATUS_CHOICES = [
        ('IN_CART', 'In Cart'),
        ('PENDING', 'Pending'),
        ('PAID', 'Paid'),
        ('CANCELLED', 'Cancelled'),
    ]
    
    TYPE_CHOICES = [
        ('CAR_TICKET', 'Car Ticket'),
        ('BUS_TICKET', 'Bus Ticket'),
        ('TRAIN_TICKET', 'Train Ticket'),
        ('PLANE_TICKET', 'Plane Ticket'),
        ('ACCOMMODATION', 'Accommodation Ticket'),
    ]

    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='bookings')
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='IN_CART')
    booking_type = models.CharField(max_length=20, choices=TYPE_CHOICES)
    price_rp = models.IntegerField(default=0)
    service_fee = models.IntegerField(default=0)
    discount_rp = models.IntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    # Transport fields
    from_location = models.CharField(max_length=255, null=True, blank=True)
    to_location = models.CharField(max_length=255, null=True, blank=True)
    date = models.CharField(max_length=100, null=True, blank=True)
    departure_time = models.CharField(max_length=100, null=True, blank=True)
    arrival_time = models.CharField(max_length=100, null=True, blank=True)
    train_number = models.CharField(max_length=100, null=True, blank=True)
    carriage = models.CharField(max_length=50, null=True, blank=True)
    seat_number = models.CharField(max_length=50, null=True, blank=True)
    seat = models.CharField(max_length=10, null=True, blank=True)
    class_label = models.CharField(max_length=100, null=True, blank=True)
    operator = models.CharField(max_length=100, null=True, blank=True)
    flight_number = models.CharField(max_length=100, null=True, blank=True)
    terminal = models.CharField(max_length=100, null=True, blank=True)
    flight_class = models.CharField(max_length=100, null=True, blank=True)
    bus_class = models.CharField(max_length=100, null=True, blank=True)
    bus_number = models.CharField(max_length=100, null=True, blank=True)
    car_plate = models.CharField(max_length=100, null=True, blank=True)
    driver_name = models.CharField(max_length=100, null=True, blank=True)
    flight_route = models.JSONField(default=list, blank=True, null=True)

    # Accommodation fields
    image_url = models.URLField(max_length=500, null=True, blank=True)
    stay_date = models.CharField(max_length=100, null=True, blank=True)
    stay_duration = models.CharField(max_length=100, null=True, blank=True)
    bed_type = models.CharField(max_length=100, null=True, blank=True)
    location_name = models.CharField(max_length=255, null=True, blank=True)
    latitude = models.FloatField(null=True, blank=True)
    longitude = models.FloatField(null=True, blank=True)

    def __str__(self):
        return f"{self.user.username} - {self.booking_type} - {self.status}"

class PurchaseItem(models.Model):
    booking = models.ForeignKey(Booking, on_delete=models.CASCADE, related_name='purchase_items')
    label = models.CharField(max_length=255)
    amount_rp = models.IntegerField()
    is_discount = models.BooleanField(default=False)

    def __str__(self):
        return f"{self.label}: {self.amount_rp}"

class Destination(models.Model):
    CATEGORY_CHOICES = [
        ('Villa', 'Villa'),
        ('Hotel', 'Hotel'),
        ('Apartment', 'Apartment'),
        ('Condo', 'Condo'),
    ]

    SECTION_TAG_CHOICES = [
        ('Discount', 'Discount'),
        ('Favorite', 'Favorite'),
        ('Hot', 'Hot'),
    ]

    title = models.CharField(max_length=255)
    category = models.CharField(max_length=50, choices=CATEGORY_CHOICES)
    image_url = models.URLField(max_length=500)
    location = models.CharField(max_length=255)
    rating = models.DecimalField(max_digits=2, decimal_places=1)
    original_price = models.DecimalField(max_digits=12, decimal_places=2)
    discount_percentage = models.IntegerField(default=0)
    description = models.TextField()
    advantages = models.JSONField(default=list, help_text='Guest Favorites list')
    tags = models.JSONField(default=list, help_text='Searchable tags like Cozy, Airy')
    section_tag = models.CharField(max_length=50, choices=SECTION_TAG_CHOICES)
    latitude = models.FloatField(null=True, blank=True)
    longitude = models.FloatField(null=True, blank=True)

    @property
    def final_price(self):
        from decimal import Decimal
        discount_factor = Decimal(1) - (Decimal(self.discount_percentage) / Decimal(100))
        return (self.original_price * discount_factor).quantize(Decimal('0.01'))

    def __str__(self):
        return self.title

class Wishlist(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='wishlist')
    destinations = models.ManyToManyField(Destination, related_name='wishlisted_by')

    def __str__(self):
        return f"Wishlist for {self.user.username}"
