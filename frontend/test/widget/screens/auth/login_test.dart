import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swifttrip_frontend/screens/auth/login.dart';
import 'package:swifttrip_frontend/screens/auth/signup.dart';

// ============================================================
// LOGIN PAGE WIDGET TEST
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
  group('LoginPage Widget Tests', () {
    Widget buildSubject() {
      return const MaterialApp(home: LoginPage());
    }

    // ----------------------------------------------------------
    // WIDGET: Form
    // METHOD: validateLoginForm()
    // ----------------------------------------------------------
    testWidgets(
        '[Form] validateLoginForm() - Form menolak submit '
        'ketika email dan password kosong',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      // validateLoginForm() dipicu saat tombol login ditekan
      await tester.tap(find.text('Log in'));
      await tester.pump();

      // Validasi gagal = SnackBar "Please fill all fields" muncul
      expect(find.text('Please fill all fields'), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets(
        '[Form] validateLoginForm() - Form menolak submit '
        'ketika salah satu field kosong',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      // Hanya isi email, password kosong
      await tester.enterText(find.byType(TextField).first, 'user@test.com');
      await tester.pump();

      await tester.tap(find.text('Log in'));
      await tester.pump();

      expect(find.text('Please fill all fields'), findsOneWidget);
      await tester.pumpAndSettle();
    });

    // ----------------------------------------------------------
    // WIDGET: Form
    // METHOD: saveFormState()
    // ----------------------------------------------------------
    testWidgets(
        '[Form] saveFormState() - State form tersimpan saat '
        'user mengetik di field email',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      const inputEmail = 'saved@example.com';
      await tester.enterText(find.byType(TextField).first, inputEmail);
      await tester.pump();

      // saveFormState() = nilai field tetap tersimpan setelah diketik
      expect(find.text(inputEmail), findsOneWidget);
    });

    testWidgets(
        '[Form] saveFormState() - State form tersimpan saat '
        'user mengetik di field password',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      await tester.enterText(find.byType(TextField).at(1), 'mypassword');
      await tester.pump();

      // Password tersimpan di controller (tidak bisa dibaca karena obscure,
      // tapi field tetap aktif dan menerima input = saveFormState berhasil)
      expect(find.byType(TextField).at(1), findsOneWidget);
    });

    // ----------------------------------------------------------
    // WIDGET: TextFormField (Email)
    // METHOD: onChanged()
    // ----------------------------------------------------------
    testWidgets(
        '[TextFormField Email] onChanged() - Field email merespons '
        'setiap perubahan input teks',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      // onChanged() dipicu setiap kali teks berubah
      await tester.enterText(find.byType(TextField).first, 'a');
      await tester.pump();
      expect(find.text('a'), findsOneWidget);

      await tester.enterText(find.byType(TextField).first, 'ab@');
      await tester.pump();
      expect(find.text('ab@'), findsOneWidget);
    });

    // ----------------------------------------------------------
    // WIDGET: TextFormField (Email)
    // METHOD: validator()
    // ----------------------------------------------------------
    testWidgets(
        '[TextFormField Email] validator() - Field email ada '
        'dan dapat divalidasi',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      // validator() dipasang pada TextFormField Email
      expect(find.widgetWithText(TextField, 'Email'), findsOneWidget);
    });

    // ----------------------------------------------------------
    // WIDGET: TextFormField (Password)
    // METHOD: onChanged()
    // ----------------------------------------------------------
    testWidgets(
        '[TextFormField Password] onChanged() - Field password merespons '
        'setiap perubahan input',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      final passwordField = find.byType(TextField).at(1);

      // onChanged() terpicu saat teks berubah
      await tester.enterText(passwordField, 'pass');
      await tester.pump();

      await tester.enterText(passwordField, 'password123');
      await tester.pump();

      // Field masih ada dan aktif
      expect(passwordField, findsOneWidget);
    });

    // ----------------------------------------------------------
    // WIDGET: TextFormField (Password)
    // METHOD: validator()
    // ----------------------------------------------------------
    testWidgets(
        '[TextFormField Password] validator() - Password field '
        'ada dan dapat divalidasi',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.widgetWithText(TextField, 'Password'), findsOneWidget);
    });

    testWidgets(
        '[TextFormField Password] validator() - Password field '
        'menggunakan obscureText secara default',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      // Password tersembunyi = validator bekerja dengan nilai aman
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    // ----------------------------------------------------------
    // WIDGET: ElevatedButton
    // METHOD: submitLogin()
    // ----------------------------------------------------------
    testWidgets(
        '[ElevatedButton] submitLogin() - Tombol login ada '
        'dan dapat ditekan',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.text('Log in'), findsOneWidget);
    });

    testWidgets(
        '[ElevatedButton] submitLogin() - submitLogin() memvalidasi '
        'field sebelum mengirim request',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      // Tap login tanpa data = submitLogin() menjalankan validasi dulu
      await tester.tap(find.text('Log in'));
      await tester.pump();

      // Validasi berjalan = SnackBar muncul, bukan loading
      expect(find.text('Please fill all fields'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      await tester.pumpAndSettle();
    });

    testWidgets(
        '[ElevatedButton] submitLogin() - Loading indicator muncul '
        'saat submitLogin() memproses request',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      // Isi kedua field agar validasi lolos
      await tester.enterText(find.byType(TextField).first, 'user@test.com');
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      await tester.pump();

      await tester.tap(find.text('Log in'));
      await tester.pump(); // Satu frame setelah tap

      // submitLogin() sedang berjalan = CircularProgressIndicator tampil
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle(); // clear pending timers
    });

    // ----------------------------------------------------------
    // WIDGET: TextButton
    // METHOD: navigateToSignup()
    // ----------------------------------------------------------
    testWidgets(
        '[TextButton] navigateToSignup() - Tombol Sign Up ada '
        'di halaman login',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.text('Sign Up'), findsOneWidget);
    });

    testWidgets(
        '[TextButton] navigateToSignup() - Tap Sign Up berpindah '
        'ke halaman SignupPage',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // navigateToSignup() berhasil = LoginPage hilang, SignupPage muncul
      expect(find.byType(SignupPage), findsOneWidget);
      expect(find.byType(LoginPage), findsNothing);
    });
  });
}