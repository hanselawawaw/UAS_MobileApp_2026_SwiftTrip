import 'package:flutter_test/flutter_test.dart';
import 'package:swifttrip_frontend/screens/cart/models/cart_models.dart';
import 'package:swifttrip_frontend/screens/cart/models/promotion_models.dart';
import 'package:swifttrip_frontend/screens/cart/services/cart_service.dart';

// ============================================================
// CART - CART SCREEN UNIT TEST
// Tabel Coverage:
//   Widget            | Class Method
//   ------------------|----------------------
//   ListView          | loadCartItems()
//   CheckboxListTile  | toggleItemSelection()
//                     | onChanged()
//   Text              | calculateTotalAmount()
// ============================================================

// Helper buat CartTicket dummy
CartTicket makeTicket({
  String id = 'TK-001',
  String type = 'Plane Ticket',
  int price = 500000,
  int serviceFee = 25000,
}) =>
    CartTicket(
      bookingId: id,
      type: type,
      classLabel: 'Economy',
      priceRp: price,
      serviceFee: serviceFee,
      from: 'CGK',
      to: 'DPS',
    );

// Helper: logika toggleItemSelection murni
class CartScreenController {
  List<CartTicket> tickets = [];
  Set<String> selectedIds = {};
  bool isLoading = false;

  Future<void> loadCartItems(CartService service) async {
    isLoading = true;
    tickets = await service.fetchTickets();
    isLoading = false;
  }

  void toggleItemSelection(String id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
  }

  void onChanged(String id, bool? value) {
    if (value == null) return;
    if (value == true) {
      selectedIds.add(id);
    } else {
      selectedIds.remove(id);
    }
  }

  int calculateTotalAmount({Promotion? promo}) {
    final base = tickets.fold(0, (sum, t) => sum + t.priceRp);
    final fee = tickets.fold(0, (sum, t) => sum + t.serviceFee);
    final discount = CartService().calculateDiscount(base, promo);
    return base + fee - discount;
  }

