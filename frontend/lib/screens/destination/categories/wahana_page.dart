import 'package:flutter/material.dart';
import '../widgets/category_page_base.dart';

class WahanaPage extends StatelessWidget {
  const WahanaPage({super.key});

  static const List<CategoryDestination> _destinations = [
    CategoryDestination(
      id: 'w1',
      name: 'Dufan Ancol Jakarta',
      imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
    ),
    CategoryDestination(
      id: 'w2',
      name: 'Trans Studio Bandung',
      imageUrl: 'https://images.unsplash.com/photo-1513889961551-628c1e5e2ee9?w=800',
    ),
    CategoryDestination(
      id: 'w3',
      name: 'Jatim Park Malang',
      imageUrl: 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=800',
    ),
    CategoryDestination(
      id: 'w4',
      name: 'Waterbom Bali',
      imageUrl: 'https://images.unsplash.com/photo-1560541919-eb5c2da6a5a3?w=800',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return const CategoryPageBase(
      title: 'Wahana',
      destinations: _destinations,
    );
  }
}