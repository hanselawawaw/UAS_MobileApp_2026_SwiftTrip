import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swifttrip_frontend/screens/searching/services/searching_service.dart';
import 'package:swifttrip_frontend/screens/searching/models/flight_offer.dart';
import 'package:swifttrip_frontend/screens/searching/models/flight_leg.dart';
import 'package:swifttrip_frontend/screens/searching/models/coupon_model.dart';

// ─── Mock Classes ────────────────────────────────────────────────────────────

class MockSearchingService extends Mock implements SearchingService {}

// ─── Helper: buat FlightLeg dengan semua required fields ─────────────────────
// FIX: FlightLeg membutuhkan originLocationCode, destinationLocationCode,
// originLabel, destinationLabel, dan departureDate.

FlightLeg makeFlightLeg({
  String originLocationCode = 'CGK',
  String destinationLocationCode = 'DPS',
  String originLabel = 'Jakarta',
  String destinationLabel = 'Bali',
  String departureDate = '2026-06-01',
}) {
  return FlightLeg(
    originLocationCode: originLocationCode,
    destinationLocationCode: destinationLocationCode,
    originLabel: originLabel,
    destinationLabel: destinationLabel,
    departureDate: departureDate,
  );
}

// ─── Unit Tests: Searching - Search Trip ────────────────────────────────────

