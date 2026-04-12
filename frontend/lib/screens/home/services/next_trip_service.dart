import '../models/purchase_detail.dart';
import 'package:swifttrip_frontend/screens/cart/models/cart_models.dart';

class NextTripService {
  Future<CartTicket> getNextTrip() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const CartTicket(
      type: 'Train Ticket',
      bookingId: 'ID-1231KADASMASDKAASD',
      classLabel: 'ECONOMY CLASS',
      from: 'Jakarta',
      to: 'Ngawi Barat',
      date: '19/2/2026',
      departure: '9:00',
      arrive: '11:00',
      operator: '1234',
      carriage: '01',
      seat: 'A12',
      priceRp: 100000,
      latitude: -7.3995,
      longitude: 111.4586,
    );
  }

  Future<List<PurchaseDetail>> getPurchaseDetails() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      PurchaseDetail(label: 'Tiket Kereta', amount: 'Rp 14.000.000'),
      PurchaseDetail(label: 'Voucher', amount: '-Rp 300.000'),
      PurchaseDetail(label: 'Diskon liburan', amount: '-Rp 1.800.000'),
      PurchaseDetail(label: 'PPN 10%', amount: 'Rp 110.700'),
    ];
  }
}
