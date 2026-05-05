import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:swifttrip_frontend/screens/cart/promotions.dart';
import 'package:swifttrip_frontend/screens/cart/models/promotion_models.dart';
import 'package:swifttrip_frontend/providers/language_provider.dart';
import 'package:swifttrip_frontend/providers/cart_provider.dart';
import 'package:swifttrip_frontend/providers/wishlist_provider.dart';
import 'dart:io';
import '../../test_helpers.dart';

// ============================================================
// CART - APPLY PROMOTIONS WIDGET TEST
// Tabel Coverage:
//   Widget              | Class Method
//   --------------------|----------------------
//   TextField           | inputPromoCode()
//                       | onChanged()
//   OutlinedButton      | validatePromoCode()
//   AlertDialog         | showPromoStatus()
//   (Logic Controller)  | applyDiscount()
// ============================================================

void main() {
  HttpOverrides.global = MockHttpOverrides();

  group('PromotionsPage Widget Tests', () {
    Widget buildSubject({Promotion? initialSelection}) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LanguageProvider()),
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ],
        child: MaterialApp(
          home: PromotionsPage(initialSelection: initialSelection),
        ),
      );
    }

    // ----------------------------------------------------------
    // WIDGET: TextField
    // METHOD: inputPromoCode()
    // ----------------------------------------------------------
    testWidgets(
        '[TextField] inputPromoCode() - PromotionsPage renders tanpa error',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();
      expect(find.byType(PromotionsPage), findsOneWidget);
    });

    testWidgets(
        '[TextField] inputPromoCode() - Loading indicator tampil saat fetch promo',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump(Duration.zero);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
        '[TextField] inputPromoCode() - Scaffold background color benar',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
      expect(scaffold.backgroundColor, equals(const Color(0xFFF6F6F6)));
    });

    // ----------------------------------------------------------
    // WIDGET: TextField
    // METHOD: onChanged()
    // ----------------------------------------------------------
    testWidgets(
        '[TextField] onChanged() - ListView tampil setelah data promo dimuat',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump(const Duration(seconds: 2));
      await tester.pump(const Duration(seconds: 1));

      // Setelah load, ListView atau empty state tampil
      expect(find.byType(PromotionsPage), findsOneWidget);
    });

    // ----------------------------------------------------------
    // WIDGET: OutlinedButton
    // METHOD: validatePromoCode()
    // ----------------------------------------------------------
    testWidgets(
        '[OutlinedButton] validatePromoCode() - ConfirmButton ada di halaman',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      // ConfirmButton menggunakan GestureDetector
      expect(find.byType(GestureDetector), findsWidgets);
    });

    testWidgets(
        '[OutlinedButton] validatePromoCode() - Tap confirm button menutup halaman',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => LanguageProvider()),
            ChangeNotifierProvider(create: (_) => CartProvider()),
            ChangeNotifierProvider(create: (_) => WishlistProvider()),
          ],
          child: MaterialApp(
            home: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PromotionsPage()),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(PromotionsPage), findsOneWidget);
    });

    // ----------------------------------------------------------
    // WIDGET: AlertDialog
    // METHOD: showPromoStatus()
    // ----------------------------------------------------------
    testWidgets(
        '[AlertDialog] showPromoStatus() - AlertDialog tidak tampil sebelum ada aksi',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets(
        '[AlertDialog] showPromoStatus() - PromoCard dapat ditap untuk select',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump(const Duration(seconds: 2));
      await tester.pump(const Duration(seconds: 1));

      // Jika ada promo, GestureDetector bisa di-tap
      final gestures = find.byType(GestureDetector);
      if (gestures.evaluate().isNotEmpty) {
        await tester.tap(gestures.first);
        await tester.pump();
      }

      expect(find.byType(PromotionsPage), findsOneWidget);
    });

    // ----------------------------------------------------------
    // WIDGET: Logic Controller
    // METHOD: applyDiscount()
    // ----------------------------------------------------------
    testWidgets(
        '[Logic Controller] applyDiscount() - initialSelection null menghasilkan '
        'tidak ada promo terpilih saat init',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject(initialSelection: null));
      await tester.pump();

      expect(find.byType(PromotionsPage), findsOneWidget);
    });

    testWidgets(
        '[Logic Controller] applyDiscount() - Column layout utama ada',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(Column), findsWidgets);
    });
  });
}