  String formatRp(int amount) {
    final str = amount.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    return 'Rp. ${buffer.toString()}';
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Cart Screen Unit Tests', () {
    late CartScreenController controller;
    late CartService service;

    setUp(() {
      controller = CartScreenController();
      service = CartService();
    });

    // ----------------------------------------------------------
    // WIDGET: ListView
    // METHOD: loadCartItems()
    // ----------------------------------------------------------
    group('loadCartItems()', () {
      test('loadCartItems - tickets kosong sebelum load', () {
        expect(controller.tickets, isEmpty);
      });

      test('loadCartItems - isLoading false sebelum dipanggil', () {
        expect(controller.isLoading, isFalse);
      });

      test('loadCartItems - isLoading false setelah selesai', () async {
        await controller.loadCartItems(service);
        expect(controller.isLoading, isFalse);
      });

      test('loadCartItems - CartService singleton selalu instance sama', () {
        final s1 = CartService();
        final s2 = CartService();
        expect(identical(s1, s2), isTrue);
      });

      test('loadCartItems - CartTicket.fromJson membuat objek dengan benar', () {
        final json = {
          'type': 'Plane Ticket',
          'booking_id': 'BK-001',
          'class_label': 'Economy',
          'price_rp': 800000,
          'service_fee': 40000,
          'discount_rp': 0,
        };
        final ticket = CartTicket.fromJson(json);
        expect(ticket.bookingId, equals('BK-001'));
        expect(ticket.priceRp, equals(800000));
        expect(ticket.type, equals('Plane Ticket'));
      });
    });

    // ----------------------------------------------------------
    // WIDGET: CheckboxListTile
    // METHOD: toggleItemSelection()
    // ----------------------------------------------------------
    group('toggleItemSelection()', () {
      test('toggleItemSelection - selectedIds kosong sebelum ada seleksi', () {
        expect(controller.selectedIds, isEmpty);
      });

      test('toggleItemSelection - menambah ID ke selectedIds saat dipilih', () {
        controller.toggleItemSelection('TK-001');
        expect(controller.selectedIds.contains('TK-001'), isTrue);
      });

      test('toggleItemSelection - menghapus ID dari selectedIds saat dipilih lagi', () {
        controller.toggleItemSelection('TK-001');
        controller.toggleItemSelection('TK-001');
        expect(controller.selectedIds.contains('TK-001'), isFalse);
      });

      test('toggleItemSelection - dapat mengelola multiple ID', () {
        controller.toggleItemSelection('TK-001');
        controller.toggleItemSelection('TK-002');
        expect(controller.selectedIds.length, equals(2));
      });

      test('toggleItemSelection - hanya menghapus ID yang ditoggle', () {
        controller.toggleItemSelection('TK-001');
        controller.toggleItemSelection('TK-002');
        controller.toggleItemSelection('TK-001'); // unselect TK-001
        expect(controller.selectedIds.contains('TK-001'), isFalse);
        expect(controller.selectedIds.contains('TK-002'), isTrue);
      });
    });

    // ----------------------------------------------------------
    // WIDGET: CheckboxListTile
    // METHOD: onChanged()
    // ----------------------------------------------------------
    group('onChanged()', () {
      test('onChanged(true) menambah ID ke selectedIds', () {
        controller.onChanged('TK-001', true);
        expect(controller.selectedIds.contains('TK-001'), isTrue);
      });

      test('onChanged(false) menghapus ID dari selectedIds', () {
        controller.onChanged('TK-001', true);
        controller.onChanged('TK-001', false);
        expect(controller.selectedIds.contains('TK-001'), isFalse);
      });

      test('onChanged(null) tidak mengubah state', () {
        controller.onChanged('TK-001', true);
        controller.onChanged('TK-001', null);
        expect(controller.selectedIds.contains('TK-001'), isTrue);
      });

      test('onChanged dipanggil berulang dengan nilai berbeda', () {
        controller.onChanged('TK-001', true);
        expect(controller.selectedIds.contains('TK-001'), isTrue);

        controller.onChanged('TK-001', false);
        expect(controller.selectedIds.contains('TK-001'), isFalse);
      });
    });

    // ----------------------------------------------------------
    // WIDGET: Text
    // METHOD: calculateTotalAmount()
    // ----------------------------------------------------------
    group('calculateTotalAmount()', () {
      test('calculateTotalAmount - mengembalikan 0 jika tidak ada tiket', () {
        expect(controller.calculateTotalAmount(), equals(0));
      });

      test('calculateTotalAmount - menjumlah price + serviceFee tiket', () {
        controller.tickets = [makeTicket(price: 500000, serviceFee: 25000)];
        expect(controller.calculateTotalAmount(), equals(525000));
      });

      test('calculateTotalAmount - menjumlah semua tiket dengan benar', () {
        controller.tickets = [
          makeTicket(id: 'TK-1', price: 500000, serviceFee: 25000),
          makeTicket(id: 'TK-2', price: 300000, serviceFee: 15000),
        ];
        expect(controller.calculateTotalAmount(), equals(840000));
      });

      test('calculateTotalAmount - mengurangi diskon promo PERCENTAGE', () {
        controller.tickets = [makeTicket(price: 1000000, serviceFee: 0)];
        final promo = Promotion(
          id: 'P1', title: '10% OFF', dateRange: '2025',
          description: 'Test', promotionType: 'PERCENTAGE',
          discountValue: 10, minPurchase: 0,
        );
        // 1000000 - 10% = 900000
        expect(controller.calculateTotalAmount(promo: promo), equals(900000));
      });

      test('calculateTotalAmount - mengurangi diskon promo CASHBACK', () {
        controller.tickets = [makeTicket(price: 1000000, serviceFee: 0)];
        final promo = Promotion(
          id: 'P2', title: 'Cashback 50K', dateRange: '2025',
          description: 'Test', promotionType: 'CASHBACK',
          discountValue: 50000, minPurchase: 0,
        );
        expect(controller.calculateTotalAmount(promo: promo), equals(950000));
      });

      test('calculateTotalAmount - formatRp menghasilkan format Rp yang benar', () {
        expect(controller.formatRp(1500000), equals('Rp. 1.500.000'));
        expect(controller.formatRp(500000), equals('Rp. 500.000'));
      });
    });
  });
}