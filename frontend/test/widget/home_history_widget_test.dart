import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swifttrip_frontend/screens/cart/models/cart_models.dart';
import 'package:swifttrip_frontend/screens/cart/widgets/ticket_card.dart';
import 'package:swifttrip_frontend/screens/home/history.dart';
import 'package:swifttrip_frontend/screens/home/services/history_service.dart';

class MockHistoryService extends Mock implements HistoryService {}

void main() {
  late MockHistoryService mockHistoryService;

  setUp(() {
    mockHistoryService = MockHistoryService();
  });

  group('Home History - Widget Test', () {
    testWidgets('shows loading indicator while fetchHistory is pending', (tester) async {
      // Arrange
      final completer = Completer<List<CartTicket>>();
      when(() => mockHistoryService.fetchHistory()).thenAnswer((_) => completer.future);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: HistoryPage(historyService: mockHistoryService),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('History'), findsOneWidget);

      completer.complete(const []);
    });

    testWidgets('shows empty state text when history is empty', (tester) async {
      // Arrange
      when(() => mockHistoryService.fetchHistory()).thenAnswer((_) async => const []);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: HistoryPage(historyService: mockHistoryService),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('No purchase history yet.'), findsOneWidget);
      expect(find.byType(ListView), findsNothing);
    });

    testWidgets('renders ListView.separated and TicketCard when history has items', (tester) async {
      // Arrange
      const tickets = [
        CartTicket(
          type: 'Train Ticket',
          bookingId: 'TR-1',
          classLabel: 'Business',
          priceRp: 500000,
          from: 'JKT',
          to: 'SBY',
          date: '2026-05-02',
          departure: '08:00',
          arrive: '16:00',
          operator: 'KAI',
          carriage: 'A',
          seat: '12B',
        ),
      ];
      when(() => mockHistoryService.fetchHistory()).thenAnswer((_) async => tickets);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: HistoryPage(historyService: mockHistoryService),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(TicketCard), findsOneWidget);
      expect(find.text('History'), findsOneWidget);
      expect(find.text('Train Ticket'), findsOneWidget);
      expect(find.text('TR-1'), findsOneWidget);
    });

    testWidgets('shows error text when fetchHistory throws non-401 error', (tester) async {
      // Arrange
      when(() => mockHistoryService.fetchHistory()).thenAnswer((_) async => throw Exception('boom'));

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: HistoryPage(historyService: mockHistoryService),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.textContaining('Error:'), findsOneWidget);
    });
  });
}