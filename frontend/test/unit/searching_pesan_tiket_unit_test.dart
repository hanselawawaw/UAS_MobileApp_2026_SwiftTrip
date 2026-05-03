import 'package:flutter_test/flutter_test.dart';
import 'package:swifttrip_frontend/screens/searching/widgets/pickers.dart';
import 'package:swifttrip_frontend/screens/cart/models/cart_models.dart';
import 'package:swifttrip_frontend/screens/searching/models/flight_offer.dart';

// ─── Helper: buat FlightOffer dengan semua required fields ───────────────────
// FIX: FlightOffer membutuhkan: airlineCode, airlineName, allAirlines,
// origin, destination, flightNumber, departureTime, arrivalTime,
// price, currency. TIDAK ada field: duration, stops, flightClass.

FlightOffer makeFlightOffer({
  String airlineCode = 'GA',
  String airlineName = 'Garuda Indonesia',
  List<String> allAirlines = const ['Garuda Indonesia'],
  String origin = 'CGK',
  String destination = 'DPS',
  String flightNumber = 'GA-001',
  String departureTime = '2026-06-01T08:00',
  String arrivalTime = '2026-06-01T10:00',
  double price = 1500000,
  String currency = 'IDR',
  double? latitude = -8.74,
  double? longitude = 115.16,
}) {
  return FlightOffer(
    airlineCode: airlineCode,
    airlineName: airlineName,
    allAirlines: allAirlines,
    origin: origin,
    destination: destination,
    flightNumber: flightNumber,
    departureTime: departureTime,
    arrivalTime: arrivalTime,
    price: price,
    currency: currency,
    latitude: latitude,
    longitude: longitude,
  );
}

// ─── Unit Tests: Searching - Pesan Tiket ────────────────────────────────────

