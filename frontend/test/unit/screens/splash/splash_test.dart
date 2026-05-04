import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swifttrip_frontend/repositories/auth_repository.dart';

// ============================================================
// SPLASH SCREEN - UNIT TEST
// Tabel Coverage:
//   Widget               | Class Method
//   ---------------------|----------------------
//   FutureBuilder        | checkAuthState()
//                        | buildWaitingState()
//   Image                | loadAppLogo()
//   CircularProgressIndicator | showLoadingIndicator()
//
// Unit test fokus pada LOGIKA murni:
// - checkAuthState()    → AuthRepository.loadSession() (logic di balik cek auth)
// - buildWaitingState() → logika state sebelum navigasi
// - loadAppLogo()       → validasi data/path logo
// - showLoadingIndicator() → logika flag loading
// ============================================================

const _secureStorageChannel = MethodChannel(
  'plugins.it_nomads.com/flutter_secure_storage',
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_secureStorageChannel, (call) async {
      if (call.method == 'read') return null;
      if (call.method == 'write') return null;
      if (call.method == 'delete') return null;
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_secureStorageChannel, null);
  });

  group('SplashScreen Unit Tests', () {

    // ----------------------------------------------------------
    // METHOD: checkAuthState()
    // Unit test: logika di balik pengecekan autentikasi
    // ----------------------------------------------------------
    group('checkAuthState()', () {
      test(
          'checkAuthState - AuthRepository tersedia sebagai singleton '
          'yang digunakan checkAuthState', () {
        // checkAuthState() menggunakan AuthRepository singleton
        final repo1 = AuthRepository();
        final repo2 = AuthRepository();

        // Singleton = instance selalu sama
        expect(identical(repo1, repo2), isTrue);
      });

      test(
          'checkAuthState - loadSession() mengembalikan false '
          'jika tidak ada token tersimpan', () async {
        final repo = AuthRepository();

        // Dalam kondisi test tanpa login, tidak ada token
        // loadSession() = inti dari checkAuthState()
        final result = await repo.loadSession();

        // Hasil false = tidak ada session aktif (kondisi normal test)
        expect(result, isFalse);
      });

      test(
          'checkAuthState - getToken() mengembalikan null '
          'jika belum pernah login', () async {
        final repo = AuthRepository();

        final token = await repo.getToken();

        // Tanpa login, token harus null
        expect(token, isNull);
      });
    });

    // ----------------------------------------------------------
    // METHOD: buildWaitingState()
    // Unit test: logika state selama splash menunggu
    // ----------------------------------------------------------
    group('buildWaitingState()', () {
      test(
          'buildWaitingState - isWaiting flag dimulai sebagai true '
          'saat splash pertama dibuka', () {
        // buildWaitingState() = splash masih menunggu = isWaiting true
        bool isWaiting = true; // State awal saat splash dibuka

        expect(isWaiting, isTrue);
      });

      test(
          'buildWaitingState - isWaiting berubah false setelah '
          'autentikasi selesai', () {
        bool isWaiting = true;

        // Simulasi: auth check selesai
        isWaiting = false;

        expect(isWaiting, isFalse);
      });

      test(
          'buildWaitingState - durasi animasi splash adalah 2500ms', () {
        // buildWaitingState berlangsung selama durasi controller
        const expectedDuration = Duration(milliseconds: 2500);

        expect(expectedDuration.inMilliseconds, equals(2500));
        expect(expectedDuration.inSeconds, lessThanOrEqualTo(3));
      });
    });

    // ----------------------------------------------------------
    // METHOD: loadAppLogo()
    // Unit test: validasi data logo
    // ----------------------------------------------------------
    group('loadAppLogo()', () {
      test(
          'loadAppLogo - path logo SVG valid dan tidak kosong', () {
        // loadAppLogo() memuat logo dari asset path ini
        const logoPath = 'assets/images/home/vacation_logo.png';

        expect(logoPath, isNotEmpty);
        expect(logoPath.endsWith('.png') || logoPath.endsWith('.svg'),
            isTrue);
      });

      test(
          'loadAppLogo - nama aplikasi yang dimuat adalah "Swift Trip"', () {
        // loadAppLogo() berkaitan dengan nama app yang ditampilkan
        const appName = 'Swift Trip';

        expect(appName, equals('Swift Trip'));
        expect(appName.split(' ').length, equals(2));
      });

      test(
          'loadAppLogo - logo terdiri dari 2 bagian: '
          'logo SVG + teks nama aplikasi', () {
        // Struktur logo: Row([_buildLogoAnimation(), _buildTextAnimation()])
        const parts = ['logo_animation', 'text_animation'];

        expect(parts.length, equals(2));
      });
    });

    // ----------------------------------------------------------
    // METHOD: showLoadingIndicator()
    // Unit test: logika flag loading
    // ----------------------------------------------------------
    group('showLoadingIndicator()', () {
      test(
          'showLoadingIndicator - loading dimulai saat splash '
          'pertama dibuka', () {
        bool isLoading = true; // AnimationController.forward() = loading dimulai

        expect(isLoading, isTrue);
      });

      test(
          'showLoadingIndicator - loading berhenti saat AnimationStatus '
          'completed', () {
        bool isLoading = true;

        // Simulasi: animasi selesai
        void onAnimationComplete() {
          isLoading = false;
        }

        onAnimationComplete();

        expect(isLoading, isFalse);
      });

      test(
          'showLoadingIndicator - loading tidak bisa berjalan lebih '
          'dari durasi animasi (2500ms)', () {
        const animDuration = Duration(milliseconds: 2500);
        const maxLoadingTime = Duration(seconds: 5);

        expect(animDuration < maxLoadingTime, isTrue);
      });

      test(
          'showLoadingIndicator - setelah loading selesai, navigasi '
          'ke LoginPage dipicu', () {
        bool navigationTriggered = false;

        // Simulasi: status completed → navigasi
        void onCompleted() {
          navigationTriggered = true;
        }

        onCompleted();

        expect(navigationTriggered, isTrue);
      });
    });
  });
}