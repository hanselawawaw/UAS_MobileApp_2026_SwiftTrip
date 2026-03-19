import 'dart:async';

import 'package:flutter/material.dart';

import '../../models/recommendation_item.dart';
import '../../models/schedule_item.dart';
import 'widgets/banner_carousel.dart';
import 'widgets/floating_buttons.dart';
import 'widgets/recommendation_grid.dart';
import 'widgets/schedule_carousel.dart';
import 'widgets/search_bar.dart';
import 'widgets/section_header.dart';
import '../../widgets/top_bar.dart';
import '../history/history.dart';
import '../destination/destination.dart';
import '../customer_service/onboarding.dart';
import 'next_trip.dart';

// ─────────────────────────────────────────────
// CONSTANTS / MOCK DATA
// ─────────────────────────────────────────────

const _carouselImages = [
  'assets/images/home/carousel1.png',
  'assets/images/home/carousel2.png',
  'assets/images/home/carousel3.png',
];

const _recommendations = [
  RecommendationItem(
    name: 'Bali',
    description: 'The island of the gods is second to none',
    imageAsset: 'assets/images/home/bali_recommendation.jpg',
  ),
  RecommendationItem(
    name: 'Malang',
    description: 'The Paris of East Java, wrapped in morning mist',
    imageAsset: 'assets/images/home/malang_recommendation.jpg',
  ),
  RecommendationItem(
    name: 'Japan',
    description: 'The land of the rising sun and endless wonders',
    imageAsset: 'assets/images/home/japan_recommendation.jpg',
  ),
  RecommendationItem(
    name: 'Egypt',
    description: 'The cradle of civilizations, etched in golden sand',
    imageAsset: 'assets/images/home/egypt_recommendation.jpg',
  ),
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

  // -- Backend-friendly Data States --
  bool _isLoading = true;
  List<String> _serverBanners = [];
  List<ScheduleItem> _serverSchedules = [];
  List<RecommendationItem> _serverRecommendations = [];

  @override
  void initState() {
    super.initState();
    _fetchHomeData();
  }

  /// Simulates fetching data from a backend API.
  Future<void> _fetchHomeData() async {
    if (!mounted) return;

    setState(() {
      _serverBanners = List.from(_carouselImages);
      _serverSchedules = List<ScheduleItem>.from([
        const ScheduleItem(
          title: 'Kuta Beach Sunset',
          time: '16.00–18.00',
          imageAsset: 'assets/images/home/vacation_logo.png',
        ),
        const ScheduleItem(
          title: 'Kota Semarang',
          time: '18.30–20.00',
          imageAsset: 'assets/images/home/vacation_logo.png',
        ),
        const ScheduleItem(
          title: 'Banten',
          time: '07.00–09.00',
          imageAsset: 'assets/images/home/vacation_logo.png',
        ),
      ]);
      _serverRecommendations = List.from(_recommendations);
      _isLoading = false;
    });

    _startBannerAutoPlay();
  }

  void _startBannerAutoPlay() {
    _bannerTimer?.cancel();
    _playNextBanner();
  }

  void _playNextBanner() {
    if (_serverBanners.isEmpty) return;
    _bannerTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      final nextPage = (_currentBanner + 1) % _serverBanners.length;
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
                              if (_serverBanners.isNotEmpty)
                                Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    BannerCarousel(
                                      images: _serverBanners,
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
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const NextTripPage(),
                                      ),
                                    );
                                  },
                                ),

                              const SizedBox(height: 20),

                              // Recommendation section
                              const SectionHeader(title: 'Recommendation'),
                              const SizedBox(height: 12),

                              RecommendationGrid(
                                items: _serverRecommendations,
                                onItemTap: (item) {
                                  // Either switch tab or push new page
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
