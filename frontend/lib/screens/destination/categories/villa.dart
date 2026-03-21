import 'package:flutter/material.dart';
import '../category_page_base.dart';
import '../detail_page.dart';

class VillaPage extends StatefulWidget {
  const VillaPage({super.key});

  @override
  State<VillaPage> createState() => _VillaPageState();
}

class _VillaPageState extends State<VillaPage> {
  bool _isLoading = true;
  List<CategoryItem> _items = [];

  @override
  void initState() {
    super.initState();
    _fetchVillas();
  }

  Future<void> _fetchVillas() async {
    // TODO: Replace with real API call: GET /destinations?category=villa
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() {
      _items = [
        const CategoryItem(
          id: 'v1',
          name: 'Alila Villas Uluwatu',
          imageUrl:
              'https://images.unsplash.com/photo-1543489816-c87b0f7f287a?w=500',
          rating: 4.9,
          description: 'Modern villas with private pools and ocean views.',
          hasDiscount: true,
          isFavorite: true,
        ),
        const CategoryItem(
          id: 'v2',
          name: 'Mandapa Villas Ubud',
          imageUrl:
              'https://images.unsplash.com/photo-1537996194471-e657df975ab4?w=500',
          rating: 4.8,
          description: 'Private luxury villas surrounded by jungle and river.',
        ),
        const CategoryItem(
          id: 'v3',
          name: 'Villa Melissa Canggu',
          imageUrl:
              'https://images.unsplash.com/photo-1499793983690-e29da59ef1c2?w=500',
          rating: 4.9,
          description: 'Beachfront luxury villa with private pool.',
          hasDiscount: true,
        ),
        const CategoryItem(
          id: 'v4',
          name: 'The Kayon Private Villas',
          imageUrl:
              'https://images.unsplash.com/photo-1590073242678-70ee3fc28e8e?w=500',
          rating: 4.8,
          description: 'Exclusive jungle villas with infinity pools.',
          isFavorite: true,
        ),
        const CategoryItem(
          id: 'v5',
          name: 'Bvlgari Villas Bali',
          imageUrl:
              'https://images.unsplash.com/photo-1540518614846-7eded433c457?w=500',
          rating: 4.9,
          description: 'Ultra-luxury cliffside villas with private pools.',
        ),
        const CategoryItem(
          id: 'v6',
          name: 'Viceroy Bali',
          imageUrl:
              'https://images.unsplash.com/photo-1584132967334-10e028bd69f7?w=500',
          rating: 4.8,
          description: 'Private pool villas with valley views.',
          hasDiscount: true,
        ),
        const CategoryItem(
          id: 'v7',
          name: 'Amankila Villas',
          imageUrl:
              'https://images.unsplash.com/photo-1576013551627-0cc20b96c2a7?w=500',
          rating: 4.9,
          description: 'Luxury private villas with ocean views.',
        ),
        const CategoryItem(
          id: 'v8',
          name: 'Sebali Private Villas Ubud',
          imageUrl:
              'https://images.unsplash.com/photo-1551882547-ff43c636a0fb?w=500',
          rating: 4.7,
          description: 'Secluded villas surrounded by rice fields.',
          isFavorite: true,
        ),
        const CategoryItem(
          id: 'v9',
          name: 'The Royal Santrian',
          imageUrl:
              'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=500',
          rating: 4.7,
          description: 'Beach villas with private pools and spa.',
        ),
        const CategoryItem(
          id: 'v10',
          name: 'Kamandalu Private Villas',
          imageUrl:
              'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=500',
          rating: 4.8,
          description: 'Private villas with traditional Balinese design.',
          hasDiscount: true,
        ),
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CategoryPageBase(
      title: 'Popular Villas',
      items: _items,
      isLoading: _isLoading,
      onItemTap: (item) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DestinationDetailPage(destination: item),
          ),
        );
      },
    );
  }
}