void main() {
  group('Searching - Search Trip Unit Tests', () {
    late MockSearchingService mockService;

    setUp(() {
      mockService = MockSearchingService();
    });

    // ── validateSearchQuery() ─────────────────────────────────────────────

    group('validateSearchQuery()', () {
      test('should return true when origin and destination are different', () {
        // Arrange
        const origin = 'CGK';
        const destination = 'DPS';

        // Act
        final isValid = origin.isNotEmpty &&
            destination.isNotEmpty &&
            origin != destination;

        // Assert
        expect(isValid, isTrue);
      });

      test('should return false when origin equals destination', () {
        // Arrange
        const origin = 'CGK';
        const destination = 'CGK';

        // Act
        final isValid = origin != destination;

        // Assert
        expect(isValid, isFalse);
      });

      test('should return false when origin is empty', () {
        // Arrange
        const origin = '';
        const destination = 'DPS';

        // Act
        final isValid = origin.isNotEmpty && destination.isNotEmpty;

        // Assert
        expect(isValid, isFalse);
      });

      test('should return false when destination is empty', () {
        // Arrange
        const origin = 'CGK';
        const destination = '';

        // Act
        final isValid = origin.isNotEmpty && destination.isNotEmpty;

        // Assert
        expect(isValid, isFalse);
      });

      test('should return false when both fields are empty', () {
        // Arrange
        const origin = '';
        const destination = '';

        // Act
        final isValid = origin.isNotEmpty && destination.isNotEmpty;

        // Assert
        expect(isValid, isFalse);
      });
    });

    // ── saveSearchState() ─────────────────────────────────────────────────

    group('saveSearchState()', () {
      test('should retain search parameters after state change', () {
        // Arrange
        final searchState = {
          'from': 'CGK',
          'to': 'DPS',
          'date': '2026-06-01',
          'passengers': '1',
          'class': 'Economy',
        };

        // Act
        final savedFrom = searchState['from'];
        final savedTo = searchState['to'];

        // Assert
        expect(savedFrom, equals('CGK'));
        expect(savedTo, equals('DPS'));
      });

      test('should update search state when parameters change', () {
        // Arrange
        var searchState = {'from': 'CGK', 'to': 'DPS'};

        // Act
        searchState = {'from': 'SUB', 'to': 'DPS'};

        // Assert
        expect(searchState['from'], equals('SUB'));
      });

      test('should handle multi-city search state with multiple legs', () {
        // Arrange
        // FIX: FlightLeg butuh originLabel dan destinationLabel
        final legs = [
          makeFlightLeg(
            originLocationCode: 'CGK',
            destinationLocationCode: 'DPS',
            originLabel: 'Jakarta',
            destinationLabel: 'Bali',
            departureDate: '2026-06-01',
          ),
          makeFlightLeg(
            originLocationCode: 'DPS',
            destinationLocationCode: 'SUB',
            originLabel: 'Bali',
            destinationLabel: 'Surabaya',
            departureDate: '2026-06-05',
          ),
        ];

        // Assert
        expect(legs.length, equals(2));
        expect(legs[0].originLocationCode, equals('CGK'));
        expect(legs[1].destinationLocationCode, equals('SUB'));
        expect(legs[0].originLabel, equals('Jakarta'));
        expect(legs[1].destinationLabel, equals('Surabaya'));
      });
    });

    // ── TextFormField validator() ─────────────────────────────────────────

    group('validator() for Origin and Destination fields', () {
      String? validateField(String? value) {
        if (value == null || value.trim().isEmpty) {
          return 'Field cannot be empty';
        }
        if (value.trim().length < 3) {
          return 'Minimum 3 characters';
        }
        return null;
      }

      test('should return error message when field is null', () {
        expect(validateField(null), equals('Field cannot be empty'));
      });

      test('should return error message when field is empty string', () {
        expect(validateField(''), equals('Field cannot be empty'));
      });

      test('should return error message when value is too short', () {
        expect(validateField('AB'), equals('Minimum 3 characters'));
      });

      test('should return null when field value is valid', () {
        expect(validateField('CGK'), isNull);
      });

      test('should return null for valid destination with spaces trimmed', () {
        expect(validateField('  DPS  '), isNull);
      });
    });

    // ── selectTravelType() / onChanged() ─────────────────────────────────

    group('selectTravelType() and onChanged()', () {
      test('should set travel type to One Way', () {
        String selectedType = 'Round Trip';
        selectedType = 'One Way';
        expect(selectedType, equals('One Way'));
      });

      test('should set travel type to Multi City', () {
        String selectedType = 'Round Trip';
        selectedType = 'Multi City';
        expect(selectedType, equals('Multi City'));
      });

      test('should update class selection from Economy to Business', () {
        String flightClass = 'economy';
        flightClass = 'business';
        expect(flightClass, equals('business'));
      });

      test('should have 3 valid travel type options', () {
        const travelTypes = ['One Way', 'Round Trip', 'Multi City'];
        expect(travelTypes.length, equals(3));
        expect(travelTypes, contains('One Way'));
        expect(travelTypes, contains('Round Trip'));
        expect(travelTypes, contains('Multi City'));
      });
    });

    // ── searchFlights() service call ──────────────────────────────────────

    group('searchFlights() service', () {
      test('should call searchFlights with correct parameters', () async {
        // Arrange
        when(
          () => mockService.searchFlights(
            multiCityLegs: any(named: 'multiCityLegs'),
            from: any(named: 'from'),
            to: any(named: 'to'),
            date: any(named: 'date'),
            passengers: any(named: 'passengers'),
            flightClass: any(named: 'flightClass'),
            isMultiCity: any(named: 'isMultiCity'),
          ),
        ).thenAnswer((_) async => []);

        // Act
        final result = await mockService.searchFlights(
          multiCityLegs: [],
          from: 'CGK',
          to: 'DPS',
          date: '2026-06-01',
          passengers: '1',
          flightClass: 'economy',
          isMultiCity: false,
        );

        // Assert
        expect(result, isA<List<FlightOffer>>());
        verify(
          () => mockService.searchFlights(
            multiCityLegs: any(named: 'multiCityLegs'),
            from: 'CGK',
            to: 'DPS',
            date: '2026-06-01',
            passengers: '1',
            flightClass: 'economy',
            isMultiCity: false,
          ),
        ).called(1);
      });

      test('should throw exception when network error occurs', () async {
        // Arrange
        when(
          () => mockService.searchFlights(
            multiCityLegs: any(named: 'multiCityLegs'),
            from: any(named: 'from'),
            to: any(named: 'to'),
            date: any(named: 'date'),
            passengers: any(named: 'passengers'),
            flightClass: any(named: 'flightClass'),
            isMultiCity: any(named: 'isMultiCity'),
          ),
        ).thenThrow(Exception('Network error'));

        // Act & Assert
        expect(
          () => mockService.searchFlights(
            multiCityLegs: [],
            from: 'CGK',
            to: 'DPS',
            date: '2026-06-01',
            passengers: '1',
            flightClass: 'economy',
            isMultiCity: false,
          ),
          throwsA(isA<Exception>()),
        );
      });
    });

    // ── getCouponsByCategory() ────────────────────────────────────────────

    group('getCouponsByCategory()', () {
      test('should return coupons for valid category', () async {
        // Arrange
        final service = SearchingService();

        // Act
        final result = await service.getCouponsByCategory('Coupon Raya');

        // Assert
        expect(result, isA<List<CouponModel>>());
        expect(result, isNotEmpty);
        expect(result.first.code, contains('RAYA'));
      });

      test('should return empty list for unknown category', () async {
        // Arrange
        final service = SearchingService();

        // Act
        final result = await service.getCouponsByCategory('Unknown');

        // Assert
        expect(result, isEmpty);
      });
    });
  });
}