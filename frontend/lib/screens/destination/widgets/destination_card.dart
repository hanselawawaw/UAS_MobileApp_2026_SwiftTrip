import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swifttrip_frontend/repositories/auth_repository.dart';
import 'package:swifttrip_frontend/screens/auth/login.dart';
import 'package:swifttrip_frontend/providers/wishlist_provider.dart';
import '../detail_page.dart';
import '../models/destination_model.dart';

class DestinationCard extends StatelessWidget {
  final DestinationModel destination;

  const DestinationCard({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DestinationDetailPage(destination: destination),
          ),
        );
      },
      child: Container(
        width: 180,
        height: 135,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    destination.imageUrl,
                    height: 90,
                    width: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 90,
                      width: 180,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image, color: Colors.grey),
                    ),
                  ),
                ),
                if (destination.hasDiscount)
                  const Positioned(
                    top: 8,
                    left: 8,
                    child: Icon(
                      Icons.discount_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Consumer<WishlistProvider>(
                    builder: (context, provider, child) {
                      final isFavorite = provider.isFavorite(destination.id);
                      return GestureDetector(
                        onTap: () async {
                          final token = await AuthRepository().getToken();
                          if (token == null) {
                            if (!context.mounted) return;
                            showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                                          MaterialPageRoute(builder: (context) => const LoginPage()),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF2B99E3),
                                        minimumSize: const Size(double.infinity, 45),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: const Text(
                                        'Log In',
                                        style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                            return;
                          }

                          await provider.toggleWishlist(destination.id);
                        },
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.white,
                          size: 20,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    destination.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      destination.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Icon(Icons.star, size: 12, color: Colors.black),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
