import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/top_bar.dart';
import 'models/language_model.dart';
import 'services/language_service.dart';
import '../../providers/language_provider.dart';
import '../../core/constants.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  final LanguageService _languageService = LanguageService();
  List<Language> _languages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLanguages();
  }

  Future<void> _fetchLanguages() async {
    try {
      final languages = await _languageService.getLanguages();
      if (mounted) {
        setState(() {
          _languages = languages;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching languages: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: null,
      body: Column(
        children: [
          // ── Top Bar ────────────────────────────────────────────────────
          const TopBar(showBackButton: true, showHamburger: false),

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
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Consumer<LanguageProvider>(
                          builder: (context, provider, child) {
                            return ListView.builder(
                              itemCount: _languages.length,
                              itemBuilder: (_, i) {
                                final lang = _languages[i];
                                final isSelected =
                                    provider.currentCode == lang.code;

                                return InkWell(
                                  onTap: () {
                                    provider.setLanguage(lang.code);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Language updated to ${lang.name}',
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        backgroundColor: Constants.popupSuccess,
                                        behavior: SnackBarBehavior.floating,
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  },
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
                                            style:
                                                const TextStyle(fontSize: 20),
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
