import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:swifttrip_frontend/providers/language_provider.dart';
import 'package:swifttrip_frontend/screens/profile/profile.dart';
import 'package:swifttrip_frontend/screens/profile/widgets/menu_item.dart';
import 'package:swifttrip_frontend/screens/profile/widgets/profile_card.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

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

  group('Profile Screen - Integration Test', () {
    testWidgets('profile flow renders card and supports menu tap', (tester) async {
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
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
      expect(find.byType(MenuItem), findsNWidgets(6));

      // Act
      await tester.tap(find.text('Language'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Scaffold), findsWidgets);
    });
  });
}
