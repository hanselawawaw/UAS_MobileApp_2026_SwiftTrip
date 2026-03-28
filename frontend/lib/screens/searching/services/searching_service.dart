import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants.dart';
import '../models/ride_option.dart';
import '../models/detail_row.dart';
import '../models/coupon_model.dart';
import '../models/flight_leg.dart';

class SearchingService {
  const SearchingService();

  // ── Land Vehicle ───────────────────────────────────────────────────────────

  /// Fetches available ride options for land vehicles.
  Future<List<RideOption>> getRideOptions() async {
    // TODO: Replace with real API call (e.g. Dio.get('/land-vehicles/options'))
    await Future.delayed(const Duration(milliseconds: 500));
    return const [
      RideOption(
        name: 'Car',
        duration: '2 hrs',
        passengerCapacity: 4,
        priceRp: 50000,
        icon: Icons.directions_car_outlined,
      ),
      RideOption(
        name: 'Bus',
        duration: '3 hrs',
        passengerCapacity: 0,
        priceRp: 50000,
        icon: Icons.directions_bus_outlined,
      ),
      RideOption(
        name: 'Train',
        duration: '4 hrs',
        passengerCapacity: 0,
        priceRp: 75000,
        icon: Icons.train_outlined,
      ),
    ];
  }

  /// Fetches default purchase details for land vehicles.
  Future<List<DetailRow>> getPurchaseDetails() async {
    // TODO: Replace with real API call
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      DetailRow(label: 'Tiket Kereta', amount: 'Rp 14.000.000'),
      DetailRow(label: 'Voucher', amount: '-Rp 300.000'),
      DetailRow(label: 'Diskon liburan', amount: '-Rp 1.800.000'),
      DetailRow(label: 'PPN 10%', amount: 'Rp 110.700'),
    ];
  }

  // ── Coupons ───────────────────────────────────────────────────────────────

  /// Fetches available coupon categories.
  Future<List<String>> getCouponCategories() async {
    // TODO: Fetch from backend
    await Future.delayed(const Duration(milliseconds: 200));
    return ['Coupon Raya', 'Coupon Ticket Plane', 'Australia', 'Indonesia'];
  }

  /// Fetches coupons filtered by category.
  Future<List<CouponModel>> getCouponsByCategory(String category) async {
    // TODO: Replace with backend API
    await Future.delayed(const Duration(milliseconds: 400));

    final Map<String, List<CouponModel>> mockData = {
      'Coupon Raya': [
        const CouponModel(
          title: 'Raya Special',
          description: 'Get 10% off this Raya',
          code: 'RAYA10',
        ),
        const CouponModel(
          title: 'Raya Extra',
          description: 'Get 15% off this Raya',
          code: 'RAYA15',
        ),
      ],
      'Coupon Ticket Plane': [
        const CouponModel(
          title: 'Plane Saver',
          description: 'Get 20% off flights',
          code: 'PLANE20',
        ),
        const CouponModel(
          title: 'Fly More',
          description: 'Get 25% off flights',
          code: 'FLY25',
        ),
      ],
      'Australia': [
        const CouponModel(
          title: 'AUS Deal',
          description: 'Get 30% off to Australia',
          code: 'AUS30',
        ),
      ],
      'Indonesia': [
        const CouponModel(
          title: 'IDN Deal',
          description: 'Get 5% off domestic',
          code: 'IDN05',
        ),
      ],
    };

    return mockData[category] ?? [];
  }

  // ── Flights ────────────────────────────────────────────────────────────────

  /// Searches for flights based on Amadeus API parameters using django backend.
  Future<List<String>> searchFlights({
    required List<FlightLeg> multiCityLegs,
    required String from,
    required String to,
    required String date,
    required String passengers,
    required String flightClass,
    required bool isMultiCity,
  }) async {
    final dio = Dio(
      BaseOptions(
        baseUrl: Constants.travelUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    try {
      if (isMultiCity) {
        final body = {
          'legs': multiCityLegs.map((leg) => {
            'origin': leg.originLocationCode,
            'destination': leg.destinationLocationCode,
            'date': leg.departureDate,
          }).toList(),
          'passengers': passengers,
          'class': flightClass,
        };
        
        final response = await dio.post('search/', data: body);

        if (response.statusCode == 200) {
          final flights = response.data['flights'] as List<dynamic>? ?? [];
          final Set<String> airlines = {};
          for (var item in flights) {
            final al = (item['airlineName'] ?? item['airline'])?.toString();
            if (al != null && al.isNotEmpty) {
              airlines.add(al);
            }
          }
          return airlines.toList();
        }
      } else {
        // Round trip implementation
        final response = await dio.get('search/', queryParameters: {
          'origin': from,
          'destination': to,
          'date': date,
          'passengers': passengers,
          'class': flightClass,
        });

        if (response.statusCode == 200) {
          final flights = response.data['flights'] as List<dynamic>? ?? [];
          final Set<String> airlines = {};
          for (var item in flights) {
            final al = (item['airlineName'] ?? item['airline'])?.toString();
            if (al != null && al.isNotEmpty) {
              airlines.add(al);
            }
          }
          return airlines.toList();
        }
      }
    } on DioException catch (e) {
      final data = e.response?.data;
      String message = 'Failed to fetch flights.';
      if (data is Map && data.containsKey('error')) {
        message = data['error'];
      }
      throw Exception(message);
    } catch (_) {
        throw Exception('An unexpected network error occurred.');
    }

    return [];
  }
}
