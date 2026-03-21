import 'package:flutter/material.dart';
import '../category_page_base.dart';

class ApartPage extends StatelessWidget {
  const ApartPage({super.key});

  static const List<CategoryDestination> _destinations = [
    CategoryDestination(
      id: 'a1',
      name: 'Sky Garden Apartment Jakarta',
      imageUrl:
          'https://images.unsplash.com/photo-1507089947368-19c1da9775ae?w=800',
    ),
    CategoryDestination(
      id: 'a2',
      name: 'Parahyangan Residence Bandung',
      imageUrl:
          'https://images.unsplash.com/photo-1494526585095-c41746248156?w=800',
    ),
    CategoryDestination(
      id: 'a3',
      name: 'Puncak Permai Apartment Surabaya',
      imageUrl:
          'https://images.unsplash.com/photo-1484154218962-a197022b5858?w=800',
    ),
    CategoryDestination(
      id: 'a4',
      name: 'Tamansari La Grande Bandung',
      imageUrl:
          'https://images.unsplash.com/photo-1523217582562-09d0def993a6?w=800',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return const CategoryPageBase(title: 'Pulau', destinations: _destinations);
  }
}
