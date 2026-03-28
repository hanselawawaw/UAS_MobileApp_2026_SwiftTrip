import 'package:flutter/material.dart';
import 'package:swifttrip_frontend/screens/customer_service/onboarding.dart';
import '../../widgets/top_bar.dart';
import 'promotions.dart';
import 'models/cart_models.dart';
import 'models/promotion_models.dart';
import 'services/cart_service.dart';
import 'widgets/ticket_card.dart';
import 'widgets/cart_bottom_bar.dart';
import 'widgets/remove_dialog.dart';

// CART PAGE
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartService _cartService = CartService();
  List<CartTicket> _tickets = [];
  Promotion? _appliedPromo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final tickets = await _cartService.fetchTickets();
    if (mounted) {
      setState(() {
        _tickets = tickets;
        _isLoading = false;
      });
    }
  }

  int get _baseTotal => _tickets.fold(0, (sum, t) => sum + t.priceRp);
  int get _discountAmount =>
      _cartService.calculateDiscount(_tickets, _appliedPromo);
  int get _finalTotal => _baseTotal - _discountAmount;

  Future<void> _removeTicket(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (BuildContext context) => const RemoveTicketDialog(),
    );

    if (confirmed == true && mounted) {
      _cartService.removeTicket(index);
      setState(() => _tickets.removeAt(index));
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: Column(
        children: [
          TopBar(
            onHamburgerTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OnboardingPage()),
              );
            },
          ),
          const SizedBox(height: 20),

          // ── Independent Ticket Scroll Area ────────────────────────────
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _tickets.isEmpty
                    ? const Center(
                        child: Text(
                          'No tickets in cart',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.only(
                          top: 20,
                          left: 20,
                          right: 20,
                          bottom: 40,
                        ),
                        child: Column(
                          children: [
                            ...List.generate(
                              _tickets.length,
                              (i) => Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: TicketCard(
                                  ticket: _tickets[i],
                                  formatRp: _formatRp,
                                  onDelete: () => _removeTicket(i),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
          ),

          const SizedBox(height: 10),

          // ── Pinned Bottom Section ─────────────────────────────────────
          if (!_isLoading && _tickets.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 110),
              child: Column(
                children: [
                  ApplyPromotionsRow(
                    appliedPromo: _appliedPromo,
                    onTap: () async {
                      final result = await Navigator.push<Promotion?>(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PromotionsPage(initialSelection: _appliedPromo),
                        ),
                      );
                      if (mounted && result != _appliedPromo) {
                        setState(() => _appliedPromo = result);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TotalConfirmBar(
                    totalString: _formatRp(_finalTotal),
                    discountAmount: _discountAmount,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
