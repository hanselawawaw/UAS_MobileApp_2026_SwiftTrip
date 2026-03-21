import 'package:flutter/material.dart';
import '../category_page_base.dart';
import '../detail_page.dart';

class CondoPage extends StatefulWidget {
  const CondoPage({super.key});

  @override
  State<CondoPage> createState() => _CondoPageState();
}

class _CondoPageState extends State<CondoPage> {
  bool _isLoading = true;
  List<CategoryItem> _items = [];

  @override
  void initState() {
    super.initState();
    _fetchCondos();
  }

  Future<void> _fetchCondos() async {
    // TODO: Replace with real API call: GET /destinations?category=condo
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() {
      _items = [
        const CategoryItem(
          id: 'c1',
          name: 'Pakubuwono Residence',
          imageUrl:
              'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=500',
          rating: 4.8,
          description:
              'Luxury condominium in South Jakarta with premium facilities.',
          hasDiscount: true,
          isFavorite: true,
        ),
        const CategoryItem(
          id: 'c2',
          name: 'Kempinski Private Residences Jakarta',
          imageUrl:
              'https://images.unsplash.com/photo-1484154218962-a197022b5858?w=500',
          rating: 4.9,
          description:
              'High-end condo residences connected to Grand Indonesia.',
        ),
        const CategoryItem(
          id: 'c3',
          name: 'District 8 Apartment Jakarta',
          imageUrl:
              'https://images.unsplash.com/photo-1493246507139-91e8bef99c02?w=500',
          rating: 4.7,
          description: 'Modern luxury condo in SCBD with city skyline views.',
          isFavorite: true,
        ),
        const CategoryItem(
          id: 'c4',
          name: 'Taman Anggrek Residence',
          imageUrl:
              'https://images.unsplash.com/photo-1460317442991-0ec209397118?w=500',
          rating: 4.6,
          description: 'Popular condominium complex in West Jakarta.',
        ),
        const CategoryItem(
          id: 'c5',
          name: 'The Peak at Sudirman',
          imageUrl:
              'https://images.unsplash.com/photo-1536376074432-8d642fed43f7?w=500',
          rating: 4.7,
          description:
              'Premium high-rise condo near Sudirman business district.',
          hasDiscount: true,
        ),
        const CategoryItem(
          id: 'c6',
          name: 'The Via & The Vue Apartment Bandung',
          imageUrl:
              'https://images.unsplash.com/photo-1551882547-ff43c636a0fb?w=500',
          rating: 4.6,
          description: 'Modern condominium living in central Bandung.',
        ),
        const CategoryItem(
          id: 'c7',
          name: 'Bintaro Plaza Residences',
          imageUrl:
              'https://images.unsplash.com/photo-1584132967334-10e028bd69f7?w=500',
          rating: 4.5,
          description: 'Comfortable condo residences in South Tangerang.',
        ),
        const CategoryItem(
          id: 'c8',
          name: 'Bali Beach Tower Residences',
          imageUrl:
              'https://images.unsplash.com/photo-1590073242678-70ee3fc28e8e?w=500',
          rating: 4.6,
          description: 'Condominium-style residences near Sanur beach.',
        ),
        const CategoryItem(
          id: 'c9',
          name: 'Meikarta Apartment Towers',
          imageUrl:
              'https://images.unsplash.com/photo-1499793983690-e29da59ef1c2?w=500',
          rating: 4.4,
          description:
              'High-rise condo complex in Cikarang with modern amenities.',
        ),
        const CategoryItem(
          id: 'c10',
          name: 'Gold Coast PIK Apartments',
          imageUrl:
              'https://images.unsplash.com/photo-1576013551627-0cc20b96c2a7?w=500',
          rating: 4.6,
          description: 'Waterfront condominium in Pantai Indah Kapuk.',
          isFavorite: true,
        ),
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CategoryPageBase(
      title: 'Popular Condos',
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
