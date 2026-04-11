import 'package:shared_preferences/shared_preferences.dart';
import '../models/language_model.dart';

class LanguageService {
  static const String _langKey = 'selected_language_code';

  Future<List<Language>> getLanguages() async {
    return const [
      Language(code: 'en', flag: '🇬🇧', name: 'English'),
      Language(code: 'id', flag: '🇮🇩', name: 'Indonesia'),
    ];
  }

  Future<void> saveLanguage(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_langKey, code);
  }

  Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_langKey) ?? 'en';
  }
}

class AppStrings {
  static const Map<String, Map<String, String>> values = {
    'en': {
      'schedule': 'Your Schedule',
      'recommendation': 'Recommendation',
      'search': 'Let AI Help Your Journey',
      'history': 'History >',
      'empty_cart_title': 'Your cart is empty',
      'empty_cart_subtitle': 'Looks like you haven\'t added any tickets yet. Let\'s find your next adventure!',
      'explore_flights': 'Explore Flights',
    },
    'id': {
      'schedule': 'Jadwal Anda',
      'recommendation': 'Rekomendasi',
      'search': 'Biarkan AI Membantu Perjalanan Anda',
      'history': 'Riwayat >',
      'empty_cart_title': 'Keranjang Anda kosong',
      'empty_cart_subtitle': 'Sepertinya Anda belum menambahkan tiket apapun. Mari temukan petualangan Anda berikutnya!',
      'explore_flights': 'Jelajahi Penerbangan',
    },
  };
}
