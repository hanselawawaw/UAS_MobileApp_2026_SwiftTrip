import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swifttrip_frontend/providers/language_provider.dart';
import 'package:swifttrip_frontend/screens/profile/language.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Profile Settings (Language) - Widget Test', () {
    testWidgets('renders language screen title and language list entries', (tester) async {
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
      expect(find.text('English'), findsOneWidget);
      expect(find.text('Indonesia'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('tapping language item shows success SnackBar', (tester) async {
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
      await tester.tap(find.text('Indonesia'));
      await tester.pump();

      // Assert
      expect(find.textContaining('Language updated to Indonesia'), findsOneWidget);
    });
  });
}
