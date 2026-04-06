import 'package:flutter/material.dart';
import 'package:swifttrip_frontend/screens/customer_service/onboarding.dart';
import '../../widgets/top_bar.dart';
import '../main/main_screen.dart';
import 'models/checkout_details_model.dart';
import 'widgets/checkout_ticket_card.dart';
import 'widgets/purchase_details_card.dart';

import 'widgets/success_check_icon.dart';

class PaymentDetailPage extends StatefulWidget {
  final CheckoutDetailsModel details;

  const PaymentDetailPage({super.key, required this.details});

  @override
  State<PaymentDetailPage> createState() => _PaymentDetailPageState();
}

class _PaymentDetailPageState extends State<PaymentDetailPage> {
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
              child: SingleChildScrollView(
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

                    // ── TICKET CARDS ───────────────────────────────────────
                    ...widget.details.tickets.map(
                      (ticket) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: CheckoutTicketCard(ticket: ticket),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── PURCHASE DETAILS CARD ───────────────────────────────
                    PurchaseDetailsCard(
                      items: widget.details.purchaseItems,
                      totalPrice: widget.details.totalPrice,
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

                    const SizedBox(height: 40),
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
