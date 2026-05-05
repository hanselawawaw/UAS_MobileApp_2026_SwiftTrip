import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:swifttrip_frontend/screens/auth/forgot_pass/forgot_pass.dart';
import '../../../helpers/test_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => mockSecureStorage());
  tearDown(() => clearSecureStorageMock());

  group('ForgotPass Integration', () {
    testWidgets('ForgotPassPage renders with email field and Continue button', (tester) async {
      await tester.pumpWidget(wrapWithProviders(const ForgotPassPage()));
      await tester.pumpAndSettle();

      expect(find.byType(ForgotPassPage), findsOneWidget);
      expect(find.byType(TextField), findsWidgets);
      expect(find.text('Continue'), findsOneWidget);
    });
  });
}
