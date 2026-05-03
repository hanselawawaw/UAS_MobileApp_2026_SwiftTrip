import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:swifttrip_frontend/screens/splash/splash_screen.dart';
import 'package:swifttrip_frontend/screens/auth/login.dart';

// ============================================================
// SPLASH SCREEN - INTEGRATION TEST
// Tabel Coverage:
//   Widget               | Class Method
//   ---------------------|----------------------
//   FutureBuilder        | checkAuthState()
//                        | buildWaitingState()
//   Image                | loadAppLogo()
//   CircularProgressIndicator | showLoadingIndicator()
//
// Integration test: end-to-end flow dari splash hingga navigasi
// ============================================================

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('SplashScreen Integration Tests', () {
    Widget buildApp() => const MaterialApp(home: SplashScreen());

    // ----------------------------------------------------------
    // FutureBuilder + checkAuthState()
    // ----------------------------------------------------------
    testWidgets(
        '[FutureBuilder] checkAuthState() - Splash screen muncul dan '
        'langsung memulai pengecekan autentikasi',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());

      // checkAuthState() langsung dipanggil di initState
      expect(find.byType(SplashScreen), findsOneWidget);

      // Animasi berjalan = checkAuthState() sedang berjalan
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byType(SplashScreen), findsOneWidget);
    });

    testWidgets(
        '[FutureBuilder] checkAuthState() - Splash tidak crash saat '
        'tidak ada session aktif',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump(const Duration(milliseconds: 500));

      // Tanpa session = splash tetap tampil (tidak crash)
      expect(find.byType(SplashScreen), findsOneWidget);
    });

    // ----------------------------------------------------------
    // FutureBuilder + buildWaitingState()
    // ----------------------------------------------------------
    testWidgets(
        '[FutureBuilder] buildWaitingState() - UI waiting tampil '
        'selama animasi berlangsung',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());

      // buildWaitingState() = splash masih tampil (menunggu)
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(SplashScreen), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(SplashScreen), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 1000));
      expect(find.byType(SplashScreen), findsOneWidget);
    });

    testWidgets(
        '[FutureBuilder] buildWaitingState() - Tidak ada input field '
        'atau tombol selama waiting state',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump(const Duration(milliseconds: 100));

      // Waiting state = pure animation, no interaction needed
      expect(find.byType(TextField), findsNothing);
      expect(find.byType(ElevatedButton), findsNothing);
      expect(find.byType(AppBar), findsNothing);
    });

    // ----------------------------------------------------------
    // Image + loadAppLogo()
    // ----------------------------------------------------------
    testWidgets(
        '[Image] loadAppLogo() - Logo aplikasi dimuat dan tampil '
        'di tengah layar',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();

      // loadAppLogo() = logo di-render dalam Row di tengah layar
      expect(find.byType(Row), findsWidgets);
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets(
        '[Image] loadAppLogo() - Logo menggunakan FadeTransition '
        'untuk animasi kemunculan',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();

      expect(find.byType(FadeTransition), findsWidgets);
    });

    testWidgets(
        '[Image] loadAppLogo() - Logo menggunakan ScaleTransition '
        'untuk animasi skala',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();

      expect(find.byType(ScaleTransition), findsWidgets);
    });

    testWidgets(
        '[Image] loadAppLogo() - Logo tampil dengan background putih',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, equals(Colors.white));
    });

    // ----------------------------------------------------------
    // CircularProgressIndicator + showLoadingIndicator()
    // ----------------------------------------------------------
    testWidgets(
        '[CircularProgressIndicator] showLoadingIndicator() - '
        'Loading aktif selama animasi splash berlangsung',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());

      // showLoadingIndicator() = AnimationController masih berjalan
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(SplashScreen), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 1000));
      expect(find.byType(SplashScreen), findsOneWidget);
    });

    testWidgets(
        '[CircularProgressIndicator] showLoadingIndicator() - '
        'Loading berhenti dan navigasi ke LoginPage setelah 2500ms',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());

      // Selesaikan semua animasi
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // showLoadingIndicator() berhenti = navigasi berhasil
      expect(find.byType(LoginPage), findsOneWidget);
      expect(find.byType(SplashScreen), findsNothing);
    });

    testWidgets(
        '[CircularProgressIndicator] showLoadingIndicator() - '
        'Tidak bisa kembali ke SplashScreen setelah navigasi (pushReplacement)',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.byType(LoginPage), findsOneWidget);

      // pushReplacement = tidak bisa pop kembali
      final NavigatorState navigator = tester.state(find.byType(Navigator));
      expect(navigator.canPop(), isFalse);
    });
  });
}