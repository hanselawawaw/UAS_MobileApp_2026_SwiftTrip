import 'package:flutter/material.dart';
import '../widgets/category_page_base.dart';

class PulauPage extends StatelessWidget {
  const PulauPage({super.key});

  static const List<CategoryDestination> _destinations = [
    CategoryDestination(
      id: 'p1',
      name: 'Pulau Komodo',
      imageUrl: 'https://images.unsplash.com/photo-1537996194471-e657df975ab4?w=800',
    ),
    CategoryDestination(
      id: 'p2',
      name: 'Pulau Raja Ampat',
      imageUrl: 'https://images.unsplash.com/photo-1518548419970-58e3b4079ab2?w=800',
    ),
    CategoryDestination(
      id: 'p3',
      name: 'Pulau Lombok',
      imageUrl: 'https://images.unsplash.com/photo-1555400038-63f5ba517a47?w=800',
    ),
    CategoryDestination(
      id: 'p4',
      name: 'Pulau Bunaken',
      imageUrl: 'https://images.unsplash.com/photo-1500964757637-c85e8a162699?w=800',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return const CategoryPageBase(
      title: 'Pulau',
      destinations: _destinations,
    );
  }
}