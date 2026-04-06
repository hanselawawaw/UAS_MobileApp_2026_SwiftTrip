import 'package:flutter/material.dart';
import 'package:swifttrip_frontend/screens/cart/models/promotion_models.dart';
import 'package:swifttrip_frontend/screens/cart/promotions.dart';

import '../../widgets/top_bar.dart';
import '../customer_service/onboarding.dart';
import '../checkout/checkout.dart';
import '../checkout/models/checkout_details_model.dart';
import '../checkout/models/ticket_model.dart';
import '../checkout/models/purchase_item_model.dart';
import 'models/detail_row.dart';
import 'models/ride_option.dart';
import 'models/vehicle_pin.dart';
import 'utils/rp_format.dart';
import 'widgets/map_placeholder.dart';
import 'widgets/purchase_details_card.dart';
import 'widgets/ride_card.dart';
import 'widgets/total_confirm_bar.dart';
import 'widgets/apply_promotions_row.dart';
import 'services/searching_service.dart';
import 'services/mock_vehicle_service.dart';
import '../cart/services/cart_service.dart';
import '../main/main_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PAGE
// ─────────────────────────────────────────────────────────────────────────────

class LandVehicleSearch extends StatefulWidget {
  const LandVehicleSearch({super.key});

  @override
  State<LandVehicleSearch> createState() => _LandVehicleSearchState();
}

class _LandVehicleSearchState extends State<LandVehicleSearch> {
  final _vehicleService = const MockVehicleService();
  final _cartService = CartService();

  int? _selectedRideIndex;
  Promotion? _appliedPromo;
  VehiclePin? _selectedVehicle;

  List<RideOption> _rideOptions = [];
  List<VehiclePin> _currentPins = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    const service = SearchingService();
    final options = await service.getRideOptions();

