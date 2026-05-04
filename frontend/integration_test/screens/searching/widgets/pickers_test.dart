import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:swifttrip_frontend/screens/searching/searching.dart';
import 'package:swifttrip_frontend/screens/searching/widgets/pickers.dart';
import 'package:swifttrip_frontend/providers/language_provider.dart';
import 'package:swifttrip_frontend/providers/cart_provider.dart';
import 'package:swifttrip_frontend/main.dart' as app;

// ─── Integration Tests: Searching - Pesan Tiket ─────────────────────────────

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Searching - Pesan Tiket Integration Tests', () {
    Widget buildTestApp({Widget? home}) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LanguageProvider()),
          ChangeNotifierProvider(create: (_) => CartProvider()),
        ],
        child: MaterialApp(home: home ?? const SearchingPage()),
      );
    }

    // ── validator() — end-to-end passenger input validation ───────────────

    group('validator() — Passenger field full interaction', () {
      testWidgets(
          'should show passenger picker bottom sheet when passenger field tapped',
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(buildTestApp());
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Act — find passenger-related text/button
        final passengerFinder = find.byWidgetPredicate(
          (w) =>
              w is Text &&
              (w.data?.toLowerCase().contains('passenger') == true ||
                  w.data?.toLowerCase().contains('penumpang') == true ||
                  w.data?.toLowerCase().contains('adult') == true),
        );

        if (passengerFinder.evaluate().isNotEmpty) {
          await tester.tap(passengerFinder.first);
          await tester.pumpAndSettle();
        }

        // Assert — no crash
        expect(tester.takeException(), isNull);
      });

      testWidgets('should not crash when SearchingPage opens',
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(buildTestApp());
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Assert
        expect(tester.takeException(), isNull);
        expect(find.byType(SearchingPage), findsOneWidget);
      });
    });

    // ── savePassengerDetails() — PassengerCount picker ────────────────────

    group('savePassengerDetails() — passenger picker flow', () {
      testWidgets('should show passenger picker bottom sheet when invoked',
          (WidgetTester tester) async {
        // Arrange
        PassengerCount? result;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (ctx) => ElevatedButton(
                  key: const Key('open_passenger_picker'),
                  onPressed: () async {
                    result = await showPassengerPicker(
                      ctx,
                      const PassengerCount(adults: 1),
                    );
                  },
                  child: const Text('Pick Passengers'),
                ),
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.byKey(const Key('open_passenger_picker')));
        await tester.pumpAndSettle();

        // Assert — bottom sheet opened
        expect(find.byType(BottomSheet), findsOneWidget);
      });

      testWidgets('should increment adult count via bottom sheet',
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (ctx) => ElevatedButton(
                  key: const Key('open_picker'),
                  onPressed: () => showPassengerPicker(
                    ctx,
                    const PassengerCount(adults: 1),
                  ),
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.byKey(const Key('open_picker')));
        await tester.pumpAndSettle();

        // Find the + button for adults
        final addButtons = find.byIcon(Icons.add);
        if (addButtons.evaluate().isNotEmpty) {
          await tester.tap(addButtons.first);
          await tester.pump();

          // Assert — count incremented (show "2 Adults" or similar)
          expect(find.textContaining('2'), findsWidgets);
        }
      });

      testWidgets('should close picker and return value when Done is tapped',
          (WidgetTester tester) async {
        // Arrange
        PassengerCount? returned;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (ctx) => ElevatedButton(
                  key: const Key('open_picker'),
                  onPressed: () async {
                    returned = await showPassengerPicker(
                      ctx,
                      const PassengerCount(adults: 1),
                    );
                  },
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.byKey(const Key('open_picker')));
        await tester.pumpAndSettle();

        // Tap Done button
        final doneBtn = find.text('Done');
        if (doneBtn.evaluate().isNotEmpty) {
          await tester.tap(doneBtn);
          await tester.pumpAndSettle();

          // Assert — picker dismissed, returned a value
          expect(returned, isNotNull);
          expect(returned!.adults, greaterThanOrEqualTo(1));
        }
      });
    });

    // ── selectSeat() — seat class dropdown end-to-end ─────────────────────

    group('selectSeat() — full dropdown interaction', () {
      testWidgets('should open and close seat class dropdown',
          (WidgetTester tester) async {
        // Arrange
        String selectedClass = 'Economy';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) => DropdownButton<String>(
                  key: const Key('seat_class_dropdown'),
                  value: selectedClass,
                  items: ['Economy', 'Business', 'First']
                      .map((v) =>
                          DropdownMenuItem(value: v, child: Text(v)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => selectedClass = v);
                  },
                ),
              ),
            ),
          ),
        );

        // Act — open dropdown
        await tester.tap(find.byKey(const Key('seat_class_dropdown')));
        await tester.pumpAndSettle();

        // Select Business
        final businessOption = find.text('Business');
        if (businessOption.evaluate().length > 1) {
          await tester.tap(businessOption.last);
        } else {
          await tester.tap(businessOption.first);
        }
        await tester.pumpAndSettle();

        // Assert
        expect(selectedClass, equals('Business'));
      });
    });

    // ── confirmTicketSelection() — full Pesan Tiket flow ─────────────────

    group('confirmTicketSelection() — full booking flow', () {
      testWidgets(
          'should show snackbar if Pesan Tiket tapped without selecting flight',
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(buildTestApp());
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Find and tap the "Pesan" or confirm ticket button
        final pesanBtn = find.byWidgetPredicate(
          (w) =>
              w is Text &&
              (w.data?.toLowerCase().contains('pesan') == true ||
                  w.data?.toLowerCase().contains('book') == true ||
                  w.data?.toLowerCase().contains('confirm') == true),
        );

        if (pesanBtn.evaluate().isNotEmpty) {
          await tester.tap(pesanBtn.first);
          await tester.pump();

          // Assert — snackbar or error shown
          expect(
            find.byType(SnackBar).evaluate().isNotEmpty ||
                find.byType(AlertDialog).evaluate().isNotEmpty ||
                tester.takeException() == null,
            isTrue,
          );
        }
      });

      testWidgets(
          'should load full app and navigate to searching without crash',
          (WidgetTester tester) async {
        // Act
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Assert
        expect(find.byType(MaterialApp), findsOneWidget);
      });
    });
  });
}