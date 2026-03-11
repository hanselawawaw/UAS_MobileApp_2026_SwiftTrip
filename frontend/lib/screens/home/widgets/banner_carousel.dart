import 'package:flutter/material.dart';
import 'page_dots.dart';

class BannerCarousel extends StatelessWidget {
  final List<String> images;
  final PageController controller;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;

  const BannerCarousel({
    super.key,
    required this.images,
    required this.controller,
    required this.currentIndex,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: controller,
            onPageChanged: onPageChanged,
            itemCount: images.length,
            itemBuilder: (_, i) {
              return Image.asset(
                images[i],
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (_, _, _) => Container(
                  color: Colors.blueGrey.shade200,
                  child: const Icon(Icons.image, size: 48, color: Colors.white),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        PageDots(count: images.length, current: currentIndex),
      ],
    );
  }
}
