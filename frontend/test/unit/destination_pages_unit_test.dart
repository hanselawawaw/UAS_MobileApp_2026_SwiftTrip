import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swifttrip_frontend/screens/destination/models/destination_model.dart';
import 'package:swifttrip_frontend/screens/destination/services/destination_service.dart';

class MockDestinationService extends Mock implements DestinationService {}

void main() {
  late MockDestinationService mockDestinationService;
  late DestinationService destinationService;

  setUp(() {
    mockDestinationService = MockDestinationService();
    destinationService = DestinationService();
  });

  group('Accommodation Pages - Unit Test', () {
    test('DestinationModel.hasDiscount is true when discountPercentage > 0', () {
      // Arrange
      final item = DestinationModel(
        id: 'villa-1',
        title: 'Villa Aurora',
        imageUrl: 'https://example.com/villa.jpg',
        rating: 4.7,
        discountPercentage: 20,
      );

      // Act
      final hasDiscount = item.hasDiscount;

      // Assert
      expect(hasDiscount, isTrue);
    });

    test('DestinationModel.hasDiscount is false when discountPercentage == 0', () {
      // Arrange
      final item = DestinationModel(
        id: 'hotel-1',
        title: 'Hotel Meridian',
        imageUrl: 'https://example.com/hotel.jpg',
        rating: 4.5,
        discountPercentage: 0,
      );

      // Act
      final hasDiscount = item.hasDiscount;

      // Assert
      expect(hasDiscount, isFalse);
    });

    test('MockDestinationService.fetchHomeSections can be stubbed', () async {
      // Arrange
      final payload = <String, List<DestinationModel>>{
        'discount_destinations': [
          DestinationModel(
            id: 'apt-1',
            title: 'Apt Green',
            imageUrl: 'https://example.com/apt.jpg',
            rating: 4.2,
          ),
        ],
        'favorite_destinations': [],
        'hot_destinations': [],
      };
      when(() => mockDestinationService.fetchHomeSections())
          .thenAnswer((_) async => payload);

      // Act
      final result = await mockDestinationService.fetchHomeSections();

      // Assert
      expect(result, equals(payload));
      verify(() => mockDestinationService.fetchHomeSections()).called(1);
    });

    test('DestinationService.getTrendingTags returns expected default tags', () {
      // Arrange
      // Act
      final tags = destinationService.getTrendingTags();

      // Assert
      expect(tags, containsAll(<String>['Cozy', 'Sleek', 'Airy', 'Moody']));
    });
  });
}
