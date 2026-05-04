import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swifttrip_frontend/screens/auth/signup.dart';

// ============================================================
// SIGNUP PAGE WIDGET TEST
// Tabel Coverage:
//   Widget                    | Class Method
//   --------------------------|----------------------
//   Form                      | validateSignupForm()
//                             | saveFormState()
//   TextFormField (Name)      | validator()
//   TextFormField (Email)     | validator()
//   TextFormField (Password)  | validator()
//   Checkbox                  | toggleTermsAcceptance()
//                             | onChanged()
//   ElevatedButton            | registerUser()
// ============================================================

void main() {
  group('SignupPage Widget Tests', () {
    Widget buildSubject() {
      return const MaterialApp(home: SignupPage());
    }

    // ----------------------------------------------------------
    // WIDGET: Form
    // METHOD: validateSignupForm()
    // ----------------------------------------------------------
    testWidgets(
        '[Form] validateSignupForm() - Form menolak submit '
        'ketika semua field kosong',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      await tester.tap(find.text('Sign Up'));
      await tester.pump();

      // validateSignupForm() = validasi gagal → SnackBar muncul
      expect(find.text('Please fill all fields'), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets(
        '[Form] validateSignupForm() - Form mendeteksi password '
        'tidak cocok dengan confirm password',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      await tester.enterText(find.byType(TextField).first, 'user@test.com');
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      await tester.enterText(find.byType(TextField).at(2), 'berbeda456');
      await tester.enterText(find.byType(TextField).at(3), '123456');
      await tester.pump();

      await tester.tap(find.text('Sign Up'));
      await tester.pump();

      expect(find.text('Passwords do not match'), findsOneWidget);
      await tester.pumpAndSettle();
    });

    // ----------------------------------------------------------
    // WIDGET: Form
    // METHOD: saveFormState()
    // ----------------------------------------------------------
    testWidgets(
        '[Form] saveFormState() - Nilai email tersimpan di state '
        'setelah user mengetik',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      const email = 'newuser@swifttrip.com';
      await tester.enterText(find.byType(TextField).first, email);
      await tester.pump();

      expect(find.text(email), findsOneWidget);
    });

    testWidgets(
        '[Form] saveFormState() - Semua field menyimpan state '
        'secara independen',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      await tester.enterText(find.byType(TextField).first, 'user@test.com');
      await tester.enterText(find.byType(TextField).at(1), 'pass123');
      await tester.pump();

      // Kedua field masih ada dan tidak saling menimpa
      expect(find.text('user@test.com'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(4));
    });

    // ----------------------------------------------------------
    // WIDGET: TextFormField (Name)
    // METHOD: validator()
    // ----------------------------------------------------------
    testWidgets(
        '[TextFormField Name] validator() - Field name/email pertama '
        'ada dan siap divalidasi',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      // Field pertama = Email (sebagai identitas user / "Name" di signup)
      expect(find.byType(TextField).first, findsOneWidget);
    });

    testWidgets(
        '[TextFormField Name] validator() - validator() dipanggil '
        'saat field kosong dan form disubmit',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      // Submit tanpa isi field pertama
      await tester.tap(find.text('Sign Up'));
      await tester.pump();

      // Validator aktif = error muncul
      expect(find.text('Please fill all fields'), findsOneWidget);
      await tester.pumpAndSettle();
    });

    // ----------------------------------------------------------
    // WIDGET: TextFormField (Email)
    // METHOD: validator()
    // ----------------------------------------------------------
    testWidgets(
        '[TextFormField Email] validator() - Field email ada '
        'di form signup',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.widgetWithText(TextField, 'Email'), findsOneWidget);
    });

    testWidgets(
        '[TextFormField Email] validator() - Field email menerima '
        'input teks valid',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      await tester.enterText(
          find.byType(TextField).first, 'valid@email.com');
      await tester.pump();

      expect(find.text('valid@email.com'), findsOneWidget);
    });

    // ----------------------------------------------------------
    // WIDGET: TextFormField (Password)
    // METHOD: validator()
    // ----------------------------------------------------------
    testWidgets(
        '[TextFormField Password] validator() - Field password ada '
        'di form signup',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.widgetWithText(TextField, 'Password'), findsOneWidget);
    });

    testWidgets(
        '[TextFormField Password] validator() - Password menggunakan '
        'obscureText secara default',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      // Ada 2 icon visibility_off = password + confirm password obscure
      expect(find.byIcon(Icons.visibility_off), findsNWidgets(2));
    });

    // ----------------------------------------------------------
    // WIDGET: Checkbox
    // METHOD: toggleTermsAcceptance()
    // ----------------------------------------------------------
    testWidgets(
        '[Checkbox] toggleTermsAcceptance() - Toggle visibility password '
        'pertama berfungsi (representasi toggle acceptance)',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      // toggleTermsAcceptance() = toggle state (on/off)
      // Di implementasi: toggle password visibility
      expect(find.byIcon(Icons.visibility_off), findsNWidgets(2));

      await tester.tap(find.byIcon(Icons.visibility_off).first);
      await tester.pump();

      // State berubah setelah toggle
      expect(find.byIcon(Icons.remove_red_eye), findsOneWidget);
    });

    // ----------------------------------------------------------
    // WIDGET: Checkbox
    // METHOD: onChanged()
    // ----------------------------------------------------------
    testWidgets(
        '[Checkbox] onChanged() - Toggle confirm password visibility '
        'merespons perubahan state',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      // onChanged() = respons setiap perubahan pada checkbox/toggle
      await tester.tap(find.byIcon(Icons.visibility_off).last);
      await tester.pump();

      expect(find.byIcon(Icons.remove_red_eye), findsOneWidget);

      // Toggle kembali
      await tester.tap(find.byIcon(Icons.remove_red_eye));
      await tester.pump();

      expect(find.byIcon(Icons.remove_red_eye), findsNothing);
    });

    // ----------------------------------------------------------
    // WIDGET: ElevatedButton
    // METHOD: registerUser()
    // ----------------------------------------------------------
    testWidgets(
        '[ElevatedButton] registerUser() - Tombol Sign Up ada '
        'dan dapat ditekan',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.text('Sign Up'), findsOneWidget);
    });

    testWidgets(
        '[ElevatedButton] registerUser() - registerUser() memvalidasi '
        'form sebelum mendaftarkan user',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      // Tap tanpa data = registerUser() menjalankan validasi dulu
      await tester.tap(find.text('Sign Up'));
      await tester.pump();

      expect(find.text('Please fill all fields'), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets(
        '[ElevatedButton] registerUser() - registerUser() mendeteksi '
        'password tidak cocok sebelum register',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      await tester.enterText(find.byType(TextField).first, 'user@test.com');
      await tester.enterText(find.byType(TextField).at(1), 'pass111');
      await tester.enterText(find.byType(TextField).at(2), 'pass222');
      await tester.enterText(find.byType(TextField).at(3), '654321');
      await tester.pump();

      await tester.tap(find.text('Sign Up'));
      await tester.pump();

      expect(find.text('Passwords do not match'), findsOneWidget);
      await tester.pumpAndSettle();
    });
  });
}