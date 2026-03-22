import 'package:flutter/material.dart';
import '../destination/category_page_base.dart';
import '../destination/detail_page.dart';

// TODO: Integrate with backend API to fetch real wishlist data for the logged-in user.
// TODO: Implement toggle favorite functionality that syncs with the database.

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  // Mock data using CategoryItem model from reusable widgets
  final List<CategoryItem> _items = [
    const CategoryItem(
      id: 'item_1',
      name: 'The Edge Bali Villa - Uluwatu',
      rating: 4.9,
      description:
          'Luxury cliffside villa with private pool and panoramic Indian Ocean views.',
      imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e',
      isFavorite: true,
    ),
    const CategoryItem(
      id: 'item_2',
      name: 'Plataran Komodo Resort - Labuan Bajo',
      rating: 4.8,
      description: 'Beachfront resort near Komodo with clear turquoise waters.',
      imageUrl: 'https://images.unsplash.com/photo-1518548419970-58e3b4079ab2',
      isFavorite: true,
    ),
    const CategoryItem(
      id: 'item_3',
      name: 'Padma Hotel Bandung - Ciumbuleuit',
      rating: 4.8,
      description:
          'Mountain-view hotel with cool climate, infinity pool, and forest atmosphere.',
      imageUrl: 'https://images.unsplash.com/photo-1501785888041-af3ef285b470',
      isFavorite: true,
    ),
    const CategoryItem(
      id: 'item_4',
      name: 'Ayana Resort - Jimbaran Bali',
      rating: 4.9,
      description:
          'Famous luxury resort with Rock Bar and stunning sunset ocean views.',
      imageUrl: 'https://images.unsplash.com/photo-1505739771715-9c3fcd5f1b38',
      isFavorite: true,
    ),
    const CategoryItem(
      id: 'item_5',
      name: 'The Ritz-Carlton Jakarta - Mega Kuningan',
      rating: 4.7,
      description:
          'High-end city hotel with premium service in the heart of Jakarta business district.',
      imageUrl: 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee',
      isFavorite: true,
    ),
  ];

  void _navigateToDetail(CategoryItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DestinationDetailPage(destination: item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Reusable CategoryPageBase provides standardized layout (TopBar, Title, Divider, List)
    return CategoryPageBase(
      title: 'Wishlist',
      items: _items,
      onItemTap: _navigateToDetail,
    );
  }
}
