import 'package:flutter/material.dart';
import '../category_page_base.dart';
import '../detail_page.dart';

class HotelPage extends StatefulWidget {
  const HotelPage({super.key});

  @override
  State<HotelPage> createState() => _HotelPageState();
}

class _HotelPageState extends State<HotelPage> {
  bool _isLoading = true;
  List<CategoryItem> _items = [];

  @override
  void initState() {
    super.initState();
    _fetchHotels();
  }

  Future<void> _fetchHotels() async {
    // TODO: Replace with real API call: GET /destinations?category=hotel
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() {
      _items = [
        const CategoryItem(
          id: 'h1',
          name: 'The Mulia Bali',
          imageUrl:
              'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=500',
          rating: 4.9,
          description:
              'Luxury beachfront hotel in Nusa Dua with world-class facilities.',
          hasDiscount: true,
          isFavorite: true,
        ),
        const CategoryItem(
          id: 'h2',
          name: 'Hotel Indonesia Kempinski Jakarta',
          imageUrl:
              'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=500',
          rating: 4.8,
          description: 'Iconic 5-star hotel in central Jakarta.',
        ),
        const CategoryItem(
          id: 'h3',
          name: 'The St. Regis Bali Resort',
          imageUrl:
              'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=500',
          rating: 4.9,
          description: 'Ultra-luxury beachfront resort with premium service.',
          hasDiscount: true,
        ),
        const CategoryItem(
          id: 'h4',
          name: 'Padma Hotel Bandung',
          imageUrl:
              'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=500',
          rating: 4.8,
          description: 'Nature-surrounded hotel with mountain views.',
          isFavorite: true,
        ),
        const CategoryItem(
          id: 'h5',
          name: 'Ayana Resort and Spa Bali',
          imageUrl:
              'https://images.unsplash.com/photo-1535827841776-24afc1e255ac?w=500',
          rating: 4.9,
          description: 'Cliffside luxury resort famous for Rock Bar.',
        ),
        const CategoryItem(
          id: 'h6',
          name: 'Raffles Jakarta',
          imageUrl:
              'https://images.unsplash.com/photo-1551882547-ff43c636a0fb?w=500',
          rating: 4.8,
          description: 'Elegant luxury hotel with artistic design.',
        ),
        const CategoryItem(
          id: 'h7',
          name: 'The Trans Luxury Hotel Bandung',
          imageUrl:
              'https://images.unsplash.com/photo-1584132967334-10e028bd69f7?w=500',
          rating: 4.7,
          description: 'Premium hotel connected to shopping and entertainment.',
        ),
        const CategoryItem(
          id: 'h8',
          name: 'Sheraton Grand Jakarta Gandaria City Hotel',
          imageUrl:
              'https://images.unsplash.com/photo-1590073242678-70ee3fc28e8e?w=500',
          rating: 4.7,
          description: 'Modern 5-star hotel in South Jakarta.',
        ),
        const CategoryItem(
          id: 'h9',
          name: 'Plataran Borobudur Resort & Spa',
          imageUrl:
              'https://images.unsplash.com/photo-1499793983690-e29da59ef1c2?w=500',
          rating: 4.8,
          description: 'Resort near Borobudur with cultural ambiance.',
        ),
        const CategoryItem(
          id: 'h10',
          name: 'Grand Hyatt Bali',
          imageUrl:
              'https://images.unsplash.com/photo-1576013551627-0cc20b96c2a7?w=500',
          rating: 4.8,
          description: 'Large beachfront resort with tropical gardens.',
          hasDiscount: true,
        ),
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CategoryPageBase(
      title: 'Popular Hotels',
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
