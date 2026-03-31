import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'core.settings')
django.setup()

from promotions.models import Promotion

promotions = [
    {
        'code': 'promo_9',
        'title': 'No Minimum Saver',
        'date_range': '01 Apr 2026 - 31 Dec 2026',
        'description': 'Discount 5% with no minimum purchase (limited quota)',
        'promotion_type': 'PERCENTAGE',
        'discount_value': 5,
        'min_purchase': 0,
    },
    {
        'code': 'promo_10',
        'title': 'Flat Cashback Lite',
        'date_range': '01 Apr 2026 - 31 Dec 2026',
        'description': 'Cashback Rp 10.000 with no minimum purchase (limited quota)',
        'promotion_type': 'CASHBACK',
        'discount_value': 10000,
        'min_purchase': 0,
    },
    {
        'code': 'promo_11',
        'title': 'Budget Traveler',
        'date_range': '01 Apr 2026 - 31 Dec 2026',
        'description': 'Discount 8% for bookings above Rp 50.000',
        'promotion_type': 'PERCENTAGE',
        'discount_value': 8,
        'min_purchase': 50000,
    },
    {
        'code': 'promo_12',
        'title': 'Low Fare Boost',
        'date_range': '01 Apr 2026 - 31 Dec 2026',
        'description': 'Cashback Rp 20.000 for bookings above Rp 100.000',
        'promotion_type': 'CASHBACK',
        'discount_value': 20000,
        'min_purchase': 100000,
    },
    {
        'code': 'promo_13',
        'title': 'Mid Range Deal',
        'date_range': '01 Apr 2026 - 31 Dec 2026',
        'description': 'Discount 12% for bookings above Rp 300.000',
        'promotion_type': 'PERCENTAGE',
        'discount_value': 12,
        'min_purchase': 300000,
    },
    {
        'code': 'promo_14',
        'title': 'High Value Cashback',
        'date_range': '01 Apr 2026 - 31 Dec 2026',
        'description': 'Cashback Rp 150.000 for bookings above Rp 1.000.000',
        'promotion_type': 'CASHBACK',
        'discount_value': 150000,
        'min_purchase': 1000000,
    },
    {
        'code': 'promo_15',
        'title': 'Premium Journey',
        'date_range': '01 Apr 2026 - 31 Dec 2026',
        'description': 'Cashback Rp 300.000 for bookings above Rp 2.500.000',
        'promotion_type': 'CASHBACK',
        'discount_value': 300000,
        'min_purchase': 2500000,
    },
    {
        'code': 'promo_16',
        'title': 'Mega Saver',
        'date_range': '01 Apr 2026 - 31 Dec 2026',
        'description': 'Discount 20% for bookings above Rp 3.000.000',
        'promotion_type': 'PERCENTAGE',
        'discount_value': 20,
        'min_purchase': 3000000,
    },
    {
        'code': 'promo_17',
        'title': 'Super Cashback',
        'date_range': '01 Apr 2026 - 31 Dec 2026',
        'description': 'Cashback Rp 500.000 for bookings above Rp 5.000.000',
        'promotion_type': 'CASHBACK',
        'discount_value': 500000,
        'min_purchase': 5000000,
    },
    {
        'code': 'promo_18',
        'title': 'Flash Deal',
        'date_range': '01 Apr 2026 - 31 Dec 2026',
        'description': 'Discount 15% limited-time for all price ranges',
        'promotion_type': 'PERCENTAGE',
        'discount_value': 15,
        'min_purchase': 200000,
    },
]

# Wipe existing data to avoid conflicts with new structure
Promotion.objects.all().delete()

for p in promotions:
    Promotion.objects.create(**p)

print("Promotions seeded successfully with dynamic calculation rules!")
