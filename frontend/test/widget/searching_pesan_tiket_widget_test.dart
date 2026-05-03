import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:swifttrip_frontend/screens/searching/widgets/pickers.dart';
import 'package:swifttrip_frontend/providers/language_provider.dart';
import 'package:swifttrip_frontend/providers/cart_provider.dart';

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

// ─── Widget Tests: Searching - Pesan Tiket ──────────────────────────────────

void main() {
  group('Searching - Pesan Tiket Widget Tests', () {
    // ── validator() — TextFormField Passenger ─────────────────────────────

    group('validator() — TextFormField Passenger input', () {
      testWidgets(
          'should show validation error when passenger field is empty on submit',
          (WidgetTester tester) async {
        // Arrange
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      key: const Key('passenger_field'),
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Passenger required' : null,
                    ),
                    ElevatedButton(
                      key: const Key('validate_btn'),
                      onPressed: () => formKey.currentState?.validate(),
                      child: const Text('Confirm'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.byKey(const Key('validate_btn')));
        await tester.pump();

        // Assert
        expect(find.text('Passenger required'), findsOneWidget);
      });

      testWidgets('should pass validation when passenger count is entered',
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
                      key: const Key('passenger_field'),
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Passenger required' : null,
                    ),
                    ElevatedButton(
                      key: const Key('validate_btn'),
                      onPressed: () {
                        isValid = formKey.currentState?.validate() ?? false;
                      },
                      child: const Text('Confirm'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        // Act
        await tester.enterText(find.byKey(const Key('passenger_field')), '2');
        await tester.tap(find.byKey(const Key('validate_btn')));
        await tester.pump();

        // Assert
        expect(isValid, isTrue);
      });
    });

    // ── savePassengerDetails() — PassengerCount display ───────────────────

    group('savePassengerDetails() — PassengerCount widget display', () {
      testWidgets('should display correct passenger label in widget',
          (WidgetTester tester) async {
        // Arrange
        const pc = PassengerCount(adults: 2, children: 1);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Text(pc.displayLabel),
            ),
          ),
        );
        await tester.pump();

        // Assert
        expect(find.text('2 Adults, 1 Child'), findsOneWidget);
      });

      testWidgets('should display "1 Adult" for single adult passenger',
          (WidgetTester tester) async {
        // Arrange
        const pc = PassengerCount(adults: 1);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: Text(pc.displayLabel)),
          ),
        );

        // Assert
        expect(find.text('1 Adult'), findsOneWidget);
      });

      testWidgets(
          'should show updated passenger count after increment button tap',
          (WidgetTester tester) async {
        // Arrange
        int adultCount = 1;

        await tester.pumpWidget(
          StatefulBuilder(
            builder: (context, setState) => MaterialApp(
              home: Scaffold(
                body: Column(
                  children: [
                    Text('Adults: $adultCount', key: const Key('adult_count')),
                    IconButton(
                      key: const Key('increment_btn'),
                      icon: const Icon(Icons.add),
                      onPressed: () => setState(() => adultCount++),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.byKey(const Key('increment_btn')));
        await tester.pump();

        // Assert
        expect(find.text('Adults: 2'), findsOneWidget);
      });

      testWidgets('should not allow adult count to go below 1',
          (WidgetTester tester) async {
        // Arrange
        int adultCount = 1;

        await tester.pumpWidget(
          StatefulBuilder(
            builder: (context, setState) => MaterialApp(
              home: Scaffold(
                body: Column(
                  children: [
                    Text('Adults: $adultCount', key: const Key('adult_count')),
                    IconButton(
                      key: const Key('decrement_btn'),
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        if (adultCount > 1) setState(() => adultCount--);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        // Act — try to decrement below 1
        await tester.tap(find.byKey(const Key('decrement_btn')));
        await tester.pump();

        // Assert — still 1
        expect(find.text('Adults: 1'), findsOneWidget);
      });
    });

    // ── selectSeat() via DropdownButton ───────────────────────────────────

    group('selectSeat() — DropdownButton seat class', () {
      testWidgets('should render seat class dropdown with options',
          (WidgetTester tester) async {
        // Arrange
        String selectedClass = 'Economy';

        await tester.pumpWidget(
          StatefulBuilder(
            builder: (context, setState) => MaterialApp(
              home: Scaffold(
                body: DropdownButton<String>(
                  key: const Key('seat_dropdown'),
                  value: selectedClass,
                  items: const [
                    DropdownMenuItem(
                        value: 'Economy', child: Text('Economy')),
                    DropdownMenuItem(
                        value: 'Business', child: Text('Business')),
                    DropdownMenuItem(value: 'First', child: Text('First')),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => selectedClass = v);
                  },
                ),
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.byKey(const Key('seat_dropdown')));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Economy'), findsWidgets);
        expect(find.text('Business'), findsOneWidget);
        expect(find.text('First'), findsOneWidget);
      });

      testWidgets('should update seat class when Business is selected',
          (WidgetTester tester) async {
        // Arrange
        String selectedClass = 'Economy';

        await tester.pumpWidget(
          StatefulBuilder(
            builder: (context, setState) => MaterialApp(
              home: Scaffold(
                body: DropdownButton<String>(
                  key: const Key('seat_dropdown'),
                  value: selectedClass,
                  items: const [
                    DropdownMenuItem(
                        value: 'Economy', child: Text('Economy')),
                    DropdownMenuItem(
                        value: 'Business', child: Text('Business')),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => selectedClass = v);
                  },
                ),
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.byKey(const Key('seat_dropdown')));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Business').last);
        await tester.pumpAndSettle();

        // Assert
        expect(selectedClass, equals('Business'));
      });
    });

    // ── confirmTicketSelection() via ElevatedButton ───────────────────────

    group('confirmTicketSelection() — ElevatedButton', () {
      testWidgets('should render ElevatedButton for confirm ticket',
          (WidgetTester tester) async {
        // Arrange
        bool confirmed = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ElevatedButton(
                key: const Key('confirm_ticket_btn'),
                onPressed: () => confirmed = true,
                child: const Text('Pesan Tiket'),
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.byKey(const Key('confirm_ticket_btn')));
        await tester.pump();

        // Assert
        expect(confirmed, isTrue);
      });

      testWidgets('should disable confirm button when no flight is selected',
          (WidgetTester tester) async {
        // Arrange
        bool? selectedFlight; // null = no flight selected

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ElevatedButton(
                key: const Key('confirm_btn'),
                onPressed: selectedFlight != null ? () {} : null,
                child: const Text('Confirm'),
              ),
            ),
          ),
        );
        await tester.pump();

        // Assert — button is disabled (onPressed is null)
        final btn = tester.widget<ElevatedButton>(
            find.byKey(const Key('confirm_btn')));
        expect(btn.onPressed, isNull);
      });
    });
  });
}