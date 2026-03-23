import 'package:flutter/material.dart';
import 'package:swifttrip_frontend/screens/cart/models/promotion_models.dart';
import 'package:swifttrip_frontend/screens/cart/promotions.dart';

import '../../widgets/top_bar.dart';
import '../customer_service/onboarding.dart';
import '../checkout/checkout.dart';
import 'models/detail_row.dart';
import 'models/ride_option.dart';
import 'utils/rp_format.dart';
import 'widgets/map_placeholder.dart';
import 'widgets/purchase_details_card.dart';
import 'widgets/ride_card.dart';
import 'widgets/total_confirm_bar.dart';
import 'widgets/apply_promotions_row.dart';
import 'services/searching_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PAGE
// ─────────────────────────────────────────────────────────────────────────────

class LandVehicleSearch extends StatefulWidget {
  const LandVehicleSearch({super.key});

  @override
  State<LandVehicleSearch> createState() => _LandVehicleSearchState();
}

class _LandVehicleSearchState extends State<LandVehicleSearch> {
  int? _selectedRideIndex;
  Promotion? _appliedPromo;

  List<RideOption> _rideOptions = [];
  List<DetailRow> _purchaseDetails = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    const service = SearchingService();
    final results = await Future.wait([
      service.getRideOptions(),
      service.getPurchaseDetails(),
    ]);

    if (mounted) {
      setState(() {
        _rideOptions = results[0] as List<RideOption>;
        _purchaseDetails = results[1] as List<DetailRow>;
        _isLoading = false;
      });
    }
  }

  int get _total {
    if (_selectedRideIndex != null && _rideOptions.isNotEmpty) {
      return _rideOptions[_selectedRideIndex!].priceRp;
    }
    return 300000;
  }

  // Kept for now to avoid touching behavior in this file.
  // (The widget layer uses `formatRp()` extracted into `utils/`.)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: Column(
        children: [
          // ── Top Bar ──────────────────────────────────────────────────
          TopBar(
            showHamburger: true,
            showBackButton: true,
            onHamburgerTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OnboardingPage()),
              );
            },
          ),

          // ── Scrollable Content ────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  // ── Map Placeholder ───────────────────────────────────
                  const MapPlaceholder(),
                  const SizedBox(height: 30),

                  // ── Choose Ride Section ───────────────────────────────
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Choose ride:',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 176,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                clipBehavior: Clip.none,
                                itemCount: _rideOptions.length,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(width: 12),
                                itemBuilder: (_, i) => RideCard(
                                  option: _rideOptions[i],
                                  isSelected: _selectedRideIndex == i,
                                  onTap: () => setState(() {
                                    _selectedRideIndex = _selectedRideIndex == i
                                        ? null
                                        : i;
                                  }),
                                  formatRp: formatRp,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            PurchaseDetailsCard(
                              details: _purchaseDetails,
                              total: 'Rp 12.000.000',
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ],
      ),

      // ── Pinned Bottom Section ─────────────────────────────────────────
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          0,
          20,
          MediaQuery.of(context).padding.bottom + 30,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            // ── Apply Promotions ────────────────────────────────────────
            ApplyPromotionsRow(
              appliedPromo: _appliedPromo,
              onTap: () async {
                final result = await Navigator.push<Promotion?>(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        PromotionsPage(initialSelection: _appliedPromo),
                  ),
                );
                if (mounted && result != _appliedPromo) {
                  setState(() => _appliedPromo = result);
                }
              },
            ),
            const SizedBox(height: 10),

            // ── Total + Confirm ─────────────────────────────────────────
            TotalConfirmBar(
              totalLabel: 'Total:',
              totalAmount: formatRp(_total),
              onConfirm: () {
                // TODO: POST selected ride + applied promo to backend
                // TODO: Navigate to checkout or booking confirmation
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CheckoutPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
