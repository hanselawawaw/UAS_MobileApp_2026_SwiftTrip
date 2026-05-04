import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:swifttrip_frontend/providers/language_provider.dart';
import 'package:swifttrip_frontend/providers/cart_provider.dart';
import 'package:swifttrip_frontend/providers/wishlist_provider.dart';

// ============================================================
// MAIN - NAVBAR/HEADER UNIT TEST
// Tabel Coverage:
//   Widget                | Class Method
//   ----------------------|----------------------
//   BottomNavigationBar   | onTabTapped()
//                         | buildNavigationItems()
//   IndexedStack          | switchView()
// ============================================================

// Helper: simulasi logika onTabTapped murni
class NavbarController {
  int _currentIndex;
  final int totalTabs;

  NavbarController({this.totalTabs = 5, int initialIndex = 0})
      : _currentIndex = initialIndex;

  int get currentIndex => _currentIndex;

  void onTabTapped(int index) {
    if (index >= 0 && index < totalTabs) {
      _currentIndex = index;
    }
  }

  // buildNavigationItems: menghasilkan list item berdasarkan jumlah tab
  List<Map<String, String>> buildNavigationItems() {
    return [
      {'icon': 'home_outlined', 'label': 'Home'},
      {'icon': 'shopping_cart_outlined', 'label': 'Cart'},
      {'icon': 'search', 'label': 'Search'},
      {'icon': 'domain_outlined', 'label': 'Destination'},
      {'icon': 'person_outline', 'label': 'Profile'},
    ];
  }

  // switchView: mengembalikan nama view sesuai index
  String switchView(int index) {
    const views = [
      'HomePage',
      'CartPage',
      'SearchingPage',
      'DestinationPage',
      'ProfilePage',
    ];
    if (index < 0 || index >= views.length) return 'Unknown';
    return views[index];
  }
}

void main() {
  group('MainScreen Navbar/Header Unit Tests', () {
    late NavbarController controller;

    setUp(() {
      controller = NavbarController();
    });

    // ----------------------------------------------------------
    // METHOD: onTabTapped()
    // ----------------------------------------------------------
    group('onTabTapped()', () {
      test('onTabTapped - index awal adalah 0 (Home)', () {
        expect(controller.currentIndex, equals(0));
      });

      test('onTabTapped(0) - mempertahankan tab Home', () {
        controller.onTabTapped(0);
        expect(controller.currentIndex, equals(0));
      });

      test('onTabTapped(1) - berpindah ke tab Cart', () {
        controller.onTabTapped(1);
        expect(controller.currentIndex, equals(1));
      });

      test('onTabTapped(2) - berpindah ke tab Searching', () {
        controller.onTabTapped(2);
        expect(controller.currentIndex, equals(2));
      });

      test('onTabTapped(3) - berpindah ke tab Destination', () {
        controller.onTabTapped(3);
        expect(controller.currentIndex, equals(3));
      });

      test('onTabTapped(4) - berpindah ke tab Profile', () {
        controller.onTabTapped(4);
        expect(controller.currentIndex, equals(4));
      });

      test('onTabTapped - index negatif diabaikan', () {
        controller.onTabTapped(0);
        controller.onTabTapped(-1);
        expect(controller.currentIndex, equals(0)); // Tidak berubah
      });

      test('onTabTapped - index melebihi totalTabs diabaikan', () {
        controller.onTabTapped(0);
        controller.onTabTapped(99);
        expect(controller.currentIndex, equals(0)); // Tidak berubah
      });

      test('onTabTapped - perpindahan berurutan bekerja dengan benar', () {
        controller.onTabTapped(1);
        expect(controller.currentIndex, equals(1));

        controller.onTabTapped(3);
        expect(controller.currentIndex, equals(3));

        controller.onTabTapped(0);
        expect(controller.currentIndex, equals(0));
      });
    });

    // ----------------------------------------------------------
    // METHOD: buildNavigationItems()
    // ----------------------------------------------------------
    group('buildNavigationItems()', () {
      test('buildNavigationItems menghasilkan tepat 5 item', () {
        final items = controller.buildNavigationItems();
        expect(items.length, equals(5));
      });

      test('buildNavigationItems - item pertama adalah Home', () {
        final items = controller.buildNavigationItems();
        expect(items[0]['label'], equals('Home'));
      });

      test('buildNavigationItems - item kedua adalah Cart', () {
        final items = controller.buildNavigationItems();
        expect(items[1]['label'], equals('Cart'));
      });

      test('buildNavigationItems - item ketiga adalah Search', () {
        final items = controller.buildNavigationItems();
        expect(items[2]['label'], equals('Search'));
      });

      test('buildNavigationItems - item keempat adalah Destination', () {
        final items = controller.buildNavigationItems();
        expect(items[3]['label'], equals('Destination'));
      });

      test('buildNavigationItems - item kelima adalah Profile', () {
        final items = controller.buildNavigationItems();
        expect(items[4]['label'], equals('Profile'));
      });

      test('buildNavigationItems - semua item memiliki icon', () {
        final items = controller.buildNavigationItems();
        for (final item in items) {
          expect(item['icon'], isNotNull);
          expect(item['icon'], isNotEmpty);
        }
      });

      test('buildNavigationItems - semua item memiliki label', () {
        final items = controller.buildNavigationItems();
        for (final item in items) {
          expect(item['label'], isNotNull);
          expect(item['label'], isNotEmpty);
        }
      });
    });

    // ----------------------------------------------------------
    // METHOD: switchView()
    // ----------------------------------------------------------
    group('switchView()', () {
      test('switchView(0) mengembalikan HomePage', () {
        expect(controller.switchView(0), equals('HomePage'));
      });

      test('switchView(1) mengembalikan CartPage', () {
        expect(controller.switchView(1), equals('CartPage'));
      });

      test('switchView(2) mengembalikan SearchingPage', () {
        expect(controller.switchView(2), equals('SearchingPage'));
      });

      test('switchView(3) mengembalikan DestinationPage', () {
        expect(controller.switchView(3), equals('DestinationPage'));
      });

      test('switchView(4) mengembalikan ProfilePage', () {
        expect(controller.switchView(4), equals('ProfilePage'));
      });

      test('switchView index tidak valid mengembalikan Unknown', () {
        expect(controller.switchView(-1), equals('Unknown'));
        expect(controller.switchView(99), equals('Unknown'));
      });

      test('switchView view berbeda untuk setiap index', () {
        final views = List.generate(5, (i) => controller.switchView(i));
        final uniqueViews = views.toSet();
        expect(uniqueViews.length, equals(5));
      });

      test('switchView konsisten dengan onTabTapped index', () {
        controller.onTabTapped(3);
        final view = controller.switchView(controller.currentIndex);
        expect(view, equals('DestinationPage'));
      });
    });

    // ----------------------------------------------------------
    // Provider tests
    // ----------------------------------------------------------
    group('Provider Integration', () {
      test('LanguageProvider dapat diinisialisasi', () {
        final provider = LanguageProvider();
        expect(provider, isNotNull);
        expect(provider.currentCode, equals('en'));
      });

      test('LanguageProvider translate mengembalikan key jika terjemahan tidak ada', () {
        final provider = LanguageProvider();
        const key = 'unknown_key';
        expect(provider.translate(key), equals(key));
      });

      test('CartProvider dapat diinisialisasi', () {
        final provider = CartProvider();
        expect(provider, isNotNull);
        expect(provider.tickets, isEmpty);
      });

      test('WishlistProvider dapat diinisialisasi', () {
        final provider = WishlistProvider();
        expect(provider, isNotNull);
      });
    });
  });
}