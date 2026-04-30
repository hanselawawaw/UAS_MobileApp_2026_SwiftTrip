import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:swifttrip_frontend/core/constants.dart';
import 'package:swifttrip_frontend/models/user.dart';

class AuthRepository {
  static final AuthRepository _instance = AuthRepository._internal();
  factory AuthRepository() => _instance;

  AuthRepository._internal();

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: Constants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  User? _currentUser;

  User? get currentUser => _currentUser;

  Future<void> _saveTokens(String access, String refresh) async {
    await _storage.write(key: 'access_token', value: access);
    await _storage.write(key: 'refresh_token', value: refresh);
  }

  Future<void> _clearTokens() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
    _currentUser = null;
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'access_token');
  }

  Future<bool> loadSession() async {
    final token = await getToken();
    if (token != null) {
      try {
        await getUserProfile();
        return true;
      } catch (e) {
        print('Session restoration failed: $e');
        await _clearTokens();
      }
    }
    return false;
  }

  Future<User> getUserProfile() async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        'user/',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        _currentUser = User.fromJson(response.data);
        return _currentUser!;
      }
      throw Exception('Failed to load user profile');
    } on DioException catch (e) {
      final data = e.response?.data;
      String message = 'Failed to fetch user profile.';
      if (data is Map && data.containsKey('detail')) {
        message = data['detail'];
      }
      throw Exception(message);
    }
  }

  Future<Map<String, dynamic>> updateUserProfile(Map<String, dynamic> data) async {
    try {
      final token = await getToken();
      final response = await _dio.patch(
        'update-profile/',
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        if (response.data['step'] == 'completed') {
          _currentUser = User.fromJson(response.data['user']);
        }
        return response.data;
      }
      throw Exception('Failed to update profile.');
    } on DioException catch (e) {
      final data = e.response?.data;
      String message = 'Failed to update profile.';
      if (data is Map && data.containsKey('detail')) {
        message = data['detail'];
      }
      throw Exception(message);
    }
  }

  Future<bool> verifyOtpProfile(String email, String otp) async {
    try {
      final token = await getToken();
      final response = await _dio.post(
        'verify-otp-profile/',
        data: {'email': email, 'otp': otp},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        _currentUser = User.fromJson(response.data['user']);
        return true;
      }
      return false;
    } on DioException catch (e) {
      final data = e.response?.data;
      String message = 'Invalid or expired code.';
      if (data is Map && data.containsKey('detail')) {
        message = data['detail'];
      }
      throw Exception(message);
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await _dio.post(
        'login/',
        data: {'username': email, 'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final access = response.data['access'];
        final refresh = response.data['refresh'];
        if (access != null && refresh != null) {
          await _saveTokens(access, refresh);
          await getUserProfile(); // Fetch profile after login
        }
        return true;
      }
    } on DioException catch (e) {
      print('Login error: ${e.response?.data ?? e.message}');
      final data = e.response?.data;
      String message = 'Login failed. Please check your credentials.';
      if (data is Map && data.containsKey('non_field_errors') && (data['non_field_errors'] as List).isNotEmpty) {
        message = data['non_field_errors'][0];
      } else if (data is Map && data.containsKey('detail')) {
        message = data['detail'];
      }
      throw Exception(message);
    } catch (_) {
      throw Exception('An unexpected error occurred.');
    }
    return false;
  }

  Future<bool> signup(
    String email,
    String password,
    String confirmation,
  ) async {
    try {
      final response = await _dio.post(
        'registration/',
        data: {
          'username': email,
          'email': email,
          'password1': password,
          'password2': confirmation,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final access = response.data['access'];
        final refresh = response.data['refresh'];
        if (access != null && refresh != null) {
          await _saveTokens(access, refresh);
        }
        return true;
      }
    } on DioException catch (e) {
      print('Signup error: ${e.response?.data ?? e.message}');
      if (e.response?.data != null && e.response?.data is Map) {
        String errorMsg = e.response!.data.values.first[0].toString();
        throw Exception(errorMsg);
      }
      throw Exception('Registration failed.');
    } catch (_) {
      throw Exception('An unexpected error occurred.');
    }
    return false;
  }

  Future<bool> resetPassword(String email) async {
    try {
      final response = await _dio.post(
        'password/reset/',
        data: {'email': email},
      );

      // dj-rest-auth returns 200 OK for successful password reset initiated
      if (response.statusCode == 200) {
        return true;
      }
    } on DioException catch (e) {
      print('Reset password error: ${e.response?.data ?? e.message}');
      throw Exception('Password reset request failed.');
    }
    return false;
  }

  Future<bool> resetPasswordConfirm(
    String uid,
    String token,
    String newPassword,
  ) async {
    try {
      final response = await _dio.post(
        'password/reset/confirm/',
        data: {'uid': uid, 'token': token, 'new_password': newPassword},
      );

      if (response.statusCode == 200) {
        return true;
      }
    } on DioException catch (e) {
      print('Confirm reset error: ${e.response?.data ?? e.message}');
      throw Exception('Failed to reset password.');
    }
    return false;
  }

  Future<void> logout() async {
    try {
      await _dio.post('logout/');
    } catch (_) {
      print('Logout API call failed, removing local tokens anyway.');
    }
    await _clearTokens();
  }

  Future<void> requestOtp(String email, {bool isPasswordReset = false}) async {
    try {
      // This will call http://127.0.0.1:8000/api/auth/send-otp/
      final response = await _dio.post(
        'send-otp/',
        data: {'email': email, 'is_password_reset': isPasswordReset},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to send OTP');
      }
    } on DioException catch (e) {
      print('OTP Error: ${e.response?.data ?? e.message}');
      final data = e.response?.data;
      String message = 'Failed to send verification code.';
      if (data is Map && data.containsKey('detail')) {
        message = data['detail'];
      }
      throw Exception(message);
    } catch (e) {
      throw Exception('An unexpected error occurred.');
    }
  }

  Future<bool> verifyOtp(String email, String otp) async {
    try {
      // This calls http://127.0.0.1:8000/api/auth/verify-otp/
      final response = await _dio.post(
        'verify-otp/',
        data: {'email': email, 'otp': otp},
      );

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      print('Verification Error: ${e.response?.data ?? e.message}');
      final data = e.response?.data;
      String message = 'Invalid or expired code.';
      if (data is Map && data.containsKey('detail')) {
        message = data['detail'];
      }
      throw Exception(message);
    } catch (e) {
      throw Exception('An unexpected error occurred during verification.');
    }
  }

  Future<bool> updatePassword(String email, String newPassword) async {
    try {
      final response = await _dio.post(
        'update-password/',
        data: {'email': email, 'new_password': newPassword},
      );

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      print('Update Password Error: ${e.response?.data ?? e.message}');
      final data = e.response?.data;
      String message = 'Failed to update password.';
      if (data is Map && data.containsKey('detail')) {
        message = data['detail'];
      }
      throw Exception(message);
    } catch (e) {
      throw Exception('An unexpected error occurred while updating password.');
    }
  }

  Future<bool> deleteUser() async {
    try {
      final token = await _storage.read(key: 'access_token');

      final response = await _dio.delete(
        'delete-account/',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 204) {
        await _clearTokens();
        return true;
      }
      return false;
    } on DioException catch (e) {
      final data = e.response?.data;
      String message = 'Failed to delete account.';
      if (data is Map && data.containsKey('detail')) {
        message = data['detail'];
      }
      throw Exception(message);
    }
  }
}
