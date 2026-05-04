import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:swifttrip_frontend/providers/wishlist_provider.dart';
import 'package:swifttrip_frontend/screens/destination/models/destination_model.dart';
import 'package:swifttrip_frontend/screens/profile/wishlist.dart';

class MockWishlistProvider extends Mock implements WishlistProvider {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockWishlistProvider mockWishlistProvider;

  setUp(() {
    mockWishlistProvider = MockWishlistProvider();
    when(() => mockWishlistProvider.loadFullWishlist()).thenAnswer((_) async {});
    when(() => mockWishlistProvider.isFavorite(any())).thenReturn(false);
  });

  group('Profile Wishlist - Integration Test', () {
    testWidgets('wishlist flow renders list then handles back button tap', (tester) async {
      // Arrange
      final items = <DestinationModel>[
        DestinationModel(
          id: 'dest-10',
          title: 'City Hotel',
          imageUrl: 'https://example.com/hotel.jpg',
          rating: 4.2,
        ),
      ];
      when(() => mockWishlistProvider.isLoading).thenReturn(false);
      when(() => mockWishlistProvider.wishlistItems).thenReturn(items);

      // Act
      await tester.pumpWidget(
        ChangeNotifierProvider<WishlistProvider>.value(
          value: mockWishlistProvider,
          child: MaterialApp(
            home: const Scaffold(body: Text('Home')),
            routes: {
              '/wishlist': (context) => const WishlistScreen(),
            },
            initialRoute: '/wishlist',
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('My Wishlist'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('City Hotel'), findsOneWidget);

      // Act
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Scaffold), findsWidgets);
    });
  });
}
