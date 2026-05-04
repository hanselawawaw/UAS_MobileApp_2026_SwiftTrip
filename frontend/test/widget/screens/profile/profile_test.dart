import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:swifttrip_frontend/providers/language_provider.dart';
import 'package:swifttrip_frontend/screens/profile/profile.dart';
import 'package:swifttrip_frontend/screens/profile/widgets/menu_item.dart';
import 'package:swifttrip_frontend/screens/profile/widgets/profile_card.dart';

void main() {
  const secureStorageChannel = MethodChannel(
    'plugins.it_nomads.com/flutter_secure_storage',
  );

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(secureStorageChannel, (call) async {
      if (call.method == 'read') return null;
      if (call.method == 'write') return null;
      if (call.method == 'delete') return null;
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(secureStorageChannel, null);
  });

  group('Profile Screen - Widget Test', () {
    testWidgets('renders ProfilePage with ProfileCard and menu text', (tester) async {
      // Arrange
      final languageProvider = LanguageProvider();

      // Act
      await tester.pumpWidget(
        ChangeNotifierProvider<LanguageProvider>.value(
          value: languageProvider,
          child: const MaterialApp(home: ProfilePage()),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(ProfilePage), findsOneWidget);
      expect(find.byType(ProfileCard), findsOneWidget);
      expect(find.byType(MenuItem), findsNWidgets(6));
      expect(find.text('Edit Profile'), findsOneWidget);
      expect(find.text('Wishlist'), findsOneWidget);
    });

    testWidgets('shows default username/email text when no user loaded', (tester) async {
      // Arrange
      final languageProvider = LanguageProvider();

      // Act
      await tester.pumpWidget(
        ChangeNotifierProvider<LanguageProvider>.value(
          value: languageProvider,
          child: const MaterialApp(home: ProfilePage()),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Unknown User'), findsOneWidget);
      expect(find.text('No email available'), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    });
  });
}
