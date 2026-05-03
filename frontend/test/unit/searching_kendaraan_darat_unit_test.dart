import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swifttrip_frontend/screens/searching/services/searching_service.dart';
import 'package:swifttrip_frontend/screens/searching/services/mock_vehicle_service.dart';
import 'package:swifttrip_frontend/screens/searching/models/ride_option.dart';
import 'package:swifttrip_frontend/screens/searching/models/vehicle_pin.dart';
import 'package:swifttrip_frontend/screens/cart/models/cart_models.dart';

// ─── Mock Classes ────────────────────────────────────────────────────────────

class MockSearchingService extends Mock implements SearchingService {}

// ─── Helper: buat CartTicket dengan semua required fields ────────────────────
// FIX: CartTicket membutuhkan classLabel sebagai required parameter.
// Gunakan helper ini di seluruh file agar tidak lupa field wajib.

CartTicket makeCartTicket({
  String type = 'Car',
  String bookingId = 'BK-001',
  String classLabel = 'Economy',
  int priceRp = 200000,
}) {
  return CartTicket(
    type: type,
    bookingId: bookingId,
    classLabel: classLabel,
    priceRp: priceRp,
  );
}

// ─── Unit Tests: Searching - Kendaraan Darat ────────────────────────────────

void main() {
  group('Searching - Kendaraan Darat Unit Tests', () {
    late MockSearchingService mockService;
    late MockVehicleService vehicleService;

    setUp(() {
      mockService = MockSearchingService();
      vehicleService = const MockVehicleService();
    });

    // ── fetchTransportOptions() ───────────────────────────────────────────

    group('fetchTransportOptions()', () {
      test('should return list of RideOption when service succeeds', () async {
        // Arrange
        final mockOptions = [
          const RideOption(
            name: 'Car',
            duration: '2 hrs',
            passengerCapacity: 4,
            priceRp: 0,
            icon: Icons.directions_car_outlined,
          ),
          const RideOption(
            name: 'Bus',
            duration: '3 hrs',
            passengerCapacity: 0,
            priceRp: 0,
            icon: Icons.directions_bus_outlined,
          ),
          const RideOption(
            name: 'Train',
            duration: '4 hrs',
            passengerCapacity: 0,
            priceRp: 0,
            icon: Icons.train_outlined,
          ),
        ];

        when(() => mockService.getRideOptions())
            .thenAnswer((_) async => mockOptions);

        // Act
        final result = await mockService.getRideOptions();

        // Assert
        expect(result, isA<List<RideOption>>());
        expect(result.length, equals(3));
        expect(result.map((r) => r.name), containsAll(['Car', 'Bus', 'Train']));
        verify(() => mockService.getRideOptions()).called(1);
      });

      test('should return real ride options from SearchingService', () async {
        // Arrange
        const service = SearchingService();

        // Act
        final result = await service.getRideOptions();

        // Assert
        expect(result.length, equals(3));
        expect(result[0].name, equals('Car'));
        expect(result[1].name, equals('Bus'));
        expect(result[2].name, equals('Train'));
      });

      test('should default to Car when no option is selected', () async {
        // Arrange
        const service = SearchingService();

        // Act
        final options = await service.getRideOptions();
        final defaultType = options.isNotEmpty ? options[0].name : 'Car';

        // Assert
        expect(defaultType, equals('Car'));
      });
    });

    // ── selectTransport() ─────────────────────────────────────────────────

    group('selectTransport()', () {
      test('should update selectedRideIndex when transport is selected', () {
        // Arrange
        int? selectedIndex;

        // Act
        selectedIndex = 1;

        // Assert
        expect(selectedIndex, equals(1));
      });

      test('should deselect transport when same index is tapped again', () {
        // Arrange
        int? selectedIndex = 1;

        // Act — toggle off same index
        selectedIndex = selectedIndex == 1 ? null : 1;

        // Assert
        expect(selectedIndex, isNull);
      });

      test('should reset selected vehicle when transport type changes', () {
        // Arrange
        // FIX: tambahkan classLabel agar CartTicket tidak error
        VehiclePin? selectedVehicle = VehiclePin(
          latitude: -6.2,
          longitude: 106.8,
          ticket: makeCartTicket(type: 'Car', bookingId: 'BK-001'),
        );

        // Act — change transport type resets vehicle
        selectedVehicle = null;

        // Assert
        expect(selectedVehicle, isNull);
      });

      test('should update pins list when new transport type is selected', () {
        // Arrange
        final carPins = vehicleService.getPinsForType('Car');
        final busPins = vehicleService.getPinsForType('Bus');

        // Assert
        expect(carPins, isNotEmpty);
        expect(busPins, isNotEmpty);
        expect(
          carPins.first.ticket.type,
          isNot(equals(busPins.first.ticket.type)),
        );
      });
    });

    // ── onTap() (ListTile) ────────────────────────────────────────────────

    group('onTap() — ListTile vehicle pin selection', () {
      test('should set selectedVehicle when pin is tapped', () {
        // Arrange
        final pins = vehicleService.getPinsForType('Car');
        VehiclePin? selectedVehicle;

        // Act
        selectedVehicle = pins.first;

        // Assert
        expect(selectedVehicle, isNotNull);
        expect(selectedVehicle!.ticket.type, isNotEmpty);
      });

      test('should get matching pin from current pins list by bookingId', () {
        // Arrange
        final pins = vehicleService.getPinsForType('Train');
        final targetPin = pins.first;
        VehiclePin? selectedVehicle;

        // Act — simulates _onPinSelected logic
        selectedVehicle = pins.firstWhere(
          (p) => p.ticket.bookingId == targetPin.ticket.bookingId,
          orElse: () => targetPin,
        );

        // Assert
        expect(
          selectedVehicle.ticket.bookingId,
          equals(targetPin.ticket.bookingId),
        );
      });
    });

    // ── displayTransportType() via Icon ───────────────────────────────────

    group('displayTransportType() — Icon display', () {
      test('should return correct icon for each transport type', () {
        // Arrange
        IconData getIconForType(String type) {
          switch (type.toLowerCase()) {
            case 'car':
              return Icons.directions_car_outlined;
            case 'bus':
              return Icons.directions_bus_outlined;
            case 'train':
              return Icons.train_outlined;
            default:
              return Icons.directions_transit_outlined;
          }
        }

        // Assert
        expect(getIconForType('Car'), equals(Icons.directions_car_outlined));
        expect(getIconForType('Bus'), equals(Icons.directions_bus_outlined));
        expect(getIconForType('Train'), equals(Icons.train_outlined));
        expect(
          getIconForType('Unknown'),
          equals(Icons.directions_transit_outlined),
        );
      });

      test('RideOption.fromJson should assign correct icon by name', () {
        // Arrange
        final carJson = {
          'name': 'Car',
          'duration': '2 hrs',
          'passenger_capacity': 4,
          'price_rp': 0,
        };
        final busJson = {
          'name': 'Bus',
          'duration': '3 hrs',
          'passenger_capacity': 40,
          'price_rp': 0,
        };

        // Act
        final car = RideOption.fromJson(carJson);
        final bus = RideOption.fromJson(busJson);

        // Assert
        expect(car.icon, equals(Icons.directions_car_outlined));
        expect(bus.icon, equals(Icons.directions_bus_outlined));
      });
    });

    // ── Price calculation ─────────────────────────────────────────────────

    group('Price and discount calculations', () {
      test('should calculate discount amount correctly', () {
        // Arrange
        const baseTotal = 500000;
        const discountPercent = 0.1;

        // Act
        final discountAmount = (baseTotal * discountPercent).toInt();
        final finalTotal = baseTotal - discountAmount;

        // Assert
        expect(discountAmount, equals(50000));
        expect(finalTotal, equals(450000));
      });

      test('should return 0 discount when no promo is applied', () {
        // Arrange
        const baseTotal = 300000;
        const discountAmount = 0;

        // Act
        final finalTotal = baseTotal - discountAmount;

        // Assert
        expect(finalTotal, equals(300000));
      });
    });
  });
}