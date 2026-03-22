import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../widgets/top_bar.dart';
import 'onboarding.dart';
import 'add_request.dart';
import 'models/faq_item.dart';
import 'models/recent_question.dart';
import 'widgets/cs_search_bar.dart';
import 'widgets/faq_card.dart';
import 'widgets/recent_card.dart';
import 'services/customer_service_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CUSTOMER SERVICE PAGE
// ─────────────────────────────────────────────────────────────────────────────

class CustomerServicePage extends StatefulWidget {
  const CustomerServicePage({super.key});

  @override
  State<CustomerServicePage> createState() => _CustomerServicePageState();
}

class _CustomerServicePageState extends State<CustomerServicePage> {
  final TextEditingController _searchController = TextEditingController();
  final CustomerServiceService _service = CustomerServiceService();

  List<FaqItem> _faqs = [];
  List<RecentQuestion> _recentQuestions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final faqs = await _service.getFaqs();
    final recent = await _service.getRecentQuestions();
    if (mounted) {
      setState(() {
        _faqs = faqs;
        _recentQuestions = recent;
        _isLoading = false;
      });
    }
  }

  List<FaqItem> get _filteredFaqs {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) return _faqs;
    return _faqs
        .where((f) => f.question.toLowerCase().contains(query))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // ── Top Bar ────────────────────────────────────────────────────
          TopBar(
            showBackButton: true,
            showHamburger: true,
            onHamburgerTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OnboardingPage()),
              );
            },
          ),

          // ── Scrollable content ─────────────────────────────────────────
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        // ── Search bar ─────────────────────────────────────────
                        CsSearchBar(
                          controller: _searchController,
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 24),

                        // ── FAQ section ────────────────────────────────────────
                        const Text(
                          'FAQ:',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),

                        ..._filteredFaqs.map((faq) => FaqCard(faq: faq)),

                        const SizedBox(height: 8),
                        const Divider(height: 32, color: Color(0xFFDDDDDD)),

                        // ── Recently Asked section ─────────────────────────────
                        const Text(
                          'Recently Asked:',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Horizontal scrollable
                        SizedBox(
                          height: 130,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            clipBehavior: Clip.none,
                            padding: const EdgeInsets.only(right: 4),
                            itemCount: _recentQuestions.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 12),
                            itemBuilder: (_, i) => RecentCard(
                              item: _recentQuestions[i],
                              cardWidth: 350,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),

      // ── Floating Chat Button ─────────────────────────────────────────────
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 25, right: 25),
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFF0B4882),
            borderRadius: BorderRadius.circular(16),
          ),
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddRequestPage()),
              );
            },
            icon: SvgPicture.string('''
              <svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M2.61279 28.7402V5.22554C2.61279 4.50703 2.86884 3.89217 3.38094 3.38094C3.89304 2.86971 4.5079 2.61366 5.22554 2.61279H26.1275C26.846 2.61279 27.4613 2.86884 27.9734 3.38094C28.4855 3.89304 28.7411 4.5079 28.7402 5.22554V20.902C28.7402 21.6205 28.4846 22.2358 27.9734 22.7479C27.4622 23.26 26.8469 23.5156 26.1275 23.5148H7.83828L2.61279 28.7402ZM7.83828 18.2893H18.2893V15.6765H7.83828V18.2893ZM7.83828 14.3701H23.5147V11.7574H7.83828V14.3701ZM7.83828 10.451H23.5147V7.83828H7.83828V10.451Z" fill="white"/>
</svg>
              ''', height: 24),
          ),
        ),
      ),
    );
  }
}
