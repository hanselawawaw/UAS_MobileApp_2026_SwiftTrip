import 'package:flutter/material.dart';
import '../screens/profile/services/language_service.dart';

class LanguageProvider extends ChangeNotifier {
  final LanguageService _service = LanguageService();
  String _currentCode = 'en';

  String get currentCode => _currentCode;

  Future<void> loadLanguage() async {
    _currentCode = await _service.getLanguage();
    notifyListeners();
  }

  Future<void> setLanguage(String code) async {
    _currentCode = code;
    await _service.saveLanguage(code);
    notifyListeners();
  }

  String translate(String key) {
    return AppStrings.values[_currentCode]?[key] ?? key;
  }
}
