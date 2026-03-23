import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../land_vehicle.dart';
import '../../main/main_screen.dart';
import '../../cart/checkout/checkout.dart';
import '../models/flight_leg.dart';
import '../services/searching_service.dart';
import 'search_input_field.dart';

class FlightSearchCard extends StatefulWidget {
  const FlightSearchCard({super.key});

  @override
  State<FlightSearchCard> createState() => _FlightSearchCardState();
}

class _PesanButton extends StatelessWidget {
  const _PesanButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CheckoutPage()),
        );
      },
      child: SizedBox(
        width: double.infinity,
        height: 40,
        child: Stack(
          children: [
            Positioned(
              left: 43,
              top: 0,
              right: 0,
              child: Container(
                height: 40,
                decoration: ShapeDecoration(
                  color: const Color(0xFF2B99E3),
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
                alignment: Alignment.center,
                child: const Text(
                  'Pesan Tiket Sekarang',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xFFE5E5E5),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 3,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainScreen(initialIndex: 1),
                    ),
                  );
                },
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: const ShapeDecoration(
                    color: Colors.white,
                    shape: OvalBorder(),
                    shadows: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 20,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.string(
                    '''<svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M18.5455 18.5455C19.1603 18.5455 19.7499 18.7897 20.1847 19.2244C20.6194 19.6592 20.8636 20.2488 20.8636 20.8636C20.8636 21.4785 20.6194 22.0681 20.1847 22.5028C19.7499 22.9376 19.1603 23.1818 18.5455 23.1818C17.9306 23.1818 17.341 22.9376 16.9063 22.5028C16.4715 22.0681 16.2273 21.4785 16.2273 20.8636C16.2273 19.577 17.2589 18.5455 18.5455 18.5455ZM0 0H3.79023L4.87977 2.31818H22.0227C22.3301 2.31818 22.625 2.4403 22.8423 2.65767C23.0597 2.87504 23.1818 3.16986 23.1818 3.47727C23.1818 3.67432 23.1239 3.87136 23.0427 4.05682L18.8932 11.5561C18.4991 12.2632 17.7341 12.75 16.8648 12.75H8.22955L7.18636 14.6393L7.15159 14.7784C7.15159 14.8553 7.18212 14.929 7.23646 14.9833C7.29081 15.0377 7.36451 15.0682 7.44136 15.0682H20.8636V17.3864H6.95455C6.33973 17.3864 5.75009 17.1421 5.31534 16.7074C4.8806 16.2726 4.63636 15.683 4.63636 15.0682C4.63636 14.6625 4.74068 14.28 4.91455 13.9555L6.49091 11.1157L2.31818 2.31818H0V0ZM6.95455 18.5455C7.56937 18.5455 8.159 18.7897 8.59375 19.2244C9.02849 19.6592 9.27273 20.2488 9.27273 20.8636C9.27273 21.4785 9.02849 22.0681 8.59375 22.5028C8.159 22.9376 7.56937 23.1818 6.95455 23.1818C6.33973 23.1818 5.75009 22.9376 5.31534 22.5028C4.8806 22.0681 4.63636 21.4785 4.63636 20.8636C4.63636 19.577 5.66795 18.5455 6.95455 18.5455ZM17.3864 10.4318L20.6086 4.63636H5.95773L8.69318 10.4318H17.3864Z" fill="black"/>
</svg>''',
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FlightSearchCardState extends State<FlightSearchCard>
    with SingleTickerProviderStateMixin {
  String _fromLabel = 'Jakarta (JKTA)';
  String _toLabel = 'Malang (MLA)';
  final String _dateLabel = 'Friday, 20 Feb 2026';
  final String _passengerLabel = '1 Passenger';
  final String _classLabel = 'Economy';
  bool _isSwapped = false;
  bool _isMultiCity = false;
  bool _isSearching = false;
  bool? _ticketFound;
  late final AnimationController _toastController;
  late final Animation<Offset> _toastSlide;

  @override
  void initState() {
    super.initState();
    _toastController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _toastSlide = Tween<Offset>(
      begin: const Offset(1.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _toastController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _toastController.dispose();
    super.dispose();
  }

  Future<void> _handleSearch() async {
    setState(() => _isSearching = true);
    final bool found = await const SearchingService().searchFlights(
      multiCityLegs: _multiCityLegs,
      from: _fromLabel,
      to: _toLabel,
      date: _dateLabel,
      passengers: _passengerLabel,
      flightClass: _classLabel,
      isMultiCity: _isMultiCity,
    );
    if (!mounted) return;
    setState(() {
      _isSearching = false;
      _ticketFound = found;
    });
    await _toastController.forward();
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) await _toastController.reverse();
  }

  final List<FlightLeg> _multiCityLegs = [
    const FlightLeg(
      from: 'Malang (MLA)',
      to: 'Malang (MLA)',
      date: 'Friday, 20 Feb 2026',
    ),
  ];

  void _addLeg() {
    setState(() {
      final String lastTo = _multiCityLegs.last.to;
      _multiCityLegs.add(
        FlightLeg(
          from: lastTo,
          to: 'Malang (MLA)',
          date: 'Friday, 20 Feb 2026',
        ),
      );
    });
  }

  void _removeLeg(int index) {
    if (_multiCityLegs.length > 1) {
      setState(() => _multiCityLegs.removeAt(index));
    }
  }

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
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
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
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _isMultiCity = false;
                        _ticketFound = null;
                      }),
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: !_isMultiCity
                                  ? const Color(0xFF2B99E3)
                                  : Colors.black.withValues(alpha: 0.1),
                              width: !_isMultiCity ? 2 : 1,
                            ),
                          ),
                        ),
                        child: Text(
                          'Round-trip',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: const Color(0xFF2B99E3),
                            fontSize: 16,
                            fontWeight: !_isMultiCity
                                ? FontWeight.w500
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _isMultiCity = true;
                        _ticketFound = null;
                      }),
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: _isMultiCity
                                  ? const Color(0xFF2B99E3)
                                  : Colors.black.withValues(alpha: 0.1),
                              width: _isMultiCity ? 2 : 1,
                            ),
                          ),
                        ),
                        child: Text(
                          'Multi-city',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: const Color(0xFF2B99E3),
                            fontSize: 16,
                            fontWeight: _isMultiCity
                                ? FontWeight.w500
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (!_isMultiCity) ...[
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Column(
                      children: [
                        SearchInputField(
                          label: 'From',
                          icon: Icons.flight_takeoff,
                          value: _fromLabel,
                        ),
                        SearchInputField(
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
                                color: Colors.black.withValues(alpha: 0.1),
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
                SearchInputField(
                  label: 'Date',
                  icon: Icons.calendar_today_outlined,
                  value: _dateLabel,
                ),
                Row(
                  children: [
                    Expanded(
                      child: SearchInputField(
                        label: 'Penumpang',
                        icon: Icons.person_outline,
                        value: _passengerLabel,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SearchInputField(
                        label: 'Flight Class',
                        icon: Icons.airline_seat_recline_normal,
                        value: _classLabel,
                      ),
                    ),
                  ],
                ),
                if (_ticketFound == true)
                  const SearchInputField(
                    label: 'Penerbangan',
                    icon: Icons.airplanemode_active,
                    value: 'Citilink',
                    trailing: Icon(
                      Icons.keyboard_arrow_down,
                      size: 20,
                      color: Colors.black54,
                    ),
                  ),
              ] else ...[
                ...List.generate(_multiCityLegs.length, (i) {
                  final leg = _multiCityLegs[i];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (i == 0)
                        SearchInputField(
                          label: 'From',
                          icon: Icons.flight_takeoff,
                          value: leg.from,
                        ),
                      Row(
                        children: [
                          Expanded(
                            child: SearchInputField(
                              label: 'To',
                              icon: Icons.flight_land,
                              value: leg.to,
                            ),
                          ),
                          if (i > 0)
                            GestureDetector(
                              onTap: () => _removeLeg(i),
                              child: const Padding(
                                padding: EdgeInsets.only(bottom: 12, left: 8),
                                child: Icon(
                                  Icons.remove_circle_outline,
                                  color: Colors.black54,
                                  size: 22,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  );
                }),
                GestureDetector(
                  onTap: _addLeg,
                  child: const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Icon(
                          Icons.add_circle_outline,
                          size: 20,
                          color: Colors.black54,
                        ),
                        SizedBox(width: 8),
                      ],
                    ),
                  ),
                ),
                SearchInputField(
                  label: 'Date',
                  icon: Icons.calendar_today_outlined,
                  value: _dateLabel,
                ),
                Row(
                  children: [
                    Expanded(
                      child: SearchInputField(
                        label: 'Penumpang',
                        icon: Icons.person_outline,
                        value: _passengerLabel,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SearchInputField(
                        label: 'Flight Class',
                        icon: Icons.airline_seat_recline_normal,
                        value: _classLabel,
                      ),
                    ),
                  ],
                ),
                if (_ticketFound == true)
                  const SearchInputField(
                    label: 'Penerbangan',
                    icon: Icons.airplanemode_active,
                    value: 'Citilink',
                    trailing: Icon(
                      Icons.keyboard_arrow_down,
                      size: 20,
                      color: Colors.black54,
                    ),
                  ),
              ],
              const SizedBox(height: 20),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: _ticketFound == true
                    ? _PesanButton(key: const ValueKey('pesan'))
                    : Row(
                        key: const ValueKey('search'),
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const LandVehicleSearch(),
                                  ),
                                );
                              },
                              child: Container(
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.black.withValues(alpha: 0.1),
                                  ),
                                ),
                                child: const Text(
                                  'Kendaraan Darat',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Color(0xFF616161),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: _isSearching ? null : _handleSearch,
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
                                child: _isSearching
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        'Cari',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
        if (_ticketFound != null)
          Positioned(
            top: -80,
            right: 0,
            child: SlideTransition(
              position: _toastSlide,
              child: IgnorePointer(
                child: SizedBox(
                  width: 266,
                  height: 82,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 21,
                        top: 20,
                        child: Container(
                          width: 224,
                          height: 40,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SvgPicture.string(
                        '''<svg width="266" height="82" viewBox="0 0 266 82" fill="none" xmlns="http://www.w3.org/2000/svg">
<g filter="url(#filter0_d_1149_1712)">
<path d="M244.818 16.5H47.3383L20.8176 37.3513L47.3383 57.5H244.818L225.274 37L244.818 16.5Z" fill="white"/>
<path d="M244.818 16.5H47.3383L20.8176 37.3513L47.3383 57.5H244.818L225.274 37L244.818 16.5Z" stroke="white"/>
</g>
<defs>
<filter id="filter0_d_1149_1712" x="-10" y="-10" width="286" height="102" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
<feFlood flood-opacity="0" result="BackgroundImageFix"/>
<feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"/>
<feOffset dy="2"/>
<feGaussianBlur stdDeviation="2"/>
<feComposite in2="hardAlpha" operator="out"/>
<feColorMatrix type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.15 0"/>
<feBlend mode="normal" in2="BackgroundImageFix" result="effect1_dropShadow_1149_1712"/>
<feBlend mode="normal" in="SourceGraphic" in2="effect1_dropShadow_1149_1712" result="shape"/>
</filter>
</defs>
</svg>''',
                        width: 266,
                        height: 82,
                        fit: BoxFit.fill,
                      ),
                      Positioned.fill(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _ticketFound!
                                  ? 'Tiket Ditemukan'
                                  : 'Tidak Ditemukan',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 8),
                            SvgPicture.string(
                              _ticketFound!
                                  ? '''<svg width="124" height="124" viewBox="0 0 124 124" fill="none" xmlns="http://www.w3.org/2000/svg">
<g filter="url(#filter0_d_482_1238)">
<path fill-rule="evenodd" clip-rule="evenodd" d="M61.75 115.5C69.3338 115.5 76.8434 114.006 83.85 111.104C90.8565 108.202 97.2228 103.948 102.585 98.5854C107.948 93.2228 112.202 86.8565 115.104 79.85C118.006 72.8434 119.5 65.3338 119.5 57.75C119.5 50.1662 118.006 42.6566 115.104 35.65C112.202 28.6435 107.948 22.2772 102.585 16.9146C97.2228 11.552 90.8565 7.29817 83.85 4.39596C76.8434 1.49375 69.3338 -1.13008e-07 61.75 0C46.4337 2.2823e-07 31.7448 6.08436 20.9146 16.9146C10.0844 27.7448 4 42.4337 4 57.75C4 73.0663 10.0844 87.7552 20.9146 98.5854C31.7448 109.416 46.4337 115.5 61.75 115.5ZM60.2613 81.1067L92.3447 42.6067L82.4887 34.3933L54.897 67.4969L40.6199 53.2134L31.5468 62.2866L50.7967 81.5366L55.7633 86.5031L60.2613 81.1067Z" fill="#02C518"/>
</g>
<defs>
<filter id="filter0_d_482_1238" x="0" y="0" width="123.5" height="123.5" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
<feFlood flood-opacity="0" result="BackgroundImageFix"/>
<feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"/>
<feOffset dy="4"/>
<feGaussianBlur stdDeviation="2"/>
<feComposite in2="hardAlpha" operator="out"/>
<feColorMatrix type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.25 0"/>
<feBlend mode="normal" in2="BackgroundImageFix" result="effect1_dropShadow_482_1238"/>
<feBlend mode="normal" in="SourceGraphic" in2="effect1_dropShadow_482_1238" result="shape"/>
</filter>
</defs>
</svg>'''
                                  : '''<svg width="37" height="37" viewBox="0 0 37 37" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill-rule="evenodd" clip-rule="evenodd" d="M25.5796 35.5918C23.3351 36.5215 20.9295 37 18.5 37C13.5935 37 8.88795 35.0509 5.41852 31.5815C1.9491 28.112 0 23.4065 0 18.5002C0 13.5937 1.9491 8.88812 5.41852 5.4187C8.88795 1.94927 13.5935 3.65482e-05 18.5 3.65482e-05C20.9295 3.65482e-05 23.3351 0.478552 25.5796 1.40826C27.8242 2.33798 29.8636 3.70068 31.5815 5.41857C33.2994 7.13645 34.6621 9.17587 35.5918 11.4204C36.5215 13.665 37 16.0706 37 18.5C37 20.9295 36.5215 23.3351 35.5918 25.5796C34.6621 27.8242 33.2994 29.8636 31.5815 31.5815C29.8636 33.2994 27.8242 34.6621 25.5796 35.5918Z" fill="#E25142"/>
<path d="M25.6592 12.4336L19.8486 18.2441C19.6611 18.4317 19.5557 18.686 19.5557 18.9512C19.5557 19.2164 19.6611 19.4707 19.8486 19.6582L25.6592 25.4688L24.5664 26.5615L18.7559 20.751C18.5683 20.5634 18.314 20.458 18.0488 20.458C17.8167 20.458 17.593 20.5387 17.415 20.6846L17.3418 20.751L11.5312 26.5615L10.4385 25.4688L16.249 19.6582C16.4366 19.4707 16.542 19.2164 16.542 18.9512C16.542 18.686 16.4366 18.4317 16.249 18.2441L10.4385 12.4336L11.5312 11.3408L17.3418 17.1514C17.5293 17.3389 17.7836 17.4443 18.0488 17.4443C18.314 17.4443 18.5683 17.3389 18.7559 17.1514L24.5664 11.3408L25.6592 12.4336Z" fill="white" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''',
                              width: 36,
                              height: 36,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
