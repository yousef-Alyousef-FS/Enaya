import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../cache/cache_helper.dart';
import '../constants/api_constants.dart';

class TokenManager {
  final FlutterSecureStorage _secureStorage;
  final CacheHelper _cacheHelper;

  TokenManager({
    required FlutterSecureStorage secureStorage,
    required CacheHelper cacheHelper,
  })  : _secureStorage = secureStorage,
        _cacheHelper = cacheHelper;

  // ---------------------------------------------------------------------------
  // 🔐 Access Token
  // ---------------------------------------------------------------------------
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

  Future<String?> getToken() async {
    try {
      return await _secureStorage.read(key: ApiConstants.tokenKey);
    } catch (e) {
      throw TokenException('Failed to retrieve token: $e');
    }
  }

  Future<void> deleteToken() async {
    try {
      await _secureStorage.delete(key: ApiConstants.tokenKey);
    } catch (e) {
      throw TokenException('Failed to delete token: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // 🔄 Refresh Token
  // ---------------------------------------------------------------------------
  Future<void> saveRefreshToken(String token) async {
    try {
      await _secureStorage.write(
        key: ApiConstants.refreshTokenKey,
        value: token,
      );
    } catch (e) {
      throw TokenException('Failed to save refresh token: $e');
    }
  }

  Future<String?> getRefreshToken() async {
    try {
      return await _secureStorage.read(key: ApiConstants.refreshTokenKey);
    } catch (e) {
      throw TokenException('Failed to retrieve refresh token: $e');
    }
  }

  Future<void> deleteRefreshToken() async {
    try {
      await _secureStorage.delete(key: ApiConstants.refreshTokenKey);
    } catch (e) {
      throw TokenException('Failed to delete refresh token: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // ⏳ Token Expiry
  // ---------------------------------------------------------------------------
  Future<void> saveTokenExpiry(DateTime expiry) async {
    try {
      await _cacheHelper.setData(
        key: ApiConstants.tokenExpiryKey,
        value: expiry.toIso8601String(),
      );
    } catch (e) {
      throw TokenException('Failed to save token expiry: $e');
    }
  }

  DateTime? getTokenExpiry() {
    try {
      final value = _cacheHelper.getData(key: ApiConstants.tokenExpiryKey);
      if (value == null) return null;
      return DateTime.parse(value);
    } catch (_) {
      return null;
    }
  }

  bool isTokenExpired() {
    final expiry = getTokenExpiry();
    if (expiry == null) return true;
    return DateTime.now().isAfter(expiry);
  }

  // ---------------------------------------------------------------------------
  // 👤 User Data (JSON)
  // ---------------------------------------------------------------------------
  Future<void> saveUserData(Map<String, dynamic> user) async {
    try {
      await _cacheHelper.setData(
        key: ApiConstants.userDataKey,
        value: jsonEncode(user),
      );
    } catch (e) {
      throw TokenException('Failed to save user data: $e');
    }
  }

  Map<String, dynamic>? getUserData() {
    try {
      final jsonString = _cacheHelper.getData(key: ApiConstants.userDataKey);
      if (jsonString == null) return null;
      return jsonDecode(jsonString);
    } catch (_) {
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // 🧹 Clear All
  // ---------------------------------------------------------------------------
  Future<void> clearAll() async {
    try {
      await deleteToken();
      await deleteRefreshToken();
      await _cacheHelper.removeData(key: ApiConstants.userDataKey);
      await _cacheHelper.removeData(key: ApiConstants.tokenExpiryKey);
    } catch (e) {
      throw TokenException('Failed to clear authentication data: $e');
    }
  }
}

class TokenException implements Exception {
  final String message;
  TokenException(this.message);

  @override
  String toString() => 'TokenException: $message';
}
