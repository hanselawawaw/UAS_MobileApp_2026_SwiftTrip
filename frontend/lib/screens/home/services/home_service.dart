import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../core/constants.dart';
import '../../../repositories/auth_repository.dart';
import '../../cart/models/cart_models.dart';
import 'package:swifttrip_frontend/models/recommendation_item.dart';
import '../../searching/services/airport_search_service.dart';

class HomeService {
  Future<List<CartTicket>> fetchSchedules() async {
    try {
      final dio = Dio();
      final token = await AuthRepository().getToken();

      final response = await dio.get(
        Constants.historyUrl,
        options: Options(
          headers: {if (token != null) 'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        const iataCoords = <String, List<double>>{
          'CGK': [-6.1256, 106.6560],
          'DPS': [-8.7482, 115.1675],
          'SUB': [-7.3797, 112.7875],
          'KNO': [3.642, 98.885],
          'UPG': [-5.062, 119.554],
          'YIA': [-7.900, 110.050],
          'BPN': [-1.268, 116.895],
          'BTH': [1.121, 104.118],
          'SRG': [-6.984, 110.375],
          'PLM': [-2.897, 104.701],
          'SIN': [1.3644, 103.9915],
          'KUL': [2.7456, 101.7099],
          'BKK': [13.6900, 100.7501],
          'DXB': [25.2532, 55.3657],
          'SYD': [-33.9399, 151.1753],
          'LHR': [51.4700, -0.4543],
          'CDG': [49.0097, 2.5479],
          'AMS': [52.311, 4.768],
          'FRA': [50.033, 8.571],
          'HND': [35.5494, 139.7798],
          'NRT': [35.7647, 140.3864],
          'ICN': [37.4602, 126.4407],
          'HKG': [22.3080, 113.9185],
          'JFK': [40.6413, -73.7781],
          'LAX': [33.9416, -118.4085],
        };

        return data.map((json) {
          final ticket = CartTicket.fromJson(json);
          if (ticket.latitude == null || ticket.longitude == null) {
            double? lat;
            double? lng;
            final target = ticket.to ?? ticket.location;
            if (target != null) {
              final upperTarget = target.trim().toUpperCase();

              // 1. Prioritize AirportSearchService list
              bool matched = false;
              for (final airport in AirportSearchService.commonAirports) {
                if (airport['iataCode']?.toUpperCase() == upperTarget &&
                    airport['lat'] != null &&
                    airport['lng'] != null) {
                  lat = double.tryParse(airport['lat']!);
                  lng = double.tryParse(airport['lng']!);
                  matched = true;
                  break;
                }
              }

              if (!matched) {
                if (iataCoords.containsKey(upperTarget)) {
                  lat = iataCoords[upperTarget]![0];
                  lng = iataCoords[upperTarget]![1];
                } else {
                  final lowerTarget = target.toLowerCase();
                  if (lowerTarget.contains('jakarta')) {
                    lat = -6.2088;
                    lng = 106.8456;
                  } else if (lowerTarget.contains('bali')) {
                    lat = -8.4095;
                    lng = 115.1889;
                  } else if (lowerTarget.contains('yogyakarta')) {
                    lat = -7.7970;
                    lng = 110.3705;
                  } else if (lowerTarget.contains('bandung')) {
                    lat = -6.9175;
                    lng = 107.6191;
                  } else if (lowerTarget.contains('surabaya')) {
                    lat = -7.2504;
                    lng = 112.7688;
                  } else {
                    // Final Ultimate Fallback
                    lat = -6.2088;
                    lng = 106.8456;
                  }
                }
              }
            }
            return ticket.copyWith(
              latitude: lat ?? ticket.latitude,
              longitude: lng ?? ticket.longitude,
            );
          }
          return ticket;
        }).toList();
      }
      return [];
    } catch (e) {
      if (kDebugMode) {
        print('Debug: Home Schedule Fetch Error: $e');
      }
      return [];
    }
  }

  Future<List<RecommendationItem>> fetchRecommendations() async {
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      return const [
        RecommendationItem(
          name: 'The Langham',
          description: 'Jakarta',
          imageAsset: 'assets/images/home/vacation_logo.png',
        ),
        RecommendationItem(
          name: 'The Ritz-Carlton',
          description: 'Bali',
          imageAsset: 'assets/images/home/vacation_logo.png',
        ),
        RecommendationItem(
          name: 'Hotel Tentrem',
          description: 'Yogyakarta',
          imageAsset: 'assets/images/home/vacation_logo.png',
        ),
        RecommendationItem(
          name: 'Padma Hotel',
          description: 'Bandung',
          imageAsset: 'assets/images/home/vacation_logo.png',
        ),
      ];
    } catch (e) {
      if (kDebugMode) {
        print('Debug: Recommendation Fetch Error: $e');
      }
      return [];
    }
  }
}
