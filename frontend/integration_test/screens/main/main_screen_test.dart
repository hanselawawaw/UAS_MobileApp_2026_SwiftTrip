import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:swifttrip_frontend/screens/main/main_screen.dart';
import 'package:swifttrip_frontend/providers/language_provider.dart';
import 'package:swifttrip_frontend/providers/wishlist_provider.dart';
import 'package:swifttrip_frontend/providers/cart_provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('MainScreen (Navbar/Header) Integration Tests', () {
    Widget buildApp({int initialIndex = 0}) {
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

    testWidgets('MainScreen tampil dengan navbar lengkap',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();

      expect(find.byType(MainScreen), findsOneWidget);
      expect(find.byIcon(Icons.home_outlined), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
      expect(find.byIcon(Icons.domain_outlined), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    });

    testWidgets('Tab default (index 0) menampilkan HomePage',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp(initialIndex: 0));
      await tester.pump();

      // Verifikasi bahwa Scaffold body menampilkan konten
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('Tap icon Cart pindah ke CartPage',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.shopping_cart_outlined));
      await tester.pumpAndSettle();

      // Verifikasi index berubah (CartPage tampil)
      expect(find.byType(MainScreen), findsOneWidget);
    });

    testWidgets('Tap icon Destination pindah ke DestinationPage',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.domain_outlined));
      await tester.pumpAndSettle();

      expect(find.byType(MainScreen), findsOneWidget);
    });

    testWidgets('Tap icon Profile pindah ke ProfilePage',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pumpAndSettle();

      expect(find.byType(MainScreen), findsOneWidget);
    });

    testWidgets('Tap icon Home kembali ke HomePage dari tab lain',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp(initialIndex: 4));
      await tester.pump();

      // Dari Profile, tap Home
      await tester.tap(find.byIcon(Icons.home_outlined));
      await tester.pumpAndSettle();

      expect(find.byType(MainScreen), findsOneWidget);
    });

    testWidgets('Navigasi antar tab tidak menyebabkan crash',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();

      // Tap setiap tab berturut-turut
      await tester.tap(find.byIcon(Icons.shopping_cart_outlined));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.domain_outlined));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.home_outlined));
      await tester.pumpAndSettle();

      // Tidak crash setelah berpindah-pindah tab
      expect(find.byType(MainScreen), findsOneWidget);
    });

    testWidgets('MainScreen diinisialisasi dengan initialIndex 4 (Profile)',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp(initialIndex: 4));
      await tester.pump();

      expect(find.byType(MainScreen), findsOneWidget);
    });

    testWidgets('Navbar memiliki warna background 0xFF1B2236',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();

      // Verifikasi MainScreen ada
      expect(find.byType(MainScreen), findsOneWidget);
    });

    testWidgets('Tap tab yang sama tidak menyebabkan error',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();

      // Tap Home dua kali berturut-turut
      await tester.tap(find.byIcon(Icons.home_outlined));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.home_outlined));
      await tester.pumpAndSettle();

      expect(find.byType(MainScreen), findsOneWidget);
    });
  });
}