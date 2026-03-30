import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/vehicle_pin.dart';

/// Live OpenStreetMap widget that displays vehicle pins.
/// Automatically adjusts zoom and position to fit all relevant markers.
class VehicleMapWidget extends StatefulWidget {
  final List<VehiclePin> pins;
  final VehiclePin? selectedPin;
  final ValueChanged<VehiclePin> onPinTap;
  final VoidCallback? onMapTap;

  const VehicleMapWidget({
    super.key,
    required this.pins,
    required this.onPinTap,
    this.selectedPin,
    this.onMapTap,
  });

  @override
  State<VehicleMapWidget> createState() => _VehicleMapWidgetState();
}

class _VehicleMapWidgetState extends State<VehicleMapWidget> {
  final MapController _mapController = MapController();

  /// Center point (User Location)
  static const _myLocation = LatLng(-6.300133, 106.638546);

  @override
  void initState() {
    super.initState();
    // Trigger initial fit after first build
    WidgetsBinding.instance.addPostFrameCallback((_) => _fitMapToPins());
  }

  @override
  void didUpdateWidget(VehicleMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Re-fit if pins change (e.g. switching Car -> Bus)
    if (oldWidget.pins != widget.pins ||
        oldWidget.selectedPin?.ticket.bookingId !=
            widget.selectedPin?.ticket.bookingId) {
      _fitMapToPins();
    }
  }

  /// Calculates bounds and fits the camera to show all pins + current location.
  void _fitMapToPins() {
    if (!mounted) return;

    // Collect all coordinates to be shown (My Location + all transport pins)
    final points = <LatLng>[_myLocation];
    for (var pin in widget.pins) {
      points.add(LatLng(pin.latitude, pin.longitude));
    }

    if (points.isEmpty) return;

    final bounds = LatLngBounds.fromPoints(points);

    // Smoothly animate the camera to fit all points with some padding
    _mapController.fitCamera(
      CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(40)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: double.infinity,
        height: 220,
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _myLocation,
            initialZoom: 14.0,
            onTap: (_, __) => widget.onMapTap?.call(),
          ),
          children: [
            // ── OSM Tile Layer ───────────────────────────────────────────
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.swifttrip.app',
            ),

            // ── Markers ─────────────────────────────────────────────────
            MarkerLayer(
              markers: [
                // "You Are Here" pin
                const Marker(
                  point: _myLocation,
                  width: 36,
                  height: 36,
                  child: _CurrentLocationDot(),
                ),

                // Vehicle pins
                ...widget.pins.map((pin) {
                  final isSelected =
                      widget.selectedPin?.ticket.bookingId == pin.ticket.bookingId;
                  return Marker(
                    point: LatLng(pin.latitude, pin.longitude),
                    width: isSelected ? 48 : 38,
                    height: isSelected ? 48 : 38,
                    child: GestureDetector(
                      onTap: () => widget.onPinTap(pin),
                      child: _VehiclePinIcon(
                        label: pin.ticket.operator ?? '',
                        isSelected: isSelected,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _CurrentLocationDot extends StatelessWidget {
  const _CurrentLocationDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2B99E3),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: const [
          BoxShadow(color: Color(0x402B99E3), blurRadius: 10, spreadRadius: 4),
        ],
      ),
      child: const Icon(Icons.my_location, color: Colors.white, size: 16),
    );
  }
}

class _VehiclePinIcon extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _VehiclePinIcon({required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF2B99E3) : const Color(0xFFFF6B35),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: isSelected ? 3 : 2),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? const Color(0x662B99E3)
                : const Color(0x40000000),
            blurRadius: isSelected ? 12 : 6,
            spreadRadius: isSelected ? 2 : 0,
          ),
        ],
      ),
      child: const Icon(Icons.directions, color: Colors.white, size: 16),
    );
  }
}
