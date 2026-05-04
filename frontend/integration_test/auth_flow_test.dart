import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:swifttrip_frontend/screens/auth/login.dart';
import 'package:swifttrip_frontend/screens/auth/signup.dart';
import 'package:swifttrip_frontend/screens/auth/forgot_pass/forgot_pass.dart';

// ============================================================
// FLOW: Auth
// User boots → Login screen → fill credentials → submit
// User navigates Login ↔ Signup ↔ ForgotPassword
// ============================================================

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Auth Flow', () {
    Widget buildApp() => const MaterialApp(home: LoginPage());

    testWidgets('login → fill fields → submit → shows loading indicator', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      // Verify login page renders
      expect(find.text('Log in'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);

      // Empty submit → validation error
      await tester.tap(find.text('Log in'));
      await tester.pump();
      expect(find.text('Please fill all fields'), findsOneWidget);

      // Fill valid credentials → submit → loading indicator
      await tester.enterText(find.byType(TextFormField).first, 'user@test.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      await tester.pump();

      await tester.tap(find.text('Log in'));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('login → navigate to signup → navigate back to login', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      // Navigate to Signup
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();
      expect(find.byType(SignupPage), findsOneWidget);
      expect(find.byType(LoginPage), findsNothing);

      // Navigate back to Login
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();
      expect(find.byType(LoginPage), findsOneWidget);
    });

    testWidgets('login → navigate to forgot password → interact → navigate back', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      // Navigate to Forgot Password
      await tester.tap(find.text('Forgot password?'));
      await tester.pumpAndSettle();
      expect(find.byType(ForgotPassPage), findsOneWidget);

      // Verify forgot password page elements
      expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);

      // Submit empty → validation error
      await tester.tap(find.text('Continue'));
      await tester.pump();
      expect(find.text('Please fill all fields'), findsOneWidget);

      // Fill email + OTP code → validation passes
      await tester.enterText(find.byType(TextFormField).first, 'user@example.com');
      await tester.enterText(find.byType(TextFormField).at(1), '654321');
      await tester.pump();

      await tester.tap(find.text('Continue'));
      await tester.pump();
      expect(find.text('Please fill all fields'), findsNothing);

      // Navigate back
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.byType(ForgotPassPage), findsNothing);
    });

    testWidgets('signup → fill fields → mismatched passwords → error', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignupPage()));
      await tester.pumpAndSettle();

      // All elements present
      expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Confirm Password'), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);

      // Fill with mismatched passwords
      await tester.enterText(find.byType(TextFormField).first, 'user@test.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      await tester.enterText(find.byType(TextFormField).at(2), 'different456');
      await tester.enterText(find.byType(TextFormField).at(3), '123456');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('signup → toggle password visibility', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignupPage()));
      await tester.pumpAndSettle();

      // Two visibility_off icons (password + confirm)
      expect(find.byIcon(Icons.visibility_off), findsNWidgets(2));

      // Toggle first password field
      await tester.tap(find.byIcon(Icons.visibility_off).first);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_off), findsNWidgets(1));
      expect(find.byIcon(Icons.remove_red_eye), findsOneWidget);
    });
  });
}
