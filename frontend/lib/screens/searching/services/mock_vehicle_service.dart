import 'package:intl/intl.dart';
import 'package:swifttrip_frontend/screens/cart/models/cart_models.dart';
import '../models/vehicle_pin.dart';

/// Provides hardcoded vehicle data with coordinates for the land-vehicle map.
/// Dates and times are generated dynamically relative to the current time.
class MockVehicleService {
  const MockVehicleService();

  /// Helper to generate a date and time relative to "now".
  /// If [hourOffset] causes the time to cross midnight, the date automatically increments.
  static Map<String, String> _getTimes(int hourOffset, int durationMinutes) {
    final now = DateTime.now();
    final departure = now.add(Duration(hours: hourOffset));
    final arrival = departure.add(Duration(minutes: durationMinutes));

    return {
      'date': DateFormat('dd MMM yyyy').format(departure),
      'departure': DateFormat('HH:mm').format(departure),
      'arrive': DateFormat('HH:mm').format(arrival),
    };
  }

  /// Calculates duration in minutes from HH:mm formatted strings.
  static String calculateDuration(String? departure, String? arrive) {
    if (departure == null || arrive == null) return '---';
    try {
      final dep = departure.split(':');
      final arr = arrive.split(':');
      if (dep.length != 2 || arr.length != 2) return '---';

      final dH = int.parse(dep[0]);
      final dM = int.parse(dep[1]);
      final aH = int.parse(arr[0]);
      final aM = int.parse(arr[1]);

      int diff = (aH * 60 + aM) - (dH * 60 + dM);
      if (diff < 0) diff += 1440; // Handle overnight (24*60)

      return '$diff min';
    } catch (_) {
      return '---';
    }
  }

  // ── Cars ──────────────────────────────────────────────────────────────────

  static List<VehiclePin> get mockCars {
    final t1 = _getTimes(0, 75);
    final t2 = _getTimes(1, 90);
    final t3 = _getTimes(2, 90);
    final t4 = _getTimes(3, 75);
    final t5 = _getTimes(5, 75);
    final t6 = _getTimes(8, 90);
    final t7 = _getTimes(11, 75);

    return [
      // CAR-001 · GoCar — Near AEON Mall BSD entrance road
      VehiclePin(
        ticket: CartTicket(
          type: 'Car Ticket',
          bookingId: 'CAR-001',
          classLabel: 'Economy',
          priceRp: 65000,
          operator: 'GoCar',
          from: 'Bintaro',
          to: 'Sudirman',
          date: t1['date'],
          departure: t1['departure'],
          arrive: t1['arrive'],
          carPlate: 'B 1234 XYZ',
          driverName: 'Pak Budi',
          latitude: -6.298200,
          longitude: 106.641500,
        ),
        latitude: -6.298200,
        longitude: 106.641500, // North-east, near AEON BSD
      ),

      // CAR-002 · GrabCar — BSD Raya Barat road (west side)
      VehiclePin(
        ticket: CartTicket(
          type: 'Car Ticket',
          bookingId: 'CAR-002',
          classLabel: 'Economy',
          priceRp: 85000,
          operator: 'GrabCar',
          from: 'BSD',
          to: 'Kuningan',
          date: t2['date'],
          departure: t2['departure'],
          arrive: t2['arrive'],
          carPlate: 'B 5678 ABC',
          driverName: 'Pak Rudi',
          latitude: -6.301800,
          longitude: 106.635200,
        ),
        latitude: -6.301800,
        longitude: 106.635200, // West side along BSD Raya Barat
      ),

      // CAR-003 · BlueBird — South of campus, Edu Town area
      VehiclePin(
        ticket: CartTicket(
          type: 'Car Ticket',
          bookingId: 'CAR-003',
          classLabel: 'Premium',
          priceRp: 120000,
          operator: 'BlueBird',
          from: 'Ciputat',
          to: 'Thamrin',
          date: t3['date'],
          departure: t3['departure'],
          arrive: t3['arrive'],
          carPlate: 'B 9012 DEF',
          driverName: 'Pak Hendra',
          latitude: -6.303500,
          longitude: 106.639800,
        ),
        latitude: -6.303500,
        longitude: 106.639800, // South, inside Edu Town
      ),

      // CAR-004 · GoCar — North-west, near campus main gate
      VehiclePin(
        ticket: CartTicket(
          type: 'Car Ticket',
          bookingId: 'CAR-004',
          classLabel: 'Economy',
          priceRp: 72000,
          operator: 'GoCar',
          from: 'Serpong',
          to: 'Semanggi',
          date: t4['date'],
          departure: t4['departure'],
          arrive: t4['arrive'],
          carPlate: 'B 3344 GHI',
          driverName: 'Pak Agus',
          latitude: -6.297900,
          longitude: 106.637100,
        ),
        latitude: -6.297900,
        longitude: 106.637100, // North-west, near campus gate
      ),

      // CAR-005 · GrabCar — East side, EduTown inner road
      VehiclePin(
        ticket: CartTicket(
          type: 'Car Ticket',
          bookingId: 'CAR-005',
          classLabel: 'Economy',
          priceRp: 78000,
          operator: 'GrabCar',
          from: 'Alam Sutera',
          to: 'Gatot Subroto',
          date: t5['date'],
          departure: t5['departure'],
          arrive: t5['arrive'],
          carPlate: 'B 7788 JKL',
          driverName: 'Pak Wahyu',
          latitude: -6.300700,
          longitude: 106.643200,
        ),
        latitude: -6.300700,
        longitude: 106.643200, // East, EduTown inner road
      ),

      // CAR-006 · BlueBird — South-west, near BSD Raya intersection
      VehiclePin(
        ticket: CartTicket(
          type: 'Car Ticket',
          bookingId: 'CAR-006',
          classLabel: 'Premium',
          priceRp: 135000,
          operator: 'BlueBird',
          from: 'Tangerang',
          to: 'Sudirman',
          date: t6['date'],
          departure: t6['departure'],
          arrive: t6['arrive'],
          carPlate: 'B 2255 MNO',
          driverName: 'Pak Doni',
          latitude: -6.304200,
          longitude: 106.636100,
        ),
        latitude: -6.304200,
        longitude: 106.636100, // South-west, near BSD Raya intersection
      ),

      // CAR-007 · GoCar — Close north, drop-off zone
      VehiclePin(
        ticket: CartTicket(
          type: 'Car Ticket',
          bookingId: 'CAR-007',
          classLabel: 'Economy',
          priceRp: 60000,
          operator: 'GoCar',
          from: 'Jombang',
          to: 'Blok M',
          date: t7['date'],
          departure: t7['departure'],
          arrive: t7['arrive'],
          carPlate: 'B 9900 PQR',
          driverName: 'Pak Fauzi',
          latitude: -6.296800,
          longitude: 106.640300,
        ),
        latitude: -6.296800,
        longitude: 106.640300, // Close north, near drop-off zone
      ),
    ];
  }

