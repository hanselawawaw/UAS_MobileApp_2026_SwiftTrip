import 'package:flutter/material.dart';
import 'package:swifttrip_frontend/screens/cart/models/cart_models.dart';
import 'package:swifttrip_frontend/screens/cart/widgets/ticket_card.dart';
import '../../widgets/top_bar.dart';
import '../cart/cart.dart';
import '../main/main_screen.dart';
import 'services/next_trip_service.dart';
import 'models/purchase_detail.dart';
import 'widgets/purchase_details_card.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PAGE
// ─────────────────────────────────────────────────────────────────────────────

class NextTripPage extends StatefulWidget {
  const NextTripPage({super.key});

  @override
  State<NextTripPage> createState() => _NextTripPageState();
}

class _NextTripPageState extends State<NextTripPage> {
  final _nextTripService = NextTripService();
  CartTicket? _ticket;
  List<PurchaseDetail> _purchaseDetails = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final ticket = await _nextTripService.getNextTrip();
    final details = await _nextTripService.getPurchaseDetails();
    if (mounted) {
      setState(() {
        _ticket = ticket;
        _purchaseDetails = details;
        _isLoading = false;
      });
    }
  }

  String _formatRp(int amount) {
    final str = amount.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    return 'Rp.${buffer.toString()}';
  }

  void _removeTicket() {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            width: 313,
            height: 157,
            decoration: ShapeDecoration(
              gradient: const LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color(0xFFFFCDCD),
                  Color(0xFFF6F6F6),
                  Color(0xFFF6F6F6),
                  Color(0xFFFFCDCD),
                ],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x4C000000),
                  blurRadius: 20,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'Are You Sure To Remove \nYour Order?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 121,
                        height: 37,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: const Color(0xFFFFFFFF),
                        ),
                        child: Center(
                          child: Text(
                            'Cancel',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF999999),
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              shadows: [
                                Shadow(
                                  offset: const Offset(0, 0),
                                  blurRadius: 8,
                                  color: Colors.black.withOpacity(0.25),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // TODO: Implement backend API call to delete/cancel the trip
                        // Simulate deletion and navigate home
                        Navigator.pop(context); // Close dialog
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      child: Container(
                        width: 121,
                        height: 33,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFE55A5A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          shadows: const [
                            BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'Delete',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: Column(
        children: [
          const TopBar(showBackButton: true, showHamburger: false),

          Expanded(
            child: _isLoading ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(
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
                  if (_ticket != null) TicketCard(
                    ticket: _ticket!,
                    formatRp: _formatRp,
                    onDelete: _removeTicket,
                  ),
                  const SizedBox(height: 12),

                  const Divider(color: Colors.black12, thickness: 1),
                  const SizedBox(height: 12),

                  // ── Purchase Details Card ───────────────────────────────
                  PurchaseDetailsCard(
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
