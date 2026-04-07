import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../core/constants.dart';
import '../../../repositories/auth_repository.dart';
import '../models/cart_models.dart';
import '../models/promotion_models.dart';

class CartService {
  static final CartService _instance = CartService._internal();

  factory CartService() {
    return _instance;
  }

  CartService._internal();

  final List<CartTicket> _tickets = [];

  Future<void> addTicket(CartTicket ticket) async {
    try {
      final dio = Dio();
      final token = await AuthRepository().getToken();
      
      print('Debug: 3. Service attempting POST to ${Constants.bookingsUrl}cart/add/');
      
      final response = await dio.post(
        '${Constants.bookingsUrl}cart/add/',
        data: ticket.toJson(),
        options: Options(headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        }),
      );

      if (response.statusCode == 201) {
        print('Debug: POST successful. Server message: ${response.data}');
      } else {
        print('Debug: POST returned unexpected status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Debug: CRITICAL ERROR in CartService: $e');
      if (e.response != null) {
        print('Debug: Server response data: ${e.response?.data}');
      }
    } catch (e) {
      print('Debug: CRITICAL ERROR in CartService: $e');
    }
  }

  Future<bool> removeTicket(String id) async {
    try {
      final dio = Dio();
      final token = await AuthRepository().getToken();
      
      print('Debug: Deleting ticket ID: $id');
      
      final response = await dio.delete(
        '${Constants.bookingsUrl}$id/',
        options: Options(headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        }),
      );

      if (response.statusCode == 204 || response.statusCode == 200) {
        _tickets.removeWhere((ticket) => ticket.bookingId == id);
        return true;
      } else {
        print('Debug: Delete returned unexpected status: ${response.statusCode}');
        return false;
      }
    } on DioException catch (e) {
      print('Debug: CRITICAL ERROR deleting ticket: $e');
      if (e.response != null) {
        print('Debug: Server response data: ${e.response?.data}');
      }
      return false;
    } catch (e) {
      print('Debug: CRITICAL ERROR in CartService delete: $e');
      return false;
    }
  }

  void clearLocalCart() {
    _tickets.clear();
  }

  Future<List<CartTicket>> fetchTickets() async {
    try {
      final dio = Dio();
      final token = await AuthRepository().getToken();
      final response = await dio.get(
        '${Constants.bookingsUrl}cart/',
        options: Options(headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        }),
      );

      if (response.statusCode == 200) {
        print('Debug: GET Cart response: ${response.data}');
        final List<dynamic> data = response.data;
        
        final List<CartTicket> fetchedTickets = data.map((json) {
          return CartTicket.fromJson(json);
        }).toList();

        _tickets.clear();
        _tickets.addAll(fetchedTickets);
        return _tickets;
      } else {
        print('Debug: GET Cart returned unexpected status ${response.statusCode}');
        return List.from(_tickets);
      }
    } on DioException catch (e) {
      print('Debug: CRITICAL ERROR fetching cart: $e');
      if (e.response != null) {
        print('Debug: Server response data: ${e.response?.data}');
      }
      return List.from(_tickets);
    } catch (e) {
      print('Debug: Parse Error: $e');
      return List.from(_tickets);
    }
  }

  Future<List<Promotion>> fetchPromotions() async {
    try {
      final dio = Dio();
      final response = await dio.get(Constants.promotionsUrl);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Promotion.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching promotions: $e');
      return [];
    }
  }

  int calculateDiscount(int baseTotal, Promotion? promo) {
    if (promo == null) return 0;

    if (baseTotal < promo.minPurchase) return 0;

    if (promo.promotionType == 'PERCENTAGE') {
      return (baseTotal * (promo.discountValue / 100)).toInt();
    } else if (promo.promotionType == 'CASHBACK') {
      return promo.discountValue.toInt();
    }
    
    return 0;
  }
}
