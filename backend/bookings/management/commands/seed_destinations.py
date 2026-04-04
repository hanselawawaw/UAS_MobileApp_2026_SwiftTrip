# seed_destinations.py
import random
from django.core.management.base import BaseCommand
from bookings.models import Destination
from decimal import Decimal

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

        # Category to LoremFlickr Keyword Mapping - Broadened to prevent fallback
        CATEGORY_KEYWORDS = {
            'Villa': 'villa,tropical',
            'Hotel': 'hotel,luxury',
            'Apartment': 'building,modern,city',
            'Condo': 'skyscraper,architecture,luxury'
        }

        for i, prop in enumerate(REAL_PROPERTIES):
            # Deterministic Proxy URL logic - Removed /all to broaden match space
            keyword = CATEGORY_KEYWORDS.get(prop['cat'], 'travel')
            img_url = f'https://loremflickr.com/800/600/{keyword}?lock={i}'
            
            original_price = Decimal(random.randint(500000, 10000000))
            
            Destination.objects.create(
                title=prop['name'],
                category=prop['cat'],
                image_url=img_url,
                location=prop['loc'],
                rating=Decimal(random.uniform(4.0, 5.0)).quantize(Decimal('0.1')),
                original_price=original_price,
                discount_percentage=random.randint(1, 40) if random.random() > 0.5 else 0,
                description=f"Stay at {prop['name']}, located in {prop['loc']}. This {prop['cat'].lower()} is designed for premium comfort and features a {random.choice(tag_pool).lower()} vibe with authentic Indonesian charm.",
                advantages=random.sample(advantage_pool, random.randint(3, 4)),
                tags=random.sample(tag_pool, random.randint(1, 2)),
                section_tag=random.choice(['Discount', 'Favorite', 'Hot'])
            )
            
        self.stdout.write(self.style.SUCCESS('Successfully seeded 50 unique Indonesian destinations with zero-404 proxy images.'))