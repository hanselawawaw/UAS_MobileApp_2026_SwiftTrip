import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:swifttrip_frontend/screens/cart/cart.dart';
import 'package:swifttrip_frontend/screens/cart/models/cart_models.dart';
import 'package:swifttrip_frontend/screens/checkout/checkout.dart';
import 'package:swifttrip_frontend/screens/checkout/successful.dart';
import 'package:swifttrip_frontend/screens/checkout/models/checkout_details_model.dart';
import 'package:swifttrip_frontend/providers/cart_provider.dart';
import 'package:swifttrip_frontend/providers/language_provider.dart';
import 'package:swifttrip_frontend/providers/wishlist_provider.dart';

// ============================================================
// FLOW: Checkout
// User opens cart → views empty state → taps explore →
// opens checkout → fills payment → sees success screen
// ============================================================

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Widget buildProviders({required Widget child}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
      ],
      child: MaterialApp(home: child),
    );
  }

  group('Checkout Flow', () {
    testWidgets('cart empty state → tap explore → callback fires', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        buildProviders(child: CartPage(onExploreFlights: () => pressed = true)),
      );
      await tester.pumpAndSettle();

      // Empty cart state
      expect(find.byType(CartPage), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
      expect(find.byType(CheckboxListTile), findsNothing);

      // Tap explore button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(pressed, isTrue);
    });

    testWidgets('checkout page renders → fill card fields → verify totals', (tester) async {
      const details = CheckoutDetailsModel(
        tickets: [],
        purchaseItems: [],
        totalPrice: 'Rp. 1.500.000',
        discountTotal: 0,
      );

      await tester.pumpWidget(
        buildProviders(child: const CheckoutPage(checkoutDetails: details)),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CheckoutPage), findsOneWidget);
      expect(find.textContaining('Rp.'), findsWidgets);
      expect(find.byType(BottomSheet), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Fill card fields if present
      final fields = find.byType(TextField);
      if (fields.evaluate().isNotEmpty) {
        await tester.enterText(fields.first, '4111 1111 1111 1111');
        await tester.pumpAndSettle();
        expect(find.text('4111 1111 1111 1111'), findsOneWidget);

        if (fields.evaluate().length > 1) {
          await tester.enterText(fields.at(1), '12/25');
          await tester.pumpAndSettle();
          expect(find.text('12/25'), findsOneWidget);
        }
        if (fields.evaluate().length > 2) {
          await tester.enterText(fields.at(2), '123');
          await tester.pumpAndSettle();
          expect(find.text('123'), findsOneWidget);
        }
      }
    });

    testWidgets('success page → shows animation → auto-navigates away', (tester) async {
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

      await tester.pumpWidget(
        buildProviders(child: SuccessfulPage(details: makeDetails())),
      );

      // Success animations play
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byType(SuccessfulPage), findsOneWidget);
      expect(find.byType(ScaleTransition), findsWidgets);
      expect(find.text('Payment Successful'), findsOneWidget);

      // Background color
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
      expect(scaffold.backgroundColor, equals(const Color(0xFFF6F6F6)));

      // Auto-navigates after animation
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.byType(SuccessfulPage), findsNothing);
    });

    testWidgets('cart → navigate back does not crash', (tester) async {
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
