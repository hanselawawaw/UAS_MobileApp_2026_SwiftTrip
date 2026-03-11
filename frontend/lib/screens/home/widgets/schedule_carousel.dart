import 'package:flutter/material.dart';
import '../../../models/schedule_item.dart';
import 'page_dots.dart';

class ScheduleCarousel extends StatelessWidget {
  final List<ScheduleItem> items;
  final PageController controller;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;

  const ScheduleCarousel({
    super.key,
    required this.items,
    required this.controller,
    required this.currentIndex,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 125 + 20,
          child: PageView.builder(
            controller: controller,
            onPageChanged: onPageChanged,
            itemCount: items.length,
            itemBuilder: (_, i) => _ScheduleCard(item: items[i]),
          ),
        ),
        const SizedBox(height: 10),
        PageDots(count: items.length, current: currentIndex),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SCHEDULE CARD — layout based on Figma raw code
// ─────────────────────────────────────────────────────────────────────────────

class _ScheduleCard extends StatelessWidget {
  final ScheduleItem item;

  const _ScheduleCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 16),
      child: SizedBox(
        width: 350,
        height: 125,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // ── White card background with shadow ──────────────────────
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: 350,
                height: 125,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x26000000),
                      blurRadius: 20,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
              ),
            ),

            // ── Title ──────────────────────────────────────────────────
            Positioned(
              left: 23,
              top: 35,
              child: Text(
                item.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // ── Time range ─────────────────────────────────────────────
            Positioned(
              left: 23,
              top: 59,
              child: Text(
                item.time,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),

            // ── "get more details" ─────────────────────────────────────
            Positioned(
              left: 23,
              top: 89,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'get more details',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.40),
                      fontSize: 8,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    size: 8,
                    color: Colors.black.withOpacity(0.40),
                  ),
                ],
              ),
            ),

            // ── Vacation logo illustration ─────────────────────────────
            Positioned(
              left: 208,
              top: 13,
              child: _ScheduleImage(
                imageAsset:
                    item.imageAsset ?? 'assets/images/home/vacation_logo.png',
                imageUrl: item.imageUrl,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// IMAGE RESOLVER
// Prefers remote URL (backend), falls back to local asset
// ─────────────────────────────────────────────────────────────────────────────

class _ScheduleImage extends StatelessWidget {
  final String imageAsset;
  final String? imageUrl;

  const _ScheduleImage({required this.imageAsset, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    const double w = 132;
    const double h = 100;

    final fallback = SizedBox(
      width: w,
      height: h,
      child: Icon(Icons.image_outlined, color: Colors.grey.shade300, size: 36),
    );

    // 1. Remote URL — from backend
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        width: w,
        height: h,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => fallback,
      );
    }

    // 2. Local asset (vacation_logo.png by default)
    return Image.asset(
      imageAsset,
      width: w,
      height: h,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => fallback,
    );
  }
}
