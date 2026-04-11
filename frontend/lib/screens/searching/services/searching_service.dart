import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants.dart';
import '../../../../repositories/auth_repository.dart';
import '../models/ride_option.dart';
import '../models/detail_row.dart';
import '../models/coupon_model.dart';
import '../models/flight_leg.dart';
import '../models/flight_offer.dart';

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
        priceRp: 0,
        icon: Icons.directions_car_outlined,
      ),
      RideOption(
        name: 'Bus',
        duration: '3 hrs',
        passengerCapacity: 0,
        priceRp: 0,
        icon: Icons.directions_bus_outlined,
      ),
      RideOption(
        name: 'Train',
        duration: '4 hrs',
        passengerCapacity: 0,
        priceRp: 0,
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
    return ['Coupon Raya', 'Ticket Plane', 'Australia', 'Indonesia', 'Business'];
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
      'Ticket Plane': [
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
        const CouponModel(
          title: 'Sydney Saver',
          description: 'Rp 150.000 off Sydney flights',
          code: 'SYD150',
        ),
      ],
      'Indonesia': [
        const CouponModel(
          title: 'IDN Deal',
          description: 'Get 5% off domestic',
          code: 'IDN05',
        ),
        const CouponModel(
          title: 'Bali Getaway',
          description: '12% discount for Bali hotels',
          code: 'BALI12',
        ),
      ],
      'Business': [
        const CouponModel(
          title: 'Biz Class Boost',
          description: 'Upgrade discount Rp 500.000',
          code: 'BIZ500',
        ),
      ],
    };

    return mockData[category] ?? [];
  }

  /// Sends a coupon code to the backend to add it to the user's collection.
  Future<bool> collectCoupon(String code) async {
    try {
      final dio = Dio();
      final token = await AuthRepository().getToken();

      final response = await dio.post(
        '${Constants.promotionsUrl}collect/',
        data: {'code': code},
        options: Options(headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        }),
      );

      return response.statusCode == 200;
    } on DioException catch (_) {
      return false;
    } catch (_) {
      return false;
    }
  }

  // ── Flights ────────────────────────────────────────────────────────────────

  /// Searches for flights based on Amadeus API parameters using django backend.
  Future<List<FlightOffer>> searchFlights({
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
          'legs': multiCityLegs
              .map(
                (leg) => {
                  'origin': leg.originLocationCode,
                  'destination': leg.destinationLocationCode,
                  'date': leg.departureDate,
                },
              )
              .toList(),
          'passengers': passengers,
          'class': flightClass,
        };

        final response = await dio.post('search/', data: body);

        if (response.statusCode == 200) {
          final flights = response.data['flights'] as List<dynamic>? ?? [];
          return flights
              .map((item) => FlightOffer.fromJson(item as Map<String, dynamic>))
              .toList();
        }
      } else {
        // Round trip implementation
        final response = await dio.get(
          'search/',
          queryParameters: {
            'origin': from,
            'destination': to,
            'date': date,
            'passengers': passengers,
            'class': flightClass,
          },
        );

        if (response.statusCode == 200) {
          final flights = response.data['flights'] as List<dynamic>? ?? [];
          return flights
              .map((item) => FlightOffer.fromJson(item as Map<String, dynamic>))
              .toList();
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
