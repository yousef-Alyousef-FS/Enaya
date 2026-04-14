import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

/// خدمة محاكاة APIs من خلال ملفات JSON محلية
class MockDataService {
  final Logger _logger = Logger();
  static const String _mockDataPath = 'assets/mock_data';

  /// تحميل بيانات JSON من assets
  Future<Map<String, dynamic>> loadJsonFile(String filename) async {
    try {
      final jsonString = await rootBundle.loadString('$_mockDataPath/$filename');
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
      milliseconds: minMilliseconds +
          DateTime.now().millisecond % (maxMilliseconds - minMilliseconds),
    );
    await Future.delayed(delay);
  }

  /// محاكاة Login
  Future<Map<String, dynamic>> mockLogin({
    required String usernameOrEmail,
    required String password,
  }) async {
    await simulateNetworkDelay();

    try {
      final authData = await loadJsonFile('auth_responses.json');
      final users = authData['users'] as List?;

      if (users == null || users.isEmpty) {
        throw MockDataException('No mock users found');
      }

      for (final user in users) {
        if ((user['email'] == usernameOrEmail || user['username'] == usernameOrEmail) &&
            user['password'] == password) {
          // نجاح اللوجين - إرجاع البيانات بدون كلمة المرور
          return {
            'success': true,
            'user': {
              'id': user['id'],
              'email': user['email'],
              'userName': user['username'],
              'phone': user['phone'],
              'roleId': user['roleId'],
            },
            'token': user['token'], // توكن مزيف
            'expiresAt': DateTime.now().add(const Duration(hours: 24)).toIso8601String(),
          };
        }
      }

      // فشل اللوجين
      return {
        'success': false,
        'error': 'بيانات الدخول غير صحيحة',
        'errorCode': 401,
      };
    } catch (e) {
      throw MockDataException('Login mock failed: $e');
    }
  }

  /// محاكاة Signup
  Future<Map<String, dynamic>> mockSignup({
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
            return {
              'success': false,
              'error': 'البريد الإلكتروني أو اسم المستخدم موجود مسبقاً',
              'errorCode': 409,
            };
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
        'roleId': 2, // مستخدم عادي
        'token': _generateMockToken(),
        'createdAt': DateTime.now().toIso8601String(),
      };

      return {
        'success': true,
        'user': {
          'id': newUser['id'],
          'email': newUser['email'],
          'userName': newUser['username'],
          'phone': newUser['phone'],
          'roleId': newUser['roleId'],
        },
        'token': newUser['token'],
        'expiresAt': DateTime.now().add(const Duration(hours: 24)).toIso8601String(),
      };
    } catch (e) {
      throw MockDataException('Signup mock failed: $e');
    }
  }

  /// محاكاة تحديث التوكن
  Future<Map<String, dynamic>> mockRefreshToken(String oldToken) async {
    await simulateNetworkDelay(minMilliseconds: 300, maxMilliseconds: 800);

    try {
      // في الواقع، ستحتاج للتحقق من صحة التوكن
      // هنا نفترض أنه صحيح دائماً
      return {
        'success': true,
        'token': _generateMockToken(),
        'expiresAt': DateTime.now().add(const Duration(hours: 24)).toIso8601String(),
      };
    } catch (e) {
      throw MockDataException('Token refresh mock failed: $e');
    }
  }

  /// محاكاة Logout (حذف جميع البيانات)
  Future<Map<String, dynamic>> mockLogout() async {
    await simulateNetworkDelay(minMilliseconds: 200, maxMilliseconds: 500);
    return {
      'success': true,
      'message': 'تم تسجيل الخروج بنجاح',
    };
  }

  /// توليد توكن مزيف لأغراض الاختبار
  String _generateMockToken() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final payload = base64Encode(utf8.encode('{"userId": 1, "exp": $timestamp}'));
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
