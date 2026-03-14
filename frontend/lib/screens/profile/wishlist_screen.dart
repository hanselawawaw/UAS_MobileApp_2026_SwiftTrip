import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ─────────────────────────────────────────────────────────────────────────────
// MODEL
// ─────────────────────────────────────────────────────────────────────────────

class WishlistItem {
  final String id;
  final String title;
  final double rating;
  final String description;
  final String? imageAsset;
  final String? imageUrl;
  bool isWishlisted;

  WishlistItem({
    required this.id,
    required this.title,
    required this.rating,
    required this.description,
    this.imageAsset,
    this.imageUrl,
    this.isWishlisted = true,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// WISHLIST SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final List<WishlistItem> _items = List.generate(
    5,
    (i) => WishlistItem(
      id: 'item_$i',
      title: 'Rumah Wilson Williem',
      rating: 5,
      description:
          'rumah wilsoLorem ipsum dolor sit amet, consectetur adipiscing elit ......',
      imageAsset: 'assets/images/home/vacation_logo.png',
    ),
  );

  void _toggleWishlist(int index) {
    setState(() => _items[index].isWishlisted = !_items[index].isWishlisted);
    if (!_items[index].isWishlisted) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) setState(() => _items.removeAt(index));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top Bar ──────────────────────────────────────────────────────
          _WishlistTopBar(),

          // ── Title ────────────────────────────────────────────────────────
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Text(
              'Wishlist',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 26,
                color: Colors.black,
              ),
            ),
          ),
          const Divider(height: 20, indent: 20, endIndent: 20),

          // ── List ─────────────────────────────────────────────────────────
          Expanded(
            child: _items.isEmpty
                ? const Center(
                    child: Text(
                      'No wishlist items yet.',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Colors.black45,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),
                    itemCount: _items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (_, i) => _WishlistCard(
                      item: _items[i],
                      onToggleWishlist: () => _toggleWishlist(i),
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

class _WishlistTopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
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
            child: const Icon(Icons.chevron_left, size: 30, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// WISHLIST CARD
// Layout persis screenshot:
//  - Gambar kiri, rounded HANYA di sisi kiri card (topLeft + bottomLeft)
//  - ⚙ gear icon → pojok KIRI BAWAH gambar
//  - ♡ heart icon → pojok KANAN ATAS gambar (agak ke tengah, di atas gambar)
//  - Teks judul, rating bintang, deskripsi di kanan
// ─────────────────────────────────────────────────────────────────────────────

class _WishlistCard extends StatelessWidget {
  final WishlistItem item;
  final VoidCallback onToggleWishlist;

  const _WishlistCard({required this.item, required this.onToggleWishlist});

  @override
  Widget build(BuildContext context) {
    const double cardHeight = 118.0;
    const double imageWidth  = 140.0;

    return Container(
      height: cardHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── IMAGE + overlaid icons ────────────────────────────────────────
          SizedBox(
            width: imageWidth,
            height: cardHeight,
            child: Stack(
              children: [
                // Image — rounded hanya di sisi kiri card
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                  child: _ItemImage(
                    item: item,
                    width: imageWidth,
                    height: cardHeight,
                  ),
                ),

                // % Percentage — pojok KIRI ATAS
                Positioned(
                  top: 8,
                  left: 8,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.82),
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: SvgPicture.asset(
                          'assets/icons/percentage.svg',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),

                // ♡ Heart — pojok KANAN ATAS
                Positioned(
                  top: 8,
                  right: 8,
                  child: _CircleIcon(
                    icon: item.isWishlisted
                        ? Icons.favorite
                        : Icons.favorite_border,
                    iconColor:
                        item.isWishlisted ? Colors.red : Colors.black54,
                    onTap: onToggleWishlist,
                  ),
                ),
              ],
            ),
          ),

          // ── TEXT CONTENT ─────────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Rating: number + star icon
                  Row(
                    children: [
                      Text(
                        '${item.rating.toInt()}',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(Icons.star, size: 13, color: Colors.amber),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Description
                  Text(
                    item.description,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w300,
                      fontSize: 10,
                      color: Colors.black54,
                      height: 1.6,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
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
// CIRCLE ICON BUTTON  (semi-transparent white background)
// ─────────────────────────────────────────────────────────────────────────────

class _CircleIcon extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _CircleIcon({
    required this.icon,
    this.iconColor = Colors.black54,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.82),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 14, color: iconColor),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// IMAGE RESOLVER  — URL dulu, fallback ke asset lokal
// ─────────────────────────────────────────────────────────────────────────────

class _ItemImage extends StatelessWidget {
  final WishlistItem item;
  final double width;
  final double height;

  const _ItemImage({
    required this.item,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      width: width,
      height: height,
      color: Colors.blueGrey.shade100,
      child: Icon(Icons.image_outlined,
          color: Colors.blueGrey.shade300, size: 32),
    );

    if (item.imageUrl != null && item.imageUrl!.isNotEmpty) {
      return Image.network(
        item.imageUrl!,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => fallback,
      );
    }

    if (item.imageAsset != null && item.imageAsset!.isNotEmpty) {
      return Image.asset(
        item.imageAsset!,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => fallback,
      );
    }

    return fallback;
  }
}