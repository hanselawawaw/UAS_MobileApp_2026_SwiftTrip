import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:swifttrip_frontend/providers/wishlist_provider.dart';
import 'package:swifttrip_frontend/screens/destination/models/destination_model.dart';
import 'package:swifttrip_frontend/screens/profile/wishlist.dart';

class MockWishlistProvider extends Mock implements WishlistProvider {}

void main() {
  late MockWishlistProvider mockWishlistProvider;

  setUp(() {
    mockWishlistProvider = MockWishlistProvider();

    when(() => mockWishlistProvider.isLoading).thenReturn(false);
    when(() => mockWishlistProvider.wishlistItems).thenReturn([]);
    when(() => mockWishlistProvider.loadFullWishlist()).thenAnswer((_) async {});
    when(() => mockWishlistProvider.isFavorite(any())).thenReturn(false);
  });

  group('Profile Wishlist - Widget Test', () {
    testWidgets('renders empty state texts and button when wishlist is empty', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ChangeNotifierProvider<WishlistProvider>.value(
          value: mockWishlistProvider,
          child: const MaterialApp(home: WishlistScreen()),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.text('My Wishlist'), findsOneWidget);
      expect(find.text('Your Wishlist is Empty'), findsOneWidget);
      expect(find.text('Start Exploring'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('shows loading indicator when loading and no items', (tester) async {
      // Arrange
      when(() => mockWishlistProvider.isLoading).thenReturn(true);
      when(() => mockWishlistProvider.wishlistItems).thenReturn([]);

      // Act
      await tester.pumpWidget(
        ChangeNotifierProvider<WishlistProvider>.value(
          value: mockWishlistProvider,
          child: const MaterialApp(home: WishlistScreen()),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders list when wishlist has items', (tester) async {
      // Arrange
      final items = <DestinationModel>[
        DestinationModel(
          id: 'dest-1',
          title: 'Mountain Cabin',
          imageUrl: 'https://example.com/cabin.jpg',
          rating: 4.8,
        ),
      ];
      when(() => mockWishlistProvider.isLoading).thenReturn(false);
      when(() => mockWishlistProvider.wishlistItems).thenReturn(items);

      // Act
      await tester.pumpWidget(
        ChangeNotifierProvider<WishlistProvider>.value(
          value: mockWishlistProvider,
          child: const MaterialApp(home: WishlistScreen()),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Mountain Cabin'), findsOneWidget);
    });
  });
}
