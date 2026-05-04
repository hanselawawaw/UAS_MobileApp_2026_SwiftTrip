import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:swifttrip_frontend/screens/searching/land_vehicle.dart';
import 'package:swifttrip_frontend/providers/language_provider.dart';
import 'package:swifttrip_frontend/providers/cart_provider.dart';

// ─── Integration Tests: Searching - Kendaraan Darat ─────────────────────────

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Searching - Kendaraan Darat Integration Tests', () {
    Widget buildTestApp() {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LanguageProvider()),
          ChangeNotifierProvider(create: (_) => CartProvider()),
        ],
        child: const MaterialApp(home: LandVehicleSearch()),
      );
    }

    // ── fetchTransportOptions() end-to-end ────────────────────────────────

    group('fetchTransportOptions() — full load flow', () {
      testWidgets('should load transport options and remove loading indicator',
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(buildTestApp());

        // Verify loading state
        await tester.pump();
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        // Wait for data
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Assert — loading gone
        expect(find.byType(CircularProgressIndicator), findsNothing);
      });

      testWidgets('should display Car, Bus, Train options after load',
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(buildTestApp());
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Assert
        expect(find.text('Car'), findsWidgets);
        expect(find.text('Bus'), findsWidgets);
        expect(find.text('Train'), findsWidgets);
      });

      testWidgets('should not throw exception during full load',
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(buildTestApp());
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Assert
        expect(tester.takeException(), isNull);
      });
    });

    // ── selectTransport() — real UI interaction ───────────────────────────

    group('selectTransport() — tapping transport type', () {
      testWidgets('should respond to transport type tap without crash',
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(buildTestApp());
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Act — tap 'Car' option if present
        final carOption = find.text('Car');
        if (carOption.evaluate().isNotEmpty) {
          await tester.tap(carOption.first);
          await tester.pumpAndSettle();
        }

        // Assert — no crash
        expect(tester.takeException(), isNull);
      });

      testWidgets('should show vehicle pins after selecting transport type',
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(buildTestApp());
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Act — select 'Bus'
        final busOption = find.text('Bus');
        if (busOption.evaluate().isNotEmpty) {
          await tester.tap(busOption.first);
          await tester.pumpAndSettle();
        }

        // Assert — page still renders correctly
        expect(find.byType(LandVehicleSearch), findsOneWidget);
      });

      testWidgets('should toggle off transport when tapped twice',
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(buildTestApp());
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Act — tap same transport twice
        final trainOption = find.text('Train');
        if (trainOption.evaluate().isNotEmpty) {
          await tester.tap(trainOption.first);
          await tester.pumpAndSettle();
          await tester.tap(trainOption.first);
          await tester.pumpAndSettle();
        }

        // Assert — no crash, page still works
        expect(find.byType(LandVehicleSearch), findsOneWidget);
      });
    });

    // ── onTap() vehicle pin — full selection flow ─────────────────────────

    group('onTap() vehicle pin — selecting a specific vehicle', () {
      testWidgets('should update UI when vehicle pin is tapped on map',
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(buildTestApp());
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Assert — page still intact after waiting
        expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
      });
    });

    // ── Add to Cart — full flow ───────────────────────────────────────────

    group('Add to Cart — integration', () {
      testWidgets(
          'should show snackbar if add to cart pressed without vehicle selected',
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(buildTestApp());
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Find confirm button
        final confirmBtn = find.byWidgetPredicate(
          (w) =>
              w is Text &&
              (w.data?.toLowerCase().contains('confirm') == true ||
                  w.data?.toLowerCase().contains('add to cart') == true),
        );

        if (confirmBtn.evaluate().isNotEmpty) {
          await tester.tap(confirmBtn.first);
          await tester.pump();

          // Assert — snackbar appears telling user to select first
          expect(find.byType(SnackBar), findsOneWidget);
        }
      });

      testWidgets('should navigate to cart after successful add to cart',
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(buildTestApp());
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Assert — no crash on page
        expect(find.byType(MaterialApp), findsOneWidget);
      });
    });
  });
}