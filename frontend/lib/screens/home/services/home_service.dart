import 'package:dio/dio.dart';
import '../../../core/constants.dart';
import '../../../repositories/auth_repository.dart';
import '../../cart/models/cart_models.dart';
import 'package:swifttrip_frontend/models/recommendation_item.dart';

class HomeService {
  Future<List<CartTicket>> fetchSchedules() async {
    try {
      final dio = Dio();
      final token = await AuthRepository().getToken();
      
      final response = await dio.get(
        Constants.historyUrl,
        options: Options(headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        }),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) {
          final ticket = CartTicket.fromJson(json);
          if (ticket.latitude == null || ticket.longitude == null) {
            double? lat;
            double? lng;
            final target = ticket.to ?? ticket.location;
            if (target != null) {
              final lowerTarget = target.toLowerCase();
              if (lowerTarget.contains('jakarta')) { lat = -6.2088; lng = 106.8456; }
              else if (lowerTarget.contains('bali')) { lat = -8.4095; lng = 115.1889; }
              else if (lowerTarget.contains('yogyakarta')) { lat = -7.7970; lng = 110.3705; }
              else if (lowerTarget.contains('bandung')) { lat = -6.9175; lng = 107.6191; }
              else if (lowerTarget.contains('ngawi')) { lat = -7.3995; lng = 111.4586; }
              else if (lowerTarget.contains('surabaya')) { lat = -7.2504; lng = 112.7688; }
            }
            return ticket.copyWith(latitude: lat ?? ticket.latitude, longitude: lng ?? ticket.longitude);
          }
          return ticket;
        }).toList();
      }
      return [];
    } catch (e) {
      print('Debug: Home Schedule Fetch Error: $e');
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
      print('Debug: Recommendation Fetch Error: $e');
      return [];
    }
  }
}
