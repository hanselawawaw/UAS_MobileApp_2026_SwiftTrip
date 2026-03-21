import 'package:flutter/material.dart';
import '../category_page_base.dart';
import '../detail_page.dart';

class CozySearchPage extends StatefulWidget {
  const CozySearchPage({super.key});

  @override
  State<CozySearchPage> createState() => _CozySearchPageState();
}

class _CozySearchPageState extends State<CozySearchPage> {
  bool _isLoading = true;
  List<CategoryItem> _items = [];

  @override
  void initState() {
    super.initState();
    _fetchCozyPlaces();
  }

  Future<void> _fetchCozyPlaces() async {
    // TODO: Replace with real API call: GET /destinations?vibe=cozy
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() {
      _items = [
        const CategoryItem(
          id: 'co-1',
          name: 'The Lodge Maribaya',
          imageUrl:
              'https://images.unsplash.com/photo-1449156001131-75994e37722d?w=500',
          rating: 4.6,
          description: 'Warm pine forests and cozy mountain stays in Lembang.',
          isFavorite: true,
        ),
        const CategoryItem(
          id: 'co-2',
          name: 'Bambu Indah Ubud',
          imageUrl:
              'https://images.unsplash.com/photo-1544644061-2403dc37720c?w=500',
          rating: 4.8,
          description: 'Sustainable luxury with a cozy, rustic Balinese heart.',
          hasDiscount: true,
        ),
        const CategoryItem(
          id: 'co-3',
          name: 'Pigeonhole Coffee Suites',
          imageUrl:
              'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=500',
          rating: 4.5,
          description: 'Cozy urban retreats with the perfect morning coffee.',
        ),
        const CategoryItem(
          id: 'co-4',
          name: 'MesaStila Resort',
          imageUrl:
              'https://images.unsplash.com/photo-1571896349842-3378fb4f5aae?w=500',
          rating: 4.7,
          description: 'Historic coffee plantation stay in Central Java.',
          isFavorite: true,
        ),
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CategoryPageBase(
      title: 'Cozy Spots',
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
