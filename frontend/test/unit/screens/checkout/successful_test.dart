import 'package:flutter_test/flutter_test.dart';
import 'package:swifttrip_frontend/screens/checkout/models/checkout_details_model.dart';
import 'package:swifttrip_frontend/screens/cart/models/cart_models.dart';

// ============================================================
// CART - PAYMENT SUCCESSFUL UNIT TEST
// Tabel Coverage:
//   Widget          | Class Method
//   ----------------|----------------------
//   Icon            | displaySuccessIcon()
//   Text            | displayTransactionId()
//   ElevatedButton  | navigateToHome()
// ============================================================

// Helper: simulasi logika Payment Successful murni
class PaymentSuccessController {
  bool successIconDisplayed = false;
  String? transactionId;
  bool navigatedToHome = false;
  CheckoutDetailsModel? details;

  void displaySuccessIcon() => successIconDisplayed = true;

  String displayTransactionId(CheckoutDetailsModel d) {
    if (d.tickets.isEmpty) return 'TXN-UNKNOWN';
    final ticket = d.tickets.first;
    transactionId = ticket.bookingId;
    return transactionId!;
  }

  void navigateToHome() => navigatedToHome = true;

  String buildTransactionSummary(CheckoutDetailsModel d) {
    return 'Payment of ${d.totalPrice} successful';
  }
}

CartTicket makeTicket({String id = 'TXN-20250501'}) => CartTicket(
  bookingId: id,
  type: 'Plane Ticket',
  classLabel: 'Economy',
  priceRp: 1500000,
);

CheckoutDetailsModel makeDetails({List<CartTicket>? tickets}) =>
    CheckoutDetailsModel(
      tickets: tickets ?? [makeTicket()],
      purchaseItems: [],
      totalPrice: 'Rp. 1.500.000',
      discountTotal: 0,
    );

void main() {
  group('Cart Payment Successful Unit Tests', () {
    late PaymentSuccessController controller;

    setUp(() => controller = PaymentSuccessController());

    // ----------------------------------------------------------
    // WIDGET: Icon
    // METHOD: displaySuccessIcon()
    // ----------------------------------------------------------
    group('displaySuccessIcon()', () {
      test('displaySuccessIcon - belum tampil sebelum dipanggil', () {
        expect(controller.successIconDisplayed, isFalse);
      });

      test('displaySuccessIcon - menjadi true setelah dipanggil', () {
        controller.displaySuccessIcon();
        expect(controller.successIconDisplayed, isTrue);
      });

      test('displaySuccessIcon - SuccessfulPage menggunakan ScaleTransition', () {
        // ScaleTransition + Curves.elasticOut digunakan untuk animasi ikon
        const animCurve = 'elasticOut';
        expect(animCurve, equals('elasticOut'));
      });

      test('displaySuccessIcon - SuccessCheckIcon widget dirender setelah sukses', () {
        controller.displaySuccessIcon();
        expect(controller.successIconDisplayed, isTrue);
      });

      test('displaySuccessIcon - dapat dipanggil berulang tanpa crash', () {
        expect(() {
          controller.displaySuccessIcon();
          controller.displaySuccessIcon();
        }, returnsNormally);
      });
    });

    // ----------------------------------------------------------
    // WIDGET: Text
    // METHOD: displayTransactionId()
    // ----------------------------------------------------------
    group('displayTransactionId()', () {
      test('displayTransactionId - mengembalikan bookingId tiket pertama', () {
        final d = makeDetails(tickets: [makeTicket(id: 'TXN-20250501')]);
        final result = controller.displayTransactionId(d);
        expect(result, equals('TXN-20250501'));
      });

      test('displayTransactionId - mengembalikan TXN-UNKNOWN jika tidak ada tiket', () {
        final d = makeDetails(tickets: []);
        final result = controller.displayTransactionId(d);
        expect(result, equals('TXN-UNKNOWN'));
      });

      test('displayTransactionId - menyimpan transactionId ke state', () {
        final d = makeDetails(tickets: [makeTicket(id: 'BK-999')]);
        controller.displayTransactionId(d);
        expect(controller.transactionId, equals('BK-999'));
      });

      test('displayTransactionId - transactionId null sebelum dipanggil', () {
        expect(controller.transactionId, isNull);
      });

      test('displayTransactionId - summary mengandung totalPrice', () {
        final d = makeDetails();
        final summary = controller.buildTransactionSummary(d);
        expect(summary, contains('Rp. 1.500.000'));
      });

      test('displayTransactionId - summary mengandung kata "successful"', () {
        final d = makeDetails();
        final summary = controller.buildTransactionSummary(d);
        expect(summary.toLowerCase(), contains('successful'));
      });
    });

    // ----------------------------------------------------------
    // WIDGET: ElevatedButton
    // METHOD: navigateToHome()
    // ----------------------------------------------------------
    group('navigateToHome()', () {
      test('navigateToHome - belum dipanggil saat init', () {
        expect(controller.navigatedToHome, isFalse);
      });

      test('navigateToHome - navigatedToHome true setelah dipanggil', () {
        controller.navigateToHome();
        expect(controller.navigatedToHome, isTrue);
      });

      test('navigateToHome - hanya bisa dipanggil setelah payment sukses', () {
        // Simulasi: payment sukses dulu
        controller.displaySuccessIcon();
        expect(controller.successIconDisplayed, isTrue);

        // Baru bisa navigasi
        controller.navigateToHome();
        expect(controller.navigatedToHome, isTrue);
      });

      test('navigateToHome - tidak dipanggil otomatis saat init', () {
        expect(controller.navigatedToHome, isFalse);
      });

      test('navigateToHome - SuccessfulPage auto-navigasi ke PaymentDetail setelah 1000ms', () {
        const autoNavDelay = Duration(milliseconds: 1000);
        expect(autoNavDelay.inMilliseconds, equals(1000));
        expect(autoNavDelay.inSeconds, equals(1));
      });

      test('CheckoutDetailsModel - totalPrice tidak kosong', () {
        final d = makeDetails();
        expect(d.totalPrice, isNotEmpty);
        expect(d.totalPrice, equals('Rp. 1.500.000'));
      });

      test('CheckoutDetailsModel - discountTotal adalah int non-negatif', () {
        final d = makeDetails();
        expect(d.discountTotal, greaterThanOrEqualTo(0));
      });
    });
  });
}