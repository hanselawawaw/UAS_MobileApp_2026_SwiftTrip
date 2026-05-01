import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/top_bar.dart';
import '../customer_service/onboarding.dart';
import 'widgets/destination_search_bar.dart';
import 'widgets/category_list.dart';
import 'widgets/destination_section.dart';
import 'search.dart';
import 'services/destination_service.dart';
import 'models/destination_model.dart';

// --- Main Page ---
class DestinationPage extends StatefulWidget {
  final DestinationService? destinationService;

  const DestinationPage({super.key, this.destinationService});

  @override
  State<DestinationPage> createState() => _DestinationPageState();
}

class _DestinationPageState extends State<DestinationPage> {
  late Future<Map<String, List<DestinationModel>>> _homeSectionsFuture;
  late final DestinationService _service;

  @override
  void initState() {
    super.initState();
    _service = widget.destinationService ?? DestinationService();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _homeSectionsFuture = _service.fetchHomeSections();
    });
  }

  @override
  Widget build(BuildContext context) {
    final langProvider = context.watch<LanguageProvider>();
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
          // ── Fixed: search bar + categories ───────────────────────────
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
          const SizedBox(height: 10),
          // ── Scrollable: destination sections ─────────────────────────
          Expanded(
            child: FutureBuilder<Map<String, List<DestinationModel>>>(
              future: _homeSectionsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF2B99E3)),
                  );
                }
                
                // --- Updated Error State UI ---
                if (snapshot.hasError || (snapshot.hasData && snapshot.data!.isEmpty)) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, color: Colors.redAccent, size: 60),
                          const SizedBox(height: 16),
                          Text(
                            'Unable to load destinations',
                            style: GoogleFonts.cairo(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1E1E1E),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Please check your connection and try again.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: _loadData,
                            icon: const Icon(Icons.refresh),
                            label: Text(
                              'Retry',
                              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2B99E3),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final data = snapshot.data ?? {};
                final discount = data['discount_destinations'] ?? [];
                final favorite = data['favorite_destinations'] ?? [];
                final hot = data['hot_destinations'] ?? [];

                // Re-verify if data is truly empty after mapping
                if (discount.isEmpty && favorite.isEmpty && hot.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('No destinations found.'),
                        const SizedBox(height: 16),
                        TextButton(onPressed: _loadData, child: const Text('Retry')),
                      ],
                    ),
                  );
                }

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (discount.isNotEmpty)
                        DestinationSection(
                          title: langProvider.translate('dest_discount'),
                          items: discount,
                        ),
                      if (favorite.isNotEmpty)
                        DestinationSection(
                          title: langProvider.translate('dest_favorites'),
                          items: favorite,
                        ),
                      if (hot.isNotEmpty)
                        DestinationSection(
                          title: langProvider.translate('dest_hot'),
                          items: hot,
                        ),
                      const SizedBox(height: 80),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
