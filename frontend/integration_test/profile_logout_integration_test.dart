import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:swifttrip_frontend/providers/language_provider.dart';
import 'package:swifttrip_frontend/screens/profile/profile.dart';
import 'package:swifttrip_frontend/screens/auth/login.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Profile Logout - Integration Test', () {
    testWidgets('full flow: tap logout and navigate to login screen', (
      tester,
    ) async {
      // Arrange
      final languageProvider = LanguageProvider();

      await tester.pumpWidget(
        ChangeNotifierProvider<LanguageProvider>.value(
          value: languageProvider,
          child: const MaterialApp(home: ProfilePage()),
        ),
      );
      await tester.pumpAndSettle();

      final logoutFinder = find.text('Log Out');
      expect(logoutFinder, findsOneWidget);

      // Act
      await tester.tap(logoutFinder);
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(LoginPage), findsOneWidget);
    });
  });
}
