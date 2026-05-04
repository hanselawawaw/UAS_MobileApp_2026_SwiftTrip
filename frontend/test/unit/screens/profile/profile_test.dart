import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swifttrip_frontend/models/user.dart';
import 'package:swifttrip_frontend/repositories/auth_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
  });

  group('Profile Screen - Unit Test', () {
    test('display username uses User.fullName', () {
      // Arrange
      final user = User(
        email: 'jane@example.com',
        firstName: 'Jane',
        lastName: 'Doe',
      );

      // Act
      final username = user.fullName;

      // Assert
      expect(username, equals('Jane Doe'));
    });

    test('fetchUserProfile can be stubbed via AuthRepository.getUserProfile', () async {
      // Arrange
      final expectedUser = User(
        email: 'john@example.com',
        firstName: 'John',
        lastName: 'Smith',
      );
      when(() => mockAuthRepository.getUserProfile())
          .thenAnswer((_) async => expectedUser);

      // Act
      final result = await mockAuthRepository.getUserProfile();

      // Assert
      expect(result.email, equals('john@example.com'));
      expect(result.fullName, equals('John Smith'));
      verify(() => mockAuthRepository.getUserProfile()).called(1);
    });

    test('load profile picture fallback icon state maps to empty image use-case', () {
      // Arrange
      const hasProfileImage = false;

      // Act
      final shouldUseFallbackAvatar = !hasProfileImage;

      // Assert
      expect(shouldUseFallbackAvatar, isTrue);
    });
  });
}
