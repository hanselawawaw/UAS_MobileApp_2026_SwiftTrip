import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../cart/models/cart_models.dart';
import 'page_dots.dart';

class ScheduleCarousel extends StatelessWidget {
  final List<CartTicket> items;
  final PageController controller;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;
  final Function(CartTicket)? onItemTap;

  const ScheduleCarousel({
    super.key,
    required this.items,
    required this.controller,
    required this.currentIndex,
    required this.onPageChanged,
    this.onItemTap,
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
            itemBuilder: (_, i) => _ScheduleCard(item: items[i], onItemTap: onItemTap),
          ),
        ),
        const SizedBox(height: 10),
        PageDots(count: items.length, current: currentIndex),
      ],
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  final CartTicket item;
  final Function(CartTicket)? onItemTap;

  const _ScheduleCard({required this.item, this.onItemTap});

  String _formatDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return '';
    try {
      final dateTime = DateTime.parse(rawDate);
      return DateFormat('d MMM yyyy').format(dateTime);
    } catch (e) {
      return rawDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isAccommodation = item.type == 'Accommodation Ticket';
    final String displayTitle = isAccommodation
        ? (item.location ?? 'Accommodation')
        : '${item.from} - ${item.to}';
    final String displayDate = _formatDate(
      isAccommodation ? item.stayDate : item.date,
    );

    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 16),
      child: GestureDetector(
        onTap: () => onItemTap?.call(item),
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
                right: 142,
                child: Text(
                  displayTitle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
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
                  displayDate,
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
              if (isAccommodation)
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: 0,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.horizontal(right: Radius.circular(20)),
                    child: _ScheduleImage(
                      imageAsset: 'assets/images/home/vacation_logo.png',
                      imageUrl: item.imageUrl,
                      isAccommodation: true,
                    ),
                  ),
                )
              else
                Positioned(
                  left: 208,
                  top: 13,
                  child: _ScheduleImage(
                    imageAsset: 'assets/images/home/vacation_logo.png',
                    imageUrl: item.imageUrl,
                    isAccommodation: false,
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
// Prefers remote URL (backend), falls back to local asset
// ─────────────────────────────────────────────────────────────────────────────

class _ScheduleImage extends StatelessWidget {
  final String imageAsset;
  final String? imageUrl;
  final bool isAccommodation;

  const _ScheduleImage({
    required this.imageAsset,
    this.imageUrl,
    this.isAccommodation = false,
  });

  @override
  Widget build(BuildContext context) {
    final double w = isAccommodation ? 142 : 132;
    final double h = isAccommodation ? 125 : 100;
    final BoxFit fit = isAccommodation ? BoxFit.cover : BoxFit.contain;

    final imageFallback = Image.asset(
      imageAsset,
      width: w,
      height: h,
      fit: fit,
    );

    // 1. Remote URL — from backend
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        width: w,
        height: h,
        fit: fit,
        errorBuilder: (_, __, ___) => imageFallback,
      );
    }

    // 2. Local asset (vacation_logo.png by default)
    return Image.asset(
      imageAsset,
      width: w,
      height: h,
      fit: fit,
      errorBuilder: (_, __, ___) => imageFallback,
    );
  }
}
