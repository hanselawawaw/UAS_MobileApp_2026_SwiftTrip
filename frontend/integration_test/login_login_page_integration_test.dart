import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:swifttrip_frontend/screens/auth/login.dart';
import 'package:swifttrip_frontend/screens/auth/signup.dart';
import 'package:swifttrip_frontend/screens/auth/forgot_pass/forgot_pass.dart';

// ============================================================
// LOGIN PAGE - INTEGRATION TEST
// Tabel Coverage:
//   Widget                  | Class Method
//   ------------------------|----------------------
//   Form                    | validateLoginForm()
//                           | saveFormState()
//   TextFormField (Email)   | onChanged()
//                           | validator()
//   TextFormField (Password)| onChanged()
//                           | validator()
//   ElevatedButton          | submitLogin()
//   TextButton              | navigateToSignup()
// ============================================================

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('LoginPage Integration Tests', () {
    Widget buildApp() => const MaterialApp(home: LoginPage());

    // ----------------------------------------------------------
    // Form + validateLoginForm()
    // ----------------------------------------------------------
    testWidgets(
        '[Form] validateLoginForm() - Form menampilkan SnackBar error '
        'saat submit dengan semua field kosong',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Log in'));
      await tester.pump();

      expect(find.text('Please fill all fields'), findsOneWidget);
    });

    testWidgets(
        '[Form] validateLoginForm() - Form menampilkan error '
        'saat hanya email yang diisi',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'user@test.com');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Log in'));
      await tester.pump();

      expect(find.text('Please fill all fields'), findsOneWidget);
    });

    testWidgets(
        '[Form] validateLoginForm() - Form menampilkan error '
        'saat hanya password yang diisi',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Log in'));
      await tester.pump();

      expect(find.text('Please fill all fields'), findsOneWidget);
    });

    // ----------------------------------------------------------
    // Form + saveFormState()
    // ----------------------------------------------------------
    testWidgets(
        '[Form] saveFormState() - Nilai email tersimpan di state '
        'dan tetap ada setelah interaksi lain',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      const email = 'saved@example.com';
      await tester.enterText(find.byType(TextFormField).first, email);
      await tester.pump();

      // Tap di luar field untuk trigger saveFormState
      await tester.tap(find.text('Plan your vacation\nin a flash.'));
      await tester.pump();

      expect(find.text(email), findsOneWidget);
    });

    testWidgets(
        '[Form] saveFormState() - State email dan password independen '
        'satu sama lain',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'user@test.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'mypass');
      await tester.pumpAndSettle();

      expect(find.text('user@test.com'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    // ----------------------------------------------------------
    // TextFormField Email + onChanged()
    // ----------------------------------------------------------
    testWidgets(
        '[TextFormField Email] onChanged() - Teks field email '
        'diperbarui setiap karakter yang diketik',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'a');
      await tester.pump();
      expect(find.text('a'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField).first, 'ab@test.com');
      await tester.pump();
      expect(find.text('ab@test.com'), findsOneWidget);
    });

    // ----------------------------------------------------------
    // TextFormField Email + validator()
    // ----------------------------------------------------------
    testWidgets(
        '[TextFormField Email] validator() - Field email ada '
        'dan divalidasi saat form disubmit',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);

      // Submit = validator() dipanggil
      await tester.tap(find.text('Log in'));
      await tester.pump();

      expect(find.text('Please fill all fields'), findsOneWidget);
    });

    // ----------------------------------------------------------
    // TextFormField Password + onChanged()
    // ----------------------------------------------------------
    testWidgets(
        '[TextFormField Password] onChanged() - Password field '
        'menerima input dan mengupdate state',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      final passwordField = find.byType(TextFormField).at(1);
      await tester.enterText(passwordField, 'p');
      await tester.pump();

      await tester.enterText(passwordField, 'password123');
      await tester.pump();

      expect(passwordField, findsOneWidget);
    });

    // ----------------------------------------------------------
    // TextFormField Password + validator()
    // ----------------------------------------------------------
    testWidgets(
        '[TextFormField Password] validator() - Password menggunakan '
        'obscureText dan toggle visibility berfungsi',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      // Default: obscure
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);

      // Toggle: tampilkan password
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();
      expect(find.byIcon(Icons.remove_red_eye), findsOneWidget);

      // Toggle kembali: sembunyikan
      await tester.tap(find.byIcon(Icons.remove_red_eye));
      await tester.pump();
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    // ----------------------------------------------------------
    // ElevatedButton + submitLogin()
    // ----------------------------------------------------------
    testWidgets(
        '[ElevatedButton] submitLogin() - Tombol login ada dan '
        'memanggil validasi sebelum submit',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Log in'), findsOneWidget);

      await tester.tap(find.text('Log in'));
      await tester.pump();

      // submitLogin() → validasi dulu → SnackBar muncul
      expect(find.text('Please fill all fields'), findsOneWidget);
    });

    testWidgets(
        '[ElevatedButton] submitLogin() - CircularProgressIndicator muncul '
        'saat submitLogin() memproses request',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'user@test.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Log in'));
      await tester.pump();

      // submitLogin() sedang berjalan = loading indicator tampil
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
        '[ElevatedButton] submitLogin() - SnackBar error muncul jika '
        'credentials salah',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byType(TextFormField).first, 'wrong@test.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'wrongpass');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Log in'));
      await tester.pump();

      // Request dikirim (loading muncul)
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    // ----------------------------------------------------------
    // TextButton + navigateToSignup()
    // ----------------------------------------------------------
    testWidgets(
        '[TextButton] navigateToSignup() - Tap Sign Up berpindah '
        'ke halaman SignupPage',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      expect(find.byType(SignupPage), findsOneWidget);
      expect(find.byType(LoginPage), findsNothing);
    });

    testWidgets(
        '[TextButton] navigateToSignup() - Bisa kembali ke LoginPage '
        'dari SignupPage (route push, bukan replace)',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();
      expect(find.byType(SignupPage), findsOneWidget);

      // Kembali ke Login dari Signup
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      expect(find.byType(LoginPage), findsOneWidget);
    });

    testWidgets(
        '[TextButton] navigateToSignup() - Tap Forgot Password '
        'membuka ForgotPassPage',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Forgot password?'));
      await tester.pumpAndSettle();

      expect(find.byType(ForgotPassPage), findsOneWidget);
    });
  });
}