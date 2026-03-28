import os
import requests
import logging
from datetime import datetime
from django.core.cache import cache
from travel_data.models import TransportRoute

logger = logging.getLogger(__name__)

class AmadeusService:
    BASE_URL = "https://test.api.amadeus.com"
    TOKEN_CACHE_KEY = "amadeus_access_token"

    def __init__(self):
        self.api_key = os.environ.get("AMADEUS_API_KEY")
        self.api_secret = os.environ.get("AMADEUS_API_SECRET")

    def _get_token(self):
        # Try to get token from cache first
        token = cache.get(self.TOKEN_CACHE_KEY)
        if token:
            return token

        if not self.api_key or not self.api_secret:
            logger.error("Amadeus API credentials missing in .env")
            return None

        logger.info("Fetching new Amadeus access token...")
        url = f"{self.BASE_URL}/v1/security/oauth2/token"
        data = {
            "grant_type": "client_credentials",
            "client_id": self.api_key,
            "client_secret": self.api_secret
        }
        try:
            response = requests.post(url, data=data, timeout=5)
            if response.status_code == 200:
                token_data = response.json()
                token = token_data.get("access_token")
                # Store in cache for 29 minutes (1740 seconds)
                cache.set(self.TOKEN_CACHE_KEY, token, timeout=1740)
                logger.info("Amadeus token cached successfully")
                return token
        except requests.RequestException as e:
            logger.error(f"Error fetching Amadeus token: {e}")
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
                    json_res = res.json()
                    data = json_res.get("data", [])
                    carriers = json_res.get("dictionaries", {}).get("carriers", {})
                    if data:
                        return self._format_amadeus_response(data, carriers)
            except requests.RequestException:
                pass

        return self._fallback_search(origin, destination, date)

    def _format_amadeus_response(self, data, carriers=None):
        carriers = carriers or {}
        results = []
        for offer in data:
            itineraries = offer.get("itineraries", [])
            if not itineraries:
                continue
            
            # Use the first segment of the first itinerary as lead info
            segments = itineraries[0].get("segments", [])
            if not segments:
                continue
                
            lead_segment = segments[0]
            price_info = offer.get("price", {})
            carrier_code = lead_segment.get("carrierCode")
            
            # For multi-city or round-trip, we might have multiple carriers.
            # We add all carriers found in this offer to help the frontend identify available airlines.
            all_carriers = set()
            for iti in itineraries:
                for seg in iti.get("segments", []):
                    c_code = seg.get("carrierCode")
                    if c_code:
                        all_carriers.add(c_code)

            results.append({
                "airline": carrier_code,
                "airlineName": carriers.get(carrier_code, carrier_code),
                "all_airlines": list(all_carriers),
                "origin": lead_segment.get("departure", {}).get("iataCode"),
                "destination": lead_segment.get("arrival", {}).get("iataCode"),
                "departure_time": lead_segment.get("departure", {}).get("at"),
                "arrival_time": segments[-1].get("arrival", {}).get("at"), # arrival of the last segment in the first itinerary
                "price": float(price_info.get("total", "0")),
                "currency": price_info.get("currency", "EUR"),
                "source": "amadeus"
            })
        return results

    def search_flights_multi_city(self, legs, passengers=1, travel_class="ECONOMY"):
        """
        Supports multiple segments using POST /v2/shopping/flight-offers
        legs: list of {'origin': '...', 'destination': '...', 'date': '...'}
        """
        token = self._get_token()
        if not token:
            return []

        url = f"{self.BASE_URL}/v2/shopping/flight-offers"
        headers = {
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json"
        }

        origin_destinations = []
        for i, leg in enumerate(legs):
            origin_destinations.append({
                "id": str(i + 1),
                "originLocationCode": leg.get("origin", "").upper(),
                "destinationLocationCode": leg.get("destination", "").upper(),
                "departureDateTimeRange": {
                    "date": leg.get("date", "")
                }
            })

        travelers = []
        num_passengers = max(1, int(passengers))
        for i in range(num_passengers):
            travelers.append({
                "id": str(i + 1),
                "travelerType": "ADULT"
            })

        payload = {
            "currencyCode": "EUR",
            "originDestinations": origin_destinations,
            "travelers": travelers,
            "sources": ["GDS"],
            "searchCriteria": {
                "maxFlightOffers": 5,
                "flightFilters": {
                    "cabin": travel_class.upper()
                }
            }
        }

        try:
            res = requests.post(url, headers=headers, json=payload, timeout=15)
            if res.status_code == 200:
                json_res = res.json()
                data = json_res.get("data", [])
                dictionaries = json_res.get("dictionaries", {})
                carriers = dictionaries.get("carriers", {})
                if data:
                    return self._format_amadeus_response(data, carriers)
        except requests.RequestException:
            pass

        return []

    def search_airports(self, keyword):
        """
        Searches airports/cities by keyword using Amadeus Location API.
        Returns list of {iataCode, name, cityName, countryCode}.
        """
        token = self._get_token()
        if not token:
            return []

        url = f"{self.BASE_URL}/v1/reference-data/locations"
        headers = {"Authorization": f"Bearer {token}"}
        params = {
            "subType": "AIRPORT,CITY",
            "keyword": keyword,
            "page[limit]": 10,
            "view": "LIGHT",
        }
        try:
            res = requests.get(url, headers=headers, params=params, timeout=8)
            if res.status_code == 200:
                data = res.json().get("data", [])
                return [
                    {
                        "iataCode": loc.get("iataCode", ""),
                        "name": loc.get("name", ""),
                        "cityName": loc.get("address", {}).get("cityName", ""),
                        "countryCode": loc.get("address", {}).get("countryCode", ""),
                    }
                    for loc in data
                    if loc.get("iataCode")
                ]
        except requests.RequestException:
            pass
        return []

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
