import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swifttrip_frontend/screens/cart/models/cart_models.dart';
import 'package:swifttrip_frontend/screens/cart/widgets/ticket_card.dart';
import '../../widgets/top_bar.dart';
import '../../providers/cart_provider.dart';
import '../../providers/language_provider.dart';
import '../cart/widgets/remove_dialog.dart';
import '../checkout/checkout.dart';
import '../checkout/models/checkout_details_model.dart';
import '../checkout/models/purchase_item_model.dart';
import '../main/main_screen.dart';
import 'widgets/bottom_action_bar.dart';

// PAGE

class OrderTicketPage extends StatefulWidget {
  const OrderTicketPage({super.key});

  @override
  State<OrderTicketPage> createState() => _OrderTicketPageState();
}

class _OrderTicketPageState extends State<OrderTicketPage> {
  final Set<int> _selectedIndices = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartProvider>().loadCart();
    });
  }

  int _getTotalPrice(List<CartTicket> tickets) {
    return _selectedIndices.fold(0, (sum, i) => sum + tickets[i].priceRp);
  }

  String _formatRp(int amount) {
    final str = amount.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    return 'Rp. ${buffer.toString()}';
  }

  void _handleAddToCart() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const MainScreen(initialIndex: 1),
      ),
      (route) => false,
    );
  }

  void _handleConfirm(List<CartTicket> tickets) {
    if (_selectedIndices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one ticket')),
      );
      return;
    }

    final selectedTickets = _selectedIndices.map((i) => tickets[i]).toList();
    final baseTotal = _getTotalPrice(tickets);

    final details = CheckoutDetailsModel(
      tickets: selectedTickets,
      purchaseItems: [
        PurchaseItemModel(
          label: 'Tickets x${selectedTickets.length}',
          amount: _formatRp(baseTotal),
        ),
        const PurchaseItemModel(
          label: 'Service Fee',
          amount: 'Rp. 15.000',
        ),
      ],
      totalPrice: _formatRp(baseTotal + 15000),
      discountTotal: 0,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CheckoutPage(checkoutDetails: details),
      ),
    );
  }

  Future<void> _removeTicket(int index, String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (BuildContext context) => const RemoveTicketDialog(),
    );

    if (confirmed == true && mounted) {
      context.read<CartProvider>().removeTicket(id);
      setState(() {
        _selectedIndices.remove(index);
        final updated = _selectedIndices
            .map((i) => i > index ? i - 1 : i)
            .toSet();
        _selectedIndices.clear();
        _selectedIndices.addAll(updated);
      });
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    final langProvider = context.watch<LanguageProvider>();
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF2B99E3).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_cart_outlined,
                size: 60,
                color: Color(0xFF2B99E3),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              langProvider.translate('empty_cart_title'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              langProvider.translate('empty_cart_subtitle'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const MainScreen(initialIndex: 2),
                  ),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2B99E3),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
              ),
              child: Text(
                langProvider.translate('explore_flights'),
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tickets = context.watch<CartProvider>().tickets;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: Column(
        children: [
          const TopBar(showBackButton: true, showHamburger: false),

          // Ticket List
          Expanded(
            child: tickets.isEmpty
                ? _buildEmptyState(context)
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                    child: Column(
                      children: List.generate(
                        tickets.length,
                        (i) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (_selectedIndices.contains(i)) {
                                  _selectedIndices.remove(i);
                                } else {
                                  _selectedIndices.add(i);
                                }
                              });
                            },
                            child: TicketCard(
                              ticket: tickets[i],
                              formatRp: _formatRp,
                              onDelete: () => _removeTicket(i, tickets[i].bookingId),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),

          // Bottom Action Bar
          BottomActionBar(
            totalLabel: _getTotalPrice(tickets) > 0
                ? _formatRp(_getTotalPrice(tickets))
                : 'Rp. 0',
            onAddToCart: _handleAddToCart,
            onConfirm: () => _handleConfirm(tickets),
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom + 30),
        ],
      ),
    );
  }
}
