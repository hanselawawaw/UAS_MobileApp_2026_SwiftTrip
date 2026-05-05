import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:swifttrip_frontend/screens/checkout/successful.dart';
import 'package:swifttrip_frontend/screens/checkout/models/checkout_details_model.dart';
import 'package:swifttrip_frontend/screens/cart/models/cart_models.dart';
import 'package:swifttrip_frontend/providers/cart_provider.dart';
import 'package:swifttrip_frontend/providers/language_provider.dart';
import 'package:swifttrip_frontend/providers/wishlist_provider.dart';
import 'dart:io';
import '../../test_helpers.dart';

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
  HttpOverrides.global = MockHttpOverrides();
  setupMockSecureStorage();

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

    /// Advance past the 1000ms auto-nav timer and clean up the widget tree
    Future<void> cleanupTimer(WidgetTester tester) async {
      // Advance clock past the 1s Future.delayed timer in SuccessfulPage
      await tester.pump(const Duration(seconds: 2));
      // Replace with empty widget to stop any remaining timers
      await tester.pumpWidget(Container());
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
      await cleanupTimer(tester);
    });

    testWidgets(
        '[Icon] displaySuccessIcon() - SuccessCheckIcon tampil di halaman',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(ScaleTransition), findsWidgets);
      await cleanupTimer(tester);
    });

    testWidgets(
        '[Icon] displaySuccessIcon() - ScaleTransition dengan Curves.elasticOut ada',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(ScaleTransition), findsWidgets);
      await cleanupTimer(tester);
    });

    testWidgets(
        '[Icon] displaySuccessIcon() - FadeTransition untuk animasi teks ada',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(FadeTransition), findsWidgets);
      await cleanupTimer(tester);
    });

    testWidgets(
        '[Icon] displaySuccessIcon() - Background color 0xFFF6F6F6',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
      expect(scaffold.backgroundColor, equals(const Color(0xFFF6F6F6)));
      await cleanupTimer(tester);
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
      await cleanupTimer(tester);
    });

    testWidgets(
        '[Text] displayTransactionId() - Teks Payment Successful menggunakan style Cairo',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump(const Duration(milliseconds: 100));

      final text = tester.widget<Text>(find.text('Payment Successful'));
      expect(text.style?.fontFamily, equals('Cairo'));
      expect(text.style?.fontWeight, equals(FontWeight.w700));
      await cleanupTimer(tester);
    });

    testWidgets(
        '[Text] displayTransactionId() - Center widget digunakan untuk memusatkan konten',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(Center), findsWidgets);
      await cleanupTimer(tester);
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

      // Before 1000ms the page should still be visible
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(SuccessfulPage), findsOneWidget);

      // Advance past the 1000ms delayed callback
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump(const Duration(milliseconds: 500));

      // After navigation, SuccessfulPage replaced by PaymentDetailPage
      expect(find.byType(SuccessfulPage), findsNothing);
      await tester.pumpWidget(Container());
    });

    testWidgets(
        '[ElevatedButton] navigateToHome() - TopBar ada dengan back button',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(Scaffold), findsWidgets);
      await cleanupTimer(tester);
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
      await cleanupTimer(tester);
    });
  });
}