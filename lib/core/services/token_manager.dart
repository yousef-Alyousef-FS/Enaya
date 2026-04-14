import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../cache/cache_helper.dart';
import '../constants/api_constants.dart';

/// إدارة التوكن وتخزينه بشكل آمن
class TokenManager {
  final FlutterSecureStorage _secureStorage;
  final CacheHelper _cacheHelper;

  TokenManager({
    required FlutterSecureStorage secureStorage,
    required CacheHelper cacheHelper,
  })  : _secureStorage = secureStorage,
        _cacheHelper = cacheHelper;

  /// حفظ التوكن بشكل آمن
  Future<void> saveToken(String token) async {
    try {
      await _secureStorage.write(
        key: ApiConstants.tokenKey,
        value: token,
      );
    } catch (e) {
      throw TokenException('Failed to save token: $e');
    }
  }

  /// الحصول على التوكن المحفوظ
  Future<String?> getToken() async {
    try {
      return await _secureStorage.read(key: ApiConstants.tokenKey);
    } catch (e) {
      throw TokenException('Failed to retrieve token: $e');
    }
  }

  /// حذف التوكن (عند Logout)
  Future<void> deleteToken() async {
    try {
      await _secureStorage.delete(key: ApiConstants.tokenKey);
    } catch (e) {
      throw TokenException('Failed to delete token: $e');
    }
  }

  /// التحقق من وجود توكن صحيح
  Future<bool> hasValidToken() async {
    try {
      final token = await getToken();
      return token != null && token.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// الحصول على Authorization Header
  Future<String?> getAuthorizationHeader() async {
    try {
      final token = await getToken();
      if (token != null) {
        return 'Bearer $token';
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// حفظ بيانات المستخدم
  Future<void> saveUserData(String userData) async {
    try {
      await _cacheHelper.setData(
        key: ApiConstants.userDataKey,
        value: userData,
      );
    } catch (e) {
      throw TokenException('Failed to save user data: $e');
    }
  }

  /// الحصول على بيانات المستخدم
  String? getUserData() {
    try {
      return _cacheHelper.getData(key: ApiConstants.userDataKey);
    } catch (e) {
      return null;
    }
  }

  /// مسح كل البيانات (عند Logout)
  Future<void> clearAll() async {
    try {
      await deleteToken();
      await _cacheHelper.removeData(key: ApiConstants.userDataKey);
    } catch (e) {
      throw TokenException('Failed to clear authentication data: $e');
    }
  }
}

/// استثناء مخصص لمشاكل التوكن
class TokenException implements Exception {
  final String message;

  TokenException(this.message);

  @override
  String toString() => 'TokenException: $message';
}
