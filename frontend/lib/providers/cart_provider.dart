import 'package:flutter/foundation.dart';
import '../screens/cart/models/cart_models.dart';
import '../screens/cart/services/cart_service.dart';

class CartProvider extends ChangeNotifier {
  final CartService _cartService = CartService();
  List<CartTicket> _tickets = [];

  List<CartTicket> get tickets => _tickets;

  Future<void> loadCart() async {
    _tickets = await _cartService.fetchTickets();
    notifyListeners();
  }

  Future<void> addTicket(CartTicket ticket) async {
    if (kDebugMode) {
      print('Debug: 2. Provider received ticket: ${ticket.type}');
    }
    await _cartService.addTicket(ticket);
    await loadCart();
  }

  Future<void> removeTicket(String id) async {
    final success = await _cartService.removeTicket(id);
    if (success) {
      _tickets.removeWhere((t) => t.bookingId == id);
      notifyListeners();
    }
  }

  void clearCart() {
    // Also need to clear in the service if it's keeping local state
    // For now we'll implement clearCart in service too
    _cartService.clearLocalCart();
    _tickets = [];
    notifyListeners();
  }
}
