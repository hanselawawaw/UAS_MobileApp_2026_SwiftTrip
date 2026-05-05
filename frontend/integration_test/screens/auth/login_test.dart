import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:swifttrip_frontend/screens/auth/login.dart';
import '../../helpers/test_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => mockSecureStorage());
  tearDown(() => clearSecureStorageMock());

  group('Login Integration', () {
    testWidgets('LoginPage renders with email and password fields', (tester) async {
      await tester.pumpWidget(wrapWithProviders(const LoginPage()));
      await tester.pumpAndSettle();

      expect(find.byType(LoginPage), findsOneWidget);
      expect(find.byType(TextField), findsWidgets);
      expect(find.text('Log in'), findsOneWidget);
    });
  });
}
