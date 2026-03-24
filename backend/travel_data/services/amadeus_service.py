import os
import requests
from datetime import datetime
from travel_data.models import TransportRoute

class AmadeusService:
    BASE_URL = "https://test.api.amadeus.com"

    def __init__(self):
        self.api_key = os.environ.get("AMADEUS_API_KEY")
        self.api_secret = os.environ.get("AMADEUS_API_SECRET")
        self._token = None

    def _get_token(self):
        if self._token:
            return self._token

        if not self.api_key or not self.api_secret:
            return None

        url = f"{self.BASE_URL}/v1/security/oauth2/token"
        data = {
            "grant_type": "client_credentials",
            "client_id": self.api_key,
            "client_secret": self.api_secret
        }
        try:
            response = requests.post(url, data=data, timeout=5)
            if response.status_code == 200:
                self._token = response.json().get("access_token")
                return self._token
        except requests.RequestException:
            pass
        return None

    def search_flights(self, origin, destination, date, passengers=1, travel_class="ECONOMY"):
        """
        Takes direct parameters and searches flights. 
        Returns standard list. Fallback to Local DB on failure.
        """
        token = self._get_token()
        if token:
            url = f"{self.BASE_URL}/v2/shopping/flight-offers"
            headers = {"Authorization": f"Bearer {token}"}
            params = {
                "originLocationCode": origin.upper(),
                "destinationLocationCode": destination.upper(),
                "departureDate": date,
                "adults": max(1, int(passengers)),
                "travelClass": travel_class.upper(),
                "max": 5
            }
            try:
                res = requests.get(url, headers=headers, params=params, timeout=10)
                if res.status_code == 200:
                    data = res.json().get("data", [])
                    if data:
                        return self._format_amadeus_response(data)
            except requests.RequestException:
                pass

        return self._fallback_search(origin, destination, date)

    def _format_amadeus_response(self, data):
        results = []
        for offer in data:
            itineraries = offer.get("itineraries", [])
            if not itineraries:
                continue
            
            segment = itineraries[0].get("segments", [])[0]
            price_info = offer.get("price", {})
            
            results.append({
                "airline": segment.get("carrierCode"),
                "origin": segment.get("departure", {}).get("iataCode"),
                "destination": segment.get("arrival", {}).get("iataCode"),
                "departure_time": segment.get("departure", {}).get("at"),
                "arrival_time": segment.get("arrival", {}).get("at"),
                "price": float(price_info.get("total", "0")),
                "currency": price_info.get("currency", "EUR"),
                "source": "amadeus"
            })
        return results

    def _fallback_search(self, origin, destination, date):
        # We try to interpret 'date' as YYYY-MM-DD
        try:
            parsed_date = datetime.strptime(date, "%Y-%m-%d").date()
            routes = TransportRoute.objects.filter(
                origin_code__iexact=origin,
                destination_code__iexact=destination,
                departure_time__date=parsed_date
            )[:5]
        except ValueError:
            # If date format is corrupt, fallback to just cities
            routes = TransportRoute.objects.filter(
                origin_code__iexact=origin,
                destination_code__iexact=destination
            )[:5]

        results = []
        for route in routes:
            results.append({
                "airline": route.vehicle_type,
                "origin": route.origin_code.upper(),
                "destination": route.destination_code.upper(),
                "departure_time": route.departure_time.isoformat(),
                "arrival_time": route.departure_time.isoformat(),
                "price": route.price_rp,
                "currency": "IDR",
                "source": "local"
            })
        return results
