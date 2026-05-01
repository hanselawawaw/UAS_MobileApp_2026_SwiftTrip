import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:swifttrip_frontend/providers/cart_provider.dart';
import 'package:swifttrip_frontend/providers/language_provider.dart';
import 'package:swifttrip_frontend/providers/wishlist_provider.dart';
import 'package:swifttrip_frontend/screens/destination/category_page_base.dart';
import 'package:swifttrip_frontend/screens/destination/detail_page.dart';
import 'package:swifttrip_frontend/screens/destination/models/destination_model.dart';

class MockWishlistProvider extends Mock implements WishlistProvider {}

class MockLanguageProvider extends Mock implements LanguageProvider {}

class MockCartProvider extends Mock implements CartProvider {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockWishlistProvider mockWishlistProvider;
  late MockLanguageProvider mockLanguageProvider;
  late MockCartProvider mockCartProvider;

  setUp(() {
    mockWishlistProvider = MockWishlistProvider();
    mockLanguageProvider = MockLanguageProvider();
    mockCartProvider = MockCartProvider();

    when(() => mockWishlistProvider.isFavorite(any())).thenReturn(false);
    when(() => mockLanguageProvider.translate(any())).thenAnswer((i) => i.positionalArguments.first as String);
  });

  group('Accommodation Pages - Integration Test', () {
    testWidgets('flow: render category card then open detail page', (tester) async {
      // Arrange
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

      // Assert
      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Apartment Skyline'), findsOneWidget);

      // Act
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

      // Assert
      expect(find.text('Apartment Skyline'), findsOneWidget);
      expect(find.text('Add to Cart'), findsOneWidget);
      expect(find.byType(Image), findsWidgets);
    });
  });
}
