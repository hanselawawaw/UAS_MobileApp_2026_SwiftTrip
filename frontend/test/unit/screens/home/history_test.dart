import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swifttrip_frontend/screens/cart/models/cart_models.dart';
import 'package:swifttrip_frontend/screens/home/services/history_service.dart';

class MockHistoryService extends Mock implements HistoryService {}

void main() {
  late MockHistoryService mockHistoryService;

  setUp(() {
    mockHistoryService = MockHistoryService();
  });

  group('Home History - Unit Test', () {
    test('mock fetchHistory returns expected list', () async {
      // Arrange
      const expected = [
        CartTicket(
          type: 'Train Ticket',
          bookingId: 'BOOK-001',
          classLabel: 'Economy',
          priceRp: 150000,
          from: 'JKT',
          to: 'BDG',
          date: '2026-05-02',
          departure: '09:00',
          arrive: '11:00',
        ),
      ];
      when(() => mockHistoryService.fetchHistory()).thenAnswer((_) async => expected);

      // Act
      final result = await mockHistoryService.fetchHistory();

      // Assert
      expect(result, equals(expected));
      verify(() => mockHistoryService.fetchHistory()).called(1);
    });

    test('rupiah formatting pattern from HistoryPage item builder', () {
      // Arrange
      String formatRp(int val) => 'Rp ${val.toString().replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]}.',
          )}';

      // Act
      final formatted = formatRp(123456789);

      // Assert
      expect(formatted, equals('Rp 123.456.789'));
    });

    test('CartTicket json payload has expected fields for history item', () {
      // Arrange
      const ticket = CartTicket(
        type: 'Bus Ticket',
        bookingId: 'BUS-10',
        classLabel: 'Executive',
        priceRp: 200000,
      );

      // Act
      final json = ticket.toJson();

      // Assert
      expect(json['type'], equals('Bus Ticket'));
      expect(json['booking_id'], equals('BUS-10'));
      expect(json['price_rp'], equals(200000));
    });
  });
}