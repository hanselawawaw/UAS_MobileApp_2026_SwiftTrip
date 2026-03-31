import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../core/constants.dart';
import '../models/cart_models.dart';
import '../models/promotion_models.dart';

class CartService {
  static final CartService _instance = CartService._internal();

  factory CartService() {
    return _instance;
  }

  CartService._internal();

  final List<CartTicket> _tickets = [];

  void addTicket(CartTicket ticket) {
    _tickets.add(ticket);
  }

  void removeTicket(int index) {
    if (index >= 0 && index < _tickets.length) {
      _tickets.removeAt(index);
    }
  }

  Future<List<CartTicket>> fetchTickets() async {
    return List.from(_tickets);
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
