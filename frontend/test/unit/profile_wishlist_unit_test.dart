import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swifttrip_frontend/providers/wishlist_provider.dart';
import 'package:swifttrip_frontend/screens/destination/models/destination_model.dart';

class MockWishlistProvider extends Mock implements WishlistProvider {}

void main() {
  late MockWishlistProvider mockWishlistProvider;

  setUp(() {
    mockWishlistProvider = MockWishlistProvider();
  });

  group('Profile Wishlist - Unit Test', () {
    test('toggleWishlist can be stubbed and verified', () async {
      // Arrange
      when(() => mockWishlistProvider.toggleWishlist('dest-1'))
          .thenAnswer((_) async => true);

      // Act
      final result = await mockWishlistProvider.toggleWishlist('dest-1');

      // Assert
      expect(result, isTrue);
      verify(() => mockWishlistProvider.toggleWishlist('dest-1')).called(1);
    });

    test('wishlist item model holds thumbnail url for Image.network usage', () {
      // Arrange
      final item = DestinationModel(
        id: 'dest-2',
        title: 'Beach Villa',
        imageUrl: 'https://example.com/thumb.jpg',
        rating: 4.7,
      );

      // Act
      final thumbnailUrl = item.imageUrl;

      // Assert
      expect(thumbnailUrl, equals('https://example.com/thumb.jpg'));
      expect(thumbnailUrl.isNotEmpty, isTrue);
    });

    test('loadFullWishlist can be invoked and verified', () async {
      // Arrange
      when(() => mockWishlistProvider.loadFullWishlist())
          .thenAnswer((_) async {});

      // Act
      await mockWishlistProvider.loadFullWishlist();

      // Assert
      verify(() => mockWishlistProvider.loadFullWishlist()).called(1);
    });
  });
}
