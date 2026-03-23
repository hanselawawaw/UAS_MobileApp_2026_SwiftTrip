import 'package:swifttrip_frontend/screens/cart/models/cart_models.dart';

class TicketService {
  Future<List<CartTicket>> getTickets() async {
    // Simulated network delay
    await Future.delayed(const Duration(milliseconds: 400));
    return const [
      CartTicket(
        type: 'Train Ticket',
        bookingId: 'ID-1231KADASMASDKAASD',
        classLabel: 'ECONOMY CLASS',
        from: 'Jakarta',
        to: 'Ngawi Barat',
        date: '19/2/2026',
        departure: '9:00',
        arrive: '11:00',
        train: '1234',
        carriage: '01',
        seat: 'A12',
        priceRp: 100000,
      ),
      CartTicket(
        type: 'Train Ticket',
        bookingId: 'ID-1231KADASMASDKAASD',
        classLabel: 'ECONOMY CLASS',
        from: 'Ngawati Barat',
        to: 'Solo',
        date: '19/2/2026',
        departure: '9:00',
        arrive: '11:00',
        train: '1234',
        carriage: '01',
        seat: 'A12',
        priceRp: 100000,
      ),
      CartTicket(
        type: 'Train Ticket',
        bookingId: 'ID-1231KADASMASDKAASD',
        classLabel: 'ECONOMY CLASS',
        from: 'Jakarta',
        to: 'Ngawi Barat',
        date: '19/2/2026',
        departure: '9:00',
        arrive: '11:00',
        train: '1234',
        carriage: '01',
        seat: 'A12',
        priceRp: 100000,
      ),
    ];
  }
}
