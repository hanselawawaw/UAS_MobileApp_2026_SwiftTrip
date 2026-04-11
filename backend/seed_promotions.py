import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'core.settings')
django.setup()

from promotions.models import Promotion

promotions = [
    {
        'code': 'RAYA10',
        'title': 'Raya Special',
        'date_range': '01 Apr 2026 - 31 Dec 2026',
        'description': 'Discount 10% this Raya holiday!',
        'promotion_type': 'PERCENTAGE',
        'discount_value': 10,
        'min_purchase': 0,
    },
    {
        'code': 'RAYA15',
        'title': 'Raya Extra',
        'date_range': '01 Apr 2026 - 31 Dec 2026',
        'description': 'Discount 15% this Raya holiday!',
        'promotion_type': 'PERCENTAGE',
        'discount_value': 15,
        'min_purchase': 200000,
    },
    {
        'code': 'PLANE20',
        'title': 'Plane Saver',
        'date_range': '01 Apr 2026 - 31 Dec 2026',
        'description': 'Get 20% off flights (limited quota)',
        'promotion_type': 'PERCENTAGE',
        'discount_value': 20,
        'min_purchase': 100000,
    },
    {
        'code': 'FLY25',
        'title': 'Fly More',
        'date_range': '01 Apr 2026 - 31 Dec 2026',
        'description': 'Get 25% off flights (limited quota)',
        'promotion_type': 'PERCENTAGE',
        'discount_value': 25,
        'min_purchase': 500000,
    },
    {
        'code': 'AUS30',
        'title': 'Australia Deal',
        'date_range': '01 Apr 2026 - 31 Dec 2026',
        'description': 'Flat Rp 300.000 cashback for Australia trips',
        'promotion_type': 'CASHBACK',
        'discount_value': 300000,
        'min_purchase': 1000000,
    },
    {
        'code': 'SYD150',
        'title': 'Sydney Saver',
        'date_range': '01 Apr 2026 - 31 Dec 2026',
        'description': 'Discount Rp 150.000 for Sydney flights',
        'promotion_type': 'CASHBACK',
        'discount_value': 150000,
        'min_purchase': 500000,
    },
    {
        'code': 'IDN05',
        'title': 'IDN Deal',
        'date_range': '01 Apr 2026 - 31 Dec 2026',
        'description': 'Discount 5% for domestic flights',
        'promotion_type': 'PERCENTAGE',
        'discount_value': 5,
        'min_purchase': 0,
    },
    {
        'code': 'BALI12',
        'title': 'Bali Getaway',
        'date_range': '01 Apr 2026 - 31 Dec 2026',
        'description': 'Discount 12% for Bali hotel bookings',
        'promotion_type': 'PERCENTAGE',
        'discount_value': 12,
        'min_purchase': 300000,
    },
    {
        'code': 'BIZ500',
        'title': 'Biz Class Boost',
        'date_range': '01 Apr 2026 - 31 Dec 2026',
        'description': 'Cashback Rp 500.000 for Business Class',
        'promotion_type': 'CASHBACK',
        'discount_value': 500000,
        'min_purchase': 2000000,
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
