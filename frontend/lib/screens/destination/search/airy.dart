import 'package:flutter/material.dart';
import '../category_page_base.dart';
import '../detail_page.dart';

class AirySearchPage extends StatefulWidget {
  const AirySearchPage({super.key});

  @override
  State<AirySearchPage> createState() => _AirySearchPageState();
}

class _AirySearchPageState extends State<AirySearchPage> {
  bool _isLoading = true;
  List<CategoryItem> _items = [];

  @override
  void initState() {
    super.initState();
    _fetchAiryPlaces();
  }

  Future<void> _fetchAiryPlaces() async {
    // TODO: Replace with real API call: GET /destinations?vibe=airy
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() {
      _items = [
        const CategoryItem(
          id: 'ai-1',
          name: 'The Oberoi Beach Resort',
          imageUrl:
              'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=500',
          rating: 4.9,
          description: 'Breezy open pavilions by the Lombok shoreline.',
          hasDiscount: true,
          isFavorite: true,
        ),
        const CategoryItem(
          id: 'ai-2',
          name: 'Como Shambhala Estate',
          imageUrl:
              'https://images.unsplash.com/photo-1540518614846-7eded433c457?w=500',
          rating: 4.9,
          description:
              'Spacious retreats designed for ultimate air circulation.',
        ),
        const CategoryItem(
          id: 'ai-3',
          name: 'Ayana Segara Bali',
          imageUrl:
              'https://images.unsplash.com/photo-1576013551627-0cc20b96c2a7?w=500',
          rating: 4.8,
          description: 'Modern beach living with wide-open ocean terraces.',
          isFavorite: true,
        ),
        const CategoryItem(
          id: 'ai-4',
          name: 'Mentawai Surf Villas',
          imageUrl:
              'https://images.unsplash.com/photo-1499793983690-e29da59ef1c2?w=500',
          rating: 4.7,
          description: 'Light-filled island escapes for the modern surfer.',
        ),
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CategoryPageBase(
      title: 'Airy Spots',
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
