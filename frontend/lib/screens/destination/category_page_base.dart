import 'package:flutter/material.dart';
import 'models/destination_model.dart';
import '../../widgets/top_bar.dart';

// ─────────────────────────────────────────────────────────────────────────────
// REUSABLE CATEGORY PAGE BASE
// ─────────────────────────────────────────────────────────────────────────────

class CategoryPageBase extends StatelessWidget {
  final String title;
  final List<DestinationModel> items;
  final bool isLoading;
  final void Function(DestinationModel)? onItemTap;

  // TODO: Add pagination / infinite scroll support when backend is ready

  const CategoryPageBase({
    super.key,
    required this.title,
    required this.items,
    this.isLoading = false,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TopBar(showBackButton: true, showHamburger: false),

            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 28,
                  color: Colors.black,
                ),
              ),
            ),

            const SizedBox(height: 12),
            const Divider(
              color: Colors.black12,
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
            const SizedBox(height: 12),

            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF2B99E3),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
                      physics: const BouncingScrollPhysics(),
                      itemCount: items.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: CategoryItemCard(
                          item: items[index],
                          onTap: onItemTap,
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

// ─────────────────────────────────────────────────────────────────────────────
// CATEGORY ITEM CARD
// ─────────────────────────────────────────────────────────────────────────────

class CategoryItemCard extends StatelessWidget {
  final DestinationModel item;
  final void Function(DestinationModel)? onTap;

  const CategoryItemCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap != null ? () => onTap!(item) : null,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // ── Image ─────────────────────────────────────────────────
            SizedBox(
              width: 140,
              height: 120,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      item.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.image, color: Colors.grey),
                      ),
                    ),
                    if (item.discountPercentage > 0)
                      const Positioned(
                        top: 8,
                        left: 8,
                        child: Icon(
                          Icons.discount_outlined,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: ValueListenableBuilder<bool>(
                        valueListenable: item.isFavoriteNotifier,
                        builder: (context, isFavorite, child) {
                          return GestureDetector(
                            onTap: () {
                              item.isFavorite = !isFavorite;
                            },
                            child: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.white,
                              size: 18,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Content ───────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          item.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                        const Icon(Icons.star, size: 13, color: Colors.black),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: Text(
                        item.description,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w300,
                          fontSize: 11,
                          color: Colors.black54,
                          height: 1.5,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
