import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swifttrip_frontend/providers/cart_provider.dart';
import 'package:swifttrip_frontend/providers/language_provider.dart';
import 'package:swifttrip_frontend/providers/wishlist_provider.dart';
import 'package:swifttrip_frontend/screens/destination/category_page_base.dart';
import 'package:swifttrip_frontend/screens/destination/detail_page.dart';
import 'package:swifttrip_frontend/screens/destination/models/destination_model.dart';
import 'package:swifttrip_frontend/screens/destination/search.dart';
import 'package:swifttrip_frontend/screens/searching/searching.dart';

// ============================================================
// FLOW: Search & Booking
// User opens destination → searches → selects trip → fills
// pickers → sees results
// ============================================================

class MockWishlistProvider extends Mock implements WishlistProvider {}

class MockLanguageProvider extends Mock implements LanguageProvider {}

class MockCartProvider extends Mock implements CartProvider {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockWishlistProvider mockWishlistProvider;
  late MockLanguageProvider mockLanguageProvider;
  late MockCartProvider mockCartProvider;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockWishlistProvider = MockWishlistProvider();
    mockLanguageProvider = MockLanguageProvider();
    mockCartProvider = MockCartProvider();

    when(() => mockWishlistProvider.isFavorite(any())).thenReturn(false);
    when(() => mockLanguageProvider.translate(any()))
        .thenAnswer((i) => i.positionalArguments.first as String);
  });

  group('Search & Booking Flow', () {
    testWidgets('destination search → type query → clear → see suggestions', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: DestinationSearchPage()));
      await tester.pump();

      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      // Type search query
      await tester.enterText(textField, 'jakarta');
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);

      // Clear search
      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();
      expect(find.text('People are looking for...'), findsOneWidget);
    });

    testWidgets('category page → view items → open detail page', (tester) async {
      final destination = DestinationModel(
        id: 'apt-1',
        title: 'Apartment Skyline',
        imageUrl: 'https://example.com/apt.jpg',
        rating: 4.6,
        originalPrice: 900000,
        price: 700000,
        discountPercentage: 10,
        description: 'Modern apartment',
        features: const ['Wifi', 'Parking'],
      );

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<WishlistProvider>.value(value: mockWishlistProvider),
            ChangeNotifierProvider<LanguageProvider>.value(value: mockLanguageProvider),
            ChangeNotifierProvider<CartProvider>.value(value: mockCartProvider),
          ],
          child: MaterialApp(
            home: CategoryPageBase(
              title: 'Apartment',
              items: [destination],
              onItemTap: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Apartment Skyline'), findsOneWidget);

      // Open detail page
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<WishlistProvider>.value(value: mockWishlistProvider),
            ChangeNotifierProvider<CartProvider>.value(value: mockCartProvider),
          ],
          child: MaterialApp(
            home: DestinationDetailPage(destination: destination),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Apartment Skyline'), findsOneWidget);
      expect(find.text('Add to Cart'), findsOneWidget);
    });

    testWidgets('searching page loads and accepts input without crash', (tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => LanguageProvider()),
            ChangeNotifierProvider(create: (_) => CartProvider()),
          ],
          child: const MaterialApp(home: SearchingPage()),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byType(SearchingPage), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Try entering text in origin field
      final textFields = find.byType(TextField);
      if (textFields.evaluate().isNotEmpty) {
        await tester.tap(textFields.first);
        await tester.pumpAndSettle();
        await tester.enterText(textFields.first, 'Jakarta');
        await tester.pumpAndSettle();
        expect(find.text('Jakarta'), findsWidgets);
      }
    });
  });
}
