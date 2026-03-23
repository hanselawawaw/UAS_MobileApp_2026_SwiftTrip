import 'package:flutter/material.dart';
import 'package:swifttrip_frontend/screens/customer_service/onboarding.dart';
import '../../widgets/top_bar.dart';
import '../main/main_screen.dart';
import 'models/checkout_details_model.dart';
import 'services/checkout_service.dart';
import 'widgets/payment_ticket_card.dart';
import 'widgets/purchase_details_card.dart';

import 'widgets/success_check_icon.dart';

class PaymentDetailPage extends StatefulWidget {
  const PaymentDetailPage({super.key});

  @override
  State<PaymentDetailPage> createState() => _PaymentDetailPageState();
}

class _PaymentDetailPageState extends State<PaymentDetailPage> {
  final CheckoutService _service = CheckoutService();
  CheckoutDetailsModel? _details;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    final details = await _service.getCheckoutDetails();
    if (mounted) {
      setState(() {
        _details = details;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: Column(
          children: [
            TopBar(
              showBackButton: true,
              onHamburgerTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OnboardingPage()),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          const SizedBox(height: 24),

                          // ── CHECK ICON + TITLE ──────────────────────────────────
                          const SuccessCheckIcon(),
                          const SizedBox(height: 16),
                          const Text(
                            'Payment Successful',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 28),

                          // ── TICKET CARD ─────────────────────────────────────────
                          if (_details != null) PaymentTicketCard(ticket: _details!.ticket),

                          const SizedBox(height: 16),

                          // ── PURCHASE DETAILS CARD ───────────────────────────────
                          if (_details != null)
                            PurchaseDetailsCard(
                              items: _details!.purchaseItems,
                              totalPrice: _details!.totalPrice,
                              showShadow: true,
                            ),
                          const SizedBox(height: 50),

                          // BACK TO HOME BUTTON
                          GestureDetector(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MainScreen(),
                                ),
                                (route) => false,
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              height: 52,
                              decoration: ShapeDecoration(
                                color: const Color(0xFF0098FF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                shadows: const [
                                  BoxShadow(
                                    color: Color(0x26000000),
                                    blurRadius: 20,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                'Back to Home',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
