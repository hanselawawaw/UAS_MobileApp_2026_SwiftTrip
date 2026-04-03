import 'package:flutter/material.dart';
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
      child: SizedBox(
        width: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    destination.imageUrl,
                    height: 90,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 90,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image, color: Colors.grey),
                    ),
                  ),
                ),
                if (destination.hasDiscount ||
                    destination.discountPercentage > 0)
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
                  child: ValueListenableBuilder<bool>(
                    valueListenable: destination.isFavoriteNotifier,
                    builder: (context, isFavorite, child) {
                      return GestureDetector(
                        onTap: () {
                          destination.isFavorite = !isFavorite;
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
                      destination.rating.toStringAsFixed(0),
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
