from django.contrib import admin
from .models import Category, Destination, UserFavorite, Recommendation, Schedule, Coupon, RideOption

@admin.register(Category)
class CategoryAdmin(admin.ModelAdmin):
    list_display = ('id', 'label')
    search_fields = ('label',)

@admin.register(Destination)
class DestinationAdmin(admin.ModelAdmin):
    list_display = ('id', 'name', 'category', 'rating', 'price', 'is_hot')
    list_filter = ('category', 'is_hot', 'has_discount')
    search_fields = ('name', 'description')

@admin.register(UserFavorite)
class UserFavoriteAdmin(admin.ModelAdmin):
    list_display = ('id', 'user', 'destination')

@admin.register(Recommendation)
class RecommendationAdmin(admin.ModelAdmin):
    list_display = ('id', 'name')
    search_fields = ('name',)

@admin.register(Schedule)
class ScheduleAdmin(admin.ModelAdmin):
    list_display = ('id', 'user', 'title', 'time')
    search_fields = ('title', 'user__email')

@admin.register(Coupon)
class CouponAdmin(admin.ModelAdmin):
    list_display = ('id', 'code', 'title')
    search_fields = ('code', 'title')

@admin.register(RideOption)
class RideOptionAdmin(admin.ModelAdmin):
    list_display = ('id', 'name', 'price_rp', 'passenger_capacity')