  // ── Buses ─────────────────────────────────────────────────────────────────

  static List<VehiclePin> get mockBuses {
    final t1 = _getTimes(0, 75);
    final t2 = _getTimes(2, 150);
    final t3 = _getTimes(4, 120);
    final t4 = _getTimes(7, 45);
    final t5 = _getTimes(10, 105);

    return [
      // BUS-001 · TransJakarta — North, near BSD City bus stop
      VehiclePin(
        ticket: CartTicket(
          type: 'Bus Ticket',
          bookingId: 'BUS-001',
          classLabel: 'Regular',
          priceRp: 3500,
          operator: 'TransJakarta',
          from: 'BSD City',
          to: 'Blok M',
          date: t1['date'],
          departure: t1['departure'],
          arrive: t1['arrive'],
          busClass: 'Regular',
          busNumber: 'S21',
          latitude: -6.296500,
          longitude: 106.639200,
        ),
        latitude: -6.296500,
        longitude: 106.639200,
      ),

      // BUS-002 · PO Haryanto — East, along AEON access road
      VehiclePin(
        ticket: CartTicket(
          type: 'Bus Ticket',
          bookingId: 'BUS-002',
          classLabel: 'Executive',
          priceRp: 15000,
          operator: 'PO Haryanto',
          from: 'BSD',
          to: 'Kampung Rambutan',
          date: t2['date'],
          departure: t2['departure'],
          arrive: t2['arrive'],
          busClass: 'Executive',
          busNumber: 'HR-77',
          latitude: -6.299100,
          longitude: 106.644800,
        ),
        latitude: -6.299100,
        longitude: 106.644800, // East, near AEON access road
      ),

      // BUS-003 · Mayasari Bakti — South-east, Edu Town exit
      VehiclePin(
        ticket: CartTicket(
          type: 'Bus Ticket',
          bookingId: 'BUS-003',
          classLabel: 'Economy',
          priceRp: 12000,
          operator: 'Mayasari Bakti',
          from: 'BSD',
          to: 'Senen',
          date: t3['date'],
          departure: t3['departure'],
          arrive: t3['arrive'],
          busClass: 'Economy',
          busNumber: 'AC-05',
          latitude: -6.304800,
          longitude: 106.642600,
        ),
        latitude: -6.304800,
        longitude: 106.642600, // South-east, Edu Town exit road
      ),

      // BUS-004 · TransJakarta — West, BSD Raya Barat roadside
      VehiclePin(
        ticket: CartTicket(
          type: 'Bus Ticket',
          bookingId: 'BUS-004',
          classLabel: 'Regular',
          priceRp: 3500,
          operator: 'TransJakarta',
          from: 'BSD',
          to: 'Lebak Bulus',
          date: t4['date'],
          departure: t4['departure'],
          arrive: t4['arrive'],
          busClass: 'Regular',
          busNumber: 'S15',
          latitude: -6.301200,
          longitude: 106.633800,
        ),
        latitude: -6.301200,
        longitude: 106.633800, // West, BSD Raya Barat roadside
      ),

      // BUS-005 · Damri — South-west, near Serpong interchange
      VehiclePin(
        ticket: CartTicket(
          type: 'Bus Ticket',
          bookingId: 'BUS-005',
          classLabel: 'Economy',
          priceRp: 8000,
          operator: 'Damri',
          from: 'Serpong',
          to: 'Tanah Abang',
          date: t5['date'],
          departure: t5['departure'],
          arrive: t5['arrive'],
          busClass: 'Economy',
          busNumber: 'DM-12',
          latitude: -6.305600,
          longitude: 106.635500,
        ),
        latitude: -6.305600,
        longitude: 106.635500, // South-west, near Serpong interchange
      ),
    ];
  }

