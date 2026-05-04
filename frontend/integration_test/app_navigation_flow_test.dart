import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:swifttrip_frontend/screens/main/main_screen.dart';
import 'package:swifttrip_frontend/screens/home/home.dart';
import 'package:swifttrip_frontend/providers/language_provider.dart';
import 'package:swifttrip_frontend/providers/wishlist_provider.dart';
import 'package:swifttrip_frontend/providers/cart_provider.dart';

// ============================================================
// FLOW: App Navigation
// User on MainScreen → taps each navbar tab → verifies page
// renders → scrolls content → carousel interactions
// ============================================================

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Navigation Flow', () {
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

    testWidgets('MainScreen renders navbar → tap through all tabs without crash', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();

      // Navbar icons present
      expect(find.byType(MainScreen), findsOneWidget);
      expect(find.byIcon(Icons.home_outlined), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
      expect(find.byIcon(Icons.domain_outlined), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);

      // Tap Cart tab
      await tester.tap(find.byIcon(Icons.shopping_cart_outlined));
      await tester.pumpAndSettle();
      expect(find.byType(MainScreen), findsOneWidget);

      // Tap Destination tab
      await tester.tap(find.byIcon(Icons.domain_outlined));
      await tester.pumpAndSettle();
      expect(find.byType(MainScreen), findsOneWidget);

      // Tap Profile tab
      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pumpAndSettle();
      expect(find.byType(MainScreen), findsOneWidget);

      // Tap Home tab (back)
      await tester.tap(find.byIcon(Icons.home_outlined));
      await tester.pumpAndSettle();
      expect(find.byType(MainScreen), findsOneWidget);

      // Double-tap same tab doesn't crash
      await tester.tap(find.byIcon(Icons.home_outlined));
      await tester.pumpAndSettle();
      expect(find.byType(MainScreen), findsOneWidget);
    });

    testWidgets('HomePage renders → pull-to-refresh → scroll → carousel swipe', (tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => LanguageProvider()),
            ChangeNotifierProvider(create: (_) => WishlistProvider()),
            ChangeNotifierProvider(create: (_) => CartProvider()),
          ],
          child: MaterialApp(
            home: HomePage(onNavigateToDestination: () {}),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(HomePage), findsOneWidget);
      expect(find.byType(RefreshIndicator), findsOneWidget);

      // Pull-to-refresh
      await tester.fling(find.byType(RefreshIndicator), const Offset(0, 400), 800);
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(HomePage), findsOneWidget);

      // Scroll down and back up
      await tester.drag(find.byType(RefreshIndicator), const Offset(0, -500));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(RefreshIndicator), const Offset(0, 400));
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);

      // Carousel swipe
      final pageViews = find.byType(PageView);
      if (pageViews.evaluate().isNotEmpty) {
        await tester.drag(pageViews.first, const Offset(-300, 0));
        await tester.pumpAndSettle();
      }
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
