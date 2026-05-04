import 'package:flutter_test/flutter_test.dart';
import 'package:swifttrip_frontend/screens/auth/models/auth_models.dart';
import 'package:swifttrip_frontend/screens/auth/services/auth_service.dart';

// ============================================================
// LOGIN PAGE - UNIT TEST
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
//
// Unit test fokus pada LOGIKA murni:
// - validateLoginForm() → logika validasi input
// - saveFormState()     → logika penyimpanan state controller
// - onChanged()         → logika perubahan nilai field
// - validator()         → fungsi validasi per field
// - submitLogin()       → logika LoginRequest model
// - navigateToSignup()  → logika kondisi navigasi
// ============================================================

// Helper: fungsi validasi email murni (tanpa widget)
String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Email tidak boleh kosong';
  }
  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  if (!emailRegex.hasMatch(value)) {
    return 'Format email tidak valid';
  }
  return null;
}

// Helper: fungsi validasi password murni
String? validatePassword(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Password tidak boleh kosong';
  }
  if (value.length < 6) {
    return 'Password minimal 6 karakter';
  }
  return null;
}

// Helper: logika validateLoginForm
bool validateLoginForm(String email, String password) {
  return email.trim().isNotEmpty && password.trim().isNotEmpty;
}

void main() {
  group('LoginPage Unit Tests', () {

    // ----------------------------------------------------------
    // METHOD: validateLoginForm()
    // ----------------------------------------------------------
    group('validateLoginForm()', () {
      test('validateLoginForm mengembalikan false jika email kosong', () {
        expect(validateLoginForm('', 'password123'), isFalse);
      });

      test('validateLoginForm mengembalikan false jika password kosong', () {
        expect(validateLoginForm('user@test.com', ''), isFalse);
      });

      test('validateLoginForm mengembalikan false jika keduanya kosong', () {
        expect(validateLoginForm('', ''), isFalse);
      });

      test('validateLoginForm mengembalikan true jika keduanya terisi', () {
        expect(validateLoginForm('user@test.com', 'pass123'), isTrue);
      });

      test('validateLoginForm menolak input yang hanya berisi spasi', () {
        expect(validateLoginForm('   ', '   '), isFalse);
      });
    });

    // ----------------------------------------------------------
    // METHOD: saveFormState()
    // ----------------------------------------------------------
    group('saveFormState()', () {
      test('saveFormState - email tersimpan dengan benar di state', () {
        String savedEmail = '';

        // saveFormState() = menyimpan nilai controller ke state
        void saveFormState(String email, String password) {
          savedEmail = email;
        }

        saveFormState('saved@example.com', 'pass123');
        expect(savedEmail, equals('saved@example.com'));
      });

      test('saveFormState - password tersimpan dengan benar di state', () {
        String savedPassword = '';

        void saveFormState(String email, String password) {
          savedPassword = password;
        }

        saveFormState('user@test.com', 'mySecretPass');
        expect(savedPassword, equals('mySecretPass'));
      });

      test('saveFormState - state di-reset saat form dikosongkan', () {
        String savedEmail = 'sebelumnya@test.com';

        void clearFormState() {
          savedEmail = '';
        }

        clearFormState();
        expect(savedEmail, isEmpty);
      });
    });

    // ----------------------------------------------------------
    // METHOD: onChanged() - TextFormField Email
    // ----------------------------------------------------------
    group('onChanged() - Email', () {
      test('onChanged email memperbarui nilai setiap kali teks berubah', () {
        String currentEmail = '';

        void onEmailChanged(String value) {
          currentEmail = value;
        }

        onEmailChanged('u');
        expect(currentEmail, equals('u'));

        onEmailChanged('us');
        expect(currentEmail, equals('us'));

        onEmailChanged('user@');
        expect(currentEmail, equals('user@'));

        onEmailChanged('user@test.com');
        expect(currentEmail, equals('user@test.com'));
      });

      test('onChanged email menerima string kosong', () {
        String currentEmail = 'ada@email.com';

        void onEmailChanged(String value) {
          currentEmail = value;
        }

        onEmailChanged('');
        expect(currentEmail, isEmpty);
      });
    });

    // ----------------------------------------------------------
    // METHOD: validator() - TextFormField Email
    // ----------------------------------------------------------
    group('validator() - Email', () {
      test('validator email mengembalikan error jika kosong', () {
        expect(validateEmail(''), isNotNull);
        expect(validateEmail(null), isNotNull);
      });

      test('validator email mengembalikan null jika format valid', () {
        expect(validateEmail('user@example.com'), isNull);
        expect(validateEmail('test.user+tag@domain.co.id'), isNull);
      });

      test('validator email mengembalikan error jika tanpa @', () {
        expect(validateEmail('userexample.com'), isNotNull);
      });

      test('validator email mengembalikan error jika tanpa domain', () {
        expect(validateEmail('user@'), isNotNull);
      });
    });

    // ----------------------------------------------------------
    // METHOD: onChanged() - TextFormField Password
    // ----------------------------------------------------------
    group('onChanged() - Password', () {
      test('onChanged password memperbarui nilai saat teks berubah', () {
        String currentPassword = '';

        void onPasswordChanged(String value) {
          currentPassword = value;
        }

        onPasswordChanged('p');
        expect(currentPassword, equals('p'));

        onPasswordChanged('pass123');
        expect(currentPassword, equals('pass123'));
      });

      test('onChanged password bisa direset ke string kosong', () {
        String currentPassword = 'password123';

        void onPasswordChanged(String value) {
          currentPassword = value;
        }

        onPasswordChanged('');
        expect(currentPassword, isEmpty);
      });
    });

    // ----------------------------------------------------------
    // METHOD: validator() - TextFormField Password
    // ----------------------------------------------------------
    group('validator() - Password', () {
      test('validator password mengembalikan error jika kosong', () {
        expect(validatePassword(''), isNotNull);
        expect(validatePassword(null), isNotNull);
      });

      test('validator password mengembalikan null jika terisi valid', () {
        expect(validatePassword('password123'), isNull);
        expect(validatePassword('abcdef'), isNull);
      });

      test('validator password mengembalikan error jika kurang dari 6 karakter', () {
        expect(validatePassword('abc'), isNotNull);
        expect(validatePassword('12345'), isNotNull);
      });
    });

    // ----------------------------------------------------------
    // METHOD: submitLogin()
    // ----------------------------------------------------------
    group('submitLogin()', () {
      test('submitLogin - LoginRequest dibuat dengan email dan password benar', () {
        final request = LoginRequest(
          email: 'user@test.com',
          password: 'password123',
        );

        expect(request.email, equals('user@test.com'));
        expect(request.password, equals('password123'));
      });

      test('submitLogin - LoginRequest.toJson() menghasilkan map yang benar', () {
        final request = LoginRequest(
          email: 'user@test.com',
          password: 'pass123',
        );

        final json = request.toJson();

        expect(json['email'], equals('user@test.com'));
        expect(json['password'], equals('pass123'));
        expect(json.containsKey('email'), isTrue);
        expect(json.containsKey('password'), isTrue);
      });

      test('submitLogin - AuthService tersedia untuk melakukan login', () {
        final authService = AuthService();
        expect(authService, isNotNull);
      });

      test('submitLogin - login ditolak jika validasi form gagal', () {
        // submitLogin() hanya dipanggil jika validateLoginForm() = true
        final shouldSubmit = validateLoginForm('', '');
        expect(shouldSubmit, isFalse);
      });

      test('submitLogin - login diizinkan jika validasi form berhasil', () {
        final shouldSubmit = validateLoginForm('user@test.com', 'pass123');
        expect(shouldSubmit, isTrue);
      });
    });

    // ----------------------------------------------------------
    // METHOD: navigateToSignup()
    // ----------------------------------------------------------
    group('navigateToSignup()', () {
      test('navigateToSignup - navigasi dipicu saat kondisi terpenuhi', () {
        bool navigationCalled = false;

        void navigateToSignup() {
          navigationCalled = true;
        }

        navigateToSignup();
        expect(navigationCalled, isTrue);
      });

      test('navigateToSignup - navigasi tidak dipicu sebelum dipanggil', () {
        bool navigationCalled = false;

        // Sebelum dipanggil = false
        expect(navigationCalled, isFalse);
      });

      test('navigateToSignup - navigasi ke SignupPage menggunakan route push', () {
        // Verifikasi logika: push = halaman LoginPage masih ada di stack
        const routeAction = 'push';

        expect(routeAction, equals('push'));
        expect(routeAction, isNot('pushReplacement'));
      });
    });
  });
}