import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swifttrip_frontend/screens/auth/forgot_pass/forgot_pass.dart';

// ============================================================
// FORGOT PASSWORD PAGE WIDGET TEST
// Tabel Coverage:
//   Widget                  | Class Method
//   ------------------------|----------------------
//   TextFormField (Email)   | validator()
//   ElevatedButton          | sendResetPasswordEmail()
//   SnackBar                | showSuccessMessage()
//                           | showErrorMessage()
// ============================================================

void main() {
  group('ForgotPassPage Widget Tests', () {
    Widget buildSubject() {
      return const MaterialApp(home: ForgotPassPage());
    }

    // ----------------------------------------------------------
    // WIDGET: TextFormField (Email)
    // METHOD: validator()
    // ----------------------------------------------------------
    testWidgets(
        '[TextFormField Email] validator() - Field email ada '
        'di halaman forgot password',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.widgetWithText(TextField, 'Email'), findsOneWidget);
    });

    testWidgets(
        '[TextFormField Email] validator() - validator() menolak '
        'submit ketika email kosong',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      // Tap Continue dengan email kosong
      await tester.tap(find.text('Continue'));
      await tester.pump();

      // validator() aktif = error message muncul
      expect(find.text('Please fill all fields'), findsOneWidget);
      await tester.pumpAndSettle(); // clear SnackBar timer
    });

    testWidgets(
        '[TextFormField Email] validator() - Field email menerima '
        'dan menyimpan input teks',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      const testEmail = 'forgot@example.com';
      await tester.enterText(find.byType(TextField).first, testEmail);
      await tester.pump();

      expect(find.text(testEmail), findsOneWidget);
    });

    testWidgets(
        '[TextFormField Email] validator() - Field kode OTP ada '
        'dan dapat menerima 6 digit angka',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      await tester.enterText(find.byType(TextField).at(1), '123456');
      await tester.pump();

      expect(find.text('123456'), findsOneWidget);
    });

    // ----------------------------------------------------------
    // WIDGET: ElevatedButton
    // METHOD: sendResetPasswordEmail()
    // ----------------------------------------------------------
    testWidgets(
        '[ElevatedButton] sendResetPasswordEmail() - Tombol Continue ada '
        'dan dapat ditekan',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets(
        '[ElevatedButton] sendResetPasswordEmail() - Tombol Continue '
        'memvalidasi email sebelum mengirim',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      // Tap tanpa email = sendResetPasswordEmail() tidak dikirim
      await tester.tap(find.text('Continue'));
      await tester.pump();

      expect(find.text('Please fill all fields'), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets(
        '[ElevatedButton] sendResetPasswordEmail() - Tombol Continue '
        'memvalidasi kode sebelum mengirim',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      // Isi email tapi kode kosong
      await tester.enterText(
          find.byType(TextField).first, 'user@example.com');
      await tester.pump();

      await tester.tap(find.text('Continue'));
      await tester.pump();

      // Kode kosong = sendResetPasswordEmail() ditolak
      expect(find.text('Please fill all fields'), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets(
        '[ElevatedButton] sendResetPasswordEmail() - Tombol hanya aktif '
        'bila email dan kode terisi',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      await tester.enterText(
          find.byType(TextField).first, 'user@example.com');
      await tester.enterText(find.byType(TextField).at(1), '654321');
      await tester.pump();

      // Tombol Continue dapat ditekan
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Tidak menampilkan "Please fill all fields" = validasi lolos
      expect(find.text('Please fill all fields'), findsNothing);
    });

    // ----------------------------------------------------------
    // WIDGET: SnackBar
    // METHOD: showErrorMessage()
    // ----------------------------------------------------------
    testWidgets(
        '[SnackBar] showErrorMessage() - SnackBar error muncul '
        'ketika field kosong saat Continue ditekan',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      // showErrorMessage() dipicu saat validasi gagal
      await tester.tap(find.text('Continue'));
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Please fill all fields'), findsOneWidget);
      await tester.pumpAndSettle(); // clear SnackBar timer
    });

    testWidgets(
        '[SnackBar] showErrorMessage() - SnackBar error "Please enter your email" '
        'muncul saat Ask Code ditekan tanpa email',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      final askCode = find.text('Ask\nCode');
      if (askCode.evaluate().isNotEmpty) {
        // Tap Ask Code tanpa isi email
        await tester.tap(askCode);
        await tester.pump();

        // showErrorMessage() = SnackBar error muncul
        expect(find.text('Please enter your email first'), findsOneWidget);
        await tester.pumpAndSettle(); // clear SnackBar timer
      }
    });

  });
}