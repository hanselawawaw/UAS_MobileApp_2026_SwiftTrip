import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'widgets/category_page_base.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DESTINATION DETAIL PAGE
// ─────────────────────────────────────────────────────────────────────────────

class DestinationDetailPage extends StatefulWidget {
  final CategoryDestination destination;
  final double pricePerNight;
  final double rating;
  final String description;
  final List<String> features;

  const DestinationDetailPage({
    super.key,
    required this.destination,
    this.pricePerNight = 300000,
    this.rating = 5,
    this.description =
        'Lorem ipsum dolor sit amet consectetur adipiscing elit. '
        'Quisque faucibus ex sapien vitae pellentesque sem placerat. '
        'In id cursus mi pretium tellus duis convallis. Tempus leo eu '
        'aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus '
        'nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia '
        'integer nunc posuere. Ut hendrerit semper vel class aptent taciti '
        'sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.',
    this.features = const [
      'Great Check In Experience',
      'Free Breakfast Included',
      'Swimming Pool Access',
      'Free WiFi',
    ],
  });

  @override
  State<DestinationDetailPage> createState() => _DestinationDetailPageState();
}

class _DestinationDetailPageState extends State<DestinationDetailPage> {
  bool _isFavorite = false;

  String get _formattedPrice {
    final price = widget.pricePerNight.toInt();
    final str = price.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
      count++;
    }
    return 'Rp. ${buffer.toString().split('').reversed.join()}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ── Top Bar ──────────────────────────────────────────────────────
          _DetailTopBar(),

          // ── Scrollable content ───────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Hero Image ─────────────────────────────────────────
                  _HeroImage(
                    destination: widget.destination,
                    isFavorite: _isFavorite,
                    onToggleFavorite: () =>
                        setState(() => _isFavorite = !_isFavorite),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Name + Rating ────────────────────────────────
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                widget.destination.name,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${widget.rating.toInt()}',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 2),
                            const Icon(Icons.star,
                                size: 16, color: Colors.black),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // ── Description ──────────────────────────────────
                        Text(
                          widget.description,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w300,
                            fontSize: 13,
                            color: Colors.black87,
                            height: 1.65,
                          ),
                        ),

                        const Divider(height: 32, color: Color(0xFFE0E0E0)),

                        // ── Guest Favorite badge ─────────────────────────
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black26, width: 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.auto_awesome,
                                    size: 16, color: Colors.black54),
                                SizedBox(width: 6),
                                Text(
                                  'Guest Favorite',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Icon(Icons.auto_awesome,
                                    size: 16, color: Colors.black54),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ── Features list ────────────────────────────────
                        ...widget.features.map(
                          (f) => _FeatureRow(text: f),
                        ),

                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // ── Bottom bar: price + Add to Cart ───────────────────────────────────
      bottomNavigationBar: _BottomBar(
        formattedPrice: _formattedPrice,
        onAddToCart: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Added to cart!',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              backgroundColor: Color(0xFF2B99E3),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TOP BAR
// ─────────────────────────────────────────────────────────────────────────────

class _DetailTopBar extends StatelessWidget {
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
            child: const Icon(Icons.chevron_left, size: 30, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HERO IMAGE  — full width + heart icon overlay
// ─────────────────────────────────────────────────────────────────────────────

class _HeroImage extends StatelessWidget {
  final CategoryDestination destination;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const _HeroImage({
    required this.destination,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      height: 260,
      color: Colors.blueGrey.shade200,
      child: Icon(Icons.image_outlined,
          color: Colors.blueGrey.shade400, size: 48),
    );

    return Stack(
      children: [
        // Image
        SizedBox(
          height: 260,
          width: double.infinity,
          child: destination.imageUrl.isNotEmpty
              ? Image.network(
                  destination.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => fallback,
                )
              : destination.imageAsset != null
                  ? Image.asset(
                      destination.imageAsset!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => fallback,
                    )
                  : fallback,
        ),

        // Heart icon — top right
        Positioned(
          top: 14,
          right: 14,
          child: GestureDetector(
            onTap: onToggleFavorite,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                size: 18,
                color: isFavorite ? Colors.red : Colors.black54,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FEATURE ROW
// ─────────────────────────────────────────────────────────────────────────────

class _FeatureRow extends StatelessWidget {
  final String text;

  const _FeatureRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          const Icon(Icons.vpn_key_outlined, size: 18, color: Colors.black54),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BOTTOM BAR  — price + Add to Cart button
// ─────────────────────────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  final String formattedPrice;
  final VoidCallback onAddToCart;

  const _BottomBar({
    required this.formattedPrice,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          // Price
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formattedPrice,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const Text(
                'For 1 Night',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                  fontSize: 11,
                  color: Colors.black54,
                ),
              ),
            ],
          ),

          const Spacer(),

          // Add to Cart button
          GestureDetector(
            onTap: onAddToCart,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 22, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF2B99E3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Add to Cart',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}