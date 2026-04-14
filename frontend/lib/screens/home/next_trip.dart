import 'package:flutter/material.dart';
import 'package:swifttrip_frontend/screens/cart/models/cart_models.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
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
  final CartTicket? ticket;
  const NextTripPage({super.key, this.ticket});

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
    final ticket = widget.ticket ?? await _nextTripService.getNextTrip();

    List<PurchaseDetail> details = [];
    if (widget.ticket != null && ticket != null) {
      // If passing ticket directly (Paid History), calculate details locally
      details = [
        PurchaseDetail(
          label: 'Ticket Price',
          amount: _formatRp(ticket.priceRp),
        ),
        PurchaseDetail(
          label: 'Service Fee (5%)',
          amount: _formatRp(ticket.serviceFee),
        ),
        if (ticket.discountRp > 0)
          PurchaseDetail(
            label: 'Discount',
            amount: '- ${_formatRp(ticket.discountRp)}',
          ),
      ];
    } else {
      details = await _nextTripService.getPurchaseDetails();
    }

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
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Map Display ─────────────────────────────────────────
                        if (_ticket != null &&
                            _ticket!.latitude != null &&
                            _ticket!.longitude != null)
                          _DynamicMap(
                            lat: _ticket!.latitude!,
                            lng: _ticket!.longitude!,
                          )
                        else
                          _MapPlaceholder(),
                        const SizedBox(height: 12),

                        const Divider(color: Colors.black12, thickness: 1),
                        const SizedBox(height: 12),

                        // ── Ticket Card ─────────────────────────────────────────
                        if (_ticket != null)
                          TicketCard(
                            ticket: _ticket!,
                            formatRp: _formatRp,
                            // If ticket came from constructor (Paid), disable delete
                            onDelete: widget.ticket != null
                                ? null
                                : _removeTicket,
                          ),
                        const SizedBox(height: 12),

                        const Divider(color: Colors.black12, thickness: 1),
                        const SizedBox(height: 12),

                        // ── Purchase Details Card ───────────────────────────────
                        PurchaseDetailsCard(
                          details: _purchaseDetails,
                          total: _ticket != null
                              ? (widget.ticket != null
                                    ? _formatRp(_ticket!.priceRp + _ticket!.serviceFee - _ticket!.discountRp)
                                    : _formatRp(_ticket!.priceRp))
                              : 'Rp 0',
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

class _DynamicMap extends StatelessWidget {
  final double lat;
  final double lng;

  const _DynamicMap({required this.lat, required this.lng});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: double.infinity,
        height: 180,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(lat, lng),
            initialZoom: 14.0,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.drag | InteractiveFlag.pinchZoom,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.swifttrip.app',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(lat, lng),
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.location_on,
                    color: Color(0xFFE25142),
                    size: 40,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
