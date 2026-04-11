import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:swifttrip_frontend/repositories/auth_repository.dart';
import 'package:swifttrip_frontend/screens/auth/login.dart';
import 'package:swifttrip_frontend/providers/wishlist_provider.dart';
import 'models/destination_model.dart';
import '../../widgets/top_bar.dart';
import '../../providers/cart_provider.dart';
import '../cart/models/cart_models.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DESTINATION DETAIL PAGE
// ─────────────────────────────────────────────────────────────────────────────

class DestinationDetailPage extends StatefulWidget {
  final DestinationModel destination;

  const DestinationDetailPage({super.key, required this.destination});

  @override
  State<DestinationDetailPage> createState() => _DestinationDetailPageState();
}

class _DestinationDetailPageState extends State<DestinationDetailPage> {
  String get _formattedPrice {
    final price = widget.destination.price.toInt();
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

  String get _formattedOriginalPrice {
    final price = widget.destination.originalPrice.toInt();
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
          const TopBar(showBackButton: true, showHamburger: false),

          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Hero Image ───────────────────────────────────────
                  Consumer<WishlistProvider>(
                    builder: (context, provider, child) {
                      return _HeroImage(
                        destination: widget.destination,
                        isFavorite: provider.isFavorite(widget.destination.id),
                        onToggleFavorite: () async {
                          final token = await AuthRepository().getToken();
                          if (token == null) {
                            if (!context.mounted) return;
                            showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              builder: (context) => Container(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Log in to save your favorite destinations',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginPage(),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF2B99E3,
                                        ),
                                        minimumSize: const Size(
                                          double.infinity,
                                          45,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        'Log In',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                            return;
                          }

                          await provider.toggleWishlist(widget.destination.id);
                        },
                      );
                    },
                  ),

                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFE0E0E0),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(height: 30, color: Color(0xFF000000)),
                        // ── Name + Rating ────────────────────────────────
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                widget.destination.title,
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
                              widget.destination.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 2),
                            const Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.black,
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // ── Description ──────────────────────────────────
                        Text(
                          widget.destination.description,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w300,
                            fontSize: 13,
                            color: Colors.black87,
                            height: 1.65,
                          ),
                        ),

                        const Divider(height: 30, color: Color(0xFF000000)),

