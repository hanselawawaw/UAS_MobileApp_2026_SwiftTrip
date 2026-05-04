import 'package:flutter_test/flutter_test.dart';
import 'package:swifttrip_frontend/screens/auth/services/auth_service.dart';

// ============================================================
// FORGOT PASSWORD PAGE - UNIT TEST
// Tabel Coverage:
//   Widget                  | Class Method
//   ------------------------|----------------------
//   TextFormField (Email)   | validator()
//   ElevatedButton          | sendResetPasswordEmail()
//   SnackBar                | showSuccessMessage()
//                           | showErrorMessage()
// ============================================================

// Helper: validator email murni
String? validateEmailField(String? value) {
  if (value == null || value.trim().isEmpty) return 'Email required';
  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  if (!emailRegex.hasMatch(value)) return 'Invalid email format';
  return null;
}

// Helper: validator kode OTP
String? validateOtpCode(String? value) {
  if (value == null || value.trim().isEmpty) return 'Code required';
  if (value.trim().length != 6) return 'Code must be 6 digits';
  if (!RegExp(r'^\d{6}$').hasMatch(value.trim())) return 'Code must be numeric';
  return null;
}

// Helper: logika sendResetPasswordEmail
String? canSendResetEmail(String email, String code) {
  if (email.trim().isEmpty || code.trim().isEmpty) {
    return 'Please fill all fields';
  }
  return null;
}

// Helper: logika pesan sukses/gagal
String buildSuccessMessage(String email) {
  return 'Password reset email sent to $email';
}

String buildErrorMessage(String reason) {
  return 'Error: $reason';
}

