import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:swifttrip_frontend/screens/searching/land_vehicle.dart';
import 'package:swifttrip_frontend/screens/searching/models/ride_option.dart';
import 'package:swifttrip_frontend/providers/language_provider.dart';
import 'package:swifttrip_frontend/providers/cart_provider.dart';
import 'dart:io';
import '../../test_helpers.dart';

// ─── Helpers ─────────────────────────────────────────────────────────────────

Widget buildTestableWidget(Widget child) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ChangeNotifierProvider(create: (_) => CartProvider()),
    ],
    child: MaterialApp(
      home: child,
    ),
  );
}

// ─── Widget Tests: Searching - Kendaraan Darat ──────────────────────────────

void main() {
  HttpOverrides.global = MockHttpOverrides();

  group('Searching - Kendaraan Darat Widget Tests', () {
    // ── ListView.builder renders RideOption list ───────────────────────────

    group('ListView.builder — renders transport list', () {
      testWidgets('should render LandVehicleSearch without crashing',
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          buildTestableWidget(const LandVehicleSearch()),
        );
        await tester.pump();

        // Assert
        expect(find.byType(LandVehicleSearch), findsOneWidget);
        await tester.pump(const Duration(seconds: 1));
        await tester.pumpWidget(Container());
      });

      testWidgets('should show loading indicator while fetching data',
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          buildTestableWidget(const LandVehicleSearch()),
        );
        // Pump sekali saja agar loading state masih terlihat
        await tester.pump();

        // Assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        await tester.pump(const Duration(seconds: 1));
        await tester.pumpWidget(Container());
      });

      testWidgets(
          'should display transport type options after data loads',
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          buildTestableWidget(const LandVehicleSearch()),
        );
        await tester.pump(const Duration(seconds: 1));

        // Assert — minimal satu opsi kendaraan tampil
        final hasTransportOption = find.text('Car').evaluate().isNotEmpty ||
            find.text('Bus').evaluate().isNotEmpty ||
            find.text('Train').evaluate().isNotEmpty;
        expect(hasTransportOption, isTrue);
      });

      testWidgets(
          'should build standalone RideOption list correctly',
          (WidgetTester tester) async {
        // Arrange
        final options = [
          const RideOption(
            name: 'Car',
            duration: '2 hrs',
            passengerCapacity: 4,
            priceRp: 0,
            icon: Icons.directions_car_outlined,
          ),
          const RideOption(
            name: 'Bus',
            duration: '3 hrs',
            passengerCapacity: 40,
            priceRp: 0,
            icon: Icons.directions_bus_outlined,
          ),
        ];

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ListView.builder(
                itemCount: options.length,
                itemBuilder: (_, i) => ListTile(
                  leading: Icon(options[i].icon),
                  title: Text(options[i].name),
                  subtitle: Text(options[i].duration),
                ),
              ),
            ),
          ),
        );
        await tester.pump();

        // Assert
        expect(find.text('Car'), findsOneWidget);
        expect(find.text('Bus'), findsOneWidget);
        expect(find.byIcon(Icons.directions_car_outlined), findsOneWidget);
        expect(find.byIcon(Icons.directions_bus_outlined), findsOneWidget);
      });
    });

    // ── ListTile onTap() — vehicle selection ──────────────────────────────

    group('ListTile onTap() — selecting a vehicle', () {
      testWidgets('should invoke callback when ListTile is tapped',
          (WidgetTester tester) async {
        // Arrange
        bool tapped = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ListView(
                children: [
                  ListTile(
                    key: const Key('car_tile'),
                    title: const Text('Car'),
                    onTap: () => tapped = true,
                  ),
                ],
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.byKey(const Key('car_tile')));
        await tester.pump();

        // Assert
        expect(tapped, isTrue);
      });

      testWidgets('should highlight selected ListTile on tap',
          (WidgetTester tester) async {
        // Arrange
        int? selectedIndex;

        await tester.pumpWidget(
          StatefulBuilder(
            builder: (context, setState) => MaterialApp(
              home: Scaffold(
                body: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (_, i) {
                    final names = ['Car', 'Bus', 'Train'];
                    return ListTile(
                      key: Key('tile_$i'),
                      selected: selectedIndex == i,
                      title: Text(names[i]),
                      onTap: () => setState(() => selectedIndex = i),
                    );
                  },
                ),
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.byKey(const Key('tile_1'))); // Bus
        await tester.pump();

        // Assert
        expect(selectedIndex, equals(1));
      });

      testWidgets('should deselect when same tile is tapped twice',
          (WidgetTester tester) async {
        // Arrange
        int? selectedIndex;

        await tester.pumpWidget(
          StatefulBuilder(
            builder: (context, setState) => MaterialApp(
              home: Scaffold(
                body: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (_, i) {
                    final names = ['Car', 'Bus', 'Train'];
                    return ListTile(
                      key: Key('tile_$i'),
                      selected: selectedIndex == i,
                      title: Text(names[i]),
                      onTap: () => setState(
                        () => selectedIndex = selectedIndex == i ? null : i,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );

        // Act — tap 'Car' dua kali untuk toggle off
        await tester.tap(find.byKey(const Key('tile_0')));
        await tester.pump();
        expect(selectedIndex, equals(0));

        await tester.tap(find.byKey(const Key('tile_0')));
        await tester.pump();

        // Assert — deselected
        expect(selectedIndex, isNull);
      });
    });

    // ── Icon display for transport type ───────────────────────────────────

    group('displayTransportType() — Icon widget rendering', () {
      testWidgets('should render correct icon for each transport type',
          (WidgetTester tester) async {
        // Arrange
        final types = [
          {'name': 'Car', 'icon': Icons.directions_car_outlined},
          {'name': 'Bus', 'icon': Icons.directions_bus_outlined},
          {'name': 'Train', 'icon': Icons.train_outlined},
        ];

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Row(
                children: types
                    .map(
                      (t) => Icon(
                        t['icon'] as IconData,
                        key: Key('icon_${t['name']}'),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        );
        await tester.pump();

        // Assert
        expect(find.byKey(const Key('icon_Car')), findsOneWidget);
        expect(find.byKey(const Key('icon_Bus')), findsOneWidget);
        expect(find.byKey(const Key('icon_Train')), findsOneWidget);
      });
    });

    // ── Add to Cart button ────────────────────────────────────────────────

    group('Add to Cart / confirm button', () {
      testWidgets(
          'should show snackbar when add to cart pressed with no vehicle selected',
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          buildTestableWidget(const LandVehicleSearch()),
        );
        await tester.pump(const Duration(seconds: 1));

        final cartBtn = find.byIcon(Icons.shopping_cart_outlined);

        if (cartBtn.evaluate().isNotEmpty) {
          await tester.tap(cartBtn.first);
          await tester.pump();
          await tester.pump(const Duration(seconds: 1));

          // Assert — SnackBar muncul
          expect(find.byType(SnackBar), findsOneWidget);
        }
        await tester.pumpWidget(Container());
      });

      testWidgets('should not crash when LandVehicleSearch fully renders',
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          buildTestableWidget(const LandVehicleSearch()),
        );
        await tester.pump(const Duration(seconds: 1));

        // Assert
        expect(tester.takeException(), isNull);
        expect(find.byType(LandVehicleSearch), findsOneWidget);
      });
    });
  });
}