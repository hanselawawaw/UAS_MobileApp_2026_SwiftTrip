import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swifttrip_frontend/screens/destination/search.dart';
import 'package:swifttrip_frontend/screens/destination/services/destination_service.dart';

class MockDestinationService extends Mock implements DestinationService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockDestinationService mockDestinationService;

  setUp(() {
    mockDestinationService = MockDestinationService();
    when(() => mockDestinationService.getTrendingTags()).thenReturn(['Cozy', 'Villa', 'Hotel']);
    when(() => mockDestinationService.getRecentSearches()).thenAnswer((_) async => []);
    when(() => mockDestinationService.getTopRated()).thenAnswer((_) async => []);
    when(() => mockDestinationService.fetchDestinations(sectionTag: any(named: 'sectionTag'))).thenAnswer((_) async => []);
    SharedPreferences.setMockInitialValues({});
  });

  group('Accommodation Search & Filter - Widget Test', () {
    testWidgets('renders query TextField and discover content text', (tester) async {
      // Arrange
      await tester.pumpWidget(MaterialApp(home: DestinationSearchPage(destinationService: mockDestinationService)));
      await tester.pump();

      // Assert
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('People are looking for...'), findsOneWidget);
      expect(find.text('Cozy'), findsOneWidget);
    });

    testWidgets('typing in query switches to searching state', (tester) async {
      // Arrange
      await tester.pumpWidget(MaterialApp(home: DestinationSearchPage(destinationService: mockDestinationService)));
      await tester.pump();
      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      // Act
      await tester.enterText(textField, 'bali');
      await tester.pump();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('clearing query returns to discover content', (tester) async {
      // Arrange
      await tester.pumpWidget(MaterialApp(home: DestinationSearchPage(destinationService: mockDestinationService)));
      await tester.pump();
      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      // Act
      await tester.enterText(textField, 'villa');
      await tester.pump();
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
