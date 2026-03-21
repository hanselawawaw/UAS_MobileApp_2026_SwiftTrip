import 'package:flutter/material.dart';
import 'widgets/destination_card.dart';
import 'widgets/destination_section.dart';

class DestinationSearchPage extends StatefulWidget {
  const DestinationSearchPage({super.key});

  @override
  State<DestinationSearchPage> createState() => _DestinationSearchPageState();
}

class _DestinationSearchPageState extends State<DestinationSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  int? _activeTagIndex;

  // TODO: Fetch trending tags from backend
  final List<String> _trendingTags = ['Cozy', 'Sleek', 'Airy', 'Moody'];

  // TODO: Fetch recent searches from backend / local storage
  final List<DestinationModel> _recentSearches = [
    DestinationModel(
      id: '1',
      name: 'Bali - Pantai Kuta',
      imageUrl:
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=500',
      rating: 4.8,
      hasDiscount: true,
      isFavorite: false,
    ),
    DestinationModel(
      id: '2',
      name: 'Yogyakarta - Candi Borobudur',
      imageUrl:
          'https://images.unsplash.com/photo-1588666309990-d68f08e3d4a6?w=500',
      rating: 4.9,
      hasDiscount: false,
      isFavorite: false,
    ),
    DestinationModel(
      id: '3',
      name: 'Labuan Bajo - Pulau Komodo',
      imageUrl:
          'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=500',
      rating: 4.9,
      hasDiscount: true,
      isFavorite: false,
    ),
    DestinationModel(
      id: '4',
      name: 'Bandung - Kawah Putih',
      imageUrl:
          'https://images.unsplash.com/photo-1596422846543-75c6fc197f07?w=500',
      rating: 4.7,
      hasDiscount: false,
      isFavorite: false,
    ),
    DestinationModel(
      id: '5',
      name: 'Lombok - Pantai Tanjung Aan',
      imageUrl:
          'https://images.unsplash.com/photo-1537996194471-e657df975ab4?w=500',
      rating: 4.8,
      hasDiscount: true,
      isFavorite: false,
    ),
  ];

  // TODO: Fetch top rated from backend
  final List<DestinationModel> _topRated = [
    DestinationModel(
      id: '1',
      name: 'Bali - Pantai Kuta',
      imageUrl:
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=500',
      rating: 4.8,
      hasDiscount: true,
      isFavorite: false,
    ),
    DestinationModel(
      id: '2',
      name: 'Yogyakarta - Candi Borobudur',
      imageUrl:
          'https://images.unsplash.com/photo-1588666309990-d68f08e3d4a6?w=500',
      rating: 4.9,
      hasDiscount: false,
      isFavorite: false,
    ),
    DestinationModel(
      id: '3',
      name: 'Labuan Bajo - Pulau Komodo',
      imageUrl:
          'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=500',
      rating: 4.9,
      hasDiscount: true,
      isFavorite: false,
    ),
    DestinationModel(
      id: '4',
      name: 'Bandung - Kawah Putih',
      imageUrl:
          'https://images.unsplash.com/photo-1596422846543-75c6fc197f07?w=500',
      rating: 4.7,
      hasDiscount: false,
      isFavorite: false,
    ),
    DestinationModel(
      id: '5',
      name: 'Lombok - Pantai Tanjung Aan',
      imageUrl:
          'https://images.unsplash.com/photo-1537996194471-e657df975ab4?w=500',
      rating: 4.8,
      hasDiscount: true,
      isFavorite: false,
    ),
  ];

  // TODO: Fetch hot destinations from backend
  final List<DestinationModel> _hotDestinations = [
    DestinationModel(
      id: '1',
      name: 'Bali - Pantai Kuta',
      imageUrl:
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=500',
      rating: 4.8,
      hasDiscount: true,
      isFavorite: false,
    ),
    DestinationModel(
      id: '2',
      name: 'Yogyakarta - Candi Borobudur',
      imageUrl:
          'https://images.unsplash.com/photo-1588666309990-d68f08e3d4a6?w=500',
      rating: 4.9,
      hasDiscount: false,
      isFavorite: false,
    ),
    DestinationModel(
      id: '3',
      name: 'Labuan Bajo - Pulau Komodo',
      imageUrl:
          'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=500',
      rating: 4.9,
      hasDiscount: true,
      isFavorite: false,
    ),
    DestinationModel(
      id: '4',
      name: 'Bandung - Kawah Putih',
      imageUrl:
          'https://images.unsplash.com/photo-1596422846543-75c6fc197f07?w=500',
      rating: 4.7,
      hasDiscount: false,
      isFavorite: false,
    ),
    DestinationModel(
      id: '5',
      name: 'Lombok - Pantai Tanjung Aan',
      imageUrl:
          'https://images.unsplash.com/photo-1537996194471-e657df975ab4?w=500',
      rating: 4.8,
      hasDiscount: true,
      isFavorite: false,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: Column(
          children: [
            // ── Search bar row with back button ───────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x26000000),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x26000000),
                            blurRadius: 20,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        onChanged: (val) {
                          setState(() {});
                          // TODO: Trigger search API with debounce on val
                        },
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText:
                              'Looking For Something?', // TODO: Create search page
                          hintStyle: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            color: Colors.black.withOpacity(0.4),
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color(0xFF9E9E9E),
                            size: 20,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                          isDense: true,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── People are looking for ──────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Text(
                        'People are looking for...',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Wrap(
                        spacing: 8,
                        children: List.generate(_trendingTags.length, (i) {
                          final isActive = _activeTagIndex == i;
                          return GestureDetector(
                            onTap: () {
                              setState(() => _activeTagIndex = i);
                              _searchController.text = _trendingTags[i];
                              // TODO: Trigger filtered search by tag from backend
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? const Color(0xFF2B99E3)
                                    : const Color(0xFF2B99E3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _trendingTags[i],
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    const SizedBox(height: 20),
                    const Divider(
                      color: Color(0xFF404040),
                      thickness: 1,
                      indent: 20,
                      endIndent: 20,
                    ),
                    const SizedBox(height: 16),

                    // ── Recent Searches ─────────────────────────────
                    DestinationSection(
                      title: 'Recent Searches',
                      items: _recentSearches,
                    ),

                    // ── Top Rated ───────────────────────────────────
                    DestinationSection(title: 'Top Rated', items: _topRated),

                    // ── Hot Destinations ────────────────────────────
                    DestinationSection(
                      title: 'Hot Destinations',
                      items: _hotDestinations,
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
