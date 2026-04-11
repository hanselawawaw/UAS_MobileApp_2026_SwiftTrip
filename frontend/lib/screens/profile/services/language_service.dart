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
      'select_flight_before': 'Please select a flight first',
      'book_now': 'Book Ticket Now',
      'first_class': 'First Class',
      'economy': 'Economy',
      'origin_dest_same': 'Origin and destination cannot be the same.',
      'origin_dest_same_legs': 'Origin and destination cannot be the same for all legs.',
      'date_past': 'Departure date cannot be in the past.',
      'min_passenger': 'Minimum 1 adult passenger is required.',
      'choose_airline': 'Select Airline',
      'round_trip': 'Round-trip',
      'multi_city': 'Multi-city',
      'from': 'From',
      'to': 'To',
      'date': 'Date',
      'passengers': 'Passengers',
      'flight_class': 'Flight Class',
      'flight_label': 'Flight',
      'land_vehicle': 'Land Vehicle',
      'search_button': 'Search',
      'ticket_found': 'Ticket Found',
      'not_found': 'Not Found',
      'limited_coupon': 'Limited Coupon',
      'use_coupon': 'Use Coupon?',
      'coupon_label': 'Coupon',
      'have_coupon_hint': 'Have a Coupon?',
      'cancel_button': 'Cancel',
      'use_button': 'Use',
      'copied_toast': 'copied!',
      'copy_button': 'COPY',
      'dest_discount': 'Discount',
      'dest_favorites': 'People’s Favorites',
      'dest_hot': 'Hot Destinations',
      'menu_edit_profile': 'Edit Profile',
      'menu_wishlist': 'Wishlist',
      'menu_subscription': 'Subscription Plan',
      'menu_language': 'Language',
      'menu_clear_cache': 'Clear Cache',
      'menu_logout': 'Log Out',
    },
    'id': {
      'schedule': 'Jadwal Anda',
      'recommendation': 'Rekomendasi',
      'search': 'Biarkan AI Membantu Perjalanan Anda',
      'history': 'Riwayat >',
      'empty_cart_title': 'Keranjang Anda kosong',
      'empty_cart_subtitle': 'Sepertinya Anda belum menambahkan tiket apapun. Mari temukan petualangan Anda berikutnya!',
      'explore_flights': 'Jelajahi Penerbangan',
      'select_flight_before': 'Silakan pilih penerbangan terlebih dahulu',
      'book_now': 'Pesan Tiket Sekarang',
      'first_class': 'First Class',
      'economy': 'Economy',
      'origin_dest_same': 'Asal dan tujuan tidak boleh sama.',
      'origin_dest_same_legs': 'Asal dan tujuan tidak boleh sama untuk semua rute.',
      'date_past': 'Tanggal keberangkatan tidak boleh di masa lalu.',
      'min_passenger': 'Minimal 1 penumpang dewasa diperlukan.',
      'choose_airline': 'Pilih Maskapai',
      'round_trip': 'Pulang-Pergi',
      'multi_city': 'Multi-kota',
      'from': 'Dari',
      'to': 'Ke',
      'date': 'Tanggal',
      'passengers': 'Penumpang',
      'flight_class': 'Kelas Penerbangan',
      'flight_label': 'Penerbangan',
      'land_vehicle': 'Kendaraan Darat',
      'search_button': 'Cari',
      'ticket_found': 'Tiket Ditemukan',
      'not_found': 'Tidak Ditemukan',
      'limited_coupon': 'Kupon Terbatas',
      'use_coupon': 'Gunakan Kupon?',
      'coupon_label': 'Kupon',
      'have_coupon_hint': 'Punya Kupon?',
      'cancel_button': 'Batal',
      'use_button': 'Gunakan',
      'copied_toast': 'tersalin!',
      'copy_button': 'SALIN',
      'dest_discount': 'Diskon',
      'dest_favorites': 'Favorit Orang',
      'dest_hot': 'Destinasi Populer',
      'menu_edit_profile': 'Edit Profil',
      'menu_wishlist': 'Daftar Keinginan',
      'menu_subscription': 'Paket Langganan',
      'menu_language': 'Bahasa',
      'menu_clear_cache': 'Bersihkan Cache',
      'menu_logout': 'Keluar',
    },
  };
}
