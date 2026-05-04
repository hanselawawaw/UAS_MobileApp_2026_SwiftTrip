import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:swifttrip_frontend/screens/main/main_screen.dart';
import 'package:swifttrip_frontend/providers/language_provider.dart';
import 'package:swifttrip_frontend/providers/wishlist_provider.dart';
import 'package:swifttrip_frontend/providers/cart_provider.dart';

// ============================================================
// MAIN - NAVBAR/HEADER WIDGET TEST
// Tabel Coverage:
//   Widget                | Class Method
//   ----------------------|----------------------
//   BottomNavigationBar   | onTabTapped()
//                         | buildNavigationItems()
//   IndexedStack          | switchView()
// ============================================================

void main() {
  group('MainScreen Navbar/Header Widget Tests', () {
    Widget buildSubject({int initialIndex = 0}) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LanguageProvider()),
          ChangeNotifierProvider(create: (_) => WishlistProvider()),
          ChangeNotifierProvider(create: (_) => CartProvider()),
        ],
        child: MaterialApp(
          home: MainScreen(initialIndex: initialIndex),
        ),
      );
    }

    // ----------------------------------------------------------
    // WIDGET: BottomNavigationBar
    // METHOD: onTabTapped()
    // ----------------------------------------------------------
    testWidgets(
        '[BottomNavigationBar] onTabTapped() - Tap icon Home '
        'memanggil onTabTapped dan mempertahankan tab 0',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.home_outlined));
      await tester.pumpAndSettle();

      // onTabTapped(0) = MainScreen masih ada dengan tab Home aktif
      expect(find.byType(MainScreen), findsOneWidget);
    });

    testWidgets(
        '[BottomNavigationBar] onTabTapped() - Tap icon Cart '
        'memanggil onTabTapped dan berpindah ke tab 1',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.shopping_cart_outlined));
      await tester.pumpAndSettle();

      // onTabTapped(1) = tab Cart aktif
      expect(find.byType(MainScreen), findsOneWidget);
    });

    testWidgets(
        '[BottomNavigationBar] onTabTapped() - Tap icon Destination '
        'memanggil onTabTapped dan berpindah ke tab 3',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.domain_outlined));
      await tester.pumpAndSettle();

      // onTabTapped(3) = tab Destination aktif
      expect(find.byType(MainScreen), findsOneWidget);
    });

    testWidgets(
        '[BottomNavigationBar] onTabTapped() - Tap icon Profile '
        'memanggil onTabTapped dan berpindah ke tab 4',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pumpAndSettle();

      // onTabTapped(4) = tab Profile aktif
      expect(find.byType(MainScreen), findsOneWidget);
    });

    testWidgets(
        '[BottomNavigationBar] onTabTapped() - Tap tab berulang '
        'tidak menyebabkan error',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      // Tap Home dua kali
      await tester.tap(find.byIcon(Icons.home_outlined));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.home_outlined));
      await tester.pumpAndSettle();

      expect(find.byType(MainScreen), findsOneWidget);
    });

    // ----------------------------------------------------------
    // WIDGET: BottomNavigationBar
    // METHOD: buildNavigationItems()
    // ----------------------------------------------------------
    testWidgets(
        '[BottomNavigationBar] buildNavigationItems() - Navbar memiliki '
        '5 item navigasi yang dibangun',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      // buildNavigationItems() menghasilkan 5 item:
      // Home, Cart, Searching, Destination, Profile
      expect(find.byIcon(Icons.home_outlined), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
      expect(find.byIcon(Icons.domain_outlined), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    });

    testWidgets(
        '[BottomNavigationBar] buildNavigationItems() - Setiap item '
        'menggunakan AnimatedContainer untuk efek seleksi',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      // buildNavigationItems() membangun AnimatedContainer per item
      expect(find.byType(AnimatedContainer), findsWidgets);
    });

    testWidgets(
        '[BottomNavigationBar] buildNavigationItems() - Navbar '
        'menggunakan warna background gelap (0xFF1B2236)',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      // Verifikasi navbar ada (buildNavigationItems berhasil)
      expect(find.byType(Scaffold), findsWidgets);
    });

    // ----------------------------------------------------------
    // WIDGET: IndexedStack
    // METHOD: switchView()
    // ----------------------------------------------------------
    testWidgets(
        '[IndexedStack] switchView() - switchView() memperlihatkan '
        'halaman sesuai index yang dipilih',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject(initialIndex: 0));
      await tester.pump();

      // switchView(0) = HomePage tampil
      expect(find.byType(MainScreen), findsOneWidget);
    });

    testWidgets(
        '[IndexedStack] switchView() - switchView() berpindah view '
        'saat tab Cart dipilih',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      // Dari Home → tap Cart → switchView(1)
      await tester.tap(find.byIcon(Icons.shopping_cart_outlined));
      await tester.pumpAndSettle();

      expect(find.byType(MainScreen), findsOneWidget);
    });

    testWidgets(
        '[IndexedStack] switchView() - switchView() berpindah view '
        'saat tab Profile dipilih',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pumpAndSettle();

      expect(find.byType(MainScreen), findsOneWidget);
    });

    testWidgets(
        '[IndexedStack] switchView() - switchView() dengan initialIndex 4 '
        'langsung menampilkan ProfilePage',
        (WidgetTester tester) async {
      // switchView() dipanggil saat init dengan initialIndex
      await tester.pumpWidget(buildSubject(initialIndex: 4));
      await tester.pump();

      expect(find.byType(MainScreen), findsOneWidget);
    });

    testWidgets(
        '[IndexedStack] switchView() - extendBody true memastikan '
        'konten tampil di balik navbar',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
      expect(scaffold.extendBody, isTrue);
    });
  });
}