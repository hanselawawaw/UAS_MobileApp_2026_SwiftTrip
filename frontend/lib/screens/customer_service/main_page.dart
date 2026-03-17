import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../widgets/top_bar.dart';
import '../main/main_screen.dart';
import 'onboarding.dart';

// ─────────────────────────────────────────────────────────────────────────────
// MODELS
// ─────────────────────────────────────────────────────────────────────────────

class _FaqItem {
  final String question;
  final String answer;

  const _FaqItem({required this.question, required this.answer});
}

class _RecentQuestion {
  final String username;
  final String question;

  const _RecentQuestion({required this.username, required this.question});
}

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

  final List<_FaqItem> _faqs = const [
    _FaqItem(
      question: 'Cara menggubah nama',
      answer:
          'Untuk mengubah nama, pergi ke halaman Profile > Edit Profile, lalu ubah nama kamu dan simpan.',
    ),
    _FaqItem(
      question: 'Ai tidak merespon',
      answer:
          'Jika AI tidak merespon, coba refresh halaman atau restart aplikasi. Pastikan koneksi internet kamu stabil.',
    ),
    _FaqItem(
      question: 'Pembayaran Error',
      answer:
          'Jika mengalami error saat pembayaran, pastikan data kartu kamu benar dan coba lagi. Hubungi bank jika masalah berlanjut.',
    ),
    _FaqItem(
      question: 'History belum muncul',
      answer:
          'History akan muncul setelah transaksi selesai diproses. Biasanya membutuhkan waktu 1-2 menit.',
    ),
  ];

  final List<_RecentQuestion> _recentQuestions = const [
    _RecentQuestion(
      username: 'Anonymous_121',
      question: 'How to get refund after accidentally press confirm?',
    ),
    _RecentQuestion(
      username: 'Anonymous_087',
      question: 'Can I change my booking date after payment?',
    ),
  ];

  List<_FaqItem> get _filteredFaqs {
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  // ── Search bar ─────────────────────────────────────────
                  _SearchBar(
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

                  ..._filteredFaqs.map((faq) => _FaqCard(faq: faq)),

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
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (_, i) => _RecentCard(
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
            onPressed: () {},
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

// ─────────────────────────────────────────────────────────────────────────────
// SEARCH BAR
// ─────────────────────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchBar({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        shadows: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 20,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Let Us Help Answering Your Question',
                hintStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: Colors.black.withOpacity(0.4),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const Icon(Icons.search, size: 20, color: Colors.black54),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FAQ CARD  — expandable accordion
// ─────────────────────────────────────────────────────────────────────────────

class _FaqCard extends StatefulWidget {
  final _FaqItem faq;

  const _FaqCard({required this.faq});

  @override
  State<_FaqCard> createState() => _FaqCardState();
}

class _FaqCardState extends State<_FaqCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            elevation: 4,
            child: InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 23,
                  vertical: 19,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Header ──
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.faq.question,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              height: 1.25,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Icon(
                          _expanded
                              ? Icons.keyboard_arrow_down_rounded
                              : Icons.chevron_right,
                          size: 22,
                        ),
                      ],
                    ),

                    // ── Answer ──
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 250),
                        opacity: _expanded ? 1.0 : 0.0,
                        child: _expanded
                            ? Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Text(
                                  widget.faq.answer,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w300,
                                    fontSize: 13,
                                    height: 1.6,
                                    color: Colors.black54,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// RECENTLY ASKED CARD
// ─────────────────────────────────────────────────────────────────────────────

class _RecentCard extends StatelessWidget {
  final _RecentQuestion item;
  final double cardWidth;

  // TODO: Add onTap callback for 'Read more' navigation when backend is ready
  const _RecentCard({required this.item, this.cardWidth = 400});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        shadows: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── Username ───────────────────────────────────────────────────
          Row(
            children: [
              Container(
                width: 33.52,
                height: 33.52,
                decoration: const ShapeDecoration(
                  color: Colors.white,
                  shape: OvalBorder(),
                  shadows: [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 20,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person_outline,
                  size: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                item.username,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  height: 1.67,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // ── Question ───────────────────────────────────────────────────
          Text(
            item.question,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: 12,
              height: 1.67,
              color: Colors.black,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),

          // ── Read more ──────────────────────────────────────────────────
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              // TODO: Navigate to full question/answer detail page
              // TODO: Pass item.id to fetch full thread from backend
              onTap: () {},
              child: const Text(
                'Read more >',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  height: 2,
                  color: Color(0xFF2B99E3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
