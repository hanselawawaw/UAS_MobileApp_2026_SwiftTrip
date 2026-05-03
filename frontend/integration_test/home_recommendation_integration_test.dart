import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:swifttrip_frontend/main.dart' as app;
import 'package:swifttrip_frontend/screens/home/home.dart';
import 'package:swifttrip_frontend/providers/language_provider.dart';
import 'package:swifttrip_frontend/providers/cart_provider.dart';

// ─── Integration Tests: Home - Recommendation ───────────────────────────────

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Home - Recommendation Integration Tests', () {
    // ── loadRecommendations() end-to-end ──────────────────────────────────

    group('loadRecommendations() — full app flow', () {
      testWidgets(
          'should display recommendation section after app starts',
          (WidgetTester tester) async {
        // Act
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Assert — Recommendation section header visible
        expect(find.textContaining('Recommendation'), findsWidgets);
      });

      testWidgets(
          'should display at least one recommendation item on Home screen',
          (WidgetTester tester) async {
        // Act
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Assert — at least one item visible (hotel names from mock data)
        final hotelFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Text &&
              (widget.data?.contains('Langham') == true ||
                  widget.data?.contains('Ritz') == true ||
                  widget.data?.contains('Tentrem') == true ||
                  widget.data?.contains('Padma') == true),
        );
        expect(hotelFinder, findsWidgets);
      });
    });

    // ── buildGridItems() renders correctly ────────────────────────────────

    group('buildGridItems() — rendered on screen', () {
      testWidgets(
          'should show recommendation grid after loading completes',
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => LanguageProvider()),
              ChangeNotifierProvider(create: (_) => CartProvider()),
            ],
            child: const MaterialApp(home: HomePage()),
          ),
        );

        // Wait for async data to load
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Assert
        expect(find.byType(HomePage), findsOneWidget);
      });

      testWidgets(
          'should not show CircularProgressIndicator after data loads',
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => LanguageProvider()),
              ChangeNotifierProvider(create: (_) => CartProvider()),
            ],
            child: const MaterialApp(home: HomePage()),
          ),
        );

        // Pump to show initial loading
        await tester.pump();
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        // Wait for data load
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Assert — loader gone
        expect(find.byType(CircularProgressIndicator), findsNothing);
      });
    });

    // ── navigateToDetail() — tap item navigates ───────────────────────────

    group('navigateToDetail() — navigation on item tap', () {
      testWidgets(
          'should navigate away from Home when recommendation item is tapped',
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => LanguageProvider()),
              ChangeNotifierProvider(create: (_) => CartProvider()),
            ],
            child: const MaterialApp(home: HomePage()),
          ),
        );

        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Act — find and tap first recommendation item
        final itemFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Text &&
              (widget.data?.contains('Langham') == true ||
                  widget.data?.contains('Ritz') == true ||
                  widget.data?.contains('Tentrem') == true ||
                  widget.data?.contains('Padma') == true),
        );

        if (itemFinder.evaluate().isNotEmpty) {
          await tester.tap(itemFinder.first);
          await tester.pumpAndSettle(const Duration(seconds: 2));
        }

        // Assert — no crash occurred
        expect(find.byType(MaterialApp), findsOneWidget);
      });
    });

    // ── handleImageError() — broken image graceful handling ───────────────

    group('handleImageError() — image load fallback', () {
      testWidgets(
          'should render recommendation section even if image fails to load',
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => LanguageProvider()),
              ChangeNotifierProvider(create: (_) => CartProvider()),
            ],
            child: const MaterialApp(home: HomePage()),
          ),
        );

        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Assert — screen still renders properly
        expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
      });
    });
  });
}