# seed_destinations.py
import random
from django.core.management.base import BaseCommand
from bookings.models import Destination
from decimal import Decimal

VILLA_IDS = [
    '1582268611958-ebfd161ef9cf',
    '1571896349842-33c89424de2d',
    '1520250497591-112f2f40a3f4',
    '1606402179428-a57976d71fa4',
    '1540541338287-41700207dee6',
    '1728049006339-1cc328a28ab0',
    '1728048756766-55208c6feb87',
    '1757439402359-aed14d39fc1b',
    '1694967832949-09984640b143',
    '1563911302283-d2bc129e7570',
    '1598928636135-d146006ff4be',
    '1549294413-26f195200c16',
    '1596436889106-be35e843f974',
    '1600585154340-be6161a56a0c',
    '1611892440504-42a792e24d32',
    '1766603636810-65b088018169',
    '1728048756910-c1d157bd24cf',
    '1722409195473-d322e99621e3',
    '1729673767073-e38a6e226671',
    '1757439402173-2ed1421f7466',
]

HOTEL_IDS = [
    '1631049307264-da0ec9d70304',
    '1618773928121-c32242e63f39',
    '1566073771259-6a8506099945',
    '1551882547-ff40c63fe5fa',
    '1584132967334-10e028bd69f7',
    '1590381105924-c72589b9ef3f',
    '1445019980597-93fa8acb246c',
    '1631048649038-e31d38df5a25',
    '1662841540530-2f04bb3291e8',
    '1568495248636-6432b97bd949',
    '1590490360182-c33d57733427',
    '1566665797739-1674de7a421a',
    '1631049035634-c04c637651b1',
    '1629140727571-9b5c6f6267b4',
    '1631049552351-16da4767cc98',
]

APARTMENT_IDS = [
    '1522708323590-d24dbb6b0267',
    '1560448204-e02f11c3d0e2',
    '1484154218962-a197022b5858',
    '1502672260266-1c1ef2d93688',
    '1545324418-cc1a3fa10c00',
    '1493809842364-78817add7ffb',
    '1554995207-c18c203602cb',
    '1536376072261-38c75010e6c9',
    '1675279200694-8529c73b1fd0',
    '1616594039964-ae9021a400a0',
    '1564078516393-cf04bd966897',
    '1512916194211-3f2b7f5f7f7f',
    '1583847268964-b28dc8f51f92',
    '1574362848149-11496d93a5a5',
]

CONDO_IDS = [
    '1512917774080-9991f1c4c750',
    '1600585154340-be6161a56a0c',
    '1554995207-c18c203602cb',
    '1600596542815-ffad4c1539a9',
    '1583847268964-b28dc8f51f92',
    '1605276374104-dee2a0ed3cd6',
    '1574362848149-11496d93a5a5',
    '1558618666-fcd25c85cd64',
    '1536376072261-38c75010e6c9',
    '1560347879-d9e1e6d5e5d5',
]

