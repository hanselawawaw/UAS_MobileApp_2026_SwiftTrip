import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swifttrip_frontend/screens/destination/search.dart';
import 'package:swifttrip_frontend/screens/destination/services/destination_service.dart';

class MockDestinationService extends Mock implements DestinationService {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockDestinationService mockDestinationService;

  setUp(() {
    mockDestinationService = MockDestinationService();
    SharedPreferences.setMockInitialValues({});
  });

  group('Accommodation Search & Filter - Integration Test', () {
    testWidgets('search flow: open page, type query, clear query', (tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(home: DestinationSearchPage()));
      await tester.pump();
      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      // Act
      await tester.enterText(textField, 'jakarta');
      await tester.pump(const Duration(milliseconds: 200));

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);

      // Act
      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      // Assert
      expect(find.text('People are looking for...'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });
  });

  test('mocktail setup creates mock instance', () {
    expect(mockDestinationService, isA<MockDestinationService>());
  });
}