                        // ── Guest Favorite ───────────────────────────────
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.string(
                                '''<svg width="12" height="22" viewBox="0 0 12 22" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M2.99593 5.36059C2.78293 7.00259 4.09993 8.52659 4.09993 8.52659C4.09993 8.52659 5.76293 7.38859 5.97593 5.74659C6.18893 4.10359 4.87193 2.57959 4.87193 2.57959C4.87193 2.57959 3.20993 3.71959 2.99593 5.36059ZM1.43293 10.8796C2.12893 12.3826 4.05693 12.9726 4.05693 12.9726C4.05693 12.9726 4.85693 11.1256 4.16093 9.62259C3.46493 8.11959 1.53693 7.52859 1.53693 7.52859C1.53693 7.52859 0.736933 9.37659 1.43293 10.8796Z" stroke="black" stroke-width="1.5" stroke-linejoin="round"/>
<path d="M5.56 16.764C5.56 16.764 3.582 17.158 2.254 16.165C0.926 15.172 0.75 13.167 0.75 13.167C0.75 13.167 2.728 12.773 4.056 13.766C5.384 14.759 5.56 16.764 5.56 16.764ZM5.56 16.764H8.758C9.28658 16.764 9.7935 16.9739 10.1673 17.3477C10.541 17.7215 10.751 18.2284 10.751 18.757C10.751 19.2855 10.541 19.7925 10.1673 20.1662C9.7935 20.54 9.28658 20.75 8.758 20.75H6.75" stroke="black" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M7.53093 1.71775C6.32093 2.85075 6.36693 4.86175 6.36693 4.86175C6.36693 4.86175 8.37693 5.03775 9.58693 3.90475C10.7969 2.77175 10.7509 0.759747 10.7509 0.759747C10.7509 0.759747 8.74093 0.584747 7.53093 1.71775Z" stroke="black" stroke-width="1.5" stroke-linejoin="round"/>
</svg>
''',
                                width: 25,
                                height: 25,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Guest Favorite',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 8),
                              SvgPicture.string(
                                '''<svg width="12" height="22" viewBox="0 0 12 22" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M8.50625 5.36059C8.71925 7.00259 7.40225 8.52659 7.40225 8.52659C7.40225 8.52659 5.73924 7.38859 5.52524 5.74659C5.31224 4.10259 6.63025 2.57959 6.63025 2.57959C6.63025 2.57959 8.29225 3.71859 8.50625 5.36059ZM10.0672 10.8796C9.37124 12.3826 7.44324 12.9726 7.44324 12.9726C7.44324 12.9726 6.64324 11.1256 7.33924 9.62259C8.03524 8.11959 9.96425 7.52859 9.96425 7.52859C9.96425 7.52859 10.7642 9.37659 10.0672 10.8796Z" stroke="black" stroke-width="1.5" stroke-linejoin="round"/>
<path d="M5.94124 16.764C5.94124 16.764 7.91924 17.158 9.24724 16.165C10.5752 15.172 10.7512 13.167 10.7512 13.167C10.7512 13.167 8.77324 12.773 7.44524 13.766C6.11724 14.759 5.94124 16.764 5.94124 16.764ZM5.94124 16.764H2.74324C2.48152 16.764 2.22236 16.8155 1.98056 16.9157C1.73875 17.0158 1.51905 17.1626 1.33398 17.3477C1.14891 17.5328 1.00211 17.7525 0.901952 17.9943C0.801794 18.2361 0.750244 18.4952 0.750244 18.757C0.750244 19.0187 0.801794 19.2779 0.901952 19.5197C1.00211 19.7615 1.14891 19.9812 1.33398 20.1662C1.51905 20.3513 1.73875 20.4981 1.98056 20.5983C2.22236 20.6984 2.48152 20.75 2.74324 20.75H4.75024" stroke="black" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M3.97023 1.71775C5.18023 2.85075 5.13423 4.86175 5.13423 4.86175C5.13423 4.86175 3.12423 5.03775 1.91423 3.90475C0.704229 2.77175 0.75023 0.759747 0.75023 0.759747C0.75023 0.759747 2.76023 0.584747 3.97023 1.71775Z" stroke="black" stroke-width="1.5" stroke-linejoin="round"/>
</svg>
''',
                                width: 25,
                                height: 25,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ── Features list ────────────────────────────────
                        ...widget.destination.features.map(
                          (f) => _FeatureRow(text: f),
                        ),

                        const Divider(height: 30, color: Color(0xFF000000)),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // ── Bottom bar overlay ────────────────────────────────────────────────
      bottomNavigationBar: _BottomBar(
        destination: widget.destination,
        formattedPrice: _formattedPrice,
        formattedOriginalPrice: _formattedOriginalPrice,
        onAddToCart: () async {
          try {
            final provider = context.read<CartProvider>();
            final ticket = CartTicket.accommodation(
              locationName: widget.destination.title,
              price: widget.destination.price.toInt(),
              imageUrl: widget.destination.imageUrl,
              stayDate: DateTime.now().toIso8601String().split('T')[0],
              stayDuration: 1,
            );

            await provider.addTicket(ticket);

            if (!context.mounted) return;
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
          } catch (e) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Failed to add to cart. Please try again.',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HERO IMAGE
// ─────────────────────────────────────────────────────────────────────────────

class _HeroImage extends StatelessWidget {
  final DestinationModel destination;
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
      child: Icon(
        Icons.image_outlined,
        color: Colors.blueGrey.shade400,
        size: 48,
      ),
    );

    return Stack(
      children: [
        SizedBox(
          height: 260,
          width: double.infinity,
          child: destination.imageUrl.isNotEmpty
              ? Image.network(
                  destination.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => fallback,
                )
              : fallback,
        ),
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
          const Icon(Icons.circle, size: 8, color: Colors.black54),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BOTTOM BAR  — fixed overlay matching Figma spec
// ─────────────────────────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  final DestinationModel destination;
  final String formattedPrice;
  final String formattedOriginalPrice;
  final VoidCallback onAddToCart;

  const _BottomBar({
    required this.destination,
    required this.formattedPrice,
    required this.formattedOriginalPrice,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 10,
        bottom: MediaQuery.of(context).padding.bottom + 40,
      ),
      child: Container(
        height: 59,
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
            ),
          ],
        ),
        child: Row(
          children: [
            // ── Price ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(left: 18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        formattedPrice,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w300,
                          fontSize: 20,
                          height: 1,
                          color: Colors.black,
                        ),
                      ),
                      if (destination.hasDiscount) ...[
                        const SizedBox(width: 8),
                        Text(
                          formattedOriginalPrice,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w300,
                            fontSize: 12,
                            height: 1,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
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
            ),

            const Spacer(),

            // ── Add to Cart ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: onAddToCart,
                child: Container(
                  width: 103,
                  height: 29,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF2B99E3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x26000000),
                        blurRadius: 20,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Add to Cart',
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
            ),
          ],
        ),
      ),
    );
  }
}
