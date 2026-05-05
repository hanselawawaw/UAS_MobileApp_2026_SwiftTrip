import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:swifttrip_frontend/screens/destination/destination_screen.dart';
import '../../helpers/test_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => mockSecureStorage());
  tearDown(() => clearSecureStorageMock());

  group('DestinationScreen Integration', () {
    testWidgets('DestinationPage renders with Scaffold', (tester) async {
      await tester.pumpWidget(wrapWithProviders(const DestinationPage()));
      await tester.pump(const Duration(seconds: 2));

      expect(find.byType(DestinationPage), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
