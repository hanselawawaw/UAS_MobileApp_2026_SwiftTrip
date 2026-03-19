import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../widgets/top_bar.dart';
import '../../main/main_screen.dart';

class PaymentDetailPage extends StatelessWidget {
  const PaymentDetailPage({super.key});

  // TODO: Replace with backend data model once API is ready
  static const String _checkSvg = '''
<svg width="124" height="124" viewBox="0 0 124 124" fill="none" xmlns="http://www.w3.org/2000/svg">
<g filter="url(#filter0_d_482_1238)">
<path fill-rule="evenodd" clip-rule="evenodd" d="M61.75 115.5C69.3338 115.5 76.8434 114.006 83.85 111.104C90.8565 108.202 97.2228 103.948 102.585 98.5854C107.948 93.2228 112.202 86.8565 115.104 79.85C118.006 72.8434 119.5 65.3338 119.5 57.75C119.5 50.1662 118.006 42.6566 115.104 35.65C112.202 28.6435 107.948 22.2772 102.585 16.9146C97.2228 11.552 90.8565 7.29817 83.85 4.39596C76.8434 1.49375 69.3338 -1.13008e-07 61.75 0C46.4337 2.2823e-07 31.7448 6.08436 20.9146 16.9146C10.0844 27.7448 4 42.4337 4 57.75C4 73.0663 10.0844 87.7552 20.9146 98.5854C31.7448 109.416 46.4337 115.5 61.75 115.5ZM60.2613 81.1067L92.3447 42.6067L82.4887 34.3933L54.897 67.4969L40.6199 53.2134L31.5468 62.2866L50.7967 81.5366L55.7633 86.5031L60.2613 81.1067Z" fill="#02C518"/>
</g>
<defs>
<filter id="filter0_d_482_1238" x="0" y="0" width="123.5" height="123.5" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
<feFlood flood-opacity="0" result="BackgroundImageFix"/>
<feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"/>
<feOffset dy="4"/>
<feGaussianBlur stdDeviation="2"/>
<feComposite in2="hardAlpha" operator="out"/>
<feColorMatrix type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.25 0"/>
<feBlend mode="normal" in2="BackgroundImageFix" result="effect1_dropShadow_482_1238"/>
<feBlend mode="normal" in="SourceGraphic" in2="effect1_dropShadow_482_1238" result="shape"/>
</filter>
</defs>
</svg>
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: Column(
          children: [
            const TopBar(showBackButton: true),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 24),

                    // ── CHECK ICON + TITLE ──────────────────────────────────
                    SvgPicture.string(_checkSvg, width: 124, height: 124),
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
                    _TicketCard(),

                    const SizedBox(height: 16),

                    // ── PURCHASE DETAILS CARD ───────────────────────────────
                    _PurchaseDetailsCard(),
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

class _TicketCard extends StatelessWidget {
  // TODO: Accept ticket model from backend
  const _TicketCard();

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
          // Faint barcode-style header strip from screenshot
          Container(
            width: double.infinity,
            height: 22,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFEEEEEE),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            alignment: Alignment.centerLeft,
            child: const Text(
              'TRAIN TICKET  ·  NO. 123 IN NAGASMSONASD',
              style: TextStyle(
                color: Color(0xFFAAAAAA),
                fontSize: 8,
                fontFamily: 'Cairo',
                letterSpacing: 0.5,
              ),
            ),
          ),

          // ── CLASS LABEL ────────────────────────────────────────────────
          const Padding(
            padding: EdgeInsets.only(left: 15, top: 10, bottom: 6),
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

          // ── FROM / TO ───────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: const [
                _LabelValue(label: 'FROM', value: 'Jakarta', isLarge: true),
                SizedBox(width: 48),
                _LabelValue(label: 'TO', value: 'Ngawi Barat', isLarge: true),
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

          // ── ROW 1: DATE / DEPARTURE / ARRIVE ───────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _LabelValue(label: 'DATE', value: '19/2/2026'),
                _LabelValue(label: 'DEPARTURE', value: '9:00'),
                _LabelValue(label: 'ARRIVE', value: '11:00'),
              ],
            ),
          ),

          // ── ROW 2: TRAIN / CARRIAGE / SEAT ─────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 4, 15, 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _LabelValue(label: 'TRAIN', value: '1234'),
                _LabelValue(label: 'CARRIAGE', value: '01'),
                _LabelValue(label: 'SEAT', value: 'A12'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PurchaseDetailsCard extends StatelessWidget {
  // TODO: Accept purchase model from backend
  const _PurchaseDetailsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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

          // TODO: Replace with dynamic list from backend
          _buildRow('Tiket Kereta', 'Rp 14.000.000'),
          _buildRow('Voucher', '-Rp 300.000'),
          _buildRow('Diskon liburan', '-Rp 1.800.000'),
          _buildRow('PPN 10%', 'Rp 110.700'),

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
                'Rp 12.000.000',
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

  Widget _buildRow(String label, String amount) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            amount,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _LabelValue extends StatelessWidget {
  final String label;
  final String value;
  final bool isLarge;

  const _LabelValue({
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
