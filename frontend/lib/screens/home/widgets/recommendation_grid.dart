import 'package:flutter/material.dart';
import '../../../models/recommendation_item.dart';
import 'dart:ui';

// ─────────────────────────────────────────────────────────────────────────────
// RECOMMENDATION GRID
// ─────────────────────────────────────────────────────────────────────────────

class RecommendationGrid extends StatelessWidget {
  final List<RecommendationItem> items;

  const RecommendationGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        shrinkWrap: true, // Crucial for nesting inside SingleChildScrollView
        physics: const NeverScrollableScrollPhysics(), // Disable grid scrolling
        crossAxisCount: 2, // Forces exactly 2 columns
        mainAxisSpacing: 15, // Vertical spacing between cards
        crossAxisSpacing: 20, // Horizontal spacing between cards
        childAspectRatio:
            1.65, // Defines the aspect ratio of each card (roughly matching original dimensions)
        children: items.map((item) => _RecommendationCard(item: item)).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// RECOMMENDATION CARD
// ─────────────────────────────────────────────────────────────────────────────

class _RecommendationCard extends StatelessWidget {
  final RecommendationItem item;

  const _RecommendationCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        shadows: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 20,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── 1. Background image (Blurred) ─────────────────────────
          ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 3.0,
              sigmaY: 3.0,
            ), // Adjust blur intensity here
            child: _RecommendationImage(
              imageAsset: item.imageAsset,
              imageUrl: item.imageUrl,
            ),
          ),

          // ── 2. Full-card dark overlay for contrast ────────────────
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 1.0],
                colors: [
                  Colors.black.withOpacity(0.20),
                  Colors.black.withOpacity(0.60),
                ],
              ),
            ),
          ),

          // ── 3. Text — centered horizontally AND vertically ────────
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // City name
                  Text(
                    item.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      height: 1.50,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Description
                  SizedBox(
                    width: 136,
                    child: Text(
                      item.description,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// IMAGE RESOLVER
// Prefers remote URL (backend), falls back to local asset, then placeholder
// ─────────────────────────────────────────────────────────────────────────────

class _RecommendationImage extends StatelessWidget {
  final String? imageAsset;
  final String? imageUrl;

  const _RecommendationImage({this.imageAsset, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      color: Colors.blueGrey.shade300,
      child: const Icon(
        Icons.landscape_outlined,
        color: Colors.white54,
        size: 36,
      ),
    );

    // 1. Remote URL — from backend
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => fallback,
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return Container(
            color: Colors.blueGrey.shade200,
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white54,
              ),
            ),
          );
        },
      );
    }

    // 2. Local asset
    if (imageAsset != null && imageAsset!.isNotEmpty) {
      return Image.asset(
        imageAsset!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => fallback,
      );
    }

    return fallback;
  }
}
