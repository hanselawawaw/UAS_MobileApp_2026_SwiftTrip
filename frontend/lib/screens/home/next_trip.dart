import 'package:flutter/material.dart';
import '../../widgets/top_bar.dart';
import '../cart/cart.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PAGE
// ─────────────────────────────────────────────────────────────────────────────

class NextTripPage extends StatefulWidget {
  const NextTripPage({super.key});

  @override
  State<NextTripPage> createState() => _NextTripPageState();
}

class _NextTripPageState extends State<NextTripPage> {
  // TODO: Replace with data fetched from backend API (e.g. GET /user/next-trip)
  final CartTicket _ticket = const CartTicket(
    type: 'Train Ticket',
    bookingId: 'ID-1231KADASMASDKAASD',
    classLabel: 'ECONOMY CLASS',
    from: 'Jakarta',
    to: 'Ngawi Barat',
    date: '19/2/2026',
    departure: '9:00',
    arrive: '11:00',
    train: '1234',
    carriage: '01',
    seat: 'A12',
    priceRp: 100000,
  );

  // TODO: Replace with dynamic purchase details from backend
  final List<_DetailRow> _purchaseDetails = const [
    _DetailRow(label: 'Tiket Kereta', amount: 'Rp 14.000.000'),
    _DetailRow(label: 'Voucher', amount: '-Rp 300.000'),
    _DetailRow(label: 'Diskon liburan', amount: '-Rp 1.800.000'),
    _DetailRow(label: 'PPN 10%', amount: 'Rp 110.700'),
  ];

  String _formatRp(int amount) {
    final str = amount.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    return 'Rp.${buffer.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: Column(
        children: [
          const TopBar(showBackButton: true),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Map Placeholder ─────────────────────────────────────
                  _MapPlaceholder(),
                  const SizedBox(height: 12),

                  const Divider(color: Colors.black12, thickness: 1),
                  const SizedBox(height: 12),

                  // ── Ticket Card ─────────────────────────────────────────
                  TicketCard(
                    ticket: _ticket,
                    formatRp: _formatRp,
                    onDelete: null,
                  ),
                  const SizedBox(height: 12),

                  const Divider(color: Colors.black12, thickness: 1),
                  const SizedBox(height: 12),

                  // ── Purchase Details Card ───────────────────────────────
                  _PurchaseDetailsCard(
                    details: _purchaseDetails,
                    // TODO: Replace with dynamic total from backend
                    total: 'Rp 12.000.000',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MAP PLACEHOLDER
// ─────────────────────────────────────────────────────────────────────────────

class _MapPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        height: 180,
        color: const Color(0xFFCBD5E1),
        child: Stack(
          children: [
            // TODO: Replace with actual map widget (e.g. google_maps_flutter)
            // TODO: Center map on ticket departure → arrival coordinates
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.map_outlined, size: 48, color: Colors.white54),
                  SizedBox(height: 8),
                  Text(
                    'Map Placeholder',
                    style: TextStyle(
                      color: Colors.white70,
                      fontFamily: 'Poppins',
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PURCHASE DETAILS CARD
// ─────────────────────────────────────────────────────────────────────────────

class _DetailRow {
  final String label;
  final String amount;

  const _DetailRow({required this.label, required this.amount});
}

class _PurchaseDetailsCard extends StatelessWidget {
  final List<_DetailRow> details;
  final String total;

  const _PurchaseDetailsCard({required this.details, required this.total});

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
          const SizedBox(height: 8),
          const Divider(color: Colors.black12, thickness: 1),
          const SizedBox(height: 8),

          ...details.map(
            (row) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    row.label,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    row.amount,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),
          const Divider(color: Colors.black12, thickness: 1),
          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total:',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                total,
                style: const TextStyle(
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
}
