import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swifttrip_frontend/screens/cart/models/cart_models.dart';
import 'package:swifttrip_frontend/screens/cart/widgets/ticket_card.dart';
import 'package:swifttrip_frontend/screens/home/history.dart';
import 'package:swifttrip_frontend/screens/home/services/history_service.dart';

class MockHistoryService extends Mock implements HistoryService {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockHistoryService mockHistoryService;

  setUp(() {
    mockHistoryService = MockHistoryService();
  });

  group('Home History - Integration Test', () {
    testWidgets('renders history page and loaded ticket flow', (tester) async {
      // Arrange
      const tickets = [
        CartTicket(
          type: 'Bus Ticket',
          bookingId: 'BUS-77',
          classLabel: 'Executive',
          priceRp: 275000,
          from: 'Bandung',
          to: 'Jakarta',
          date: '2026-05-02',
          departure: '10:00',
          arrive: '13:00',
          operator: 'SwiftBus',
          busClass: 'Executive',
          busNumber: 'SB-77',
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
      expect(find.byType(HistoryPage), findsOneWidget);
      expect(find.text('History'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(TicketCard), findsOneWidget);
      expect(find.text('BUS-77'), findsOneWidget);
    });
  });
}