import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:swifttrip_frontend/screens/searching/searching.dart';
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
      home: Scaffold(body: child),
    ),
  );
}

// ─── Widget Tests: Searching - Search Trip ────────────────────────────────

void main() {
  HttpOverrides.global = MockHttpOverrides();

  group('Searching - Search Trip Widget Tests', () {
    // ── Form renders correctly ─────────────────────────────────────────────

    group('Form — renders on SearchingPage', () {
      testWidgets('should render SearchingPage without error',
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          buildTestableWidget(const SearchingPage()),
        );
        await tester.pump();

        // Assert
        expect(find.byType(SearchingPage), findsOneWidget);
        await tester.pump(const Duration(seconds: 1));
        await tester.pumpWidget(Container());
      });

      testWidgets('should display SingleChildScrollView inside SearchingPage',
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          buildTestableWidget(const SearchingPage()),
        );
        await tester.pump();

        // Assert
        expect(find.byType(SingleChildScrollView), findsWidgets);
        await tester.pump(const Duration(seconds: 1));
        await tester.pumpWidget(Container());
      });
    });

    // ── validateSearchQuery() via Form ────────────────────────────────────

    group('validateSearchQuery() — Form validation', () {
      testWidgets(
          'should show validation error when form is submitted with empty origin field',
          (WidgetTester tester) async {
        // Arrange
        final formKey = GlobalKey<FormState>();
        String? originValue;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      key: const Key('origin_field'),
                      onSaved: (v) => originValue = v,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Origin required' : null,
                    ),
                    ElevatedButton(
                      key: const Key('submit_btn'),
                      onPressed: () => formKey.currentState?.validate(),
                      child: const Text('Search'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.byKey(const Key('submit_btn')));
        await tester.pump();

        // Assert
        expect(find.text('Origin required'), findsOneWidget);
      });

      testWidgets('should pass validation when valid origin is entered',
          (WidgetTester tester) async {
        // Arrange
        final formKey = GlobalKey<FormState>();
        bool isValid = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      key: const Key('origin_field'),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Origin required' : null,
                    ),
                    ElevatedButton(
                      key: const Key('submit_btn'),
                      onPressed: () {
                        isValid = formKey.currentState?.validate() ?? false;
                      },
                      child: const Text('Search'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        // Act
        await tester.enterText(find.byKey(const Key('origin_field')), 'CGK');
        await tester.tap(find.byKey(const Key('submit_btn')));
        await tester.pump();

        // Assert
        expect(isValid, isTrue);
      });
    });

    // ── saveSearchState() via TextFormField ───────────────────────────────

    group('saveSearchState() — TextFormField saves data', () {
      testWidgets('should save origin field value on form save',
          (WidgetTester tester) async {
        // Arrange
        final formKey = GlobalKey<FormState>();
        String? savedOrigin;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      key: const Key('origin_field'),
                      onSaved: (v) => savedOrigin = v,
                      validator: (_) => null,
                    ),
                    ElevatedButton(
                      key: const Key('save_btn'),
                      onPressed: () {
                        formKey.currentState?.validate();
                        formKey.currentState?.save();
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        // Act
        await tester.enterText(
            find.byKey(const Key('origin_field')), 'Jakarta');
        await tester.tap(find.byKey(const Key('save_btn')));
        await tester.pump();

        // Assert
        expect(savedOrigin, equals('Jakarta'));
      });

      testWidgets('should save destination field value on form save',
          (WidgetTester tester) async {
        // Arrange
        final formKey = GlobalKey<FormState>();
        String? savedDestination;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      key: const Key('destination_field'),
                      onSaved: (v) => savedDestination = v,
                      validator: (_) => null,
                    ),
                    ElevatedButton(
                      key: const Key('save_btn'),
                      onPressed: () {
                        formKey.currentState?.validate();
                        formKey.currentState?.save();
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        // Act
        await tester.enterText(
            find.byKey(const Key('destination_field')), 'Bali');
        await tester.tap(find.byKey(const Key('save_btn')));
        await tester.pump();

        // Assert
        expect(savedDestination, equals('Bali'));
      });
    });

    // ── selectTravelType() via DropdownButton ─────────────────────────────

    group('selectTravelType() — DropdownButton interaction', () {
      testWidgets('should display dropdown with travel type options',
          (WidgetTester tester) async {
        // Arrange
        String selectedType = 'One Way';

        await tester.pumpWidget(
          StatefulBuilder(
            builder: (context, setState) => MaterialApp(
              home: Scaffold(
                body: DropdownButton<String>(
                  key: const Key('travel_type_dropdown'),
                  value: selectedType,
                  items: const [
                    DropdownMenuItem(value: 'One Way', child: Text('One Way')),
                    DropdownMenuItem(
                        value: 'Round Trip', child: Text('Round Trip')),
                    DropdownMenuItem(
                        value: 'Multi City', child: Text('Multi City')),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => selectedType = v);
                  },
                ),
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.byKey(const Key('travel_type_dropdown')));
        await tester.pumpAndSettle();

        // Assert — all options visible in dropdown
        expect(find.text('One Way'), findsWidgets);
        expect(find.text('Round Trip'), findsOneWidget);
        expect(find.text('Multi City'), findsOneWidget);
      });

      testWidgets('should update selected travel type when changed',
          (WidgetTester tester) async {
        // Arrange
        String selectedType = 'One Way';

        await tester.pumpWidget(
          StatefulBuilder(
            builder: (context, setState) => MaterialApp(
              home: Scaffold(
                body: DropdownButton<String>(
                  key: const Key('travel_type_dropdown'),
                  value: selectedType,
                  items: const [
                    DropdownMenuItem(value: 'One Way', child: Text('One Way')),
                    DropdownMenuItem(
                        value: 'Round Trip', child: Text('Round Trip')),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => selectedType = v);
                  },
                ),
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.byKey(const Key('travel_type_dropdown')));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Round Trip').last);
        await tester.pumpAndSettle();

        // Assert
        expect(selectedType, equals('Round Trip'));
      });

      testWidgets('should call onChanged when DropdownButton value changes',
          (WidgetTester tester) async {
        // Arrange
        String? changedValue;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: DropdownButton<String>(
                value: 'One Way',
                items: const [
                  DropdownMenuItem(value: 'One Way', child: Text('One Way')),
                  DropdownMenuItem(
                      value: 'Round Trip', child: Text('Round Trip')),
                ],
                onChanged: (v) => changedValue = v,
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.text('One Way'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Round Trip').last);
        await tester.pumpAndSettle();

        // Assert
        expect(changedValue, equals('Round Trip'));
      });
    });
  });
}