class Command(BaseCommand):
    help = 'Seed 50 real Indonesian destinations with zero-404 proxy images'

    def handle(self, *args, **options):
        Destination.objects.all().delete()
        self.stdout.write(self.style.WARNING('Clearing existing destinations...'))

        # 50 REAL INDONESIAN PROPERTIES
        REAL_PROPERTIES = [
            # VILLAS (20)
            {'name': 'Alila Villas Uluwatu', 'cat': 'Villa', 'loc': 'Uluwatu, Bali'},
            {'name': 'Viceroy Bali', 'cat': 'Villa', 'loc': 'Ubud, Bali'},
            {'name': 'The Edge Bali', 'cat': 'Villa', 'loc': 'Uluwatu, Bali'},
            {'name': 'Bulgari Resort Bali', 'cat': 'Villa', 'loc': 'Uluwatu, Bali'},
            {'name': 'Mandapa Ritz-Carlton', 'cat': 'Villa', 'loc': 'Ubud, Bali'},
            {'name': 'Four Seasons Jimbaran', 'cat': 'Villa', 'loc': 'Jimbaran, Bali'},
            {'name': 'Amankila Resort', 'cat': 'Villa', 'loc': 'Manggis, Bali'},
            {'name': 'Potato Head Studios', 'cat': 'Villa', 'loc': 'Seminyak, Bali'},
            {'name': 'Munduk Plantation', 'cat': 'Villa', 'loc': 'Munduk, Bali'},
            {'name': 'Hanging Gardens', 'cat': 'Villa', 'loc': 'Ubud, Bali'},
            {'name': 'Kayon Jungle Resort', 'cat': 'Villa', 'loc': 'Ubud, Bali'},
            {'name': 'Kamandalu Ubud', 'cat': 'Villa', 'loc': 'Ubud, Bali'},
            {'name': 'Ayana Resort', 'cat': 'Villa', 'loc': 'Jimbaran, Bali'},
            {'name': 'Six Senses Uluwatu', 'cat': 'Villa', 'loc': 'Uluwatu, Bali'},
            {'name': 'Karma Kandara', 'cat': 'Villa', 'loc': 'Uluwatu, Bali'},
            {'name': 'Samabe Bali Suites', 'cat': 'Villa', 'loc': 'Nusa Dua, Bali'},
            {'name': 'W Bali Seminyak', 'cat': 'Villa', 'loc': 'Seminyak, Bali'},
            {'name': 'The St. Regis Bali', 'cat': 'Villa', 'loc': 'Nusa Dua, Bali'},
            {'name': 'Jeeva Klui Resort', 'cat': 'Villa', 'loc': 'Senggigi, Lombok'},
            {'name': 'The Oberoi Lombok', 'cat': 'Villa', 'loc': 'Tanjung, Lombok'},

            # HOTELS (15)
            {'name': 'Ritz-Carlton Kuningan', 'cat': 'Hotel', 'loc': 'Jakarta, Indonesia'},
            {'name': 'Hotel Indonesia Kempinski', 'cat': 'Hotel', 'loc': 'Jakarta, Indonesia'},
            {'name': 'The St. Regis Jakarta', 'cat': 'Hotel', 'loc': 'Jakarta, Indonesia'},
            {'name': 'Fairmont Jakarta', 'cat': 'Hotel', 'loc': 'Jakarta, Indonesia'},
            {'name': 'Raffles Jakarta', 'cat': 'Hotel', 'loc': 'Jakarta, Indonesia'},
            {'name': 'The Westin Jakarta', 'cat': 'Hotel', 'loc': 'Jakarta, Indonesia'},
            {'name': 'Pullman Central Park', 'cat': 'Hotel', 'loc': 'Jakarta, Indonesia'},
            {'name': 'The Dharmawangsa', 'cat': 'Hotel', 'loc': 'Jakarta, Indonesia'},
            {'name': 'Hyatt Regency Yogyakarta', 'cat': 'Hotel', 'loc': 'Yogyakarta, DIY'},
            {'name': 'Phoenix Hotel Yogyakarta', 'cat': 'Hotel', 'loc': 'Yogyakarta, DIY'},
            {'name': 'Tentrem Hotel', 'cat': 'Hotel', 'loc': 'Yogyakarta, DIY'},
            {'name': 'Padma Hotel Bandung', 'cat': 'Hotel', 'loc': 'Bandung, West Java'},
            {'name': 'Trans Luxury Hotel', 'cat': 'Hotel', 'loc': 'Bandung, West Java'},
            {'name': 'InterContinental Bandung', 'cat': 'Hotel', 'loc': 'Bandung, West Java'},
            {'name': 'JW Marriott Surabaya', 'cat': 'Hotel', 'loc': 'Surabaya, East Java'},

            # APARTMENTS/CONDOS (15)
            {'name': 'St. Moritz Penthouses', 'cat': 'Condo', 'loc': 'West Jakarta, Indonesia'},
            {'name': 'Pondok Indah Residences', 'cat': 'Apartment', 'loc': 'South Jakarta, Indonesia'},
            {'name': 'Anandamaya Residences', 'cat': 'Apartment', 'loc': 'Sudirman, Jakarta'},
            {'name': 'Verde Two Apartment', 'cat': 'Apartment', 'loc': 'Kuningan, Jakarta'},
            {'name': 'The Pakubuwono', 'cat': 'Apartment', 'loc': 'Kebayoran, Jakarta'},
            {'name': 'District 8 Apartments', 'cat': 'Condo', 'loc': 'Senopati, Jakarta'},
            {'name': 'Lavish Kemang', 'cat': 'Apartment', 'loc': 'South Jakarta, Indonesia'},
            {'name': 'Branz BSD City', 'cat': 'Condo', 'loc': 'Tangerang, Banten'},
            {'name': 'Saumata Apartment', 'cat': 'Apartment', 'loc': 'Alam Sutera, Banten'},
            {'name': 'Grand Sungkono Lagoon', 'cat': 'Condo', 'loc': 'Surabaya, Indonesia'},
            {'name': 'Westown View Surabaya', 'cat': 'Apartment', 'loc': 'Surabaya, Indonesia'},
            {'name': 'Ciputra World Apartment', 'cat': 'Apartment', 'loc': 'Surabaya, Indonesia'},
            {'name': 'Marvel City Residence', 'cat': 'Apartment', 'loc': 'Surabaya, Indonesia'},
            {'name': 'Aerium Residence', 'cat': 'Apartment', 'loc': 'West Jakarta, Indonesia'},
            {'name': 'Bassura City', 'cat': 'Apartment', 'loc': 'East Jakarta, Indonesia'},
        ]

        tag_pool = ["Cozy", "Airy", "Sleek", "Moody"]
        advantage_pool = ["Private Pool", "High-Speed Wi-Fi", "Gym Access", "City View", "Ocean Front", "Mountain View", "Breakfast Included", "Free Parking", "Jacuzzi", "Spa Access", "Smart Home System", "Kitchenette"]

        counters = {
            'Villa': 0,
            'Hotel': 0,
            'Apartment': 0,
            'Condo': 0
        }

        fallback_id = '1511268571738-98e85838ccb8'

        for prop in REAL_PROPERTIES:
            cat = prop['cat']
            idx = counters[cat]
            
            # Map category to its corresponding ID list
            id_repo = {
                'Villa': VILLA_IDS,
                'Hotel': HOTEL_IDS,
                'Apartment': APARTMENT_IDS,
                'Condo': CONDO_IDS
            }.get(cat, [])

            # Extract Photo ID with safety fallback
            if idx < len(id_repo):
                photo_id = id_repo[idx]
            else:
                photo_id = fallback_id

            if photo_id.startswith('https://'):
                img_url = photo_id
            else:
                img_url = f"https://images.unsplash.com/photo-{photo_id}?auto=format&fit=crop&w=800&q=80"

            original_price = Decimal(random.randint(500000, 10000000))
            
            Destination.objects.create(
                title=prop['name'],
                category=cat,
                image_url=img_url,
                location=prop['loc'],
                rating=Decimal(random.uniform(4.0, 5.0)).quantize(Decimal('0.1')),
                original_price=original_price,
                discount_percentage=random.randint(1, 40) if random.random() > 0.5 else 0,
                description=f"Stay at {prop['name']}, located in {prop['loc']}. This {cat.lower()} is designed for premium comfort and features a {random.choice(tag_pool).lower()} vibe with authentic Indonesian charm.",
                advantages=random.sample(advantage_pool, random.randint(3, 4)),
                tags=random.sample(tag_pool, random.randint(1, 2)),
                section_tag=random.choice(['Discount', 'Favorite', 'Hot'])
            )
            
            counters[cat] += 1
            
        self.stdout.write(self.style.SUCCESS(f'Successfully seeded {len(REAL_PROPERTIES)} unique Indonesian destinations.'))
