import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

import '../../features/auth/data/models/auth_responses.dart';

/// خدمة محاكاة APIs من خلال ملفات JSON محلية
class MockDataService {
  final Logger _logger = Logger();
  static const String _mockDataPath = 'assets/mock_data';

  /// تحميل بيانات JSON من assets
  Future<Map<String, dynamic>> loadJsonFile(String filename) async {
    try {
      final jsonString = await rootBundle.loadString(
        '$_mockDataPath/$filename',
      );
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      _logger.e('Error loading $filename: $e');
      throw MockDataException('Failed to load $filename');
    }
  }

  /// محاكاة تأخير شبكي
  Future<void> simulateNetworkDelay({
    int minMilliseconds = 800,
    int maxMilliseconds = 2000,
  }) async {
    final delay = Duration(
      milliseconds:
          minMilliseconds +
          DateTime.now().millisecond % (maxMilliseconds - minMilliseconds),
    );
    await Future.delayed(delay);
  }

  /// محاكاة Login
  Future<LoginResponse> mockLogin({
    required String usernameOrEmail,
    required String password,
  }) async {
    await simulateNetworkDelay();

    try {
      final authData = await loadJsonFile('auth_responses.json');
      final users = authData['users'] as List?;

      if (users == null || users.isEmpty) {
        return LoginResponse(
          success: false,
          error: 'لا توجد بيانات مستخدمين محاكاة',
          errorCode: 500,
        );
      }

      for (final user in users) {
        if ((user['email'] == usernameOrEmail ||
                user['username'] == usernameOrEmail) &&
            user['password'] == password) {
          // نجاح اللوجين - إرجاع البيانات بدون كلمة المرور
          final userResponse = UserResponse(
            id: user['id'] as int? ?? 0,
            email: user['email'] as String? ?? '',
            userName: user['username'] as String? ?? '',
            phone: user['phone'] as String? ?? '',
            roleId: user['roleId'] as int? ?? 4,
          );

          final loginData = LoginResponseData(
            user: userResponse,
            token: user['token'] as String? ?? '',
            expiresAt: DateTime.now()
                .add(const Duration(hours: 24))
                .toIso8601String(),
          );

          return LoginResponse(success: true, data: loginData);
        }
      }

      // فشل اللوجين
      return LoginResponse(
        success: false,
        error: 'بيانات الدخول غير صحيحة',
        errorCode: 401,
      );
    } catch (e) {
      _logger.e('Login mock failed: $e');
      return LoginResponse(
        success: false,
        error: 'خطأ في محاكاة تسجيل الدخول: $e',
        errorCode: 500,
      );
    }
  }

  /// محاكاة Signup
  Future<SignupResponse> mockSignup({
    required String username,
    required String email,
    required String password,
    required String phone,
  }) async {
    await simulateNetworkDelay();

    try {
      final authData = await loadJsonFile('auth_responses.json');
      final users = authData['users'] as List?;

      // التحقق من عدم وجود المستخدم
      if (users != null) {
        for (final user in users) {
          if (user['email'] == email || user['username'] == username) {
            return SignupResponse(
              success: false,
              error: 'البريد الإلكتروني أو اسم المستخدم موجود مسبقاً',
              errorCode: 409,
            );
          }
        }
      }

      // إنشاء مستخدم جديد
      final newUser = {
        'id': (users?.length ?? 0) + 1,
        'username': username,
        'email': email,
        'phone': phone,
        'password': password,
        'roleId': 4, // مريض عادي
        'token': _generateMockToken(),
        'createdAt': DateTime.now().toIso8601String(),
      };

      final userResponse = UserResponse(
        id: newUser['id'] as int? ?? 0,
        email: newUser['email'] as String? ?? '',
        userName: newUser['username'] as String? ?? '',
        phone: newUser['phone'] as String? ?? '',
        roleId: newUser['roleId'] as int? ?? 4,
      );

      final signupData = SignupResponseData(
        user: userResponse,
        token: newUser['token'] as String? ?? '',
        expiresAt: DateTime.now()
            .add(const Duration(hours: 24))
            .toIso8601String(),
      );

      return SignupResponse(success: true, data: signupData);
    } catch (e) {
      _logger.e('Signup mock failed: $e');
      return SignupResponse(
        success: false,
        error: 'خطأ في محاكاة التسجيل: $e',
        errorCode: 500,
      );
    }
  }

  /// محاكاة Forgot Password
  Future<ForgotPasswordResponse> mockForgotPassword({
    required String email,
  }) async {
    await simulateNetworkDelay(minMilliseconds: 1000, maxMilliseconds: 3000);

    try {
      final authData = await loadJsonFile('auth_responses.json');
      final users = authData['users'] as List?;

      if (users != null) {
        for (final user in users) {
          if (user['email'] == email) {
            // محاكاة إرسال البريد الإلكتروني
            return ForgotPasswordResponse(
              success: true,
              message:
                  'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني',
            );
          }
        }
      }

      // البريد غير موجود
      return ForgotPasswordResponse(
        success: false,
        error: 'البريد الإلكتروني غير مسجل في النظام',
        errorCode: 404,
      );
    } catch (e) {
      _logger.e('Forgot password mock failed: $e');
      return ForgotPasswordResponse(
        success: false,
        error: 'خطأ في محاكاة إعادة تعيين كلمة المرور: $e',
        errorCode: 500,
      );
    }
  }

  /// محاكاة تحديث التوكن
  Future<RefreshTokenResponse> mockRefreshToken(String oldToken) async {
    await simulateNetworkDelay(minMilliseconds: 300, maxMilliseconds: 800);

    try {
      // في الواقع، ستحتاج للتحقق من صحة التوكن
      // هنا نفترض أنه صحيح دائماً
      return RefreshTokenResponse(
        success: true,
        token: _generateMockToken(),
        expiresAt: DateTime.now()
            .add(const Duration(hours: 24))
            .toIso8601String(),
      );
    } catch (e) {
      _logger.e('Token refresh mock failed: $e');
      return RefreshTokenResponse(
        success: false,
        error: 'خطأ في تحديث التوكن: $e',
        errorCode: 500,
      );
    }
  }

  /// محاكاة Logout
  Future<LogoutResponse> mockLogout() async {
    await simulateNetworkDelay(minMilliseconds: 200, maxMilliseconds: 500);
    return LogoutResponse(success: true, message: 'تم تسجيل الخروج بنجاح');
  }

  /// توليد توكن مزيف لأغراض الاختبار
  String _generateMockToken() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final payload = base64Encode(
      utf8.encode('{"userId": 1, "exp": $timestamp}'),
    );
    return 'mock_token_$payload';
  }

  /// محاكاة الحصول على بيانات المستخدم
  Future<Map<String, dynamic>> mockGetUserProfile(String userId) async {
    await simulateNetworkDelay();

    try {
      final authData = await loadJsonFile('auth_responses.json');
      final users = authData['users'] as List?;

      if (users != null) {
        for (final user in users) {
          if (user['id'].toString() == userId) {
            return {
              'success': true,
              'user': {
                'id': user['id'],
                'email': user['email'],
                'userName': user['username'],
                'phone': user['phone'],
                'roleId': user['roleId'],
              },
            };
          }
        }
      }

      return {
        'success': false,
        'error': 'المستخدم غير موجود',
        'errorCode': 404,
      };
    } catch (e) {
      throw MockDataException('Get user profile mock failed: $e');
    }
  }
}

/// استثناء مخصص لمشاكل البيانات المحاكاة
class MockDataException implements Exception {
  final String message;

  MockDataException(this.message);

  @override
  String toString() => 'MockDataException: $message';
}
