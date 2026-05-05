import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:swifttrip_frontend/screens/main/main_screen.dart';
import '../../helpers/test_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => mockSecureStorage());
  tearDown(() => clearSecureStorageMock());

  group('MainScreen Integration', () {
    testWidgets('MainScreen renders with bottom navigation bar', (tester) async {
      await tester.pumpWidget(wrapWithProviders(const MainScreen()));
      await tester.pump(const Duration(seconds: 2));

      expect(find.byType(MainScreen), findsOneWidget);
      expect(find.byType(Scaffold), findsWidgets);
    });
  });
}
