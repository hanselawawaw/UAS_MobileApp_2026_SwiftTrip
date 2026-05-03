import 'package:flutter_test/flutter_test.dart';
import 'package:swifttrip_frontend/screens/checkout/checkout_controller.dart';
import 'package:swifttrip_frontend/screens/checkout/models/checkout_details_model.dart';
import 'package:swifttrip_frontend/screens/checkout/models/payment_method_model.dart';

// ============================================================
// CART - PAYMENT METHOD UNIT TEST
// Tabel Coverage:
//   Widget          | Class Method
//   ----------------|----------------------
//   BottomSheet     | showPaymentOptions()
//   RadioListTile   | selectPaymentMethod()
//                   | onChanged()
//   ElevatedButton  | processPayment()
// ============================================================

// Helper: simulasi logika payment method murni
class PaymentMethodController {
  PaymentMethodModel? selectedMethod;
  bool bottomSheetShown = false;

  final List<PaymentMethodModel> availableMethods = [
    PaymentMethodModel(id: 'CREDIT_CARD', name: 'Credit Card'),
    PaymentMethodModel(id: 'BANK_TRANSFER', name: 'Bank Transfer'),
    PaymentMethodModel(id: 'E_WALLET', name: 'E-Wallet'),
  ];

  void showPaymentOptions() => bottomSheetShown = true;

  void selectPaymentMethod(PaymentMethodModel method) {
    selectedMethod = method;
  }

  void onChanged(PaymentMethodModel? method) {
    selectedMethod = method;
  }

  bool validateCardDetails({
    required String cardNumber,
    required String expiry,
    required String cvc,
  }) {
    final cleanCard = cardNumber.replaceAll(' ', '');
    return cleanCard.length == 16 && expiry.length == 5 && cvc.length == 3;
  }
}

// Helper: buat CheckoutDetailsModel dummy
CheckoutDetailsModel makeDetails() => const CheckoutDetailsModel(
  tickets: [],
  purchaseItems: [],
  totalPrice: 'Rp. 1.500.000',
  discountTotal: 0,
);

