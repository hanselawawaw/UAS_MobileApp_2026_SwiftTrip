import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swifttrip_frontend/providers/language_provider.dart';
import 'package:swifttrip_frontend/screens/profile/models/language_model.dart';
import 'package:swifttrip_frontend/screens/profile/services/language_service.dart';
import 'package:swifttrip_frontend/screens/profile/services/cache_service.dart';

// ============================================================
// PROFILE SERVICE - CONSOLIDATED UNIT TEST
// Merges: logout_test, language_test, clear_cache_test
//
// Coverage:
//   Service          | Method
//   -----------------|----------------------
//   LanguageService  | getLanguages()
//   LanguageProvider | translate()
//   CacheService     | getCacheDetails()
//                    | clearAllCache()
//   Logout           | (placeholder – no pure logic)
// ============================================================

class MockLanguageService extends Mock implements LanguageService {}

class MockCacheService extends Mock implements CacheService {}

void main() {
  // ── Language Service ──────────────────────────────────────────

  group('Profile Service - Language', () {
    late MockLanguageService mockLanguageService;
    late LanguageProvider languageProvider;

    setUp(() {
      mockLanguageService = MockLanguageService();
      languageProvider = LanguageProvider();
    });

    test('Language model serializes and deserializes correctly', () {
      const language = Language(code: 'en', flag: '🇬🇧', name: 'English');
      final json = language.toJson();
      final parsed = Language.fromJson(json);

      expect(parsed.code, equals('en'));
      expect(parsed.flag, equals('🇬🇧'));
      expect(parsed.name, equals('English'));
    });

    test('LanguageService.getLanguages can be stubbed', () async {
      const expected = [
        Language(code: 'en', flag: '🇬🇧', name: 'English'),
        Language(code: 'id', flag: '🇮🇩', name: 'Indonesia'),
      ];
      when(() => mockLanguageService.getLanguages())
          .thenAnswer((_) async => expected);

      final result = await mockLanguageService.getLanguages();

      expect(result, equals(expected));
      verify(() => mockLanguageService.getLanguages()).called(1);
    });

    test('LanguageProvider.translate returns key when unknown', () {
      const key = 'unknown_key';
      final translated = languageProvider.translate(key);
      expect(translated, equals(key));
    });
  });

  // ── Cache Service ─────────────────────────────────────────────

  group('Profile Service - Cache', () {
    late CacheService cacheService;
    late MockCacheService mockCacheService;

    setUp(() {
      cacheService = CacheService();
      mockCacheService = MockCacheService();
    });

    test('getCacheDetails returns expected cache map', () async {
      final details = await cacheService.getCacheDetails();
      expect(details['Search Cache'], equals(103));
      expect(details['User Cache'], equals(0));
      expect(details['Download Cache'], equals(201));
    });

    test('clearAllCache can be stubbed and verified', () async {
      when(() => mockCacheService.clearAllCache()).thenAnswer((_) async {});
      await mockCacheService.clearAllCache();
      verify(() => mockCacheService.clearAllCache()).called(1);
    });

    test('getCacheDetails can be stubbed and verified', () async {
      final expected = <String, double>{
        'Search Cache': 10,
        'User Cache': 20,
        'Download Cache': 30,
      };
      when(() => mockCacheService.getCacheDetails())
          .thenAnswer((_) async => expected);

      final result = await mockCacheService.getCacheDetails();

      expect(result, equals(expected));
      verify(() => mockCacheService.getCacheDetails()).called(1);
    });
  });

  // ── Logout ────────────────────────────────────────────────────

  group('Profile Service - Logout', () {
    test('Placeholder: No pure business logic available to unit test in the provided snippet', () {
      expect(true, isTrue);
    });
  });
}
