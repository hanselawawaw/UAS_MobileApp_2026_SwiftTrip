import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:swifttrip_frontend/screens/auth/signup.dart';
import '../../helpers/test_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => mockSecureStorage());
  tearDown(() => clearSecureStorageMock());

  group('Signup Integration', () {
    testWidgets('SignupPage renders with input fields and Sign Up button', (tester) async {
      await tester.pumpWidget(wrapWithProviders(const SignupPage()));
      await tester.pumpAndSettle();

      expect(find.byType(SignupPage), findsOneWidget);
      expect(find.byType(TextField), findsWidgets);
      expect(find.text('Sign Up'), findsOneWidget);
    });
  });
}
