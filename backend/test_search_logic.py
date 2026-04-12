import os
import django
import sys
from datetime import datetime

# Setup Django environment
sys.path.append(os.getcwd())
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'core.settings')
django.setup()

from travel_data.services.amadeus_service import AmadeusService

def test_logic():
    print("--- Testing Flight Search Refactor ---")
    service = AmadeusService()
    
    # 1. Test Coordinate Extraction
    print("\n1. Testing Coordinate Extraction:")
    for code in ['CGK', 'DPS', 'SIN', 'LHR', 'UNKNOWN']:
        lat, lng = service._get_airport_coordinates(code)
        print(f"   {code}: Lat={lat}, Lng={lng}")

    # 2. Test Distance Calculation (Haversine)
    print("\n2. Testing Distance Calculation:")
    # CGK (-6.1256, 106.6560) to DPS (-8.7482, 115.1675)
    lat1, lon1 = -6.1256, 106.6560
    lat2, lon2 = -8.7482, 115.1675
    dist = service._calculate_distance(lat1, lon1, lat2, lon2)
    print(f"   CGK to DPS Distance: {dist:.2f} km (Expected ~980km)")
    
    # CGK to JFK (Long haul)
    lat1, lon1 = -6.1256, 106.6560
    lat2, lon2 = 40.6413, -73.7781
    dist_long = service._calculate_distance(lat1, lon1, lat2, lon2)
    print(f"   CGK to JFK Distance: {dist_long:.2f} km")

    # 3. Test Pricing Logic
    print("\n3. Testing Pricing Logic:")
    # Formula: 500,000 + (dist * 1,500)
    # CGK-DPS: 500k + (980 * 1.5k) = 500k + 1.47M = ~1.97M
    price_short = service._get_dynamic_price('CGK', 'DPS')
    print(f"   CGK to DPS Price: Rp {price_short:,}")
    
    price_long = service._get_dynamic_price('CGK', 'JFK')
    print(f"   CGK to JFK Price: Rp {price_long:,}")

    # 4. Test Temporal Filtering (Simulation)
    print("\n4. Testing Temporal Filtering (Simulation):")
    # We'll create a mock flight list and filter it
    now = datetime.now()
    current_time_str = now.strftime("%H:%M:%S")
    print(f"   Current System Time: {current_time_str}")
    
    mock_flights = [
        {'departure_time': '2026-04-12T08:00:00'}, # Past
        {'departure_time': '2026-04-12T10:00:00'}, # Past/Near
        {'departure_time': '2026-04-12T14:30:00'}, # Future
        {'departure_time': '2026-04-12T22:00:00'}, # Future
    ]
    
    filtered = [f for f in mock_flights if f['departure_time'].split('T')[-1] > current_time_str]
    print(f"   Original Count: {len(mock_flights)}")
    print(f"   Filtered Count: {len(filtered)}")
    for f in filtered:
        print(f"   - Kept: {f['departure_time']}")

if __name__ == "__main__":
    test_logic()
