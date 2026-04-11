import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import 'package:swifttrip_frontend/screens/customer_service/onboarding.dart';
import '../../widgets/top_bar.dart';
import 'promotions.dart';
import 'models/promotion_models.dart';
import 'services/cart_service.dart';
import 'widgets/ticket_card.dart';
import 'widgets/cart_bottom_bar.dart';
import 'widgets/remove_dialog.dart';
import '../main/main_screen.dart';
import '../checkout/checkout.dart';
import '../checkout/models/checkout_details_model.dart';
import '../checkout/models/purchase_item_model.dart';
import '../../providers/language_provider.dart';

// CART PAGE
class CartPage extends StatefulWidget {
  final VoidCallback? onExploreFlights;
  const CartPage({super.key, this.onExploreFlights});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartService _cartService = CartService();
  Promotion? _appliedPromo;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartProvider>().loadCart();
    });
  }

  Future<void> _removeTicket(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (BuildContext context) => const RemoveTicketDialog(),
    );

    if (confirmed == true && mounted) {
      context.read<CartProvider>().removeTicket(id);
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
                if (widget.onExploreFlights != null) {
                  widget.onExploreFlights!();
                } else {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const MainScreen(initialIndex: 2),
                    ),
                    (route) => false,
                  );
                }
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
    final cartProvider = context.watch<CartProvider>();
    final tickets = cartProvider.tickets;

    int baseTotalVal = tickets.fold(0, (sum, t) => sum + t.priceRp);
    int serviceFeeVal = tickets.fold(0, (sum, t) => sum + t.serviceFee);
    int discountAmountVal = _cartService.calculateDiscount(baseTotalVal, _appliedPromo);
    int finalTotalVal = baseTotalVal + serviceFeeVal - discountAmountVal;

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
            child: tickets.isEmpty
                ? _buildEmptyState(context)
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
                          tickets.length,
                          (i) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: TicketCard(
                              ticket: tickets[i],
                              formatRp: _formatRp,
                              onDelete: () => _removeTicket(tickets[i].bookingId),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),

          const SizedBox(height: 10),

          // ── Pinned Bottom Section ─────────────────────────────────────
          if (tickets.isNotEmpty)
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
                    totalString: _formatRp(finalTotalVal),
                    discountAmount: discountAmountVal,
                    onConfirm: () {
                      if (tickets.isEmpty) return;

                      final details = CheckoutDetailsModel(
                        tickets: tickets,
                        purchaseItems: [
                          PurchaseItemModel(
                            label: 'Tickets x${tickets.length}',
                            amount: _formatRp(baseTotalVal),
                          ),
                          PurchaseItemModel(
                            label: 'Service Fee (5%)',
                            amount: _formatRp(serviceFeeVal),
                          ),
                          if (discountAmountVal > 0)
                            PurchaseItemModel(
                              label: 'Discount',
                              amount: '- ${_formatRp(discountAmountVal)}',
                              isDiscount: true,
                            ),
                        ],
                        totalPrice: _formatRp(finalTotalVal),
                        discountTotal: discountAmountVal,
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CheckoutPage(checkoutDetails: details),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
