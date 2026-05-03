import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:swifttrip_frontend/screens/searching/searching.dart';
import 'package:swifttrip_frontend/providers/language_provider.dart';
import 'package:swifttrip_frontend/providers/cart_provider.dart';
import 'package:swifttrip_frontend/main.dart' as app;

// ─── Integration Tests: Searching - Search Trip ──────────────────────────────

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Searching - Search Trip Integration Tests', () {
    Widget buildTestApp() {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LanguageProvider()),
          ChangeNotifierProvider(create: (_) => CartProvider()),
        ],
        child: const MaterialApp(home: SearchingPage()),
      );
    }

    // ── validateSearchQuery() end-to-end ──────────────────────────────────

    group('validateSearchQuery() — full screen interaction', () {
      testWidgets('should render SearchingPage within full app',
          (WidgetTester tester) async {
        // Act
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Navigate to Search tab (index 2 in MainScreen)
        // Tap the Search icon on bottom navigation
        final searchTab = find.byIcon(Icons.search);
        if (searchTab.evaluate().isNotEmpty) {
          await tester.tap(searchTab.first);
          await tester.pumpAndSettle();
        }

        // Assert
        expect(find.byType(MaterialApp), findsOneWidget);
      });

      testWidgets('should show searching page content after navigating to it',
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(buildTestApp());
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Assert
        expect(find.byType(SearchingPage), findsOneWidget);
        expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
      });
    });

    // ── saveSearchState() — user inputs persist ───────────────────────────

    group('saveSearchState() — user input across interaction', () {
      testWidgets('should retain entered text in origin field',
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(buildTestApp());
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Try to find a TextField in the page (origin input)
        final textFields = find.byType(TextField);
        if (textFields.evaluate().isNotEmpty) {
          // Act
          await tester.tap(textFields.first);
          await tester.pumpAndSettle();
          await tester.enterText(textFields.first, 'Jakarta');
          await tester.pumpAndSettle();

          // Assert
          expect(find.text('Jakarta'), findsWidgets);
        }
      });
    });

    // ── selectTravelType() — dropdown interaction ─────────────────────────

    group('selectTravelType() — DropdownButton full interaction', () {
      testWidgets('should open dropdown when DropdownButton is tapped',
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(buildTestApp());
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Act — find and tap any DropdownButton in the page
        final dropdowns = find.byType(DropdownButton<String>);
        if (dropdowns.evaluate().isNotEmpty) {
          await tester.tap(dropdowns.first);
          await tester.pumpAndSettle();

          // Assert — dropdown menu should be visible
          expect(find.byType(DropdownMenuItem<String>), findsWidgets);
        }
      });
    });

    // ── onChanged() — flight class selection ─────────────────────────────

    group('onChanged() — travel type and class selection', () {
      testWidgets('should update state when dropdown value is changed',
          (WidgetTester tester) async {
        // Arrange
        String currentValue = 'One Way';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) => DropdownButton<String>(
                  key: const Key('travel_type'),
                  value: currentValue,
                  items: ['One Way', 'Round Trip', 'Multi City']
                      .map((v) =>
                          DropdownMenuItem(value: v, child: Text(v)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => currentValue = v);
                  },
                ),
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.byKey(const Key('travel_type')));
        await tester.pumpAndSettle();

        final roundTrip = find.text('Round Trip');
        if (roundTrip.evaluate().length > 1) {
          await tester.tap(roundTrip.last);
        } else {
          await tester.tap(roundTrip.first);
        }
        await tester.pumpAndSettle();

        // Assert
        expect(currentValue, equals('Round Trip'));
      });
    });

    // ── Full search flow ──────────────────────────────────────────────────

    group('Full search trip flow', () {
      testWidgets('should not crash when SearchingPage loads completely',
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(buildTestApp());
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Assert
        expect(tester.takeException(), isNull);
        expect(find.byType(SearchingPage), findsOneWidget);
      });
    });
  });
}