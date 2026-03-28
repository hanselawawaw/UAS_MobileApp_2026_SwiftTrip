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
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      Promotion(
        id: 'promo_1',
        title: 'Family Discount',
        dateRange: '12 Feb 2024 - 12 Mar 2025',
        description: 'Discount 10% with minimum Rp 1.000.000 purchases',
      ),
      Promotion(
        id: 'promo_2',
        title: 'Student Getaway',
        dateRange: '01 Jan 2024 - 31 Dec 2024',
        description: 'Discount 15% with valid student ID card',
      ),
      Promotion(
        id: 'promo_3',
        title: 'Weekend Flash Sale',
        dateRange: 'Every Saturday - Sunday',
        description: 'Cashback Rp 50.000 with no minimum purchase',
      ),
    ];
  }

  int calculateDiscount(List<CartTicket> tickets, Promotion? promo) {
    if (promo == null) return 0;
    final baseTotal = tickets.fold(0, (sum, t) => sum + t.priceRp);

    if (promo.id == 'promo_1' && baseTotal >= 1000000) {
      return (baseTotal * 0.10).toInt();
    }
    if (promo.id == 'promo_2') {
      return (baseTotal * 0.15).toInt();
    }
    if (promo.id == 'promo_3') {
      return 50000;
    }
    return 0;
  }
}
