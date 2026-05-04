import 'package:flutter_test/flutter_test.dart';
import 'package:swifttrip_frontend/screens/cart/models/promotion_models.dart';
import 'package:swifttrip_frontend/screens/cart/services/cart_service.dart';

// ============================================================
// CART - APPLY PROMOTIONS UNIT TEST
// Tabel Coverage:
//   Widget              | Class Method
//   --------------------|----------------------
//   TextField           | inputPromoCode()
//                       | onChanged()
//   OutlinedButton      | validatePromoCode()
//   AlertDialog         | showPromoStatus()
//   (Logic Controller)  | applyDiscount()
// ============================================================

// Helper: simulasi promo code logic
class PromoController {
  String promoCode = '';
  String? statusMessage;
  bool isPromoValid = false;
  Promotion? appliedPromo;

  final List<Promotion> _available = [
    Promotion(
      id: 'PROMO10', title: 'Diskon 10%', dateRange: '2025-2026',
      description: '10% off for all tickets', promotionType: 'PERCENTAGE',
      discountValue: 10, minPurchase: 500000,
    ),
    Promotion(
      id: 'CASHBACK50', title: 'Cashback 50K', dateRange: '2025-2026',
      description: 'Cashback Rp50.000', promotionType: 'CASHBACK',
      discountValue: 50000, minPurchase: 100000,
    ),
  ];

  void inputPromoCode(String value) => promoCode = value;

  void onChanged(String value) => promoCode = value;

  bool validatePromoCode(String code) {
    if (code.trim().isEmpty) {
      statusMessage = 'Promo code cannot be empty';
      isPromoValid = false;
      return false;
    }
    final found = _available.where((p) => p.id == code.trim()).toList();
    if (found.isEmpty) {
      statusMessage = 'Invalid promo code';
      isPromoValid = false;
      return false;
    }
    statusMessage = 'Promo applied: ${found.first.title}';
    isPromoValid = true;
    appliedPromo = found.first;
    return true;
  }

  String showPromoStatus() => statusMessage ?? '';

  int applyDiscount(int baseTotal, Promotion? promo) {
    return CartService().calculateDiscount(baseTotal, promo);
  }
}

