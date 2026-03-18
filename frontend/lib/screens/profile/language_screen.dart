import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../widgets/top_bar.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  int? _selectedIndex;

  static const List<_LangData> _languages = [
    _LangData(flag: '🇮🇩', name: 'Indonesia'),
    _LangData(flag: '🇬🇧', name: 'English'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: null,
      body: Column(
        children: [
          // ── Top Bar ────────────────────────────────────────────────────
          TopBar(showBackButton: true, showHamburger: false),

          // ── Content ────────────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: Text(
                    'Language',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(
                  height: 20,
                  indent: 20,
                  endIndent: 20,
                  color: Colors.black,
                ),

                // ── List View ────────────────────────────────────────────────────
                Expanded(
                  child: ListView.builder(
                    itemCount: _languages.length,
                    itemBuilder: (_, i) {
                      final lang = _languages[i];
                      final isSelected = _selectedIndex == i;
                      return InkWell(
                        onTap: () => setState(() => _selectedIndex = i),
                        child: Container(
                          color: isSelected
                              ? const Color(0xFFE8F4FD)
                              : Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 32,
                                child: Text(
                                  lang.flag,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                lang.name,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LangData {
  final String flag;
  final String name;
  const _LangData({required this.flag, required this.name});
}
