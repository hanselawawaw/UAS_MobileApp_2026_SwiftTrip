import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../core/constants.dart';
import '../../../repositories/auth_repository.dart';
import '../../cart/models/cart_models.dart';

class HistoryService {
  final _dio = Dio();

  Future<List<CartTicket>> fetchHistory() async {
    try {
      final token = await AuthRepository().getToken();
      
      final response = await _dio.get(
        '${Constants.bookingsUrl}history/',
        options: Options(headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        }),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => CartTicket.fromJson(json)).toList();
      }
      throw Exception('Failed to fetch history');
    } on DioException catch (e) {
      if (e.response?.statusCode == 500) {
        debugPrint('500 Internal Server Error: Could not fetch history. Check backend data sync.');
        return [];
      }
      rethrow;
    } catch (e) {
      debugPrint('Error parsing history: $e');
      return [];
    }
  }
}
