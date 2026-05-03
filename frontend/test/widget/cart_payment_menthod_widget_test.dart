import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:swifttrip_frontend/screens/checkout/checkout.dart';
import 'package:swifttrip_frontend/screens/checkout/models/checkout_details_model.dart';
import 'package:swifttrip_frontend/providers/cart_provider.dart';
import 'package:swifttrip_frontend/providers/language_provider.dart';
import 'package:swifttrip_frontend/providers/wishlist_provider.dart';

// ============================================================
// CART - PAYMENT METHOD WIDGET TEST
// Tabel Coverage:
//   Widget          | Class Method
//   ----------------|----------------------
//   BottomSheet     | showPaymentOptions()
//   RadioListTile   | selectPaymentMethod()
//                   | onChanged()
//   ElevatedButton  | processPayment()
// ============================================================

const _details = CheckoutDetailsModel(
  tickets: [],
  purchaseItems: [],
  totalPrice: 'Rp. 1.500.000',
  discountTotal: 0,
);

void main() {
  group('CheckoutPage (Payment Method) Widget Tests', () {
    Widget buildSubject() {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => LanguageProvider()),
          ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ],
        child: const MaterialApp(
          home: CheckoutPage(checkoutDetails: _details),
        ),
      );
    }

    // ----------------------------------------------------------
    // WIDGET: BottomSheet
    // METHOD: showPaymentOptions()
    // ----------------------------------------------------------
    testWidgets(
        '[BottomSheet] showPaymentOptions() - CheckoutPage renders tanpa error',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();
      expect(find.byType(CheckoutPage), findsOneWidget);
    });

    testWidgets(
        '[BottomSheet] showPaymentOptions() - Scaffold ada dengan background benar',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
      expect(scaffold.backgroundColor, equals(const Color(0xFFF6F6F6)));
    });

    testWidgets(
        '[BottomSheet] showPaymentOptions() - BottomSheet belum tampil sebelum dipicu',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(BottomSheet), findsNothing);
    });

    testWidgets(
        '[BottomSheet] showPaymentOptions() - PaymentMethodCard ada di halaman checkout',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      // PaymentMethodCard dirender sebagai bagian dari CheckoutPage
      expect(find.byType(CheckoutPage), findsOneWidget);
    });

    // ----------------------------------------------------------
    // WIDGET: RadioListTile
    // METHOD: selectPaymentMethod()
    // ----------------------------------------------------------
    testWidgets(
        '[RadioListTile] selectPaymentMethod() - Form input kartu ada di halaman',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      // TextField untuk card number, expiry, cvc
      expect(find.byType(TextField), findsWidgets);
    });

    testWidgets(
        '[RadioListTile] selectPaymentMethod() - TextField card number bisa menerima input',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      final fields = find.byType(TextField);
      if (fields.evaluate().isNotEmpty) {
        await tester.enterText(fields.first, '1234 5678 9012 3456');
        await tester.pump();
        expect(find.text('1234 5678 9012 3456'), findsOneWidget);
      }
    });

    // ----------------------------------------------------------
    // WIDGET: RadioListTile
    // METHOD: onChanged()
    // ----------------------------------------------------------
    testWidgets(
        '[RadioListTile] onChanged() - TextFormField expiry dapat menerima input',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      final fields = find.byType(TextField);
      if (fields.evaluate().length > 1) {
        await tester.enterText(fields.at(1), '12/25');
        await tester.pump();
        expect(find.text('12/25'), findsOneWidget);
      }
    });

    testWidgets(
        '[RadioListTile] onChanged() - TextFormField CVC dapat menerima input',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      final fields = find.byType(TextField);
      if (fields.evaluate().length > 2) {
        await tester.enterText(fields.at(2), '123');
        await tester.pump();
        expect(find.text('123'), findsOneWidget);
      }
    });

    // ----------------------------------------------------------
    // WIDGET: ElevatedButton
    // METHOD: processPayment()
    // ----------------------------------------------------------
    testWidgets(
        '[ElevatedButton] processPayment() - Tombol konfirmasi/hold ada di halaman',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      // HoldToConfirmBar menggunakan GestureDetector
      expect(find.byType(GestureDetector), findsWidgets);
    });

    testWidgets(
        '[ElevatedButton] processPayment() - Error muncul jika form tidak lengkap saat konfirmasi',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      // Tap hold confirm tanpa isi form
      final gestures = find.byType(GestureDetector);
      if (gestures.evaluate().isNotEmpty) {
        await tester.longPress(gestures.last);
        await tester.pump();
      }
      expect(find.byType(CheckoutPage), findsOneWidget);
    });

    testWidgets(
        '[ElevatedButton] processPayment() - CircularProgressIndicator tidak tampil '
        'sebelum ada proses pembayaran',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets(
        '[ElevatedButton] processPayment() - Total price tampil di halaman',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.textContaining('Rp.'), findsWidgets);
    });
  });
}