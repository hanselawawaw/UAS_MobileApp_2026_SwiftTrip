import 'package:flutter/material.dart';
import '../../widgets/top_bar.dart';
import 'checkout_controller.dart';
import 'successful.dart';
import '../customer_service/onboarding.dart';
import 'widgets/checkout_ticket_card.dart';
import 'widgets/payment_method_card.dart';
import 'widgets/purchase_details_card.dart';
import 'widgets/hold_to_confirm_bar.dart';
import 'widgets/bottom_total_bar.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final CheckoutController _controller = CheckoutController();

  @override
  void initState() {
    super.initState();
    _controller.init();
    _controller.addListener(_update);
  }

  @override
  void dispose() {
    _controller.removeListener(_update);
    _controller.dispose();
    super.dispose();
  }

  void _update() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            TopBar(
              showBackButton: true,
              onHamburgerTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OnboardingPage(),
                  ),
                );
              },
            ),
            Expanded(
              child: _controller.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          if (_controller.details != null)
                            CheckoutTicketCard(ticket: _controller.details!.ticket),
                          const SizedBox(height: 10),
                          const Divider(color: Colors.black12, thickness: 1),
                          const SizedBox(height: 10),

                          ...List.generate(_controller.paymentMethods.length, (index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: PaymentMethodCard(
                                paymentMethod: _controller.paymentMethods[index],
                                isExpanded: _controller.expandedPaymentIndex == index,
                                onTap: () => _controller.togglePaymentMethod(index),
                              ),
                            );
                          }),

                          const SizedBox(height: 10),
                          const Divider(color: Colors.black12, thickness: 1),
                          const SizedBox(height: 10),

                          if (_controller.details != null)
                            PurchaseDetailsCard(
                              items: _controller.details!.purchaseItems,
                              totalPrice: _controller.details!.totalPrice,
                            ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _controller.isLoading
          ? const SizedBox.shrink()
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_controller.details != null)
                  BottomTotalBar(totalPrice: _controller.details!.totalPrice),
                HoldToConfirmBar(
                  onConfirmed: () async {
                    final success = await _controller.confirmPurchase();
                    if (success && mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SuccessfulPage(),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
    );
  }
}
