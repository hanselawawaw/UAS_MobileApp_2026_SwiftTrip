import 'package:flutter/material.dart';
import '../../widgets/top_bar.dart';
import 'checkout_controller.dart';
import 'models/checkout_details_model.dart';
import 'successful.dart';
import '../customer_service/onboarding.dart';
import 'widgets/checkout_ticket_card.dart';
import 'widgets/payment_method_card.dart';
import 'widgets/purchase_details_card.dart';
import 'widgets/hold_to_confirm_bar.dart';
import 'widgets/bottom_total_bar.dart';

class CheckoutPage extends StatefulWidget {
  final CheckoutDetailsModel checkoutDetails;

  const CheckoutPage({
    super.key,
    required this.checkoutDetails,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late final CheckoutController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CheckoutController();
    _controller.init(widget.checkoutDetails);
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
    if (_controller.details == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    CheckoutTicketCard(
                      ticket: _controller.details!.ticket,
                    ),
                    const SizedBox(height: 20),
                    const Divider(color: Colors.black12, thickness: 1),
                    const SizedBox(height: 20),

                    PaymentMethodCard(
                      cardNumberController: _controller.cardNumberController,
                      expiryDateController: _controller.expiryDateController,
                      cvcController: _controller.cvcController,
                    ),

                    const SizedBox(height: 20),
                    const Divider(color: Colors.black12, thickness: 1),
                    const SizedBox(height: 20),

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
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
              } else if (!success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill in all payment details'),
                    behavior: SnackBarBehavior.floating,
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

