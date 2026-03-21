import 'package:flutter/material.dart';
import '../../widgets/top_bar.dart';
import '../customer_service/onboarding.dart';
import 'widgets/destination_search_bar.dart';
import 'widgets/category_list.dart';
import 'widgets/destination_section.dart';
import 'widgets/destination_card.dart';
import 'search.dart';

// --- Main Page ---
class DestinationPage extends StatelessWidget {
  const DestinationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: Column(
        children: [
          TopBar(
            showHamburger: true,
            onHamburgerTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OnboardingPage()),
              );
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  DestinationSearchBar(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DestinationSearchPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                  const CategoryList(),
                  const SizedBox(height: 30),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    height: 1,
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          color: Colors.black12,
                          strokeAlign: BorderSide.strokeAlignCenter,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  DestinationSection(
                    title: 'Discount',
                    items: _mockDestinations,
                  ),
                  DestinationSection(
                    title: 'People’s Favorites',
                    items: _mockDestinations,
                  ),
                  DestinationSection(
                    title: 'Hot Destinations',
                    items: _mockDestinations,
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Dummy Data ---
final List<DestinationModel> _mockDestinations = [
  DestinationModel(
    id: '1',
    name: 'rumah wilson williem',
    imageUrl: 'https://images.unsplash.com/photo-1552733407-5d5c46c3bb3b?w=500',
    rating: 5,
    hasDiscount: true,
    isFavorite: false,
  ),
  DestinationModel(
    id: '2',
    name: 'rumah wilson williem',
    imageUrl: 'https://images.unsplash.com/photo-1552733407-5d5c46c3bb3b?w=500',
    rating: 5,
    hasDiscount: true,
    isFavorite: false,
  ),
];