void main() {
  group('Cart Payment Method Unit Tests', () {
    late PaymentMethodController controller;
    late CheckoutController checkoutController;

    setUp(() {
      controller = PaymentMethodController();
      checkoutController = CheckoutController();
      checkoutController.init(makeDetails());
    });

    tearDown(() => checkoutController.dispose());

    // ----------------------------------------------------------
    // WIDGET: BottomSheet
    // METHOD: showPaymentOptions()
    // ----------------------------------------------------------
    group('showPaymentOptions()', () {
      test('showPaymentOptions - bottomSheet belum ditampilkan sebelum dipanggil', () {
        expect(controller.bottomSheetShown, isFalse);
      });

      test('showPaymentOptions - menandai bottomSheetShown menjadi true', () {
        controller.showPaymentOptions();
        expect(controller.bottomSheetShown, isTrue);
      });

      test('showPaymentOptions - available methods berisi 3 opsi', () {
        expect(controller.availableMethods.length, equals(3));
      });

      test('showPaymentOptions - Credit Card ada di pilihan', () {
        final names = controller.availableMethods.map((m) => m.name).toList();
        expect(names, contains('Credit Card'));
      });

      test('showPaymentOptions - Bank Transfer ada di pilihan', () {
        final names = controller.availableMethods.map((m) => m.name).toList();
        expect(names, contains('Bank Transfer'));
      });

      test('showPaymentOptions - E-Wallet ada di pilihan', () {
        final names = controller.availableMethods.map((m) => m.name).toList();
        expect(names, contains('E-Wallet'));
      });
    });

    // ----------------------------------------------------------
    // WIDGET: RadioListTile
    // METHOD: selectPaymentMethod()
    // ----------------------------------------------------------
    group('selectPaymentMethod()', () {
      test('selectPaymentMethod - selectedMethod null sebelum dipilih', () {
        expect(controller.selectedMethod, isNull);
      });

      test('selectPaymentMethod - menyimpan metode yang dipilih', () {
        final method = controller.availableMethods.first;
        controller.selectPaymentMethod(method);
        expect(controller.selectedMethod, equals(method));
      });

      test('selectPaymentMethod - dapat mengganti metode yang dipilih', () {
        controller.selectPaymentMethod(controller.availableMethods[0]);
        controller.selectPaymentMethod(controller.availableMethods[1]);
        expect(controller.selectedMethod?.id, equals('BANK_TRANSFER'));
      });

      test('selectPaymentMethod - ID metode tersimpan dengan benar', () {
        controller.selectPaymentMethod(
          PaymentMethodModel(id: 'CREDIT_CARD', name: 'Credit Card'),
        );
        expect(controller.selectedMethod?.id, equals('CREDIT_CARD'));
      });
    });

    // ----------------------------------------------------------
    // WIDGET: RadioListTile
    // METHOD: onChanged()
    // ----------------------------------------------------------
    group('onChanged()', () {
      test('onChanged - mengubah selectedMethod saat nilai berbeda', () {
        final credit = controller.availableMethods[0];
        controller.onChanged(credit);
        expect(controller.selectedMethod, equals(credit));
      });

      test('onChanged(null) - mengosongkan selectedMethod', () {
        controller.onChanged(controller.availableMethods[0]);
        controller.onChanged(null);
        expect(controller.selectedMethod, isNull);
      });

      test('onChanged - dipanggil berulang mengupdate selectedMethod', () {
        controller.onChanged(controller.availableMethods[0]);
        controller.onChanged(controller.availableMethods[2]);
        expect(controller.selectedMethod?.id, equals('E_WALLET'));
      });
    });

    // ----------------------------------------------------------
    // WIDGET: ElevatedButton
    // METHOD: processPayment()
    // ----------------------------------------------------------
    group('processPayment()', () {
      test('processPayment - validasi gagal jika card number kurang dari 16 digit', () {
        final valid = controller.validateCardDetails(
          cardNumber: '1234 5678',
          expiry: '12/25',
          cvc: '123',
        );
        expect(valid, isFalse);
      });

      test('processPayment - validasi gagal jika expiry tidak 5 karakter', () {
        final valid = controller.validateCardDetails(
          cardNumber: '1234 5678 9012 3456',
          expiry: '1225',
          cvc: '123',
        );
        expect(valid, isFalse);
      });

      test('processPayment - validasi gagal jika CVC tidak 3 karakter', () {
        final valid = controller.validateCardDetails(
          cardNumber: '1234 5678 9012 3456',
          expiry: '12/25',
          cvc: '12',
        );
        expect(valid, isFalse);
      });

      test('processPayment - validasi berhasil dengan data lengkap', () {
        final valid = controller.validateCardDetails(
          cardNumber: '1234 5678 9012 3456',
          expiry: '12/25',
          cvc: '123',
        );
        expect(valid, isTrue);
      });

      test('processPayment - CheckoutController.isLoading false sebelum proses', () {
        expect(checkoutController.isLoading, isFalse);
      });

      test('processPayment - lastErrorMessage null sebelum proses', () {
        expect(checkoutController.lastErrorMessage, isNull);
      });

      test('processPayment - error jika card details tidak lengkap', () async {
        checkoutController.cardNumberController.text = '1234';
        checkoutController.expiryDateController.text = '12/25';
        checkoutController.cvcController.text = '123';

        final result = await checkoutController.confirmPurchase();
        expect(result, isFalse);
        expect(checkoutController.lastErrorMessage, isNotNull);
      });

      test('processPayment - PaymentMethodModel.toJson() benar', () {
        final method = PaymentMethodModel(id: 'CC', name: 'Credit Card');
        final json = method.toJson();
        expect(json['id'], equals('CC'));
        expect(json['name'], equals('Credit Card'));
      });
    });
  });
}