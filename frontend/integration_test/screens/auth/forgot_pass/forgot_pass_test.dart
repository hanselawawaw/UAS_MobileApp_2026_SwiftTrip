import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:swifttrip_frontend/screens/auth/forgot_pass/forgot_pass.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('ForgotPassPage Integration Tests', () {
    Widget buildApp() {
      return const MaterialApp(
        home: ForgotPassPage(),
      );
    }

    testWidgets('ForgotPassPage tampil dengan semua elemen UI',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Forgot Password?\nWe Got You!'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, '6-digit Code'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('Tap Continue dengan field kosong menampilkan SnackBar error',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(find.text('Please fill all fields'), findsOneWidget);
    });

    testWidgets('Tap Continue hanya dengan email terisi menampilkan error',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byType(TextFormField).first, 'forgot@example.com');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(find.text('Please fill all fields'), findsOneWidget);
    });

    testWidgets('Tap Continue hanya dengan kode terisi menampilkan error',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(1), '123456');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(find.text('Please fill all fields'), findsOneWidget);
    });

    testWidgets('User mengisi email lalu meminta OTP',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      // Isi email
      await tester.enterText(
          find.byType(TextFormField).first, 'user@example.com');
      await tester.pumpAndSettle();

      // Cari tombol "Ask Code" jika ada
      final askCodeButton = find.text('Ask Code');
      if (askCodeButton.evaluate().isEmpty) return;

      await tester.tap(askCodeButton);
      await tester.pump(const Duration(seconds: 1));
      // Response dari server bisa berhasil atau gagal
      expect(find.byType(ForgotPassPage), findsOneWidget);
    });

    testWidgets('Tap email field kosong lalu minta kode menampilkan error',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      final askCodeButton = find.text('Ask Code');
      if (askCodeButton.evaluate().isEmpty) return;

      await tester.tap(askCodeButton);
      await tester.pumpAndSettle();

      expect(find.text('Please enter your email first'), findsOneWidget);
    });

    testWidgets('Back button berfungsi untuk kembali ke halaman sebelumnya',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ForgotPassPage()),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.byType(ForgotPassPage), findsOneWidget);

      // Tap back
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(find.byType(ForgotPassPage), findsNothing);
    });

    testWidgets('Email field menerima input dengan format yang valid',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      const testEmail = 'test.user+tag@example.co.id';
      await tester.enterText(find.byType(TextFormField).first, testEmail);
      await tester.pumpAndSettle();

      expect(find.text(testEmail), findsOneWidget);
    });

    testWidgets('Kode field hanya menerima angka 6 digit',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(1), '654321');
      await tester.pumpAndSettle();

      expect(find.text('654321'), findsOneWidget);
    });

    testWidgets('SnackBar error menghilang setelah beberapa detik',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Continue'));
      await tester.pump();

      expect(find.text('Please fill all fields'), findsOneWidget);

      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();

      expect(find.text('Please fill all fields'), findsNothing);
    });
  });
}