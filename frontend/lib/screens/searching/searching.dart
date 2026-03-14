import 'package:flutter/material.dart';
import '../../widgets/top_bar.dart';

class CouponModel {
  final String title;
  final String description;
  final String code;

  const CouponModel({
    required this.title,
    required this.description,
    required this.code,
  });
}

class SearchingPage extends StatelessWidget {
  const SearchingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: Stack(
        children: [
          // Background Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 250,
            child: Image.asset(
              'assets/images/searching/background.png',
              fit: BoxFit.cover,
            ),
          ),

          const Column(
            children: [
              TopBar(),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 100,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 100),
                      const _FlightSearchCard(),
                      const SizedBox(height: 30),
                      const _CouponSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FlightSearchCard extends StatefulWidget {
  const _FlightSearchCard();

  @override
  State<_FlightSearchCard> createState() => _FlightSearchCardState();
}

class _FlightSearchCardState extends State<_FlightSearchCard> {
  String _fromLabel = 'Jakarta (JKTA)';
  String _toLabel = 'Malang (MLA)';
  String _dateLabel = 'Friday, 20 Feb 2026';
  String _passengerLabel = '1 Passenger';
  String _classLabel = 'Economy';
  bool _isSwapped = false;

  void _swap() {
    setState(() {
      final temp = _fromLabel;
      _fromLabel = _toLabel;
      _toLabel = temp;
      _isSwapped = !_isSwapped;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
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
          // Tabs
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xFF2B99E3), width: 2),
                    ),
                  ),
                  child: Text(
                    'Round-trip',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xFF2B99E3),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Text(
                    'Multi-city', // TODO: Implement Multi-city
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xFF2B99E3),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Inputs
          Stack(
            alignment: Alignment.centerRight,
            children: [
              Column(
                children: [
                  _SearchInputField(
                    label: 'From',
                    icon: Icons.flight_takeoff,
                    value: _fromLabel,
                  ),
                  _SearchInputField(
                    label: 'To',
                    icon: Icons.flight_land,
                    value: _toLabel,
                  ),
                ],
              ),
              Positioned(
                top: 40,
                right: 0,
                child: GestureDetector(
                  onTap: _swap,
                  child: AnimatedRotation(
                    turns: _isSwapped ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black.withOpacity(0.1),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1A000000),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.swap_vert,
                        size: 20,
                        color: Color(0xFF2B99E3),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          _SearchInputField(
            label: 'Date',
            icon: Icons.calendar_today_outlined,
            value: _dateLabel,
          ),

          Row(
            children: [
              Expanded(
                child: _SearchInputField(
                  label: 'Penumpang',
                  icon: Icons.person_outline,
                  value: _passengerLabel,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _SearchInputField(
                  label: 'Flight Class',
                  icon: Icons.airline_seat_recline_normal,
                  value: _classLabel,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black.withOpacity(0.1)),
                  ),
                  child: Text(
                    'Kendaraan Darat', // TODO: Implement Kendaraan Darat
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: const Color(0xFF616161),
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2B99E3),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x26000000),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    'Cari',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SearchInputField extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final String? value;

  const _SearchInputField({this.label, this.icon, this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label ?? '',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.black.withOpacity(0.60),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(icon ?? Icons.circle, size: 20, color: Colors.black),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black.withOpacity(0.2)),
                    ),
                  ),
                  child: Text(
                    value ?? '-',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CouponSection extends StatelessWidget {
  const _CouponSection();

  static const List<String> _categories = [
    'Coupon Raya',
    'Coupon Ticket Plane',
    'Australia',
    'Indonesia',
  ];

  static const List<CouponModel> _coupons = [
    CouponModel(
      title: 'Coupon Raya',
      description: 'Get 10% discount on your next purchase',
      code: 'COUPON123',
    ),
    CouponModel(
      title: 'Coupon Ticket Plane',
      description: 'Get 20% discount on your next purchase',
      code: 'COUPON456',
    ),
    CouponModel(
      title: 'Australia',
      description: 'Get 30% discount on your next purchase',
      code: 'COUPON789',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Limited Coupon',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Use Coupon?', // TODO: Implement Use Coupon
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: const Color(0xFF2B99E3),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(_categories.length, (index) {
              return _buildChip(_categories[index], isActive: index == 0);
            }),
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _coupons
                .map((coupon) => _CouponCard(coupon: coupon))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String label, {bool isActive = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF5A9AE5) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? Colors.transparent : Colors.black12,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Poppins',
          color: isActive ? Colors.white : const Color(0xFF5A9AE5),
          fontSize: 12,
        ),
      ),
    );
  }
}

class _CouponCard extends StatelessWidget {
  final CouponModel coupon;
  const _CouponCard({super.key, required this.coupon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFF5A9AE5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.flight, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  coupon.title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              const Icon(Icons.info_outline, size: 16, color: Colors.black54),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Text(
              coupon.description,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                color: Colors.black54,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.copy, size: 12, color: Colors.black54),
                      SizedBox(width: 4),
                      Text(
                        coupon.code,
                        style: TextStyle(fontSize: 10, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF5A9AE5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'COPY', // TODO: Implement Copy
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
