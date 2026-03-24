import requests
import json

BASE_URL = "http://127.0.0.1:8002/api"

print("--- Testing Phase 2: GET /api/travel/search/ ---")
res1 = requests.get(f"{BASE_URL}/travel/search/?origin=CGK&destination=SIN&date=2026-03-30")
print(f"Status: {res1.status_code}")
if res1.status_code == 200:
    data = res1.json().get('flights', [])
    print(f"Flights found: {len(data)}")
    if data:
        print(f"Sample: {data[0]}")
else:
    print(res1.text)

print("\n--- Testing Phase 3: POST /api/support/chat/ ---")
payload = {
    "message": "I want to fly from Jakarta (CGK) to Tokyo (HND) next friday"
}
headers = {
    "Content-Type": "application/json",
    "Accept-Language": "id-ID"
}
res2 = requests.post(f"{BASE_URL}/support/chat/", json=payload, headers=headers)
print(f"Status: {res2.status_code}")
if res2.status_code == 200:
    data = res2.json()
    print(f"Message: {data.get('message')}")
    flights = data.get('flights', [])
    print(f"Flights found: {len(flights)}")
    if flights:
        print(f"Sample: {flights[0]}")
else:
    print(res2.text)
