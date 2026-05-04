import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swifttrip_frontend/providers/language_provider.dart';
import 'package:swifttrip_frontend/screens/profile/models/language_model.dart';
import 'package:swifttrip_frontend/screens/profile/services/language_service.dart';

class MockLanguageService extends Mock implements LanguageService {}

void main() {
  late MockLanguageService mockLanguageService;
  late LanguageProvider languageProvider;

  setUp(() {
    mockLanguageService = MockLanguageService();
    languageProvider = LanguageProvider();
  });

  group('Profile Settings (Language) - Unit Test', () {
    test('Language model serializes and deserializes correctly', () {
      // Arrange
      const language = Language(code: 'en', flag: '🇬🇧', name: 'English');

      // Act
      final json = language.toJson();
      final parsed = Language.fromJson(json);

      // Assert
      expect(parsed.code, equals('en'));
      expect(parsed.flag, equals('🇬🇧'));
      expect(parsed.name, equals('English'));
    });

    test('LanguageService.getLanguages can be stubbed', () async {
      // Arrange
      const expected = [
        Language(code: 'en', flag: '🇬🇧', name: 'English'),
        Language(code: 'id', flag: '🇮🇩', name: 'Indonesia'),
      ];
      when(() => mockLanguageService.getLanguages())
          .thenAnswer((_) async => expected);

      // Act
      final result = await mockLanguageService.getLanguages();

      // Assert
      expect(result, equals(expected));
      verify(() => mockLanguageService.getLanguages()).called(1);
    });

    test('LanguageProvider.translate returns key when unknown', () {
      // Arrange
      const key = 'unknown_key';

      // Act
      final translated = languageProvider.translate(key);

      // Assert
      expect(translated, equals(key));
    });
  });
}
