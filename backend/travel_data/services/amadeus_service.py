import os
import requests
import logging
from datetime import datetime, timedelta
import random
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
                "currencyCode": "IDR",
                "max": 5
            }
            try:
                res = requests.get(url, headers=headers, params=params, timeout=10)
                if res.status_code == 200:
                    json_res = res.json()
                    data = json_res.get("data", [])
                    if data:
                        return self._format_amadeus_response(data, json_res.get("dictionaries", {}).get("carriers", {}))
            except requests.RequestException:
                pass

        # The Fallback: If data is empty or network fails, generate dynamic data.
        return self._generative_fallback(origin, destination, date, passengers, travel_class)
    
    def _generative_fallback(self, origin, destination, date, passengers, travel_class):
        """
        Generates dynamic flight data based on user/AI input parameters.
        """
        # 1. Handle Dynamic Date
        try:
            # If the AI/Frontend sends a valid YYYY-MM-DD string
            base_date = datetime.strptime(date, "%Y-%m-%d")
        except (ValueError, TypeError):
            # Fallback to 7 days from now if date is 'next week' or invalid
            base_date = datetime.now() + timedelta(days=7)

        # 2. Handle Dynamic Pricing
        # Multiply base price by class (First Class is more expensive)
        class_map = {"ECONOMY": 1.0, "PREMIUM_ECONOMY": 1.5, "BUSINESS": 2.5, "FIRST": 4.0}
        multiplier = class_map.get(travel_class.upper(), 1.0)
        
        num_passengers = max(1, int(passengers))
        
        # 3. Generate 3 Diverse Options
        airlines = [
            {"code": "GA", "name": "Garuda Indonesia", "price": 1200000},
            {"code": "EK", "name": "Emirates", "price": 8500000},
            {"code": "QR", "name": "Qatar Airways", "price": 7800000},
        ]

        results = []
        for i, air in enumerate(airlines):
            # Create staggered times based on the base_date
            depart = base_date + timedelta(hours=6 + (i * 5), minutes=random.randint(0, 59))
            arrive = depart + timedelta(hours=random.randint(2, 12))

            results.append({
                "airline": air["code"],
                "airlineName": air["name"],
                "all_airlines": [air["code"]],
                "flight_number": f"{air['code']} {random.randint(100, 999)}",
                "origin": origin.upper(),
                "destination": destination.upper(),
                "departure_time": depart.strftime("%Y-%m-%dT%H:%M:%S"),
                "arrival_time": arrive.strftime("%Y-%m-%dT%H:%M:%S"),
                "price": float(air["price"] * multiplier * num_passengers),
                "currency": "IDR",
                "source": "generative_mock"
            })
        
        return results

    def _format_amadeus_response(self, data, carriers=None):
        carriers = carriers or {}
        cheapest_by_airline = {}

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
            price = float(price_info.get("total", "0"))
            
            # For multi-city or round-trip, we might have multiple carriers.
            # We add all carriers found in this offer to help the frontend identify available airlines.
            all_carriers = set()
            for iti in itineraries:
                for seg in iti.get("segments", []):
                    c_code = seg.get("carrierCode")
                    if c_code:
                        all_carriers.add(c_code)

            formatted_offer = {
                "airline": carrier_code,
                "airlineName": carriers.get(carrier_code, carrier_code),
                "all_airlines": list(all_carriers),
                "flight_number": f"{carrier_code} {lead_segment.get('number')}",
                "origin": lead_segment.get("departure", {}).get("iataCode"),
                "destination": segments[-1].get("arrival", {}).get("iataCode"),
                "departure_time": lead_segment.get("departure", {}).get("at"),
                "arrival_time": segments[-1].get("arrival", {}).get("at"), # arrival of the last segment in the first itinerary
                "price": price,
                "currency": price_info.get("currency", "EUR"),
                "source": "amadeus"
            }

            # Only keep the cheapest representative for this airline
            if carrier_code not in cheapest_by_airline or price < cheapest_by_airline[carrier_code]["price"]:
                cheapest_by_airline[carrier_code] = formatted_offer

        return list(cheapest_by_airline.values())

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
            "currencyCode": "IDR",
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
                if data:
                    return self._format_amadeus_response(data, json_res.get("dictionaries", {}).get("carriers", {}))
        except requests.RequestException:
            pass

        # The Fallback: Intercept empty responses and generate multi-city data
        return self._generative_fallback_multi_city(legs, passengers, travel_class)

    def _generative_fallback_multi_city(self, legs, passengers, travel_class):
        """
        Generates dynamic flight data for multi-city trips.
        """
        if not legs:
            return []

        # 1. Journey Metadata
        num_legs = len(legs)
        first_leg = legs[0]
        last_leg = legs[-1]
        
        origin = first_leg.get("origin", "CGK").upper()
        destination = last_leg.get("destination", "DXB").upper()
        
        # 2. Dynamic Pricing Logic
        class_map = {"ECONOMY": 1.0, "PREMIUM_ECONOMY": 1.5, "BUSINESS": 2.5, "FIRST": 4.0}
        multiplier = class_map.get(travel_class.upper(), 1.0)
        num_passengers = max(1, int(passengers))
        
        # Multi-city is naturally more expensive
        base_trip_price = 5000000 * num_legs 

        airlines = [
            {"code": "SQ", "name": "Singapore Airlines", "price": base_trip_price},
            {"code": "EK", "name": "Emirates", "price": base_trip_price * 1.2},
            {"code": "TK", "name": "Turkish Airlines", "price": base_trip_price * 0.9},
        ]

        results = []
        for i, air in enumerate(airlines):
            try:
                depart_date = datetime.strptime(first_leg.get("date"), "%Y-%m-%d")
            except:
                depart_date = datetime.now() + timedelta(days=7)

            try:
                arrival_date = datetime.strptime(last_leg.get("date"), "%Y-%m-%d")
            except:
                arrival_date = depart_date + timedelta(days=num_legs)

            results.append({
                "airline": air["code"],
                "airlineName": air["name"],
                "all_airlines": [air["code"]],
                "flight_number": f"{air['code']} {random.randint(100, 999)} (Multi-City)",
                "origin": origin,
                "destination": destination,
                "departure_time": depart_date.strftime("%Y-%m-%dT08:00:00"),
                "arrival_time": arrival_date.strftime("%Y-%m-%dT22:00:00"),
                "price": float(air["price"] * multiplier * num_passengers),
                "currency": "IDR",
                "source": "generative_mock_multi"
            })
        
        return results

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
