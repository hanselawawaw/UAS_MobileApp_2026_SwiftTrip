import os
import requests
import logging
from datetime import datetime, timedelta
import random
import math
import re
from django.core.cache import cache
from travel_data.models import TransportRoute

logger = logging.getLogger(__name__)

class AmadeusService:
    BASE_URL = "https://test.api.amadeus.com"
    TOKEN_CACHE_KEY = "amadeus_access_token"

    def __init__(self):
        self.api_key = os.environ.get("AMADEUS_API_KEY")
        self.api_secret = os.environ.get("AMADEUS_API_SECRET")
        self._airport_data_cache = None

    def _get_airport_coordinates(self, iata_code):
        """
        Extracts lat/lng from the frontend airport_search_service.dart file.
        Returns (lat, lng) as floats or (None, None) if not found.
        """
        if self._airport_data_cache is None:
            self._airport_data_cache = {}
            try:
                # Path relative to this service file
                dart_file_path = os.path.abspath(os.path.join(
                    os.path.dirname(__file__), 
                    '..', '..', '..', 'frontend', 'lib', 'screens', 'searching', 'services', 'airport_search_service.dart'
                ))
                with open(dart_file_path, 'r', encoding='utf-8') as f:
                    content = f.read()
                
                # Regex to find blocks of airports
                # Matching: 'iataCode': '...', ... 'lat': '...', 'lng': '...'
                matches = re.finditer(r"\{[^{]*'iataCode':\s*'([^']*)'[^{]*'lat':\s*'([^']*)'[^{]*'lng':\s*'([^']*)'", content, re.DOTALL)
                for m in matches:
                    code, lat, lng = m.groups()
                    self._airport_data_cache[code.upper()] = (float(lat), float(lng))
            except Exception as e:
                logger.error(f"Error reading airport data from dart file: {e}")

        return self._airport_data_cache.get(iata_code.upper(), (None, None))

    def _calculate_distance(self, lat1, lon1, lat2, lon2):
        """
        Haversine formula to calculate the distance between two points in km.
        """
        if None in (lat1, lon1, lat2, lon2):
            return 1000.0  # Default fallback distance
            
        R = 6371.0 # Earth radius in km
        phi1, phi2 = math.radians(lat1), math.radians(lat2)
        dphi = math.radians(lat2 - lat1)
        dlambda = math.radians(lon2 - lon1)

        a = math.sin(dphi / 2)**2 + \
            math.cos(phi1) * math.cos(phi2) * math.sin(dlambda / 2)**2
        c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
        return R * c

    def _get_dynamic_price(self, origin, destination):
        """
        Calculates price: 500,000 Rp base + 1,500 Rp per km.
        """
        lat1, lon1 = self._get_airport_coordinates(origin)
        lat2, lon2 = self._get_airport_coordinates(destination)
        distance = self._calculate_distance(lat1, lon1, lat2, lon2)
        
        # Formula: 500k + (dist * 1.5k)
        price = 500000 + (distance * 1500)
        return int(price)

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
                "max": 10
            }
            try:
                res = requests.get(url, headers=headers, params=params, timeout=10)
                if res.status_code == 200:
                    json_res = res.json()
                    data = json_res.get("data", [])
                    if data:
                        flights = self._format_amadeus_response(data, json_res.get("dictionaries", {}).get("carriers", {}), travel_class)
                        
                        # Temporal Validation: Filter past flights if today (2026-04-12)
                        now = datetime.now()
                        current_date_str = now.strftime("%Y-%m-%d")
                        if date == current_date_str:
                            current_time_str = now.strftime("%H:%M:%S")
                            flights = [f for f in flights if f['departure_time'].split('T')[-1] > current_time_str]
                        
                        if flights:
                            return flights
            except requests.RequestException:
                pass

        # The Fallback: If data is empty or network fails, generate dynamic data.
        flights = self._generative_fallback(origin, destination, date, passengers, travel_class)
        
        # Temporal Validation for fallback as well
        now = datetime.now()
        current_date_str = now.strftime("%Y-%m-%d")
        if date == current_date_str:
            current_time_str = now.strftime("%H:%M:%S")
            flights = [f for f in flights if f['departure_time'].split('T')[-1] > current_time_str]
            
        return flights
    
    def _generative_fallback(self, origin, destination, date, passengers, travel_class):
        """
        Generates dynamic flight data based on user/AI input parameters.
        """
        # 1. Handle Dynamic Date
        try:
            base_date = datetime.strptime(date, "%Y-%m-%d")
        except (ValueError, TypeError):
            base_date = datetime.now() + timedelta(days=7)

        # 2. Base Configuration
        num_passengers = max(1, int(passengers))
        class_map = {"ECONOMY": 1.0, "PREMIUM_ECONOMY": 1.5, "BUSINESS": 2.5, "FIRST": 4.0}
        class_multiplier = class_map.get(travel_class.upper(), 1.0)
        
        base_route_price = self._get_dynamic_price(origin, destination)
        
        # 3. Defined Temporal Windows (Diurnal Spread)
        # (Start Hour, End Hour, Duration Category)
        windows = [
            (5, 11, "short"),   # Morning
            (12, 17, "medium"), # Afternoon
            (18, 23, "long")    # Night
        ]

        airlines = [
            {"code": "GA", "name": "Garuda Indonesia"},
            {"code": "EK", "name": "Emirates"},
            {"code": "QR", "name": "Qatar Airways"},
        ]

        results = []
        for i, (start_h, end_h, dur_cat) in enumerate(windows):
            air = airlines[i]
            
            # A. Temporal Spread
            hour = random.randint(start_h, end_h)
            minute = random.randint(0, 59)
            depart = base_date.replace(hour=hour, minute=minute, second=0)
            
            # B. Duration Simulation
            if dur_cat == "short":
                dur_hours = random.uniform(1.5, 3.0)
            elif dur_cat == "medium":
                dur_hours = random.uniform(4.0, 7.0)
            else: # long
                dur_hours = random.uniform(8.0, 14.0)
            
            arrive = depart + timedelta(hours=dur_hours)

            # C. Competitive Pricing Variance
            carrier_variance = random.uniform(0.85, 1.15)
            final_price = int(base_route_price * class_multiplier * carrier_variance * num_passengers)

            results.append({
                "airline": air["code"],
                "airlineName": air["name"],
                "all_airlines": [air["code"]],
                "flight_number": f"{air['code']} {random.randint(100, 999)}",
                "origin": origin.upper(),
                "destination": destination.upper(),
                "departure_time": depart.strftime("%Y-%m-%dT%H:%M:%S"),
                "arrival_time": arrive.strftime("%Y-%m-%dT%H:%M:%S"),
                "price": float(final_price),
                "currency": "IDR",
                "travel_class": travel_class.upper(),
                "source": "generative_mock"
            })
        
        return results

    def _format_amadeus_response(self, data, carriers=None, travel_class="ECONOMY"):
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

            formatted_origin = lead_segment.get("departure", {}).get("iataCode")
            formatted_dest = segments[-1].get("arrival", {}).get("iataCode")

            formatted_offer = {
                "airline": carrier_code,
                "airlineName": carriers.get(carrier_code, carrier_code),
                "all_airlines": list(all_carriers),
                "flight_number": f"{carrier_code} {lead_segment.get('number')}",
                "origin": formatted_origin,
                "destination": formatted_dest,
                "departure_time": lead_segment.get("departure", {}).get("at"),
                "arrival_time": segments[-1].get("arrival", {}).get("at"), # arrival of the last segment in the first itinerary
                "price": float(self._get_dynamic_price(formatted_origin, formatted_dest)),
                "currency": "IDR",
                "travel_class": travel_class.upper(),
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
                    flights = self._format_amadeus_response(data, json_res.get("dictionaries", {}).get("carriers", {}), travel_class)
                    
                    # Temporal Validation for Multi-City (using first leg date)
                    now = datetime.now()
                    current_date_str = now.strftime("%Y-%m-%d")
                    first_leg_date = legs[0].get("date")
                    if first_leg_date == current_date_str:
                        current_time_str = now.strftime("%H:%M:%S")
                        flights = [f for f in flights if f['departure_time'].split('T')[-1] > current_time_str]
                    
                    if flights:
                        return flights
        except requests.RequestException:
            pass

        # The Fallback: Intercept empty responses and generate multi-city data
        flights = self._generative_fallback_multi_city(legs, passengers, travel_class)
        
        # Temporal Validation for fallback
        now = datetime.now()
        current_date_str = now.strftime("%Y-%m-%d")
        first_leg_date = legs[0].get("date")
        if first_leg_date == current_date_str:
            current_time_str = now.strftime("%H:%M:%S")
            flights = [f for f in flights if f['departure_time'].split('T')[-1] > current_time_str]
            
        return flights

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
        class_multiplier = class_map.get(travel_class.upper(), 1.0)
        num_passengers = max(1, int(passengers))
        
        # Calculate base total price from all legs
        total_base_price = 0
        for leg in legs:
            leg_origin = leg.get("origin", "").upper()
            leg_dest = leg.get("destination", "").upper()
            total_base_price += self._get_dynamic_price(leg_origin, leg_dest)

        airlines = [
            {"code": "SQ", "name": "Singapore Airlines"},
            {"code": "EK", "name": "Emirates"},
            {"code": "TK", "name": "Turkish Airlines"},
        ]

        results = []
        for i, air in enumerate(airlines):
            try:
                base_depart_date = datetime.strptime(first_leg.get("date"), "%Y-%m-%d")
            except:
                base_depart_date = datetime.now() + timedelta(days=7)

            # A. Dynamic Multi-City Scheduling
            # Random departure hour between 04:00 and 20:00
            hour = random.randint(4, 20)
            minute = random.randint(0, 59)
            depart_date = base_depart_date.replace(hour=hour, minute=minute, second=0)

            # B. Duration Simulation (Flight Duration: 2 to 14 hours)
            duration_hours = random.uniform(2.0, 14.0)
            arrival_date = depart_date + timedelta(hours=duration_hours)

            # C. Competitive Pricing Variance
            carrier_variance = random.uniform(0.85, 1.15)
            final_price = int(total_base_price * class_multiplier * carrier_variance * num_passengers)

            results.append({
                "airline": air["code"],
                "airlineName": air["name"],
                "all_airlines": [air["code"]],
                "flight_number": f"{air['code']} {random.randint(100, 999)} (Multi-City)",
                "origin": origin,
                "destination": destination,
                "departure_time": depart_date.strftime("%Y-%m-%dT%H:%M:%S"),
                "arrival_time": arrival_date.strftime("%Y-%m-%dT%H:%M:%S"),
                "price": float(final_price),
                "currency": "IDR",
                "travel_class": travel_class.upper(),
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
