import 'package:flutter/material.dart';
import '../category_page_base.dart';

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
          id: '1',
          name: 'Alila Villas Uluwatu',
          imageUrl:
              'https://images.unsplash.com/photo-1543489816-c87b0f7f287a?w=500',
          rating: 4.9,
          description: 'Modern villas with private pools and ocean views.',
          hasDiscount: true,
          isFavorite: true,
        ),
        const CategoryItem(
          id: '2',
          name: 'Mandapa, Ritz-Carlton',
          imageUrl:
              'https://images.unsplash.com/photo-1537996194471-e657df975ab4?w=500',
          rating: 4.8,
          description: 'Luxury jungle retreat by the river.',
        ),
        const CategoryItem(
          id: '3',
          name: 'Nihi Sumba',
          imageUrl:
              'https://images.unsplash.com/photo-1499793983690-e29da59ef1c2?w=500',
          rating: 5.0,
          description: 'Top-rated resort with unique villas and surfing.',
          hasDiscount: true,
        ),
        const CategoryItem(
          id: '4',
          name: 'The Kayon Jungle Resort',
          imageUrl:
              'https://images.unsplash.com/photo-1590073242678-70ee3fc28e8e?w=500',
          rating: 4.7,
          description: 'Peaceful jungle retreat for relaxation.',
          isFavorite: true,
        ),
        const CategoryItem(
          id: '5',
          name: 'Bulgari Resort Bali',
          imageUrl:
              'https://images.unsplash.com/photo-1540518614846-7eded433c457?w=500',
          rating: 4.9,
          description: 'Luxury resort blending Balinese and Italian design.',
        ),
        const CategoryItem(
          id: '6',
          name: 'Viceroy Bali',
          imageUrl:
              'https://images.unsplash.com/photo-1584132967334-10e028bd69f7?w=500',
          rating: 4.8,
          description: 'Private pool villas with valley views.',
          hasDiscount: true,
        ),
        const CategoryItem(
          id: '7',
          name: 'Amankila',
          imageUrl:
              'https://images.unsplash.com/photo-1576013551627-0cc20b96c2a7?w=500',
          rating: 4.9,
          description: 'Cliffside resort with iconic infinity pool.',
        ),
        const CategoryItem(
          id: '8',
          name: 'Puri Sebali Resort',
          imageUrl:
              'https://images.unsplash.com/photo-1551882547-ff43c636a0fb?w=500',
          rating: 4.6,
          description: 'Romantic villas in rice field surroundings.',
          isFavorite: true,
        ),
        const CategoryItem(
          id: '9',
          name: 'The Royal Santrian',
          imageUrl:
              'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=500',
          rating: 4.7,
          description: 'Beach villas with private pools and spa.',
        ),
        const CategoryItem(
          id: '10',
          name: 'Kamandalu Ubud',
          imageUrl:
              'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=500',
          rating: 4.8,
          description: 'Village-style resort with modern comfort.',
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
        // TODO: Navigate to villa detail page: Navigator.of(context).push(...)
        // Print the ID to verify link to backend data
        debugPrint('Tapped on villa: ${item.name} (ID: ${item.id})');
        // TODO: Pass item.id to fetch full villa details from backend
      },
    );
  }
}
