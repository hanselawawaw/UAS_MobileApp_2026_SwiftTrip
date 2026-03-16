import 'package:flutter/material.dart';
import '../widgets/category_page_base.dart';

class HotelPage extends StatelessWidget {
  const HotelPage({super.key});

  static const List<CategoryDestination> _destinations = [
    CategoryDestination(
      id: 'h1',
      name: 'Hotel Santika Bandung',
      imageUrl: 'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=800',
    ),
    CategoryDestination(
      id: 'h2',
      name: 'Hotel Mulia Jakarta',
      imageUrl: 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=800',
    ),
    CategoryDestination(
      id: 'h3',
      name: 'Hotel Kempinski Surabaya',
      imageUrl: 'https://images.unsplash.com/photo-1564501049412-61c2a3083791?w=800',
    ),
    CategoryDestination(
      id: 'h4',
      name: 'Hotel Raffles Jakarta',
      imageUrl: 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=800',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return const CategoryPageBase(
      title: 'Hotel',
      destinations: _destinations,
    );
  }
}