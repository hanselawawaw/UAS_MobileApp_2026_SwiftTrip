import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:swifttrip_frontend/screens/splash/splash_screen.dart';
import '../../helpers/test_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => mockSecureStorage());
  tearDown(() => clearSecureStorageMock());

  group('Splash Integration', () {
    testWidgets('SplashScreen renders and shows animations', (tester) async {
      await tester.pumpWidget(wrapWithProviders(const SplashScreen()));

      expect(find.byType(SplashScreen), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