  // ── Trains ────────────────────────────────────────────────────────────────

  static List<VehiclePin> get mockTrains {
    final t1 = _getTimes(0, 75);
    final t2 = _getTimes(3, 80);
    final t3 = _getTimes(6, 45);
    final t4 = _getTimes(12, 135);

    return [
      // TRN-001 · KAI Commuter — Serpong Station (nearest KRL stop)
      VehiclePin(
        ticket: CartTicket(
          type: 'Train Ticket',
          bookingId: 'TRN-001',
          classLabel: 'Commuter',
          priceRp: 5000,
          operator: 'KAI Commuter',
          from: 'Serpong',
          to: 'Tanah Abang',
          date: t1['date'],
          departure: t1['departure'],
          arrive: t1['arrive'],
          carriage: 'KRL-4',
          seat: '-',
          latitude: -6.330800,
          longitude: 106.666200,
        ),
        latitude: -6.330800,
        longitude: 106.666200, // Serpong Station platform area
      ),

      // TRN-002 · KAI Commuter — Sudimara Station
      VehiclePin(
        ticket: CartTicket(
          type: 'Train Ticket',
          bookingId: 'TRN-002',
          classLabel: 'Commuter',
          priceRp: 5000,
          operator: 'KAI Commuter',
          from: 'Sudimara',
          to: 'Duri',
          date: t2['date'],
          departure: t2['departure'],
          arrive: t2['arrive'],
          carriage: 'KRL-7',
          seat: '-',
          latitude: -6.336400,
          longitude: 106.710500,
        ),
        latitude: -6.336400,
        longitude: 106.710500, // Sudimara Station, ~5.5km south-east
      ),

      // TRN-003 · KAI LRT Jabodebek — Jatimulya Depot area
      VehiclePin(
        ticket: CartTicket(
          type: 'Train Ticket',
          bookingId: 'TRN-003',
          classLabel: 'LRT',
          priceRp: 10000,
          operator: 'KAI LRT Jabodebek',
          from: 'Ciracas',
          to: 'Dukuh Atas',
          date: t3['date'],
          departure: t3['departure'],
          arrive: t3['arrive'],
          carriage: 'LRT-2',
          seat: 'A12',
          latitude: -6.285600,
          longitude: 106.680400,
        ),
        latitude: -6.285600,
        longitude: 106.680400, // North-east ~6km, toward Pondok Cabe corridor
      ),

      // TRN-004 · KAI Intercity — Rangkasbitung Station
      VehiclePin(
        ticket: CartTicket(
          type: 'Train Ticket',
          bookingId: 'TRN-004',
          classLabel: 'Economy',
          priceRp: 8000,
          operator: 'KAI Commuter',
          from: 'Rangkasbitung',
          to: 'Tanah Abang',
          date: t4['date'],
          departure: t4['departure'],
          arrive: t4['arrive'],
          carriage: 'KRL-11',
          seat: '-',
          latitude: -6.358200,
          longitude: 106.618700,
        ),
        latitude: -6.358200,
        longitude: 106.618700, // South-west ~8km, toward Rangkasbitung line
      ),
    ];
  }

  /// Returns pins for the given ride type name (case-insensitive).
  List<VehiclePin> getPinsForType(String type) {
    switch (type.toLowerCase()) {
      case 'car':
        return mockCars;
      case 'bus':
        return mockBuses;
      case 'train':
        return mockTrains;
      default:
        return [];
    }
  }
}
