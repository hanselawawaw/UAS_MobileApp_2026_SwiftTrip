import os
from django.db import models
from django.conf import settings

class Destination(models.Model):
    name = models.CharField(max_length=255)
    image_url = models.URLField(max_length=500)
    rating = models.DecimalField(max_digits=3, decimal_places=1, default=0.0)
    description = models.TextField(blank=True)
    price = models.DecimalField(max_digits=12, decimal_places=2, default=0.0)
    features = models.JSONField(default=list)
    has_discount = models.BooleanField(default=False)
    is_hot = models.BooleanField(default=False)
    category = models.CharField(max_length=100)

    def __str__(self):
        return self.name

class UserFavorite(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='favorites')
    destination = models.ForeignKey(Destination, on_delete=models.CASCADE, related_name='favorited_by')

    class Meta:
        unique_together = ('user', 'destination')

class Recommendation(models.Model):
    name = models.CharField(max_length=255)
    description = models.TextField()
    image_url = models.URLField(max_length=500, null=True, blank=True)
    image_asset = models.CharField(max_length=255, null=True, blank=True)

    def __str__(self):
        return self.name

class Schedule(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='schedules')
    title = models.CharField(max_length=255)
    time = models.CharField(max_length=100) # Storing as string to match "10:00 AM" format from Flutter
    image_url = models.URLField(max_length=500, null=True, blank=True)
    image_asset = models.CharField(max_length=255, null=True, blank=True)

    def __str__(self):
        return f"{self.user.username} - {self.title}"

class Coupon(models.Model):
    title = models.CharField(max_length=255)
    description = models.TextField()
    code = models.CharField(max_length=50, unique=True)

    def __str__(self):
        return self.code

class RideOption(models.Model):
    name = models.CharField(max_length=100)
    duration = models.CharField(max_length=50)
    passenger_capacity = models.IntegerField()
    price_rp = models.IntegerField()

    def __str__(self):
        return self.name

class TransportRoute(models.Model):
    origin_code = models.CharField(max_length=10)
    destination_code = models.CharField(max_length=10)
    departure_time = models.DateTimeField()
    vehicle_type = models.CharField(max_length=50) # Flight, Train, Bus
    price_rp = models.IntegerField()

    def __str__(self):
        return f"{self.vehicle_type} from {self.origin_code} to {self.destination_code}"
