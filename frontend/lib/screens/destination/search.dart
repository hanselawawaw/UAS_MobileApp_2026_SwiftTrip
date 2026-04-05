import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swifttrip_frontend/providers/wishlist_provider.dart';
import 'package:swifttrip_frontend/repositories/auth_repository.dart';
import 'package:swifttrip_frontend/screens/auth/login.dart';
import 'widgets/destination_section.dart';
import 'search/cozy.dart';
import 'search/airy.dart';
import 'search/moody.dart';
import 'search/sleek.dart';
import 'services/destination_service.dart';
import 'models/destination_model.dart';
import 'detail_page.dart';

class DestinationSearchPage extends StatefulWidget {
  const DestinationSearchPage({super.key});

  @override
  State<DestinationSearchPage> createState() => _DestinationSearchPageState();
}

class _DestinationSearchPageState extends State<DestinationSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final DestinationService _service = DestinationService();

  late final List<String> _trendingTags;
  List<DestinationModel> _searchResults = [];
  bool _isSearching = false;
  Timer? _debounce;

  bool get _hasQuery => _searchController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _trendingTags = _service.getTrendingTags();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    _debounce = Timer(const Duration(milliseconds: 400), () async {
      final results = await _service.searchDestinations(query.trim());
      if (mounted) {
        setState(() {
          _searchResults = results;
          _isSearching = false;
        });
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchResults = [];
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildSearchBar(),
            const SizedBox(height: 24),
            Expanded(
              child: _hasQuery
                  ? _buildSearchResults()
                  : _buildDiscoverContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: _hasQuery
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
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
                  ),
          ),
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
                onChanged: _onSearchChanged,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  hintText: 'Looking For Something?',
                  hintStyle: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    color: Colors.black.withOpacity(0.4),
                  ),
                  prefixIcon: _hasQuery
                      ? GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Color(0xFF9E9E9E),
                            size: 18,
                          ),
                        )
                      : const Icon(
                          Icons.search,
                          color: Color(0xFF9E9E9E),
                          size: 20,
                        ),
                  suffixIcon: _hasQuery
                      ? GestureDetector(
                          onTap: _clearSearch,
                          child: const Icon(
                            Icons.close,
                            color: Color(0xFF9E9E9E),
                            size: 20,
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  isDense: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_isSearching) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF2B99E3)),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No destinations found',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Try a different keyword or location',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _searchResults.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final destination = _searchResults[index];
        return _SearchResultCard(destination: destination);
      },
    );
  }

  Widget _buildDiscoverContent() {
    return SingleChildScrollView(
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
                final tagLabel = _trendingTags[i];
                return GestureDetector(
                  onTap: () {
                    _searchController.text = tagLabel;
                    Widget? targetPage;
                    if (tagLabel == 'Cozy') {
                      targetPage = const CozySearchPage();
                    } else if (tagLabel == 'Airy') {
                      targetPage = const AirySearchPage();
                    } else if (tagLabel == 'Moody') {
                      targetPage = const MoodySearchPage();
                    } else if (tagLabel == 'Sleek') {
                      targetPage = const SleekSearchPage();
                    }
                    if (targetPage != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => targetPage!),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2B99E3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tagLabel,
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

          // ── Recent Searches (Conditional) ─────────────────
          FutureBuilder<List<DestinationModel>>(
            future: _service.getRecentSearches(),
            builder: (context, snapshot) {
              final recentItems = snapshot.data ?? [];
              if (recentItems.isEmpty) return const SizedBox.shrink();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Divider(
                    color: Color(0xFF404040),
                    thickness: 1,
                    indent: 20,
                    endIndent: 20,
                  ),
                  const SizedBox(height: 16),
                  DestinationSection(
                    title: 'Recent Searches',
                    items: recentItems,
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 20),
          const Divider(
            color: Color(0xFF404040),
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),
          const SizedBox(height: 16),

          // ── Top Rated ───────────────────────────────────
          FutureBuilder<List<DestinationModel>>(
            future: _service.getTopRated(),
            builder: (context, snapshot) {
              return DestinationSection(
                title: 'Top Rated',
                items: snapshot.data ?? [],
              );
            },
          ),

          // ── Hot Destinations ────────────────────────────
          FutureBuilder<List<DestinationModel>>(
            future: _service.fetchDestinations(sectionTag: 'Hot'),
            builder: (context, snapshot) {
              return DestinationSection(
                title: 'Hot Destinations',
                items: snapshot.data ?? [],
              );
            },
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SEARCH RESULT CARD
// ─────────────────────────────────────────────────────────────────────────────

class _SearchResultCard extends StatelessWidget {
  final DestinationModel destination;

  const _SearchResultCard({required this.destination});

  String get _formattedPrice {
    final price = destination.price.toInt();
    final str = price.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
      count++;
    }
    return 'Rp. ${buffer.toString().split('').reversed.join()}';
  }

  @override
  Widget build(BuildContext context) {
    final service = DestinationService();

    return GestureDetector(
      onTap: () async {
        await service.addToRecentSearches(destination);
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DestinationDetailPage(destination: destination),
            ),
          ).then((_) {
            // Trigger refresh when coming back
            if (context.mounted) {
              final state = context
                  .findAncestorStateOfType<_DestinationSearchPageState>();
              // ignore: invalid_use_of_protected_member
              state?.setState(() {});
            }
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 12,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                bottomLeft: Radius.circular(14),
              ),
              child: Image.network(
                destination.imageUrl,
                width: 110,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 110,
                  height: 100,
                  color: Colors.grey.shade200,
                  child: Icon(
                    Icons.image_outlined,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      destination.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: Color(0xFF9E9E9E),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            destination.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: Color(0xFF9E9E9E),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formattedPrice,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Color(0xFF2B99E3),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              destination.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 2),
                            const Icon(
                              Icons.star,
                              size: 14,
                              color: Color(0xFFFFC107),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Consumer<WishlistProvider>(
                builder: (context, provider, child) {
                  final isFavorite = provider.isFavorite(destination.id);
                  return GestureDetector(
                    onTap: () async {
                      final token = await AuthRepository().getToken();
                      if (token == null) {
                        if (!context.mounted) return;
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (context) => Container(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Log in to save your favorite destinations',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const LoginPage(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2B99E3),
                                    minimumSize: const Size(
                                      double.infinity,
                                      45,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    'Log In',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                        return;
                      }
                      await provider.toggleWishlist(destination.id);
                    },
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : const Color(0xFFBDBDBD),
                      size: 22,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
