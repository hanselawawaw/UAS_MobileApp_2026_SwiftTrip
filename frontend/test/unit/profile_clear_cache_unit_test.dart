import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swifttrip_frontend/screens/profile/services/cache_service.dart';

class MockCacheService extends Mock implements CacheService {}

void main() {
  late CacheService cacheService;
  late MockCacheService mockCacheService;

  setUp(() {
    cacheService = CacheService();
    mockCacheService = MockCacheService();
  });

  group('Profile Settings (Cache) - Unit Test', () {
    test('getCacheDetails returns expected cache map', () async {
      // Arrange

      // Act
      final details = await cacheService.getCacheDetails();

      // Assert
      expect(details['Search Cache'], equals(103));
      expect(details['User Cache'], equals(0));
      expect(details['Download Cache'], equals(201));
    });

    test('clearAllCache can be stubbed and verified', () async {
      // Arrange
      when(() => mockCacheService.clearAllCache()).thenAnswer((_) async {});

      // Act
      await mockCacheService.clearAllCache();

      // Assert
      verify(() => mockCacheService.clearAllCache()).called(1);
    });

    test('getCacheDetails can be stubbed and verified', () async {
      // Arrange
      final expected = <String, double>{
        'Search Cache': 10,
        'User Cache': 20,
        'Download Cache': 30,
      };
      when(() => mockCacheService.getCacheDetails())
          .thenAnswer((_) async => expected);

      // Act
      final result = await mockCacheService.getCacheDetails();

      // Assert
      expect(result, equals(expected));
      verify(() => mockCacheService.getCacheDetails()).called(1);
    });
  });
}
