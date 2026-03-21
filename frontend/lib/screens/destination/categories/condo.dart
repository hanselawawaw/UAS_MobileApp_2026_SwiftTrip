import 'package:flutter/material.dart';
import '../category_page_base.dart';

class CondoPage extends StatelessWidget {
  const CondoPage({super.key});

  static const List<CategoryDestination> _destinations = [
    CategoryDestination(
      id: 'c1',
      name: 'The Mansion Kemayoran',
      imageUrl:
          'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800',
    ),
    CategoryDestination(
      id: 'c2',
      name: 'Gateway Pasteur Bandung',
      imageUrl:
          'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800',
    ),
    CategoryDestination(
      id: 'c3',
      name: 'Beverly Dago Apartment',
      imageUrl:
          'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800',
    ),
    CategoryDestination(
      id: 'c4',
      name: 'Tamansari Semanggi Apartment',
      imageUrl:
          'https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=800',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return const CategoryPageBase(title: 'Wahana', destinations: _destinations);
  }
}
