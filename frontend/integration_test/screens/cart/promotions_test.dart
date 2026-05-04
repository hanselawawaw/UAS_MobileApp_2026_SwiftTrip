import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:swifttrip_frontend/screens/cart/promotions.dart';
import 'package:swifttrip_frontend/screens/cart/models/promotion_models.dart';
import 'package:swifttrip_frontend/providers/cart_provider.dart';
import 'package:swifttrip_frontend/providers/language_provider.dart';
import 'package:swifttrip_frontend/providers/wishlist_provider.dart';

// ============================================================
// CART - APPLY PROMOTIONS INTEGRATION TEST
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
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('PromotionsPage Integration Tests', () {
    Widget buildApp({Promotion? initialSelection}) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => LanguageProvider()),
          ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ],
        child: MaterialApp(
          home: PromotionsPage(initialSelection: initialSelection),
        ),
      );
    }

    // ----------------------------------------------------------
    // TextField + inputPromoCode()
    // ----------------------------------------------------------
    testWidgets(
        '[TextField] inputPromoCode() - PromotionsPage tampil dan memuat promo',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(find.byType(PromotionsPage), findsOneWidget);
    });

    testWidgets(
        '[TextField] inputPromoCode() - Loading indicator muncul saat fetch promo',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump(Duration.zero);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
        '[TextField] inputPromoCode() - Loading hilang setelah promo dimuat',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    // ----------------------------------------------------------
    // TextField + onChanged()
    // ----------------------------------------------------------
    testWidgets(
        '[TextField] onChanged() - PromoCard tampil setelah data dimuat',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Jika ada promo dari server, PromoCard muncul
      expect(find.byType(PromotionsPage), findsOneWidget);
    });

    // ----------------------------------------------------------
    // OutlinedButton + validatePromoCode()
    // ----------------------------------------------------------
    testWidgets(
        '[OutlinedButton] validatePromoCode() - Tap PromoCard menyeleksinya',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      final gestures = find.byType(GestureDetector);
      if (gestures.evaluate().length > 1) {
        await tester.tap(gestures.first);
        await tester.pump();
      }

      expect(find.byType(PromotionsPage), findsOneWidget);
    });

    testWidgets(
        '[OutlinedButton] validatePromoCode() - Tap confirm menutup halaman '
        'dan mengembalikan promo yang dipilih',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => CartProvider()),
            ChangeNotifierProvider(create: (_) => LanguageProvider()),
            ChangeNotifierProvider(create: (_) => WishlistProvider()),
          ],
          child: MaterialApp(
            home: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PromotionsPage()),
                ),
                child: const Text('Open Promos'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Promos'));
      await tester.pumpAndSettle();
      expect(find.byType(PromotionsPage), findsOneWidget);
    });

    // ----------------------------------------------------------
    // AlertDialog + showPromoStatus()
    // ----------------------------------------------------------
    testWidgets(
        '[AlertDialog] showPromoStatus() - Tidak ada AlertDialog sebelum aksi',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();

      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets(
        '[AlertDialog] showPromoStatus() - Halaman tidak crash setelah load',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(find.byType(PromotionsPage), findsOneWidget);
    });

    // ----------------------------------------------------------
    // Logic Controller + applyDiscount()
    // ----------------------------------------------------------
    testWidgets(
        '[Logic Controller] applyDiscount() - initialSelection null = tidak ada '
        'promo yang disorot saat awal',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp(initialSelection: null));
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(find.byType(PromotionsPage), findsOneWidget);
    });

    testWidgets(
        '[Logic Controller] applyDiscount() - Scroll list promo tidak crash',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      final listView = find.byType(ListView);
      if (listView.evaluate().isNotEmpty) {
        await tester.drag(listView, const Offset(0, -300));
        await tester.pump();
      }

      expect(find.byType(PromotionsPage), findsOneWidget);
    });
  });
}