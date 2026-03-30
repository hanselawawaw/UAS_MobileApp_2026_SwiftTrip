import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'core.settings')
django.setup()

from promotions.models import Promotion

promotions = [
    {
        'code': 'promo_4',
        'title': 'Early Bird Saver',
        'date_range': '01 Apr 2026 - 30 Sep 2026',
        'description': 'Discount 12% for bookings made at least 7 days in advance',
        'promotion_type': 'PERCENTAGE',
        'discount_value': 12,
        'min_purchase': 300000,
    },
    {
        'code': 'promo_5',
        'title': 'Road Trip Deal',
        'date_range': '01 May 2026 - 31 Dec 2026',
        'description': 'Cashback Rp 75.000 for land transport bookings above Rp 500.000',
        'promotion_type': 'CASHBACK',
        'discount_value': 75000,
        'min_purchase': 500000,
    },
    {
        'code': 'promo_6',
        'title': 'First Time Traveler',
        'date_range': '01 Jan 2026 - 31 Dec 2026',
        'description': 'Discount 20% for first-time users',
        'promotion_type': 'PERCENTAGE',
        'discount_value': 20,
        'min_purchase': 200000,
    },
    {
        'code': 'promo_7',
        'title': 'Holiday Escape',
        'date_range': '01 Dec 2026 - 05 Jan 2027',
        'description': 'Discount 18% on all bookings during holiday season',
        'promotion_type': 'PERCENTAGE',
        'discount_value': 18,
        'min_purchase': 400000,
    },
    {
        'code': 'promo_8',
        'title': 'Group Travel Bonus',
        'date_range': '01 Jun 2026 - 31 Dec 2026',
        'description': 'Cashback Rp 100.000 for group bookings (min 3 tickets)',
        'promotion_type': 'CASHBACK',
        'discount_value': 100000,
        'min_purchase': 600000,
    },
]

# Wipe existing data to avoid conflicts with new structure
Promotion.objects.all().delete()

for p in promotions:
    Promotion.objects.create(**p)

print("Promotions seeded successfully with dynamic calculation rules!")
