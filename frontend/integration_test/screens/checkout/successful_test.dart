import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:swifttrip_frontend/screens/checkout/successful.dart';
import 'package:swifttrip_frontend/screens/checkout/models/checkout_details_model.dart';
import 'package:swifttrip_frontend/screens/cart/models/cart_models.dart';
import 'package:swifttrip_frontend/providers/cart_provider.dart';
import 'package:swifttrip_frontend/providers/language_provider.dart';
import 'package:swifttrip_frontend/providers/wishlist_provider.dart';

// ============================================================
// CART - PAYMENT SUCCESSFUL INTEGRATION TEST
// Tabel Coverage:
//   Widget          | Class Method
//   ----------------|----------------------
//   Icon            | displaySuccessIcon()
//   Text            | displayTransactionId()
//   ElevatedButton  | navigateToHome()
// ============================================================

CheckoutDetailsModel makeDetails() => const CheckoutDetailsModel(
  tickets: [
    CartTicket(
      bookingId: 'TXN-20250501-001',
      type: 'Plane Ticket',
      classLabel: 'Economy',
      priceRp: 1500000,
    ),
  ],
  purchaseItems: [],
  totalPrice: 'Rp. 1.500.000',
  discountTotal: 0,
);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('SuccessfulPage Integration Tests', () {
    Widget buildApp() {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => LanguageProvider()),
          ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ],
        child: MaterialApp(
          home: SuccessfulPage(details: makeDetails()),
        ),
      );
    }

    // ----------------------------------------------------------
    // Icon + displaySuccessIcon()
    // ----------------------------------------------------------
    testWidgets(
        '[Icon] displaySuccessIcon() - SuccessfulPage tampil dengan animasi',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();

      expect(find.byType(SuccessfulPage), findsOneWidget);
    });

    testWidgets(
        '[Icon] displaySuccessIcon() - ScaleTransition berjalan untuk SuccessCheckIcon',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byType(ScaleTransition), findsWidgets);
    });

    testWidgets(
        '[Icon] displaySuccessIcon() - FadeTransition berjalan untuk teks',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byType(FadeTransition), findsWidgets);
    });

    testWidgets(
        '[Icon] displaySuccessIcon() - Animasi selesai dalam 600ms',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump(const Duration(milliseconds: 600));

      // Animasi controller forward selesai
      expect(find.byType(SuccessfulPage), findsOneWidget);
    });

    // ----------------------------------------------------------
    // Text + displayTransactionId()
    // ----------------------------------------------------------
    testWidgets(
        '[Text] displayTransactionId() - Teks "Payment Successful" tampil',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('Payment Successful'), findsOneWidget);
    });

    testWidgets(
        '[Text] displayTransactionId() - FadeTransition membungkus teks Payment Successful',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(FadeTransition), findsWidgets);
      expect(find.text('Payment Successful'), findsOneWidget);
    });

    testWidgets(
        '[Text] displayTransactionId() - Background color halaman putih abu-abu',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
      expect(scaffold.backgroundColor, equals(const Color(0xFFF6F6F6)));
    });

    // ----------------------------------------------------------
    // ElevatedButton + navigateToHome()
    // ----------------------------------------------------------
    testWidgets(
        '[ElevatedButton] navigateToHome() - Auto navigasi ke PaymentDetailPage '
        'setelah 1000ms',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());

      // Sebelum 1000ms = masih di SuccessfulPage
      await tester.pump(const Duration(milliseconds: 800));
      expect(find.byType(SuccessfulPage), findsOneWidget);

      // Setelah 1000ms + transition 400ms = navigasi selesai
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.byType(SuccessfulPage), findsNothing);
    });

    testWidgets(
        '[ElevatedButton] navigateToHome() - Navigasi menggunakan pushReplacement '
        '(tidak bisa back ke SuccessfulPage)',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Setelah navigasi, SuccessfulPage tidak ada
      expect(find.byType(SuccessfulPage), findsNothing);
    });

    testWidgets(
        '[ElevatedButton] navigateToHome() - Tidak crash selama durasi animasi + navigasi',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());

      // Jalankan semua frame
      await tester.pump(Duration.zero);
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump(const Duration(milliseconds: 1000));
      await tester.pumpAndSettle();

      // Tidak ada exception = test lulus
      expect(tester.takeException(), isNull);
    });
  });
}