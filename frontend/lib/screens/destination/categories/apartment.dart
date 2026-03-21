import 'package:flutter/material.dart';
import '../category_page_base.dart';
import '../detail_page.dart';

class ApartmentPage extends StatefulWidget {
  const ApartmentPage({super.key});

  @override
  State<ApartmentPage> createState() => _ApartmentPageState();
}

class _ApartmentPageState extends State<ApartmentPage> {
  bool _isLoading = true;
  List<CategoryItem> _items = [];

  @override
  void initState() {
    super.initState();
    _fetchApartments();
  }

  Future<void> _fetchApartments() async {
    // TODO: Replace with real API call: GET /destinations?category=apartment
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() {
      _items = [
        const CategoryItem(
          id: 'a1',
          name: 'Kalibata City Apartment',
          imageUrl:
              'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=500',
          rating: 4.5,
          description:
              'Affordable apartment in South Jakarta with full facilities.',
          hasDiscount: true,
        ),
        const CategoryItem(
          id: 'a2',
          name: 'Bassura City Apartment',
          imageUrl:
              'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=500',
          rating: 4.6,
          description: 'Integrated apartment with mall access in East Jakarta.',
          isFavorite: true,
        ),
        const CategoryItem(
          id: 'a3',
          name: 'Green Pramuka City Apartment',
          imageUrl:
              'https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=500',
          rating: 4.4,
          description: 'Mid-range apartment with green open spaces.',
        ),
        const CategoryItem(
          id: 'a4',
          name: 'Gateway Pasteur Apartment Bandung',
          imageUrl:
              'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd?w=500',
          rating: 4.5,
          description: 'Strategic apartment near Pasteur toll access.',
          hasDiscount: true,
        ),
        const CategoryItem(
          id: 'a5',
          name: 'Margonda Residence Depok',
          imageUrl:
              'https://images.unsplash.com/photo-1505691938895-1758d7eaa511?w=500',
          rating: 4.6,
          description: 'Popular student-friendly apartment near UI campus.',
          isFavorite: true,
        ),
        const CategoryItem(
          id: 'a6',
          name: 'Puri Park View Apartment',
          imageUrl:
              'https://images.unsplash.com/photo-1551882547-ff43c636a0fb?w=500',
          rating: 4.4,
          description:
              'Comfortable apartment in West Jakarta residential area.',
        ),
        const CategoryItem(
          id: 'a7',
          name: 'Tamansari Sudirman Apartment',
          imageUrl:
              'https://images.unsplash.com/photo-1584132967334-10e028bd69f7?w=500',
          rating: 4.6,
          description: 'City apartment close to Jakarta business district.',
        ),
        const CategoryItem(
          id: 'a8',
          name: 'The Jarrdin Apartment Cihampelas',
          imageUrl:
              'https://images.unsplash.com/photo-1590073242678-70ee3fc28e8e?w=500',
          rating: 4.5,
          description: 'Apartment near shopping and tourism area in Bandung.',
        ),
        const CategoryItem(
          id: 'a9',
          name: 'Vida View Apartment Makassar',
          imageUrl:
              'https://images.unsplash.com/photo-1499793983690-e29da59ef1c2?w=500',
          rating: 4.5,
          description: 'Modern apartment with city and sea views.',
        ),
        const CategoryItem(
          id: 'a10',
          name: 'Begawan Apartment Malang',
          imageUrl:
              'https://images.unsplash.com/photo-1576013551627-0cc20b96c2a7?w=500',
          rating: 4.4,
          description: 'Cozy apartment in a quiet residential area.',
        ),
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CategoryPageBase(
      title: 'Popular Apartments',
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
