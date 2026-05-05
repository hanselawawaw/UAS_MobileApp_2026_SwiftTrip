import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:swifttrip_frontend/screens/destination/search.dart';
import '../../helpers/test_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => mockSecureStorage());
  tearDown(() => clearSecureStorageMock());

  group('DestinationSearch Integration', () {
    testWidgets('DestinationSearchPage renders with search bar', (tester) async {
      await tester.pumpWidget(wrapWithProviders(const DestinationSearchPage()));
      await tester.pump(const Duration(seconds: 2));

      expect(find.byType(DestinationSearchPage), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });
  });
}
