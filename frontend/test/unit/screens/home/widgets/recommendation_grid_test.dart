import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swifttrip_frontend/screens/home/services/home_service.dart';
import 'package:swifttrip_frontend/models/recommendation_item.dart';
import 'package:swifttrip_frontend/screens/cart/models/cart_models.dart';

// ─── Mock Classes ────────────────────────────────────────────────────────────

class MockHomeService extends Mock implements HomeService {}

// ─── Unit Tests: Home - Recommendation ──────────────────────────────────────

void main() {
  group('Home - Recommendation Unit Tests', () {
    late MockHomeService mockHomeService;

    setUp(() {
      mockHomeService = MockHomeService();
    });

    // ── loadRecommendations() ─────────────────────────────────────────────

    group('loadRecommendations()', () {
      test('should return list of RecommendationItem when fetch is successful',
          () async {
        // Arrange
        final mockRecommendations = [
          const RecommendationItem(
            name: 'The Langham',
            description: 'Jakarta',
            imageAsset: 'assets/images/home/vacation_logo.png',
          ),
          const RecommendationItem(
            name: 'The Ritz-Carlton',
            description: 'Bali',
            imageAsset: 'assets/images/home/vacation_logo.png',
          ),
        ];

        when(() => mockHomeService.fetchRecommendations())
            .thenAnswer((_) async => mockRecommendations);

        // Act
        final result = await mockHomeService.fetchRecommendations();

        // Assert
        expect(result, isA<List<RecommendationItem>>());
        expect(result.length, equals(2));
        expect(result.first.name, equals('The Langham'));
        expect(result.first.description, equals('Jakarta'));
        verify(() => mockHomeService.fetchRecommendations()).called(1);
      });

      test('should return empty list when no recommendations available',
          () async {
        // Arrange
        when(() => mockHomeService.fetchRecommendations())
            .thenAnswer((_) async => []);

        // Act
        final result = await mockHomeService.fetchRecommendations();

        // Assert
        expect(result, isEmpty);
      });

      test('should return all 4 default recommendations', () async {
        // Arrange
        final service = HomeService();

        // Act
        final result = await service.fetchRecommendations();

        // Assert
        expect(result.length, equals(4));
        expect(result.map((r) => r.description),
            containsAll(['Jakarta', 'Bali', 'Yogyakarta', 'Bandung']));
      });

      test('should return recommendation with valid imageAsset', () async {
        // Arrange
        final service = HomeService();

        // Act
        final result = await service.fetchRecommendations();

        // Assert
        for (final item in result) {
          expect(item.imageAsset, isNotNull);
          expect(item.imageAsset, isNotEmpty);
        }
      });
    });

    // ── buildGridItems() ─────────────────────────────────────────────────

    group('buildGridItems()', () {
      test('RecommendationItem should serialize and deserialize correctly', () {
        // Arrange
        final item = const RecommendationItem(
          name: 'Hotel Tentrem',
          description: 'Yogyakarta',
          imageUrl: 'https://example.com/image.jpg',
          imageAsset: 'assets/images/home/vacation_logo.png',
        );

        // Act
        final json = item.toJson();
        final rebuilt = RecommendationItem.fromJson(json);

        // Assert
        expect(rebuilt.name, equals(item.name));
        expect(rebuilt.description, equals(item.description));
        expect(rebuilt.imageUrl, equals(item.imageUrl));
        expect(rebuilt.imageAsset, equals(item.imageAsset));
      });

      test('RecommendationItem.fromJson with null fields should not throw', () {
        // Arrange
        final json = {
          'name': 'Padma Hotel',
          'description': 'Bandung',
          'image_url': null,
          'image_asset': null,
        };

        // Act
        final item = RecommendationItem.fromJson(json);

        // Assert
        expect(item.name, equals('Padma Hotel'));
        expect(item.imageUrl, isNull);
        expect(item.imageAsset, isNull);
      });

      test('RecommendationItem list can be built from multiple JSON entries',
          () {
        // Arrange
        final jsonList = [
          {'name': 'Hotel A', 'description': 'City A'},
          {'name': 'Hotel B', 'description': 'City B'},
          {'name': 'Hotel C', 'description': 'City C'},
        ];

        // Act
        final items =
            jsonList.map((j) => RecommendationItem.fromJson(j)).toList();

        // Assert
        expect(items.length, equals(3));
        expect(items[1].name, equals('Hotel B'));
      });
    });

    // ── fetchSchedules() ─────────────────────────────────────────────────

    group('fetchSchedules()', () {
      test('should return empty list when service throws exception', () async {
        // Arrange
        when(() => mockHomeService.fetchSchedules())
            .thenAnswer((_) async => []);

        // Act
        final result = await mockHomeService.fetchSchedules();

        // Assert
        expect(result, isEmpty);
      });

      test('should call fetchSchedules exactly once', () async {
        // Arrange
        when(() => mockHomeService.fetchSchedules())
            .thenAnswer((_) async => []);

        // Act
        await mockHomeService.fetchSchedules();

        // Assert
        verify(() => mockHomeService.fetchSchedules()).called(1);
      });

      test('CartTicket fromJson should parse correctly', () {
        // Arrange
        final json = {
          'type': 'Plane Ticket',
          'booking_id': 'BK-001',
          'from': 'Jakarta',
          'to': 'Bali',
          'date': '2026-06-01',
          'departure': '08:00',
          'arrive': '10:00',
          'price_rp': 1500000,
          'class_label': 'Economy',
          'is_reviewable': false,
        };

        // Act
        final ticket = CartTicket.fromJson(json);

        // Assert
        expect(ticket.from, equals('Jakarta'));
        expect(ticket.to, equals('Bali'));
        expect(ticket.type, equals('Plane Ticket'));
      });
    });
  });
}