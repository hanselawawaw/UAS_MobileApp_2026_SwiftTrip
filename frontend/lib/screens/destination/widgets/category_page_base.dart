import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../destination_detail_page.dart';

// ─────────────────────────────────────────────────────────────────────────────
// MODEL
// ─────────────────────────────────────────────────────────────────────────────

class CategoryDestination {
  final String id;
  final String name;
  final String imageUrl;
  final String? imageAsset;

  const CategoryDestination({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.imageAsset,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// SLIDE-UP ROUTE
// ─────────────────────────────────────────────────────────────────────────────

class SlideUpRoute extends PageRouteBuilder {
  final Widget page;

  SlideUpRoute({required this.page})
      : super(
          pageBuilder: (_, __, ___) => page,
          transitionsBuilder: (_, animation, __, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeOutCubic;
            final tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 400),
        );
}

// ─────────────────────────────────────────────────────────────────────────────
// CATEGORY PAGE BASE
// ─────────────────────────────────────────────────────────────────────────────

class CategoryPageBase extends StatelessWidget {
  final String title;
  final List<CategoryDestination> destinations;

  const CategoryPageBase({
    super.key,
    required this.title,
    required this.destinations,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: Column(
        children: [
          // ── Top Bar ──────────────────────────────────────────────────────
          _CategoryTopBar(title: title),

          // ── List ─────────────────────────────────────────────────────────
          Expanded(
            child: destinations.isEmpty
                ? const Center(
                    child: Text(
                      'No destinations available.',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Colors.black45,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                    itemCount: destinations.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (_, i) => _CategoryCard(
                      destination: destinations[i],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TOP BAR
// ─────────────────────────────────────────────────────────────────────────────

class _CategoryTopBar extends StatelessWidget {
  final String title;

  const _CategoryTopBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 15,
        left: 20,
        right: 20,
        bottom: 15,
      ),
      child: Row(
        children: [
          SvgPicture.asset('assets/icons/swifttrip_logo.svg', height: 30),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.chevron_left,
              size: 30,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CATEGORY CARD  — full-width image, name bottom-left, "book now" bottom-right
// ─────────────────────────────────────────────────────────────────────────────

class _CategoryCard extends StatelessWidget {
  final CategoryDestination destination;

  const _CategoryCard({required this.destination});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 180,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ── Image ───────────────────────────────────────────────────
              _CardImage(destination: destination),

              // ── Dark gradient overlay ────────────────────────────────────
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.55),
                    ],
                    stops: const [0.45, 1.0],
                  ),
                ),
              ),

              // ── Name — bottom left ───────────────────────────────────────
              Positioned(
                bottom: 14,
                left: 16,
                child: Text(
                  destination.name,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 4,
                        color: Colors.black45,
                      ),
                    ],
                  ),
                ),
              ),

              // ── Book now button — bottom right ───────────────────────────
              Positioned(
                bottom: 10,
                right: 14,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DestinationDetailPage(
                          destination: destination,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2B99E3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'book now',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
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

// ─────────────────────────────────────────────────────────────────────────────
// IMAGE RESOLVER
// ─────────────────────────────────────────────────────────────────────────────

class _CardImage extends StatelessWidget {
  final CategoryDestination destination;

  const _CardImage({required this.destination});

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      color: Colors.blueGrey.shade200,
      child: Icon(Icons.image_outlined,
          color: Colors.blueGrey.shade400, size: 40),
    );

    if (destination.imageUrl.isNotEmpty) {
      return Image.network(
        destination.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => fallback,
      );
    }

    if (destination.imageAsset != null) {
      return Image.asset(
        destination.imageAsset!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => fallback,
      );
    }

    return fallback;
  }
}