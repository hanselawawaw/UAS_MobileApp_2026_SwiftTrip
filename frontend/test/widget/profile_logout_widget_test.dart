import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:swifttrip_frontend/providers/language_provider.dart';
import 'package:swifttrip_frontend/screens/profile/profile.dart';
import 'package:swifttrip_frontend/screens/auth/login.dart';

void main() {
  const secureStorageChannel = MethodChannel('plugins.it_nomads.com/flutter_secure_storage');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(secureStorageChannel, (call) async => null);
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(secureStorageChannel, null);
  });

  group('Profile Logout - Widget Test', () {
    testWidgets('taps logout menu item and navigates to LoginPage', (tester) async {
      // Arrange
      final languageProvider = LanguageProvider();
      await tester.pumpWidget(
        ChangeNotifierProvider<LanguageProvider>.value(
          value: languageProvider,
          child: const MaterialApp(home: ProfilePage()),
        ),
      );
      await tester.pumpAndSettle();

      // Assert the logout button exists
      final logoutFinder = find.text('Log Out');
      expect(logoutFinder, findsWidgets);

      // Act
      await tester.ensureVisible(logoutFinder.last);
      await tester.pumpAndSettle();
      await tester.tap(logoutFinder.last);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Assert it navigated to LoginPage
      expect(find.byType(LoginPage), findsOneWidget);
    });
  });
}
