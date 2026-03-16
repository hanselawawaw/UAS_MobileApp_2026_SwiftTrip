import 'package:flutter/material.dart';
import '../widgets/category_page_base.dart';

class VilaPage extends StatelessWidget {
  const VilaPage({super.key});

  static const List<CategoryDestination> _destinations = [
    CategoryDestination(
      id: 'v1',
      name: 'Vila Santika Bandung',
      imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=800',
    ),
    CategoryDestination(
      id: 'v2',
      name: 'Vila Ubud Bali',
      imageUrl: 'https://images.unsplash.com/photo-1552733407-5d5c46c3bb3b?w=800',
    ),
    CategoryDestination(
      id: 'v3',
      name: 'Vila Puncak Bogor',
      imageUrl: 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800',
    ),
    CategoryDestination(
      id: 'v4',
      name: 'Vila Seminyak Bali',
      imageUrl: 'https://images.unsplash.com/photo-1540541338287-41700207dee6?w=800',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return const CategoryPageBase(
      title: 'Vila',
      destinations: _destinations,
    );
  }
} 