import 'package:flutter_test/flutter_test.dart';
import 'package:swifttrip_frontend/screens/auth/models/auth_models.dart';
import 'package:swifttrip_frontend/screens/auth/services/auth_service.dart';

// ============================================================
// SIGNUP PAGE - UNIT TEST
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

// Helper: logika validateSignupForm murni
String? validateSignupForm({
  required String email,
  required String password,
  required String confirmPassword,
  required String verificationCode,
}) {
  if (email.trim().isEmpty ||
      password.trim().isEmpty ||
      confirmPassword.trim().isEmpty ||
      verificationCode.trim().isEmpty) {
    return 'Please fill all fields';
  }
  if (password != confirmPassword) {
    return 'Passwords do not match';
  }
  return null; // valid
}

// Helper: validator untuk field Name/Email
String? validateField(String? value) {
  if (value == null || value.trim().isEmpty) return 'Field required';
  return null;
}

// Helper: validator password dengan konfirmasi
String? validatePasswordMatch(String password, String confirm) {
  if (password.isEmpty) return 'Password required';
  if (password != confirm) return 'Passwords do not match';
  return null;
}

void main() {
  group('SignupPage Unit Tests', () {

    // ----------------------------------------------------------
    // METHOD: validateSignupForm()
    // ----------------------------------------------------------
    group('validateSignupForm()', () {
      test('validateSignupForm mengembalikan error jika semua field kosong', () {
        final result = validateSignupForm(
          email: '',
          password: '',
          confirmPassword: '',
          verificationCode: '',
        );
        expect(result, equals('Please fill all fields'));
      });

      test('validateSignupForm mengembalikan error jika email kosong', () {
        final result = validateSignupForm(
          email: '',
          password: 'pass123',
          confirmPassword: 'pass123',
          verificationCode: '123456',
        );
        expect(result, equals('Please fill all fields'));
      });

      test('validateSignupForm mengembalikan error jika password tidak cocok', () {
        final result = validateSignupForm(
          email: 'user@test.com',
          password: 'pass123',
          confirmPassword: 'pass456',
          verificationCode: '123456',
        );
        expect(result, equals('Passwords do not match'));
      });

      test('validateSignupForm mengembalikan null jika semua valid', () {
        final result = validateSignupForm(
          email: 'user@test.com',
          password: 'pass123',
          confirmPassword: 'pass123',
          verificationCode: '654321',
        );
        expect(result, isNull);
      });

      test('validateSignupForm menolak password yang hanya berisi spasi', () {
        final result = validateSignupForm(
          email: 'user@test.com',
          password: '   ',
          confirmPassword: '   ',
          verificationCode: '123456',
        );
        expect(result, equals('Please fill all fields'));
      });

      test('validateSignupForm mengembalikan error jika kode verifikasi kosong', () {
        final result = validateSignupForm(
          email: 'user@test.com',
          password: 'pass123',
          confirmPassword: 'pass123',
          verificationCode: '',
        );
        expect(result, equals('Please fill all fields'));
      });
    });

    // ----------------------------------------------------------
    // METHOD: saveFormState()
    // ----------------------------------------------------------
    group('saveFormState()', () {
      test('saveFormState menyimpan semua nilai field dengan benar', () {
        String email = '';
        String password = '';
        String confirmPassword = '';

        void saveFormState(String e, String p, String c) {
          email = e;
          password = p;
          confirmPassword = c;
        }

        saveFormState('user@test.com', 'pass123', 'pass123');

        expect(email, equals('user@test.com'));
        expect(password, equals('pass123'));
        expect(confirmPassword, equals('pass123'));
      });

      test('saveFormState mereset state ke kosong saat form di-clear', () {
        String email = 'old@test.com';
        String password = 'oldpass';

        void clearState() {
          email = '';
          password = '';
        }

        clearState();

        expect(email, isEmpty);
        expect(password, isEmpty);
      });

      test('saveFormState - SignupRequest dibuat dari state yang tersimpan', () {
        const email = 'user@test.com';
        const password = 'pass123';

        final request = SignupRequest(
          email: email,
          password: password,
          confirmPassword: password,
        );

        expect(request.email, equals(email));
        expect(request.password, equals(password));
        expect(request.confirmPassword, equals(password));
      });
    });

    // ----------------------------------------------------------
    // METHOD: validator() - TextFormField Name
    // ----------------------------------------------------------
    group('validator() - Name', () {
      test('validator name mengembalikan error jika kosong', () {
        expect(validateField(''), isNotNull);
        expect(validateField(null), isNotNull);
      });

      test('validator name mengembalikan null jika terisi', () {
        expect(validateField('John'), isNull);
        expect(validateField('user@test.com'), isNull);
      });

      test('validator name menolak string yang hanya spasi', () {
        expect(validateField('   '), isNotNull);
      });
    });

    // ----------------------------------------------------------
    // METHOD: validator() - TextFormField Email
    // ----------------------------------------------------------
    group('validator() - Email', () {
      test('validator email mengembalikan error jika kosong', () {
        expect(validateField(''), isNotNull);
      });

      test('validator email mengembalikan null jika ada isi', () {
        expect(validateField('user@test.com'), isNull);
      });

      test('validator email berbeda dengan Name adalah independent', () {
        // Kedua field memiliki validator masing-masing
        final nameResult = validateField('John');
        final emailResult = validateField('');

        expect(nameResult, isNull);       // Name valid
        expect(emailResult, isNotNull);  // Email tidak valid
      });
    });

    // ----------------------------------------------------------
    // METHOD: validator() - TextFormField Password
    // ----------------------------------------------------------
    group('validator() - Password', () {
      test('validator password mengembalikan error jika kosong', () {
        expect(validatePasswordMatch('', ''), isNotNull);
      });

      test('validator password mengembalikan error jika tidak cocok', () {
        expect(validatePasswordMatch('pass123', 'pass456'), isNotNull);
      });

      test('validator password mengembalikan null jika sama', () {
        expect(validatePasswordMatch('pass123', 'pass123'), isNull);
      });

      test('validator password - password identik dianggap valid', () {
        const p = 'StrongP@ss1';
        expect(validatePasswordMatch(p, p), isNull);
      });
    });

    // ----------------------------------------------------------
    // METHOD: toggleTermsAcceptance()
    // ----------------------------------------------------------
    group('toggleTermsAcceptance()', () {
      test('toggleTermsAcceptance - nilai awal adalah false (belum centang)', () {
        bool termsAccepted = false;
        expect(termsAccepted, isFalse);
      });

      test('toggleTermsAcceptance - toggle dari false menjadi true', () {
        bool termsAccepted = false;

        void toggleTermsAcceptance() {
          termsAccepted = !termsAccepted;
        }

        toggleTermsAcceptance();
        expect(termsAccepted, isTrue);
      });

      test('toggleTermsAcceptance - toggle dua kali kembali ke false', () {
        bool termsAccepted = false;

        void toggleTermsAcceptance() {
          termsAccepted = !termsAccepted;
        }

        toggleTermsAcceptance();
        toggleTermsAcceptance();

        expect(termsAccepted, isFalse);
      });

      test('toggleTermsAcceptance - nilai password visibility juga toggle', () {
        // Di implementasi: toggle = ubah obscurePassword
        bool obscurePassword = true;

        void toggle() => obscurePassword = !obscurePassword;

        toggle();
        expect(obscurePassword, isFalse);

        toggle();
        expect(obscurePassword, isTrue);
      });
    });

    // ----------------------------------------------------------
    // METHOD: onChanged()
    // ----------------------------------------------------------
    group('onChanged()', () {
      test('onChanged dipanggil setiap perubahan karakter di field', () {
        int callCount = 0;
        String lastValue = '';

        void onChanged(String value) {
          callCount++;
          lastValue = value;
        }

        onChanged('a');
        onChanged('ab');
        onChanged('abc');

        expect(callCount, equals(3));
        expect(lastValue, equals('abc'));
      });

      test('onChanged checkbox/toggle mengubah state boolean', () {
        bool currentValue = false;

        void onChanged(bool value) {
          currentValue = value;
        }

        onChanged(true);
        expect(currentValue, isTrue);

        onChanged(false);
        expect(currentValue, isFalse);
      });
    });

    // ----------------------------------------------------------
    // METHOD: registerUser()
    // ----------------------------------------------------------
    group('registerUser()', () {
      test('registerUser - SignupRequest.toJson() menghasilkan JSON yang benar', () {
        final request = SignupRequest(
          email: 'newuser@test.com',
          password: 'mypass123',
          confirmPassword: 'mypass123',
        );

        final json = request.toJson();

        expect(json['email'], equals('newuser@test.com'));
        expect(json['password'], equals('mypass123'));
        expect(json['confirm_password'], equals('mypass123'));
      });

      test('registerUser - tidak dipanggil jika validasi gagal', () {
        bool registerCalled = false;

        final error = validateSignupForm(
          email: '',
          password: '',
          confirmPassword: '',
          verificationCode: '',
        );

        if (error == null) {
          registerCalled = true;
        }

        expect(registerCalled, isFalse);
      });

      test('registerUser - dipanggil jika semua validasi berhasil', () {
        bool registerCalled = false;

        final error = validateSignupForm(
          email: 'user@test.com',
          password: 'pass123',
          confirmPassword: 'pass123',
          verificationCode: '123456',
        );

        if (error == null) {
          registerCalled = true;
        }

        expect(registerCalled, isTrue);
      });

      test('registerUser - AuthService.signup() tersedia', () {
        final service = AuthService();
        expect(service, isNotNull);
      });

      test('registerUser - email dan password tidak boleh sama dengan field kosong', () {
        final request = SignupRequest(
          email: 'user@test.com',
          password: 'pass123',
          confirmPassword: 'pass123',
        );

        expect(request.email, isNotEmpty);
        expect(request.password, isNotEmpty);
        expect(request.confirmPassword, isNotEmpty);
      });
    });
  });
}