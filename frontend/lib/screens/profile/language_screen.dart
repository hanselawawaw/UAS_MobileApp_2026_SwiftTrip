import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  int? _selectedIndex;

  static const List<_LangData> _languages = [
    _LangData(flag: '🇯🇵', name: 'Japan'),
    _LangData(flag: '🇪🇬', name: 'Egypt'),
    _LangData(flag: '🇨🇳', name: 'Mandarin'),
    _LangData(flag: '🇮🇹', name: 'Italian'),
    _LangData(flag: '🇮🇳', name: 'India'),
    _LangData(flag: '🇪🇸', name: 'Spain'),
    _LangData(flag: '🇯🇵', name: 'Japan'),
    _LangData(flag: '🇪🇬', name: 'Egypt'),
    _LangData(flag: '🇨🇳', name: 'Mandarin'),
    _LangData(flag: '🇮🇹', name: 'Italian'),
    _LangData(flag: '🇮🇳', name: 'India'),
    _LangData(flag: '🇪🇸', name: 'Spain'),
    _LangData(flag: '🇯🇵', name: 'Japan'),
    _LangData(flag: '🇪🇬', name: 'Egypt'),
    _LangData(flag: '🇨🇳', name: 'Mandarin'),
    _LangData(flag: '🇮🇹', name: 'Italian'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: null,
      body: Column(
        children: [
          // ── Top Bar ────────────────────────────────────────────────────
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 15,
              left: 20,
              right: 20,
              bottom: 15,
            ),
            child: Row(
              children: [
                SvgPicture.asset('assets/icons/swifttrip_logo.svg', height: 30),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.chevron_left, size: 30, color: Colors.black),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          const Divider(height: 20, indent: 20, endIndent: 20),
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
                        Container(width: 1, height: 20, color: Colors.black26),
                        const SizedBox(width: 12),
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