from django.contrib import admin
from .models import Booking, PurchaseItem

@admin.register(Booking)
class BookingAdmin(admin.ModelAdmin):
    list_display = ('id', 'user', 'booking_type', 'status', 'created_at')
    list_filter = ('status', 'booking_type', 'created_at')
    search_fields = ('user__email', 'from_location', 'to_location')

@admin.register(PurchaseItem)
class PurchaseItemAdmin(admin.ModelAdmin):
    list_display = ('id', 'booking', 'label', 'amount_rp', 'is_discount')
    list_filter = ('is_discount',)
    search_fields = ('label', 'booking__user__email')
