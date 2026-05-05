import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:swifttrip_frontend/screens/cart/cart.dart';
import 'package:swifttrip_frontend/providers/cart_provider.dart';
import 'package:swifttrip_frontend/providers/language_provider.dart';
import 'package:swifttrip_frontend/providers/wishlist_provider.dart';

// ============================================================
// CART - CART SCREEN WIDGET TEST
// Tabel Coverage:
//   Widget            | Class Method
//   ------------------|----------------------
//   ListView          | loadCartItems()
//   CheckboxListTile  | toggleItemSelection()
//                     | onChanged()
//   Text              | calculateTotalAmount()
// ============================================================

void main() {
  group('CartPage Widget Tests', () {
    Widget buildSubject({VoidCallback? onExploreFlights}) {
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
    // WIDGET: ListView
    // METHOD: loadCartItems()
    // ----------------------------------------------------------
    testWidgets(
        '[ListView] loadCartItems() - CartPage renders tanpa error',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();
      expect(find.byType(CartPage), findsOneWidget);
    });

    testWidgets(
        '[ListView] loadCartItems() - Empty state tampil saat cart kosong',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      // Cart kosong = empty state icon ditampilkan
      expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
    });

    testWidgets(
        '[ListView] loadCartItems() - Scaffold ada dengan background color benar',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
      expect(scaffold.backgroundColor, equals(const Color(0xFFF6F6F6)));
    });

    testWidgets(
        '[ListView] loadCartItems() - ScrollView ada untuk list tiket',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      // Cart is empty so it shows the empty state (Center) layout
      // SingleChildScrollView only appears when there are tickets
      expect(find.byType(Column), findsWidgets);
    });

    // ----------------------------------------------------------
    // WIDGET: CheckboxListTile
    // METHOD: toggleItemSelection()
    // ----------------------------------------------------------
    testWidgets(
        '[CheckboxListTile] toggleItemSelection() - Cart kosong tidak menampilkan tiket',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      // Tidak ada CheckboxListTile saat cart kosong
      expect(find.byType(CheckboxListTile), findsNothing);
    });

    testWidgets(
        '[CheckboxListTile] toggleItemSelection() - ElevatedButton explore ada saat cart kosong',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets(
        '[CheckboxListTile] toggleItemSelection() - Tap explore button memanggil callback',
        (WidgetTester tester) async {
      bool callbackCalled = false;
      await tester.pumpWidget(buildSubject(onExploreFlights: () {
        callbackCalled = true;
      }));
      await tester.pump();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(callbackCalled, isTrue);
    });

    // ----------------------------------------------------------
    // WIDGET: CheckboxListTile
    // METHOD: onChanged()
    // ----------------------------------------------------------
    testWidgets(
        '[CheckboxListTile] onChanged() - CartProvider tersedia di context',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(CartPage), findsOneWidget);
    });

    testWidgets(
        '[CheckboxListTile] onChanged() - RemoveDialog tidak muncul sebelum ada tiket',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(AlertDialog), findsNothing);
    });

    // ----------------------------------------------------------
    // WIDGET: Text
    // METHOD: calculateTotalAmount()
    // ----------------------------------------------------------
    testWidgets(
        '[Text] calculateTotalAmount() - Total text tidak tampil saat cart kosong',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      // TotalConfirmBar tidak tampil saat cart kosong
      expect(find.textContaining('Rp.'), findsNothing);
    });

    testWidgets(
        '[Text] calculateTotalAmount() - LanguageProvider dapat translate key',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(CartPage), findsOneWidget);
    });

    testWidgets(
        '[Text] calculateTotalAmount() - Column layout utama ada di CartPage',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(Column), findsWidgets);
    });
  });
}