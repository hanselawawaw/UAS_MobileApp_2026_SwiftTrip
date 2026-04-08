import 'dart:async';

import 'package:flutter/material.dart';
import 'package:swifttrip_frontend/screens/home/widgets/review_popup.dart';

import '../cart/models/cart_models.dart';
import 'services/home_service.dart';
import '../destination/services/destination_service.dart';
import '../destination/models/destination_model.dart';
import 'widgets/banner_carousel.dart';
import 'widgets/floating_buttons.dart';
import 'widgets/recommendation_grid.dart';
import 'widgets/schedule_carousel.dart';
import 'widgets/search_bar.dart';
import 'widgets/section_header.dart';
import '../../widgets/top_bar.dart';
import 'history.dart';
import '../destination/destination_screen.dart';
import '../customer_service/onboarding.dart';
import 'next_trip.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'review.dart';
import '../main/main_screen.dart';
import '../../core/constants.dart';

// ─────────────────────────────────────────────
// CONSTANTS
// ─────────────────────────────────────────────

const _bannerImages = [
  'assets/images/home/carousel1.png',
  'assets/images/home/carousel2.png',
  'assets/images/home/carousel3.png',
];

// ─────────────────────────────────────────────
// HOME PAGE
// ─────────────────────────────────────────────

class HomePage extends StatefulWidget {
  final VoidCallback? onNavigateToDestination;
  const HomePage({super.key, this.onNavigateToDestination});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentBanner = 0;
  int _currentSchedule = 0;

  final PageController _bannerController = PageController();
  final PageController _scheduleController = PageController(
    viewportFraction: 0.92,
  );
  Timer? _bannerTimer;

  bool _isLoading = true;
  List<CartTicket> _serverSchedules = [];
  List<DestinationModel> _serverRecommendations = [];

  @override
  void initState() {
    super.initState();
    _fetchHomeData();
  }

  Future<void> _fetchHomeData() async {
    setState(() => _isLoading = true);
    final homeService = HomeService();
    final destService = DestinationService();
    try {
      final schedules = await homeService.fetchSchedules();
      final recs = await destService.fetchRecommendations();
      if (mounted) {
        setState(() {
          _serverSchedules = schedules.take(5).toList();
          _serverRecommendations = recs;
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _startBannerAutoPlay() {
    _bannerTimer?.cancel();
    _playNextBanner();
  }

  void _playNextBanner() {
    _bannerTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      final nextPage = (_currentBanner + 1) % _bannerImages.length;
      if (_bannerController.hasClients) {
        _bannerController
            .animateToPage(
              nextPage,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOutCubic,
            )
            .then((_) {
              if (mounted) _playNextBanner();
            });
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    _scheduleController.dispose();
    super.dispose();
  }

  void _showReviewPopup() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (_) => const ReviewPopupWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF2B99E3)),
            )
          : Stack(
              children: [
                Column(
                  children: [
                    // ── Top app bar ──
                    TopBar(
                      onHamburgerTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OnboardingPage(),
                          ),
                        );
                      },
                    ),

                    // ── Scrollable body ──
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 80),
                        child: SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  BannerCarousel(
                                    images: _bannerImages,
                                    controller: _bannerController,
                                    currentIndex: _currentBanner,
                                    onPageChanged: (i) =>
                                        setState(() => _currentBanner = i),
                                    onTap: widget.onNavigateToDestination,
                                  ),
                                  const Positioned(
                                    bottom: 0,
                                    child: SearchBarWidget(),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              // Your Schedule section
                              SectionHeader(
                                title: 'Your Schedule',
                                actionLabel: 'History >',
                                onAction: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const HistoryPage(),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 12),

                              if (_serverSchedules.isNotEmpty)
                                ScheduleCarousel(
                                  items: _serverSchedules,
                                  controller: _scheduleController,
                                  currentIndex: _currentSchedule,
                                  onPageChanged: (i) {
                                    setState(() => _currentSchedule = i);
                                  },
                                  onItemTap: (ticket) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NextTripPage(
                                          ticket: ticket,
                                        ),
                                      ),
                                    );
                                  },
                                )
                              else
                                _EmptySchedulePlaceholder(),

                              const SizedBox(height: 20),

                              // Recommendation section
                              const SectionHeader(title: 'Recommendation'),
                              const SizedBox(height: 12),

                              RecommendationGrid(
                                items: _serverRecommendations,
                                onItemTap: (item) {
                                  if (widget.onNavigateToDestination != null) {
                                    widget.onNavigateToDestination!();
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const DestinationPage(),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // ── Floating buttons overlay ──
                const Positioned(
                  right: 30,
                  bottom: 100,
                  child: FloatingButtons(),
                ),
              ],
            ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EMPTY SCHEDULE PLACEHOLDER
// Tapping navigates to the Search tab (index 2) with a clean nav stack.
// ─────────────────────────────────────────────────────────────────────────────

class _EmptySchedulePlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 16),
      child: GestureDetector(
        onTap: () => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const MainScreen(initialIndex: 2),
          ),
          (route) => false,
        ),
        child: Container(
          height: 125,
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle_outline_rounded,
                size: 36,
                color: Constants.primaryBlue,
              ),
              const SizedBox(width: 14),
              Flexible(
                child: Text(
                  'No upcoming trips.\nFind your next destination!',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Constants.primaryBlue,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
