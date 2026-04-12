# Setup django environment
import os
import sys
from datetime import datetime, timedelta
sys.path.append(os.getcwd())
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'core.settings')
import django
django.setup()

from travel_data.services.amadeus_service import AmadeusService

def test_fallbacks():
    service = AmadeusService()
    
    print("=== Testing _generative_fallback (One-Way) ===")
    one_way_results = service._generative_fallback(
        origin="CGK",
        destination="DPS",
        date="2026-05-20",
        passengers=1,
        travel_class="ECONOMY"
    )
    
    for i, flight in enumerate(one_way_results):
        print(f"Option {i+1}:")
        print(f"  Airline: {flight['airlineName']} ({flight['airline']})")
        print(f"  Departure: {flight['departure_time']}")
        print(f"  Arrival: {flight['arrival_time']}")
        print(f"  Price: {flight['price']}")
        print(f"  Source: {flight['source']}")
    
    print("\n=== Testing _generative_fallback_multi_city ===")
    legs = [
        {"origin": "CGK", "destination": "SIN", "date": "2026-06-01"},
        {"origin": "SIN", "destination": "NRT", "date": "2026-06-05"}
    ]
    multi_results = service._generative_fallback_multi_city(
        legs=legs,
        passengers=2,
        travel_class="BUSINESS"
    )
    
    for i, flight in enumerate(multi_results):
        print(f"Option {i+1}:")
        print(f"  Airline: {flight['airlineName']} ({flight['airline']})")
        print(f"  Departure: {flight['departure_time']}")
        print(f"  Arrival: {flight['arrival_time']}")
        print(f"  Price: {flight['price']}")
        print(f"  Source: {flight['source']}")

if __name__ == "__main__":
    test_fallbacks()
