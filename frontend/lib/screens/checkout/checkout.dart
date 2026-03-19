import 'package:flutter/material.dart';
import '../../widgets/top_bar.dart';
import 'successful.dart';
import '../customer_service/onboarding.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int? _expandedPaymentIndex;

  final List<String> _paymentMethods = ['ABC', 'Master Bank', 'Visa'];

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
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const _CheckoutTicketCard(),
                    const SizedBox(height: 10),
                    const Divider(color: Colors.black12, thickness: 1),
                    const SizedBox(height: 10),

                    ...List.generate(_paymentMethods.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _PaymentMethodCard(
                          title: _paymentMethods[index],
                          isExpanded: _expandedPaymentIndex == index,
                          onTap: () {
                            setState(() {
                              _expandedPaymentIndex =
                                  _expandedPaymentIndex == index ? null : index;
                            });
                          },
                        ),
                      );
                    }),

                    const SizedBox(height: 10),
                    const Divider(color: Colors.black12, thickness: 1),
                    const SizedBox(height: 10),

                    const _PurchaseDetails(),
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
        children: const [
          _BottomTotalBar(),
          _HoldToConfirmBar(),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  final String title;
  final bool isExpanded;
  final VoidCallback onTap;

  const _PaymentMethodCard({
    required this.title,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        shadows: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                const Icon(Icons.discount_outlined, color: Colors.black),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_down_rounded
                      : Icons.arrow_forward_ios_rounded,
                  color: Colors.black,
                  size: isExpanded ? 28 : 20,
                ),
              ],
            ),
          ),
          if (isExpanded) ...[
            const SizedBox(height: 20),
            _buildInputField('Card Number', '****-****-****-****'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildInputField('Expire', 'DD/MM/YYYY')),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInputField(
                    'CVC',
                    '***',
                    prefixIcon: Icons.credit_card_outlined,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputField(String label, String hint, {IconData? prefixIcon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 48,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black87),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              if (prefixIcon != null) ...[
                Icon(prefixIcon, size: 20, color: Colors.black87),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: const TextStyle(
                      color: Colors.black38,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PurchaseDetails extends StatelessWidget {
  const _PurchaseDetails();

  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rincian Pembelian:',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          const Divider(color: Colors.black12, thickness: 1),
          const SizedBox(height: 5),
          _buildDetailRow('Tiket Kereta', 'Rp 14.000.000'),
          const SizedBox(height: 8),
          _buildDetailRow('Voucher', '-Rp 300.000'),
          const SizedBox(height: 8),
          _buildDetailRow('Diskon Liburan', '-Rp 1.000.000'),
          const SizedBox(height: 8),
          _buildDetailRow('PPN 10%', 'Rp 1.300.000'),
          const SizedBox(height: 5),
          const Divider(color: Colors.black12, thickness: 1),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Total:',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Rp 15.000.000',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 12,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class _HoldToConfirmBar extends StatefulWidget {
  const _HoldToConfirmBar();

  @override
  State<_HoldToConfirmBar> createState() => _HoldToConfirmBarState();
}

class _HoldToConfirmBarState extends State<_HoldToConfirmBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;

  static const Duration _holdDuration = Duration(milliseconds: 800);
  static const double _triggerThreshold = 0.95;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _holdDuration);
    _progress = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHoldStart() => _controller.forward();

  void _onHoldEnd() {
    if (_progress.value >= _triggerThreshold) {
      _onConfirmed();
    } else {
      _controller.reverse();
    }
  }

  void _onConfirmed() {
    // TODO: Call backend purchase confirmation API here
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SuccessfulPage()),
    );

    // Optional: Reset button state after navigation in case user swipes back
    _controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).padding.bottom + 20,
        top: 20,
      ),
      child: GestureDetector(
        onTapDown: (_) => _onHoldStart(),
        onTapUp: (_) => _onHoldEnd(),
        onTapCancel: _onHoldEnd,
        child: AnimatedBuilder(
          animation: _progress,
          builder: (context, child) {
            final scale = _progress.value;

            return Container(
              width: double.infinity,
              height: 50,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 20,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // ── OUTER LIGHT BLUE CIRCLE ───────────────────────────────
                  if (scale > 0)
                    Transform.scale(
                      scale: scale * 12,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFF90CAF9).withOpacity(0.45),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),

                  // ── INNER DARK BLUE CIRCLE ────────────────────────────────
                  if (scale > 0)
                    Transform.scale(
                      scale: scale * 10,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: const Color(0xFF1565C0),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),

                  // ── LABEL ─────────────────────────────────────────────────
                  Text(
                    scale >= _triggerThreshold
                        ? 'Confirmed!'
                        : 'Hold to Confirm',
                    style: TextStyle(
                      color: scale > 0.3 ? Colors.white : Colors.black54,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// Static mock of the ticket card specifically for the checkout UI structure
class _CheckoutTicketCard extends StatelessWidget {
  const _CheckoutTicketCard();

  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        shadows: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── HEADER BAR ───────────────────────────────────────────────────
          Container(
            width: double.infinity,
            height: 30.50,
            padding: const EdgeInsets.symmetric(horizontal: 17),
            decoration: const ShapeDecoration(
              color: Color(0xFF0098FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
            ),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Train Ticket',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

          // ── CLASS LABEL ──────────────────────────────────────────────────
          const Padding(
            padding: EdgeInsets.only(left: 15, top: 6, bottom: 6),
            child: Text(
              'ECONOMY CLASS',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const Divider(
            height: 1,
            thickness: 1,
            indent: 13,
            endIndent: 13,
            color: Color(0x4D000000),
          ),

          // ── FROM / TO ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _TicketLabelValue(
                  label: 'FROM',
                  value: 'Jakarta',
                  isLarge: true,
                ),
                _TicketLabelValue(
                  label: 'TO',
                  value: 'Ngawi Barat',
                  isLarge: true,
                ),
                SizedBox(width: 20),
              ],
            ),
          ),

          const Divider(
            height: 1,
            thickness: 1,
            indent: 13,
            endIndent: 13,
            color: Color(0x4D000000),
          ),

          // ── ROW 1: DATE / DEPARTURE / ARRIVE ─────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _TicketLabelValue(label: 'DATE', value: '19/2/2026'),
                _TicketLabelValue(label: 'DEPARTURE', value: '9:00'),
                _TicketLabelValue(label: 'ARRIVE', value: '11:00'),
              ],
            ),
          ),

          // ── ROW 2: TRAIN / CARRIAGE / SEAT ───────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 4, 15, 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _TicketLabelValue(label: 'TRAIN', value: '1234'),
                _TicketLabelValue(label: 'CARRIAGE', value: '01'),
                _TicketLabelValue(label: 'SEAT', value: 'A12'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TicketLabelValue extends StatelessWidget {
  final String label;
  final String value;
  final bool isLarge;

  const _TicketLabelValue({
    required this.label,
    required this.value,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 10,
            fontFamily: 'Cairo',
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.black,
            fontSize: isLarge ? 16 : 10,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }
}

class _BottomTotalBar extends StatelessWidget {
  const _BottomTotalBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: ShapeDecoration(
          color: const Color(0xFF5A9AE5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Total:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              'Rp. 12.000.000',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
