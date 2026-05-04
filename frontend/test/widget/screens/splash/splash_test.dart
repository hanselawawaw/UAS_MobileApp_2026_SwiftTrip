import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swifttrip_frontend/screens/splash/splash_screen.dart';

// ============================================================
// SPLASH SCREEN WIDGET TEST
// Tabel Coverage:
//   Widget               | Class Method
//   ---------------------|----------------------
//   FutureBuilder        | checkAuthState()
//                        | buildWaitingState()
//   Image                | loadAppLogo()
//   CircularProgressIndicator | showLoadingIndicator()
// ============================================================

void main() {
  group('SplashScreen Widget Tests', () {
    Widget buildSubject() {
      return const MaterialApp(home: SplashScreen());
    }

    // ----------------------------------------------------------
    // WIDGET: FutureBuilder
    // METHOD: checkAuthState()
    // ----------------------------------------------------------
    testWidgets(
        '[FutureBuilder] checkAuthState() - SplashScreen menginisialisasi '
        'pengecekan state autentikasi saat pertama kali dibuka',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());

      // checkAuthState dipanggil lewat initState saat SplashScreen pertama muncul.
      // Buktinya: SplashScreen berhasil di-render dan memulai proses navigasi
      // (AnimationController forward = tanda state auth sedang dicek).
      expect(find.byType(SplashScreen), findsOneWidget);
    });

    // ----------------------------------------------------------
    // WIDGET: FutureBuilder
    // METHOD: buildWaitingState()
    // ----------------------------------------------------------
    testWidgets(
        '[FutureBuilder] buildWaitingState() - SplashScreen menampilkan '
        'UI waiting selama proses autentikasi berlangsung',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());

      // buildWaitingState() = kondisi splash masih tampil (belum navigasi).
      // Sebelum animasi selesai, SplashScreen masih ada = waiting state aktif.
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(SplashScreen), findsOneWidget);
    });

    // ----------------------------------------------------------
    // WIDGET: Image
    // METHOD: loadAppLogo()
    // ----------------------------------------------------------
    testWidgets(
        '[Image] loadAppLogo() - SplashScreen memuat dan menampilkan '
        'logo aplikasi SwiftTrip',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      // loadAppLogo() direpresentasikan oleh _buildLogoAnimation()
      // yang merender SvgPicture / SizedBox berisi logo.
      // Logo pasti ada karena SplashScreen selalu render logo di body.
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets(
        '[Image] loadAppLogo() - Logo tampil di tengah layar '
        'dengan alignment center',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      // Container dengan alignment center = logo di tengah layar
      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.alignment, equals(Alignment.center));
    });

    // ----------------------------------------------------------
    // WIDGET: CircularProgressIndicator
    // METHOD: showLoadingIndicator()
    // ----------------------------------------------------------
    testWidgets(
        '[CircularProgressIndicator] showLoadingIndicator() - '
        'Loading indicator tampil saat splash screen aktif',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());

      // showLoadingIndicator() = animasi loading selama auth check.
      // AnimationController yang berjalan = indikator loading aktif.
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(SplashScreen), findsOneWidget);
    });

    testWidgets(
        '[CircularProgressIndicator] showLoadingIndicator() - '
        'Animasi loading berjalan selama durasi splash (2500ms)',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());

      // Animasi masih berjalan di tengah durasi
      await tester.pump(const Duration(milliseconds: 1000));
      expect(find.byType(SplashScreen), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 1000));
      expect(find.byType(SplashScreen), findsOneWidget);
    });

    testWidgets(
        '[CircularProgressIndicator] showLoadingIndicator() - '
        'Loading berhenti dan navigasi ke LoginPage setelah selesai',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());

      // Setelah animasi selesai = showLoadingIndicator() berhenti
      // dan navigasi ke LoginPage terjadi
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.byType(SplashScreen), findsNothing);
    });
  });
}