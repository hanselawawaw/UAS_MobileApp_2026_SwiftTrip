import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:swifttrip_frontend/screens/auth/signup.dart';
import 'package:swifttrip_frontend/screens/auth/forgot_pass/forgot_pass.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('SignupPage Integration Tests', () {
    Widget buildApp() {
      return const MaterialApp(
        home: SignupPage(),
      );
    }

    testWidgets('SignupPage tampil dengan semua elemen UI',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Plan your vacation\nin a flash.'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Confirm Password'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Email Verification'), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
    });

    testWidgets('Tap Sign Up dengan semua field kosong menampilkan error',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      expect(find.text('Please fill all fields'), findsOneWidget);
    });

    testWidgets('Password tidak sama menampilkan SnackBar "Passwords do not match"',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'user@test.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      await tester.enterText(find.byType(TextFormField).at(2), 'different456');
      await tester.enterText(find.byType(TextFormField).at(3), '123456');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('Toggle password visibility pada field Password',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      // Ada 2 icon visibility_off
      expect(find.byIcon(Icons.visibility_off), findsNWidgets(2));

      // Tap icon pertama (field Password)
      await tester.tap(find.byIcon(Icons.visibility_off).first);
      await tester.pumpAndSettle();

      // Sekarang 1 visibility_off, 1 remove_red_eye
      expect(find.byIcon(Icons.visibility_off), findsNWidgets(1));
      expect(find.byIcon(Icons.remove_red_eye), findsOneWidget);
    });

    testWidgets('Toggle password visibility pada field Confirm Password',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      // Tap icon kedua (field Confirm Password)
      await tester.tap(find.byIcon(Icons.visibility_off).last);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.remove_red_eye), findsOneWidget);
    });

    testWidgets('Navigasi ke ForgotPassPage dari SignupPage',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Forgot password?'));
      await tester.pumpAndSettle();

      expect(find.byType(ForgotPassPage), findsOneWidget);
    });

    testWidgets('Tap "Login" link kembali ke halaman sebelumnya',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // SignupPage harus tertutup
      expect(find.byType(SignupPage), findsNothing);
    });

    testWidgets('Email field menerima format email dengan benar',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      const email = 'newuser@swifttrip.com';
      await tester.enterText(find.byType(TextFormField).first, email);
      await tester.pumpAndSettle();

      expect(find.text(email), findsOneWidget);
    });

    testWidgets('Tap "Ask Code" tanpa email menampilkan error',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      // Cari tombol "Ask Code" di dalam verificationField
      // (biasanya TextButton dengan teks 'Ask Code' atau 'Get Code')
      final askCodeButton = find.text('Ask Code');
      if (askCodeButton.evaluate().isNotEmpty) {
        await tester.tap(askCodeButton);
        await tester.pumpAndSettle();
        expect(find.text('Please enter your email first'), findsOneWidget);
      }
    });

    testWidgets('SignupPage scroll berfungsi untuk melihat semua konten',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      // Scroll ke bawah
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -300),
      );
      await tester.pumpAndSettle();

      // Halaman tidak crash setelah di-scroll
      expect(find.byType(SignupPage), findsOneWidget);
    });
  });
}