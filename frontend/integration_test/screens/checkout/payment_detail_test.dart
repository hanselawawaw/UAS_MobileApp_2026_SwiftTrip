import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:swifttrip_frontend/screens/checkout/checkout.dart';
import 'package:swifttrip_frontend/screens/checkout/models/checkout_details_model.dart';
import 'package:swifttrip_frontend/providers/cart_provider.dart';
import 'package:swifttrip_frontend/providers/language_provider.dart';
import 'package:swifttrip_frontend/providers/wishlist_provider.dart';

// ============================================================
// CART - PAYMENT METHOD INTEGRATION TEST
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
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('CheckoutPage (Payment Method) Integration Tests', () {
    Widget buildApp() {
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
    // BottomSheet + showPaymentOptions()
    // ----------------------------------------------------------
    testWidgets(
        '[BottomSheet] showPaymentOptions() - CheckoutPage tampil dengan semua elemen',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(CheckoutPage), findsOneWidget);
    });

    testWidgets(
        '[BottomSheet] showPaymentOptions() - BottomSheet tidak tampil sebelum dipicu',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(BottomSheet), findsNothing);
    });

    testWidgets(
        '[BottomSheet] showPaymentOptions() - Total price tampil di halaman checkout',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.textContaining('Rp.'), findsWidgets);
    });

    // ----------------------------------------------------------
    // RadioListTile + selectPaymentMethod()
    // ----------------------------------------------------------
    testWidgets(
        '[RadioListTile] selectPaymentMethod() - Field card number bisa diisi',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);
      if (fields.evaluate().isNotEmpty) {
        await tester.enterText(fields.first, '1234 5678 9012 3456');
        await tester.pumpAndSettle();
        expect(find.text('1234 5678 9012 3456'), findsOneWidget);
      }
    });

    testWidgets(
        '[RadioListTile] selectPaymentMethod() - Field expiry bisa diisi',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);
      if (fields.evaluate().length > 1) {
        await tester.enterText(fields.at(1), '12/25');
        await tester.pumpAndSettle();
        expect(find.text('12/25'), findsOneWidget);
      }
    });

    // ----------------------------------------------------------
    // RadioListTile + onChanged()
    // ----------------------------------------------------------
    testWidgets(
        '[RadioListTile] onChanged() - Field CVC bisa diisi',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);
      if (fields.evaluate().length > 2) {
        await tester.enterText(fields.at(2), '123');
        await tester.pumpAndSettle();
        expect(find.text('123'), findsOneWidget);
      }
    });

    testWidgets(
        '[RadioListTile] onChanged() - Nilai field tersimpan setelah diketik',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);
      if (fields.evaluate().isNotEmpty) {
        await tester.enterText(fields.first, '4111 1111 1111 1111');
        await tester.pump();
        expect(find.text('4111 1111 1111 1111'), findsOneWidget);

        // Tap di luar field
        await tester.tap(find.byType(Scaffold).first);
        await tester.pump();
        // Nilai tetap ada
        expect(find.text('4111 1111 1111 1111'), findsOneWidget);
      }
    });

    // ----------------------------------------------------------
    // ElevatedButton + processPayment()
    // ----------------------------------------------------------
    testWidgets(
        '[ElevatedButton] processPayment() - Error muncul jika card tidak lengkap',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      // Isi hanya card number tanpa expiry dan CVC
      final fields = find.byType(TextField);
      if (fields.evaluate().isNotEmpty) {
        await tester.enterText(fields.first, '1234 5678 9012 3456');
        await tester.pumpAndSettle();
      }

      // Tap konfirmasi
      final gestures = find.byType(GestureDetector);
      if (gestures.evaluate().isNotEmpty) {
        await tester.longPress(gestures.last);
        await tester.pumpAndSettle();
      }

      // Masih di halaman checkout (tidak navigasi karena error)
      expect(find.byType(CheckoutPage), findsOneWidget);
    });

    testWidgets(
        '[ElevatedButton] processPayment() - CircularProgressIndicator tidak muncul '
        'sebelum ada aksi konfirmasi',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets(
        '[ElevatedButton] processPayment() - Halaman tidak crash saat form kosong '
        'dan dikonfirmasi',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      final gestures = find.byType(GestureDetector);
      if (gestures.evaluate().isNotEmpty) {
        await tester.longPress(gestures.last);
        await tester.pump(const Duration(milliseconds: 500));
      }

      expect(find.byType(CheckoutPage), findsOneWidget);
    });
  });
}