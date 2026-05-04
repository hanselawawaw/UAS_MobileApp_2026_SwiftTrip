import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swifttrip_frontend/providers/language_provider.dart';
import 'package:swifttrip_frontend/screens/profile/language.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Profile Settings (Language) - Integration Test', () {
    testWidgets('language flow: open screen, select language, verify snackbar', (tester) async {
      // Arrange
      final provider = LanguageProvider();

      // Act
      await tester.pumpWidget(
        ChangeNotifierProvider<LanguageProvider>.value(
          value: provider,
          child: const MaterialApp(home: LanguageScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Language'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);

      // Act
      await tester.tap(find.text('English'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.textContaining('Language updated to English'), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
