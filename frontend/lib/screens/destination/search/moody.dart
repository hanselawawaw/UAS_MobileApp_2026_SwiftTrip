import 'package:flutter/material.dart';
import '../category_page_base.dart';
import '../detail_page.dart';

class MoodySearchPage extends StatefulWidget {
  const MoodySearchPage({super.key});

  @override
  State<MoodySearchPage> createState() => _MoodySearchPageState();
}

class _MoodySearchPageState extends State<MoodySearchPage> {
  bool _isLoading = true;
  List<CategoryItem> _items = [];

  @override
  void initState() {
    super.initState();
    _fetchMoodyPlaces();
  }

  Future<void> _fetchMoodyPlaces() async {
    // TODO: Replace with real API call: GET /destinations?vibe=moody
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() {
      _items = [
        const CategoryItem(
          id: 'mo-1',
          name: 'Jiwa Jawa Resort Ijen',
          imageUrl:
              'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=500',
          rating: 4.7,
          description: 'Foggy mornings and industrial chic near the volcano.',
          hasDiscount: true,
        ),
        const CategoryItem(
          id: 'mo-2',
          name: 'The Kayon Jungle Resort',
          imageUrl:
              'https://images.unsplash.com/photo-1590073242678-70ee3fc28e8e?w=500',
          rating: 4.8,
          description: 'Deep green pools and rainforest shadows in Ubud.',
          isFavorite: true,
        ),
        const CategoryItem(
          id: 'mo-3',
          name: 'Hard Rock Hotel Bali',
          imageUrl:
              'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=500',
          rating: 4.5,
          description: 'Edgy evening vibes and rock-and-roll luxury.',
        ),
        const CategoryItem(
          id: 'mo-4',
          name: 'Plataran Canggu',
          imageUrl:
              'https://images.unsplash.com/photo-1536376074432-8d642fed43f7?w=500',
          rating: 4.6,
          description: 'Mystical jungle enclaves with vintage character.',
          isFavorite: true,
        ),
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CategoryPageBase(
      title: 'Moody Spots',
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