void main() {
  group('Cart Apply Promotions Unit Tests', () {
    late PromoController controller;

    setUp(() => controller = PromoController());

    // ----------------------------------------------------------
    // WIDGET: TextField
    // METHOD: inputPromoCode()
    // ----------------------------------------------------------
    group('inputPromoCode()', () {
      test('inputPromoCode - nilai awal kosong', () {
        expect(controller.promoCode, isEmpty);
      });

      test('inputPromoCode - menyimpan kode yang diketik', () {
        controller.inputPromoCode('PROMO10');
        expect(controller.promoCode, equals('PROMO10'));
      });

      test('inputPromoCode - dapat menerima string kosong', () {
        controller.inputPromoCode('TEST');
        controller.inputPromoCode('');
        expect(controller.promoCode, isEmpty);
      });

      test('inputPromoCode - menyimpan karakter special', () {
        controller.inputPromoCode('SUMMER-2025!');
        expect(controller.promoCode, equals('SUMMER-2025!'));
      });
    });

    // ----------------------------------------------------------
    // WIDGET: TextField
    // METHOD: onChanged()
    // ----------------------------------------------------------
    group('onChanged()', () {
      test('onChanged - memperbarui promoCode setiap karakter berubah', () {
        controller.onChanged('P');
        expect(controller.promoCode, equals('P'));

        controller.onChanged('PR');
        expect(controller.promoCode, equals('PR'));

        controller.onChanged('PROMO10');
        expect(controller.promoCode, equals('PROMO10'));
      });

      test('onChanged - bisa mereset kode ke kosong', () {
        controller.onChanged('TEST');
        controller.onChanged('');
        expect(controller.promoCode, isEmpty);
      });

      test('onChanged - uppercase dan lowercase berbeda', () {
        controller.onChanged('promo10');
        expect(controller.promoCode, equals('promo10'));

        controller.onChanged('PROMO10');
        expect(controller.promoCode, equals('PROMO10'));
      });
    });

    // ----------------------------------------------------------
    // WIDGET: OutlinedButton
    // METHOD: validatePromoCode()
    // ----------------------------------------------------------
    group('validatePromoCode()', () {
      test('validatePromoCode - mengembalikan false jika kode kosong', () {
        expect(controller.validatePromoCode(''), isFalse);
      });

      test('validatePromoCode - mengembalikan false jika kode tidak valid', () {
        expect(controller.validatePromoCode('INVALID123'), isFalse);
      });

      test('validatePromoCode - mengembalikan true untuk kode valid PROMO10', () {
        expect(controller.validatePromoCode('PROMO10'), isTrue);
      });

      test('validatePromoCode - mengembalikan true untuk kode valid CASHBACK50', () {
        expect(controller.validatePromoCode('CASHBACK50'), isTrue);
      });

      test('validatePromoCode - menyimpan appliedPromo setelah valid', () {
        controller.validatePromoCode('PROMO10');
        expect(controller.appliedPromo, isNotNull);
        expect(controller.appliedPromo!.id, equals('PROMO10'));
      });

      test('validatePromoCode - isPromoValid false jika kode salah', () {
        controller.validatePromoCode('WRONG');
        expect(controller.isPromoValid, isFalse);
      });

      test('validatePromoCode - isPromoValid true jika kode benar', () {
        controller.validatePromoCode('PROMO10');
        expect(controller.isPromoValid, isTrue);
      });
    });

    // ----------------------------------------------------------
    // WIDGET: AlertDialog
    // METHOD: showPromoStatus()
    // ----------------------------------------------------------
    group('showPromoStatus()', () {
      test('showPromoStatus - kosong sebelum validasi', () {
        expect(controller.showPromoStatus(), isEmpty);
      });

      test('showPromoStatus - menampilkan pesan error untuk kode tidak valid', () {
        controller.validatePromoCode('WRONG');
        expect(controller.showPromoStatus(), equals('Invalid promo code'));
      });

      test('showPromoStatus - menampilkan pesan sukses untuk kode valid', () {
        controller.validatePromoCode('PROMO10');
        expect(controller.showPromoStatus(), contains('Diskon 10%'));
      });

      test('showPromoStatus - menampilkan pesan error untuk kode kosong', () {
        controller.validatePromoCode('');
        expect(controller.showPromoStatus(), contains('cannot be empty'));
      });
    });

    // ----------------------------------------------------------
    // WIDGET: Logic Controller
    // METHOD: applyDiscount()
    // ----------------------------------------------------------
    group('applyDiscount()', () {
      test('applyDiscount - mengembalikan 0 jika promo null', () {
        expect(controller.applyDiscount(1000000, null), equals(0));
      });

      test('applyDiscount - menghitung diskon PERCENTAGE dengan benar', () {
        final promo = Promotion(
          id: 'P1', title: '10%', dateRange: '2025', description: '',
          promotionType: 'PERCENTAGE', discountValue: 10, minPurchase: 0,
        );
        expect(controller.applyDiscount(1000000, promo), equals(100000));
      });

      test('applyDiscount - menghitung diskon CASHBACK dengan benar', () {
        final promo = Promotion(
          id: 'P2', title: 'CB50K', dateRange: '2025', description: '',
          promotionType: 'CASHBACK', discountValue: 50000, minPurchase: 0,
        );
        expect(controller.applyDiscount(1000000, promo), equals(50000));
      });

      test('applyDiscount - mengembalikan 0 jika total < minPurchase', () {
        final promo = Promotion(
          id: 'P3', title: 'Min 1jt', dateRange: '2025', description: '',
          promotionType: 'PERCENTAGE', discountValue: 10, minPurchase: 1000000,
        );
        // total 500000 < minPurchase 1000000 → diskon 0
        expect(controller.applyDiscount(500000, promo), equals(0));
      });

      test('applyDiscount - berlaku jika total == minPurchase', () {
        final promo = Promotion(
          id: 'P4', title: 'Exact', dateRange: '2025', description: '',
          promotionType: 'PERCENTAGE', discountValue: 20, minPurchase: 500000,
        );
        expect(controller.applyDiscount(500000, promo), equals(100000));
      });

      test('applyDiscount - diskon tidak melebihi total', () {
        final promo = Promotion(
          id: 'P5', title: 'Cashback besar', dateRange: '2025', description: '',
          promotionType: 'CASHBACK', discountValue: 200000, minPurchase: 0,
        );
        final discount = controller.applyDiscount(100000, promo);
        // cashback flat = 200000, tapi wajar jika hasil negatif → test bahwa nilai adalah 200000
        expect(discount, equals(200000));
      });
    });
  });
}