import datetime

class MockLandService:
    @staticmethod
    def _get_times(hour_offset, duration_minutes):
        now = datetime.datetime.now()
        departure = now + datetime.timedelta(hours=hour_offset)
        arrive = departure + datetime.timedelta(minutes=duration_minutes)
        return {
            "date": departure.strftime("%d %b %Y"),
            "departure": departure.strftime("%H:%M"),
            "arrive": arrive.strftime("%H:%M")
        }

    @staticmethod
    def get_mock_cars():
        t1 = MockLandService._get_times(0, 75)
        t2 = MockLandService._get_times(1, 90)
        t3 = MockLandService._get_times(2, 90)
        t4 = MockLandService._get_times(3, 75)
        t5 = MockLandService._get_times(5, 75)
        t6 = MockLandService._get_times(8, 90)
        t7 = MockLandService._get_times(11, 75)

        return [
            {
                "type": "Car Ticket", "bookingId": "CAR-001", "classLabel": "Economy", "priceRp": 65000,
                "operator": "GoCar", "from": "Bintaro", "to": "Sudirman", **t1,
                "carPlate": "B 1234 XYZ", "driverName": "Pak Budi",
                "latitude": -6.298200, "longitude": 106.641500
            },
            {
                "type": "Car Ticket", "bookingId": "CAR-002", "classLabel": "Economy", "priceRp": 85000,
                "operator": "GrabCar", "from": "BSD", "to": "Kuningan", **t2,
                "carPlate": "B 5678 ABC", "driverName": "Pak Rudi",
                "latitude": -6.301800, "longitude": 106.635200
            },
            {
                "type": "Car Ticket", "bookingId": "CAR-003", "classLabel": "Premium", "priceRp": 120000,
                "operator": "BlueBird", "from": "Ciputat", "to": "Thamrin", **t3,
                "carPlate": "B 9012 DEF", "driverName": "Pak Hendra",
                "latitude": -6.303500, "longitude": 106.639800
            },
            {
                "type": "Car Ticket", "bookingId": "CAR-004", "classLabel": "Economy", "priceRp": 72000,
                "operator": "GoCar", "from": "Serpong", "to": "Semanggi", **t4,
                "carPlate": "B 3344 GHI", "driverName": "Pak Agus",
                "latitude": -6.297900, "longitude": 106.637100
            },
            {
                "type": "Car Ticket", "bookingId": "CAR-005", "classLabel": "Economy", "priceRp": 78000,
                "operator": "GrabCar", "from": "Alam Sutera", "to": "Gatot Subroto", **t5,
                "carPlate": "B 7788 JKL", "driverName": "Pak Wahyu",
                "latitude": -6.300700, "longitude": 106.643200
            },
            {
                "type": "Car Ticket", "bookingId": "CAR-006", "classLabel": "Premium", "priceRp": 135000,
                "operator": "BlueBird", "from": "Tangerang", "to": "Sudirman", **t6,
                "carPlate": "B 2255 MNO", "driverName": "Pak Doni",
                "latitude": -6.304200, "longitude": 106.636100
            },
            {
                "type": "Car Ticket", "bookingId": "CAR-007", "classLabel": "Economy", "priceRp": 60000,
                "operator": "GoCar", "from": "Jombang", "to": "Blok M", **t7,
                "carPlate": "B 9900 PQR", "driverName": "Pak Fauzi",
                "latitude": -6.296800, "longitude": 106.640300
            }
        ]

    @staticmethod
    def get_mock_buses():
        t1 = MockLandService._get_times(0, 75)
        t2 = MockLandService._get_times(2, 150)
        t3 = MockLandService._get_times(4, 120)
        t4 = MockLandService._get_times(7, 45)
        t5 = MockLandService._get_times(10, 105)

        return [
            {
                "type": "Bus Ticket", "bookingId": "BUS-001", "classLabel": "Regular", "priceRp": 3500,
                "operator": "TransJakarta", "from": "BSD City", "to": "Blok M", **t1,
                "busClass": "Regular", "busNumber": "S21",
                "latitude": -6.296500, "longitude": 106.639200
            },
            {
                "type": "Bus Ticket", "bookingId": "BUS-002", "classLabel": "Executive", "priceRp": 15000,
                "operator": "PO Haryanto", "from": "BSD", "to": "Kampung Rambutan", **t2,
                "busClass": "Executive", "busNumber": "HR-77",
                "latitude": -6.299100, "longitude": 106.644800
            },
            {
                "type": "Bus Ticket", "bookingId": "BUS-003", "classLabel": "Economy", "priceRp": 12000,
                "operator": "Mayasari Bakti", "from": "BSD", "to": "Senen", **t3,
                "busClass": "Economy", "busNumber": "AC-05",
                "latitude": -6.304800, "longitude": 106.642600
            },
            {
                "type": "Bus Ticket", "bookingId": "BUS-004", "classLabel": "Regular", "priceRp": 3500,
                "operator": "TransJakarta", "from": "BSD", "to": "Lebak Bulus", **t4,
                "busClass": "Regular", "busNumber": "S15",
                "latitude": -6.301200, "longitude": 106.633800
            },
            {
                "type": "Bus Ticket", "bookingId": "BUS-005", "classLabel": "Economy", "priceRp": 8000,
                "operator": "Damri", "from": "Serpong", "to": "Tanah Abang", **t5,
                "busClass": "Economy", "busNumber": "DM-12",
                "latitude": -6.305600, "longitude": 106.635500
            }
        ]

    @staticmethod
    def get_mock_trains():
        t1 = MockLandService._get_times(0, 75)
        t2 = MockLandService._get_times(3, 80)
        t3 = MockLandService._get_times(6, 45)
        t4 = MockLandService._get_times(12, 135)

        return [
            {
                "type": "Train Ticket", "bookingId": "TRN-001", "classLabel": "Commuter", "priceRp": 5000,
                "operator": "KAI Commuter", "from": "Serpong", "to": "Tanah Abang", **t1,
                "carriage": "KRL-4", "seat": "-",
                "latitude": -6.330800, "longitude": 106.666200
            },
            {
                "type": "Train Ticket", "bookingId": "TRN-002", "classLabel": "Commuter", "priceRp": 5000,
                "operator": "KAI Commuter", "from": "Sudimara", "to": "Duri", **t2,
                "carriage": "KRL-7", "seat": "-",
                "latitude": -6.336400, "longitude": 106.710500
            },
            {
                "type": "Train Ticket", "bookingId": "TRN-003", "classLabel": "LRT", "priceRp": 10000,
                "operator": "KAI LRT Jabodebek", "from": "Ciracas", "to": "Dukuh Atas", **t3,
                "carriage": "LRT-2", "seat": "A12",
                "latitude": -6.285600, "longitude": 106.680400
            },
            {
                "type": "Train Ticket", "bookingId": "TRN-004", "classLabel": "Economy", "priceRp": 8000,
                "operator": "KAI Commuter", "from": "Rangkasbitung", "to": "Tanah Abang", **t4,
                "carriage": "KRL-11", "seat": "-",
                "latitude": -6.358200, "longitude": 106.618700
            }
        ]

    def search_land_tickets(self, vehicle_type, origin, destination):
        v_type = vehicle_type.lower()
        if v_type == 'car':
            dataset = self.get_mock_cars()
        elif v_type == 'bus':
            dataset = self.get_mock_buses()
        elif v_type == 'train':
            dataset = self.get_mock_trains()
        else:
            return []
            
        def is_match(item):
            # Check if origin matches somewhere in from/to, and destination matches somewhere
            match_o = not origin or origin.lower() == 'unknown' or origin.lower() in item.get('from', '').lower() or origin.lower() in item.get('to', '').lower()
            match_d = not destination or destination.lower() == 'unknown' or destination.lower() in item.get('to', '').lower() or destination.lower() in item.get('from', '').lower()
            return match_o and match_d

        matches = [item for item in dataset if is_match(item)]
        return matches or dataset  # Fallback to all if no exact match