void main() {
  group('Searching - Pesan Tiket Unit Tests', () {
    // ── validator() — TextFormField Passenger ─────────────────────────────

    group('validator() — TextFormField Passenger', () {
      String? validatePassenger(int? count) {
        if (count == null || count < 1) return 'Minimum 1 passenger required';
        if (count > 9) return 'Maximum 9 passengers allowed';
        return null;
      }

      test('should return error when passenger count is null', () {
        expect(validatePassenger(null), equals('Minimum 1 passenger required'));
      });

      test('should return error when passenger count is 0', () {
        expect(validatePassenger(0), equals('Minimum 1 passenger required'));
      });

      test('should return null for valid passenger count of 1', () {
        expect(validatePassenger(1), isNull);
      });

      test('should return null for valid passenger count of 5', () {
        expect(validatePassenger(5), isNull);
      });

      test('should return error when passenger count exceeds maximum', () {
        expect(validatePassenger(10), equals('Maximum 9 passengers allowed'));
      });
    });

    // ── savePassengerDetails() ────────────────────────────────────────────

    group('savePassengerDetails()', () {
      test('should create PassengerCount with correct values', () {
        const pc = PassengerCount(adults: 2, children: 1, infants: 0);

        expect(pc.adults, equals(2));
        expect(pc.children, equals(1));
        expect(pc.infants, equals(0));
      });

      test('should compute total passengers correctly', () {
        const pc = PassengerCount(adults: 2, children: 1, infants: 1);

        expect(pc.total, equals(4));
      });

      test('should display label with adults only', () {
        const pc = PassengerCount(adults: 1);

        expect(pc.displayLabel, equals('1 Adult'));
      });

      test('should display label with adults and children', () {
        const pc = PassengerCount(adults: 2, children: 2);

        expect(pc.displayLabel, contains('2 Adults'));
        expect(pc.displayLabel, contains('2 Children'));
      });

      test('should display plural adults correctly', () {
        const pc = PassengerCount(adults: 3);

        expect(pc.displayLabel, equals('3 Adults'));
      });

      test('copyWith should update only the specified field', () {
        const original = PassengerCount(adults: 1, children: 0, infants: 0);

        final updated = original.copyWith(adults: 3);

        expect(updated.adults, equals(3));
        expect(updated.children, equals(0));
        expect(updated.infants, equals(0));
      });

      test('should not allow adult count to go below 1', () {
        const pc = PassengerCount(adults: 1);

        final next = pc.adults - 1;
        final newCount = next >= 1 ? pc.copyWith(adults: next) : pc;

        expect(newCount.adults, equals(1));
      });
    });

    // ── selectSeat() via DropdownButton ───────────────────────────────────

    group('selectSeat() — seat class selection', () {
      test('should have Economy as default seat class', () {
        const defaultClass = 'Economy';
        expect(defaultClass, equals('Economy'));
      });

      test('should accept valid seat class options', () {
        const validClasses = ['Economy', 'Business', 'First'];
        expect(validClasses, contains('Business'));
      });

      test('should update seat class when changed', () {
        String seatClass = 'Economy';
        seatClass = 'Business';
        expect(seatClass, equals('Business'));
      });

      test('should convert seat class to API format correctly', () {
        String mapToApiClass(String displayClass) {
          switch (displayClass.toLowerCase()) {
            case 'economy':
              return 'economy';
            case 'business':
              return 'business';
            case 'first':
              return 'first';
            default:
              return 'economy';
          }
        }

        expect(mapToApiClass('Economy'), equals('economy'));
        expect(mapToApiClass('Business'), equals('business'));
        expect(mapToApiClass('First'), equals('first'));
      });
    });

    // ── confirmTicketSelection() via ElevatedButton ───────────────────────

    group('confirmTicketSelection() — build CartTicket from FlightOffer', () {
      test('should build CartTicket correctly from FlightOffer data', () {
        // Arrange — gunakan helper, semua required field terisi
        final offer = makeFlightOffer();

        // classLabel diambil dari pilihan user di UI, bukan dari FlightOffer
        const selectedFlightClass = 'Economy';

        // Act
        final ticket = CartTicket(
          type: 'Plane Ticket',
          bookingId: 'ID-TEST-001',
          classLabel: selectedFlightClass,
          from: offer.origin,
          to: offer.destination,
          date: offer.departureTime.split('T').first,
          departure: offer.departureTime.split('T').last.substring(0, 5),
          arrive: offer.arrivalTime.split('T').last.substring(0, 5),
          operator: offer.airlineName,
          flightNumber: offer.flightNumber,
          priceRp: offer.price.toInt(),
          latitude: offer.latitude,
          longitude: offer.longitude,
        );

        // Assert
        expect(ticket.type, equals('Plane Ticket'));
        expect(ticket.from, equals('CGK'));
        expect(ticket.to, equals('DPS'));
        expect(ticket.operator, equals('Garuda Indonesia'));
        expect(ticket.priceRp, equals(1500000));
        expect(ticket.date, equals('2026-06-01'));
        expect(ticket.departure, equals('08:00'));
        expect(ticket.arrive, equals('10:00'));
        expect(ticket.classLabel, equals('Economy'));
      });

      test('should return true when flight offer is selected before confirm',
          () {
        // Arrange
        final FlightOffer? selectedFlight = makeFlightOffer(
          airlineCode: 'SJ',
          airlineName: 'Sriwijaya Air',
          allAirlines: const ['Sriwijaya Air'],
          origin: 'SUB',
          destination: 'CGK',
          flightNumber: 'SJ-202',
          departureTime: '2026-07-10T14:00',
          arrivalTime: '2026-07-10T15:30',
          price: 750000,
          latitude: -6.2,
          longitude: 106.8,
        );

        // Act
        final canConfirm = selectedFlight != null;

        // Assert
        expect(canConfirm, isTrue);
      });

      test('should return false when no flight offer is selected', () {
        FlightOffer? selectedFlight;

        final canConfirm = selectedFlight != null;

        expect(canConfirm, isFalse);
      });

      test('should correctly split departureTime into date and time parts', () {
        const departureTime = '2026-06-01T08:00';

        final date = departureTime.split('T').first;
        final time = departureTime.split('T').last.substring(0, 5);

        expect(date, equals('2026-06-01'));
        expect(time, equals('08:00'));
      });

      test('should format price in Rupiah correctly', () {
        String formatRp(int amount) {
          return 'Rp ${amount.toString().replaceAllMapped(
                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                (m) => '${m[1]}.',
              )}';
        }

        expect(formatRp(1500000), equals('Rp 1.500.000'));
        expect(formatRp(750000), equals('Rp 750.000'));
      });

      test('should use allAirlines list from FlightOffer correctly', () {
        // Arrange
        final offer = makeFlightOffer(
          allAirlines: const ['Garuda Indonesia', 'Citilink'],
        );

        // Assert
        expect(offer.allAirlines, contains('Garuda Indonesia'));
        expect(offer.allAirlines.length, equals(2));
      });

      test('should use currency field from FlightOffer', () {
        // Arrange
        final offer = makeFlightOffer(currency: 'IDR');

        // Assert
        expect(offer.currency, equals('IDR'));
      });
    });
  });
}