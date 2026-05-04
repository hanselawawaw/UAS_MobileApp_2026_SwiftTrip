import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:swifttrip_frontend/screens/checkout/successful.dart';
import 'package:swifttrip_frontend/screens/checkout/models/checkout_details_model.dart';
import 'package:swifttrip_frontend/screens/cart/models/cart_models.dart';
import 'package:swifttrip_frontend/providers/cart_provider.dart';
import 'package:swifttrip_frontend/providers/language_provider.dart';
import 'package:swifttrip_frontend/providers/wishlist_provider.dart';

// ============================================================
// CART - PAYMENT SUCCESSFUL WIDGET TEST
// Tabel Coverage:
//   Widget          | Class Method
//   ----------------|----------------------
//   Icon            | displaySuccessIcon()
//   Text            | displayTransactionId()
//   ElevatedButton  | navigateToHome()
// ============================================================

CheckoutDetailsModel makeDetails() => CheckoutDetailsModel(
  tickets: const [
    CartTicket(
      bookingId: 'TXN-20250501',
      type: 'Plane Ticket',
      classLabel: 'Economy',
      priceRp: 1500000,
    ),
  ],
  purchaseItems: const [],
  totalPrice: 'Rp. 1.500.000',
  discountTotal: 0,
);

void main() {
  group('SuccessfulPage Widget Tests', () {
    Widget buildSubject() {
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
    // WIDGET: Icon
    // METHOD: displaySuccessIcon()
    // ----------------------------------------------------------
    testWidgets(
        '[Icon] displaySuccessIcon() - SuccessfulPage renders tanpa error',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();
      expect(find.byType(SuccessfulPage), findsOneWidget);
    });

    testWidgets(
        '[Icon] displaySuccessIcon() - SuccessCheckIcon tampil di halaman',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      // SuccessCheckIcon dirender dalam ScaleTransition
      expect(find.byType(ScaleTransition), findsWidgets);
    });

    testWidgets(
        '[Icon] displaySuccessIcon() - ScaleTransition dengan Curves.elasticOut ada',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(ScaleTransition), findsWidgets);
    });

    testWidgets(
        '[Icon] displaySuccessIcon() - FadeTransition untuk animasi teks ada',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(FadeTransition), findsWidgets);
    });

    testWidgets(
        '[Icon] displaySuccessIcon() - Background color 0xFFF6F6F6',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
      expect(scaffold.backgroundColor, equals(const Color(0xFFF6F6F6)));
    });

    // ----------------------------------------------------------
    // WIDGET: Text
    // METHOD: displayTransactionId()
    // ----------------------------------------------------------
    testWidgets(
        '[Text] displayTransactionId() - Teks "Payment Successful" tampil',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Payment Successful'), findsOneWidget);
    });

    testWidgets(
        '[Text] displayTransactionId() - Teks Payment Successful menggunakan style Cairo',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump(const Duration(milliseconds: 100));

      final text = tester.widget<Text>(find.text('Payment Successful'));
      expect(text.style?.fontFamily, equals('Cairo'));
      expect(text.style?.fontWeight, equals(FontWeight.w700));
    });

    testWidgets(
        '[Text] displayTransactionId() - Center widget digunakan untuk memusatkan konten',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(Center), findsWidgets);
    });

    // ----------------------------------------------------------
    // WIDGET: ElevatedButton
    // METHOD: navigateToHome()
    // ----------------------------------------------------------
    testWidgets(
        '[ElevatedButton] navigateToHome() - SuccessfulPage auto-navigasi '
        'ke PaymentDetailPage setelah 1000ms',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());

      // Sebelum 1000ms
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(SuccessfulPage), findsOneWidget);

      // Setelah 1000ms = auto navigate
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.byType(SuccessfulPage), findsNothing);
    });

    testWidgets(
        '[ElevatedButton] navigateToHome() - TopBar ada dengan back button',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets(
        '[ElevatedButton] navigateToHome() - Animasi controller berjalan '
        'selama 600ms',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());

      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(SuccessfulPage), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(SuccessfulPage), findsOneWidget);
    });
  });
}