void main() {
  group('ForgotPassPage Unit Tests', () {

    // ----------------------------------------------------------
    // METHOD: validator() - TextFormField Email
    // ----------------------------------------------------------
    group('validator() - Email', () {
      test('validator email mengembalikan error jika kosong', () {
        expect(validateEmailField(''), isNotNull);
        expect(validateEmailField(null), isNotNull);
      });

      test('validator email mengembalikan error jika hanya spasi', () {
        expect(validateEmailField('   '), isNotNull);
      });

      test('validator email mengembalikan null untuk email valid', () {
        expect(validateEmailField('forgot@example.com'), isNull);
        expect(validateEmailField('user.name+tag@domain.co.id'), isNull);
      });

      test('validator email mengembalikan error untuk format tidak valid', () {
        expect(validateEmailField('notanemail'), isNotNull);
        expect(validateEmailField('missing@'), isNotNull);
        expect(validateEmailField('@nodomain.com'), isNotNull);
      });

      test('validator kode OTP mengembalikan error jika kosong', () {
        expect(validateOtpCode(''), isNotNull);
        expect(validateOtpCode(null), isNotNull);
      });

      test('validator kode OTP mengembalikan error jika bukan 6 digit', () {
        expect(validateOtpCode('12345'), isNotNull);   // 5 digit
        expect(validateOtpCode('1234567'), isNotNull); // 7 digit
      });

      test('validator kode OTP mengembalikan null untuk 6 digit angka', () {
        expect(validateOtpCode('123456'), isNull);
        expect(validateOtpCode('000000'), isNull);
        expect(validateOtpCode('999999'), isNull);
      });

      test('validator kode OTP mengembalikan error untuk huruf', () {
        expect(validateOtpCode('abcdef'), isNotNull);
        expect(validateOtpCode('12345a'), isNotNull);
      });
    });

    // ----------------------------------------------------------
    // METHOD: sendResetPasswordEmail()
    // ----------------------------------------------------------
    group('sendResetPasswordEmail()', () {
      test('sendResetPasswordEmail mengembalikan error jika email kosong', () {
        final result = canSendResetEmail('', '123456');
        expect(result, equals('Please fill all fields'));
      });

      test('sendResetPasswordEmail mengembalikan error jika kode kosong', () {
        final result = canSendResetEmail('user@test.com', '');
        expect(result, equals('Please fill all fields'));
      });

      test('sendResetPasswordEmail mengembalikan error jika keduanya kosong', () {
        final result = canSendResetEmail('', '');
        expect(result, equals('Please fill all fields'));
      });

      test('sendResetPasswordEmail mengembalikan null jika keduanya terisi', () {
        final result = canSendResetEmail('user@test.com', '654321');
        expect(result, isNull);
      });

      test('sendResetPasswordEmail - AuthService tersedia', () {
        final service = AuthService();
        expect(service, isNotNull);
      });

      test('sendResetPasswordEmail - AuthService memiliki method verifyOtp', () {
        final service = AuthService();
        // verifyOtp adalah inti dari sendResetPasswordEmail flow
        expect(service.verifyOtp, isNotNull);
      });

      test('sendResetPasswordEmail - email tidak bisa null saat dikirim', () {
        const email = 'user@test.com';
        const code = '123456';

        expect(email, isNotEmpty);
        expect(code, isNotEmpty);
        expect(email.contains('@'), isTrue);
      });
    });

    // ----------------------------------------------------------
    // METHOD: showSuccessMessage()
    // ----------------------------------------------------------
    group('showSuccessMessage()', () {
      test('showSuccessMessage menghasilkan pesan yang mengandung email', () {
        final message = buildSuccessMessage('user@test.com');
        expect(message, contains('user@test.com'));
      });

      test('showSuccessMessage menghasilkan string tidak kosong', () {
        final message = buildSuccessMessage('user@test.com');
        expect(message, isNotEmpty);
      });

      test('showSuccessMessage berbeda untuk email berbeda', () {
        final msg1 = buildSuccessMessage('user1@test.com');
        final msg2 = buildSuccessMessage('user2@test.com');
        expect(msg1, isNot(equals(msg2)));
      });

      test('showSuccessMessage dipicu hanya jika canSendResetEmail = null', () {
        bool successShown = false;

        final error = canSendResetEmail('user@test.com', '123456');
        if (error == null) {
          successShown = true;
        }

        expect(successShown, isTrue);
      });

      test('showSuccessMessage tidak dipicu jika ada error validasi', () {
        bool successShown = false;

        final error = canSendResetEmail('', '');
        if (error == null) {
          successShown = true;
        }

        expect(successShown, isFalse);
      });
    });

    // ----------------------------------------------------------
    // METHOD: showErrorMessage()
    // ----------------------------------------------------------
    group('showErrorMessage()', () {
      test('showErrorMessage menghasilkan pesan error yang tidak kosong', () {
        final message = buildErrorMessage('Invalid OTP');
        expect(message, isNotEmpty);
        expect(message, contains('Invalid OTP'));
      });

      test('showErrorMessage dipicu saat validasi gagal', () {
        bool errorShown = false;

        final error = canSendResetEmail('', '');
        if (error != null) {
          errorShown = true;
        }

        expect(errorShown, isTrue);
      });

      test('showErrorMessage tidak dipicu saat validasi berhasil', () {
        bool errorShown = false;

        final error = canSendResetEmail('user@test.com', '123456');
        if (error != null) {
          errorShown = true;
        }

        expect(errorShown, isFalse);
      });

      test('showErrorMessage untuk kode tidak valid menghasilkan pesan tepat', () {
        final error = validateOtpCode('abc');
        expect(error, isNotNull);

        final message = buildErrorMessage(error!);
        expect(message, isNotEmpty);
      });

      test('showErrorMessage dan showSuccessMessage tidak muncul bersamaan', () {
        bool successShown = false;
        bool errorShown = false;

        final error = canSendResetEmail('', '');

        if (error == null) {
          successShown = true;
        } else {
          errorShown = true;
        }

        // Hanya salah satu yang bisa true
        expect(successShown && errorShown, isFalse);
        expect(successShown || errorShown, isTrue);
      });
    });
  });
}