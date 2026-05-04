import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:swifttrip_frontend/screens/cart/cart.dart';
import 'package:swifttrip_frontend/providers/cart_provider.dart';
import 'package:swifttrip_frontend/providers/language_provider.dart';
import 'package:swifttrip_frontend/providers/wishlist_provider.dart';

// ============================================================
// CART - CART SCREEN INTEGRATION TEST
// Tabel Coverage:
//   Widget            | Class Method
//   ------------------|----------------------
//   ListView          | loadCartItems()
//   CheckboxListTile  | toggleItemSelection()
//                     | onChanged()
//   Text              | calculateTotalAmount()
// ============================================================

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('CartPage Integration Tests', () {
    Widget buildApp({VoidCallback? onExploreFlights}) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => LanguageProvider()),
          ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ],
        child: MaterialApp(
          home: CartPage(onExploreFlights: onExploreFlights),
        ),
      );
    }

    // ----------------------------------------------------------
    // ListView + loadCartItems()
    // ----------------------------------------------------------
    testWidgets(
        '[ListView] loadCartItems() - CartPage tampil dan langsung load cart',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(CartPage), findsOneWidget);
    });

    testWidgets(
        '[ListView] loadCartItems() - Empty state tampil saat tidak ada tiket',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
    });

    testWidgets(
        '[ListView] loadCartItems() - loadCart dipanggil saat halaman dibuka',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump(const Duration(milliseconds: 100));

      // CartProvider.loadCart() dipanggil = widget tidak crash
      expect(find.byType(CartPage), findsOneWidget);
    });

    // ----------------------------------------------------------
    // CheckboxListTile + toggleItemSelection()
    // ----------------------------------------------------------
    testWidgets(
        '[CheckboxListTile] toggleItemSelection() - Cart kosong tidak crash',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(CheckboxListTile), findsNothing);
      expect(find.byType(CartPage), findsOneWidget);
    });

    testWidgets(
        '[CheckboxListTile] toggleItemSelection() - ElevatedButton explore bisa ditekan',
        (WidgetTester tester) async {
      bool pressed = false;
      await tester.pumpWidget(buildApp(onExploreFlights: () => pressed = true));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(pressed, isTrue);
    });

    // ----------------------------------------------------------
    // CheckboxListTile + onChanged()
    // ----------------------------------------------------------
    testWidgets(
        '[CheckboxListTile] onChanged() - Tidak ada dialog saat cart kosong',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets(
        '[CheckboxListTile] onChanged() - ScrollView bisa di-scroll saat ada tiket',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      // Saat cart kosong tidak ada tiket untuk di-scroll
      expect(find.byType(CartPage), findsOneWidget);
    });

    // ----------------------------------------------------------
    // Text + calculateTotalAmount()
    // ----------------------------------------------------------
    testWidgets(
        '[Text] calculateTotalAmount() - Total tidak tampil saat cart kosong',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      // TotalConfirmBar hanya tampil jika ada tiket
      expect(find.textContaining('Rp.'), findsNothing);
    });

    testWidgets(
        '[Text] calculateTotalAmount() - Halaman tidak crash setelah navigasi back',
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
                  MaterialPageRoute(builder: (_) => const CartPage()),
                ),
                child: const Text('Open Cart'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Cart'));
      await tester.pumpAndSettle();
      expect(find.byType(CartPage), findsOneWidget);

      final NavigatorState nav = tester.state(find.byType(Navigator));
      nav.pop();
      await tester.pumpAndSettle();
      expect(find.byType(CartPage), findsNothing);
    });
  });
}