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

  group('Accommodation Search & Filter - Unit Test', () {
    test('DestinationModel toJson preserves core search fields', () {
      // Arrange
      final destination = DestinationModel(
        id: '1',
        title: 'Ocean View Villa',
        imageUrl: 'https://example.com/image.jpg',
        rating: 4.8,
        location: 'Bali',
        tags: const ['Cozy', 'Airy'],
      );

      // Act
      final json = destination.toJson();

      // Assert
      expect(json['id'], equals('1'));
      expect(json['title'], equals('Ocean View Villa'));
      expect(json['location'], equals('Bali'));
      expect(json['tags'], equals(const ['Cozy', 'Airy']));
    });

    test('DestinationService.getTrendingTags returns non-empty tags', () {
      // Arrange
      // Act
      final tags = destinationService.getTrendingTags();

      // Assert
      expect(tags, isNotEmpty);
      expect(tags, contains('Cozy'));
    });

    test('MockDestinationService.searchDestinations can be stubbed', () async {
      // Arrange
      final expected = [
        DestinationModel(
          id: '2',
          title: 'Skyline Apartment',
          imageUrl: 'https://example.com/apartment.jpg',
          rating: 4.3,
        ),
      ];
      when(() => mockDestinationService.searchDestinations(any()))
          .thenAnswer((_) async => expected);

      // Act
      final result = await mockDestinationService.searchDestinations('skyline');

      // Assert
      expect(result, equals(expected));
      verify(() => mockDestinationService.searchDestinations('skyline')).called(1);
    });
  });
}
