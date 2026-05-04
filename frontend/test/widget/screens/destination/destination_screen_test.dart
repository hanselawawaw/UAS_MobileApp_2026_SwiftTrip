import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:swifttrip_frontend/providers/cart_provider.dart';
import 'package:swifttrip_frontend/providers/language_provider.dart';
import 'package:swifttrip_frontend/providers/wishlist_provider.dart';
import 'package:swifttrip_frontend/screens/destination/category_page_base.dart';
import 'package:swifttrip_frontend/screens/destination/detail_page.dart';
import 'package:swifttrip_frontend/screens/destination/destination_screen.dart';
import 'package:swifttrip_frontend/screens/destination/models/destination_model.dart';
import 'package:swifttrip_frontend/screens/destination/services/destination_service.dart';

class MockWishlistProvider extends Mock implements WishlistProvider {}

class MockLanguageProvider extends Mock implements LanguageProvider {}

class MockCartProvider extends Mock implements CartProvider {}

class MockDestinationService extends Mock implements DestinationService {}

void main() {
  late MockWishlistProvider mockWishlistProvider;
  late MockLanguageProvider mockLanguageProvider;
  late MockCartProvider mockCartProvider;
  late MockDestinationService mockDestinationService;

  setUp(() {
    mockWishlistProvider = MockWishlistProvider();
    mockLanguageProvider = MockLanguageProvider();
    mockCartProvider = MockCartProvider();
    mockDestinationService = MockDestinationService();

    when(() => mockWishlistProvider.isFavorite(any())).thenReturn(false);
    when(() => mockLanguageProvider.translate(any())).thenAnswer((i) => i.positionalArguments.first as String);
    when(() => mockDestinationService.fetchHomeSections()).thenAnswer((_) async => {});
  });

  group('Accommodation Pages - Widget Test', () {
    testWidgets('CategoryPageBase renders ListView.builder and CategoryItemCard', (tester) async {
      // Arrange
      final items = <DestinationModel>[
        DestinationModel(
          id: 'villa-1',
          title: 'Villa Aurora',
          imageUrl: 'https://example.com/villa.jpg',
          rating: 4.8,
          description: 'Seaside villa',
        ),
      ];

      // Act
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<WishlistProvider>.value(value: mockWishlistProvider),
          ],
          child: MaterialApp(
            home: CategoryPageBase(
              title: 'Villa',
              items: items,
            ),
          ),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.text('Villa'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(CategoryItemCard), findsOneWidget);
      expect(find.byType(Image), findsWidgets);
    });

    testWidgets('DestinationPage renders loading state initially', (tester) async {
      // Arrange
      final completer = Completer<Map<String, List<DestinationModel>>>();
      when(() => mockDestinationService.fetchHomeSections()).thenAnswer((_) => completer.future);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<LanguageProvider>.value(value: mockLanguageProvider),
          ],
          child: MaterialApp(home: DestinationPage(destinationService: mockDestinationService)),
        ),
      );

      // Act
      // Initial pump to build the widget tree (triggers initState and fetchHomeSections)

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      completer.complete({});
    });

    testWidgets('DestinationDetailPage renders title, rating and Add to Cart control', (tester) async {
      // Arrange
      final destination = DestinationModel(
        id: 'hotel-1',
        title: 'Hotel Meridian',
        imageUrl: 'https://example.com/hotel.jpg',
        rating: 4.4,
        originalPrice: 1000000,
        price: 800000,
        discountPercentage: 20,
        description: 'City center hotel',
        features: const ['Breakfast included', 'Pool access'],
      );

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
      await tester.pump();

      // Assert
      expect(find.text('Hotel Meridian'), findsOneWidget);
      expect(find.text('4.4'), findsOneWidget);
      expect(find.text('Add to Cart'), findsOneWidget);
      expect(find.byType(Image), findsWidgets);
    });
  });
}