    if (mounted) {
      setState(() {
        _rideOptions = options;
        _selectedRideIndex = 0;
        _isLoading = false;
        if (_selectedRideIndex != null) {
          final type = _rideOptions[_selectedRideIndex!].name;
          _currentPins = _vehicleService.getPinsForType(type);
        }
      });
    }
  }

  // ── Derived state ─────────────────────────────────────────────────────────

  String get _activeType {
    if (_selectedRideIndex == null || _rideOptions.isEmpty) return 'Car';
    return _rideOptions[_selectedRideIndex!].name;
  }

  int get _baseTotal {
    if (_selectedVehicle != null) return _selectedVehicle!.ticket.priceRp;
    if (_selectedRideIndex != null && _rideOptions.isNotEmpty) {
      return _rideOptions[_selectedRideIndex!].priceRp;
    }
    return 0;
  }

  int get _discountAmount =>
      _cartService.calculateDiscount(_baseTotal, _appliedPromo);

  int get _finalTotal => _baseTotal - _discountAmount;

  List<DetailRow> get _dynamicDetails {
    if (_selectedVehicle == null) {
      return const [DetailRow(label: 'Select a vehicle', amount: '-')];
    }

    final ticket = _selectedVehicle!.ticket;
    final rows = [
      DetailRow(label: ticket.type, amount: formatRp(ticket.priceRp)),
      if (ticket.operator != null)
        DetailRow(label: 'Operator', amount: ticket.operator!),
      if (ticket.from != null && ticket.to != null)
        DetailRow(label: 'Route', amount: '${ticket.from} → ${ticket.to}'),
      if (ticket.date != null) DetailRow(label: 'Date', amount: ticket.date!),
      if (ticket.departure != null && ticket.arrive != null)
        DetailRow(
          label: 'Time',
          amount: '${ticket.departure} – ${ticket.arrive}',
        ),
      if (ticket.classLabel.isNotEmpty)
        DetailRow(label: 'Class', amount: ticket.classLabel),
    ];

    if (_discountAmount > 0) {
      rows.add(
        DetailRow(label: 'Discount', amount: '- ${formatRp(_discountAmount)}'),
      );
    }

    return rows;
  }

  // ── Event handlers ────────────────────────────────────────────────────────

  void _onRideSelected(int index) {
    setState(() {
      _selectedRideIndex = _selectedRideIndex == index ? null : index;
      _selectedVehicle = null;
      if (_selectedRideIndex != null) {
        final type = _rideOptions[_selectedRideIndex!].name;
        _currentPins = _vehicleService.getPinsForType(type);
      } else {
        _currentPins = [];
      }
    });
  }

  void _onPinSelected(VehiclePin pin) {
    setState(() {
      // Find the stable reference from our current list for this pin
      _selectedVehicle = _currentPins.firstWhere(
        (p) => p.ticket.bookingId == pin.ticket.bookingId,
        orElse: () => pin,
      );
    });
  }

  void _onAddToCart() {
    if (_selectedVehicle == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a vehicle first'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Since VehiclePin already contains a CartTicket, we can use it directly
    // and just apply any transient UI-only modifications if needed.
    final baseTicket = _selectedVehicle!.ticket;
    
    final cartTicket = baseTicket.copyWith(
      imageUrl: baseTicket.imageUrl ?? 'assets/images/train_vector.png',
    );

    _cartService.addTicket(cartTicket);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const MainScreen(initialIndex: 1),
      ),
    );
  }

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

                  // ── Live Map ───────────────────────────────────────────
                  VehicleMapWidget(
                    pins: _currentPins,
                    selectedPin: _selectedVehicle,
                    onPinTap: _onPinSelected,
                    onMapTap: () {
                      setState(() => _selectedVehicle = null);
                    },
                  ),
                  const SizedBox(height: 30),

                  // ── Choose Ride Section ────────────────────────────────
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

                            // ── Ride type cards (Car / Bus / Train) ─────
                            SizedBox(
                              height: 176,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                clipBehavior: Clip.none,
                                itemCount: _rideOptions.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 12),
                                itemBuilder: (_, i) {
                                  final option = _rideOptions[i];
                                  String? duration;

                                  // Only show duration if this category and a vehicle in it is picked
                                  if (_selectedVehicle != null &&
                                      _selectedVehicle!.ticket.type
                                          .toLowerCase()
                                          .contains(
                                            option.name.toLowerCase(),
                                          )) {
                                    duration =
                                        MockVehicleService.calculateDuration(
                                          _selectedVehicle!.ticket.departure,
                                          _selectedVehicle!.ticket.arrive,
                                        );
                                  }

                                  return RideCard(
                                    option: option,
                                    isSelected: _selectedRideIndex == i,
                                    dynamicDuration: duration,
                                    onTap: () => _onRideSelected(i),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 20),

                            // ── Available vehicles list ─────────────────
                            if (_selectedRideIndex != null) ...[
                              Text(
                                'Available ${_activeType}:',
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 100,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  clipBehavior: Clip.none,
                                  itemCount: _currentPins.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(width: 12),
                                  itemBuilder: (_, i) => _VehicleCard(
                                    pin: _currentPins[i],
                                    isSelected:
                                        _selectedVehicle == _currentPins[i],
                                    onTap: () =>
                                        _onPinSelected(_currentPins[i]),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],

                            // ── Payment Detail ──────────────────────────
                            PurchaseDetailsCard(
                              details: _dynamicDetails,
                              total: formatRp(_finalTotal),
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
              totalAmount: formatRp(_finalTotal),
              discountAmount: _discountAmount,
              onCartTap: _onAddToCart,
              onConfirm: () {
                final details = CheckoutDetailsModel(
                  ticket: TicketModel(
                    type: _selectedVehicle?.ticket.type ?? _activeType,
                    classType: _selectedVehicle?.ticket.classLabel ?? '-',
                    from: _selectedVehicle?.ticket.from ?? '-',
                    to: _selectedVehicle?.ticket.to ?? '-',
                    date: _selectedVehicle?.ticket.date ?? '-',
                    departureTime: _selectedVehicle?.ticket.departure ?? '-',
                    arrivalTime: _selectedVehicle?.ticket.arrive ?? '-',
                    operator: _selectedVehicle?.ticket.operator,
                    carPlate: _selectedVehicle?.ticket.carPlate,
                    busNumber: _selectedVehicle?.ticket.busNumber,
                  ),
                  purchaseItems: _dynamicDetails
                      .map(
                        (d) => PurchaseItemModel(
                          label: d.label,
                          amount: d.amount,
                          isDiscount: d.label.toLowerCase().contains('discount'),
                        ),
                      )
                      .toList(),
                  totalPrice: formatRp(_finalTotal),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CheckoutPage(checkoutDetails: details),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Vehicle selection card (horizontal list below ride-type cards)
// ─────────────────────────────────────────────────────────────────────────────

class _VehicleCard extends StatelessWidget {
  final VehiclePin pin;
  final bool isSelected;
  final VoidCallback onTap;

  const _VehicleCard({
    required this.pin,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ticket = pin.ticket;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 170,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2B99E3) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF2B99E3)
                : const Color(0xFFE0E0E0),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0x332B99E3)
                  : const Color(0x14000000),
              blurRadius: isSelected ? 12 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              ticket.operator ?? 'Unknown',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: isSelected ? Colors.white : Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '${ticket.from} → ${ticket.to}',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 11,
                color: isSelected ? Colors.white70 : const Color(0xFF9E9E9E),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              formatRp(ticket.priceRp),
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: isSelected ? Colors.white : const Color(0xFF2B99E3),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
