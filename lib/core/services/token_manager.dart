import '../cache/cache_helper.dart';
import '../constants/api_constants.dart';

/// Specialized service for managing authentication tokens and their lifecycle.
///
/// It delegates the actual storage logic to [CacheHelper] but maintains
/// the business logic of keys, expiry, and token-specific exceptions.
class TokenManager {
  final CacheHelper _cacheHelper;

  TokenManager({required CacheHelper cacheHelper}) : _cacheHelper = cacheHelper;

  // ---------------------------------------------------------------------------
  // 🔐 Access Token
  // ---------------------------------------------------------------------------

  /// Persists access token in secure storage.
  Future<void> saveToken(String token) async {
    try {
      await _cacheHelper.saveSecuredString(ApiConstants.tokenKey, token);
    } catch (e) {
      throw TokenException('Failed to save access token: $e');
    }
  }

  /// Reads access token from secure storage.
  Future<String?> getToken() async {
    try {
      return await _cacheHelper.getSecuredString(ApiConstants.tokenKey);
    } catch (e) {
      throw TokenException('Failed to retrieve access token: $e');
    }
  }

  /// Deletes access token from secure storage.
  Future<void> deleteToken() async {
    try {
      await _cacheHelper.deleteSecuredString(ApiConstants.tokenKey);
    } catch (e) {
      throw TokenException('Failed to delete access token: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // 🔄 Refresh Token
  // ---------------------------------------------------------------------------

  /// Persists refresh token in secure storage.
  Future<void> saveRefreshToken(String token) async {
    try {
      await _cacheHelper.saveSecuredString(ApiConstants.refreshTokenKey, token);
    } catch (e) {
      throw TokenException('Failed to save refresh token: $e');
    }
  }

  /// Reads refresh token from secure storage.
  Future<String?> getRefreshToken() async {
    try {
      return await _cacheHelper.getSecuredString(ApiConstants.refreshTokenKey);
    } catch (e) {
      throw TokenException('Failed to retrieve refresh token: $e');
    }
  }

  /// Deletes refresh token from secure storage.
  Future<void> deleteRefreshToken() async {
    try {
      await _cacheHelper.deleteSecuredString(ApiConstants.refreshTokenKey);
    } catch (e) {
      throw TokenException('Failed to delete refresh token: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // ⏳ Token Expiry
  // ---------------------------------------------------------------------------

  /// Persists token expiry timestamp.
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

  /// Returns token expiry timestamp if available.
  DateTime? getTokenExpiry() {
    try {
      final value = _cacheHelper.getData(key: ApiConstants.tokenExpiryKey);
      if (value == null) return null;
      return DateTime.parse(value);
    } catch (_) {
      return null;
    }
  }

  /// Checks if the current token is considered expired.
  bool isTokenExpired() {
    final expiry = getTokenExpiry();
    if (expiry == null) return true;
    // Buffer of 30 seconds to be safe
    return DateTime.now().isAfter(expiry.subtract(const Duration(seconds: 30)));
  }

  // ---------------------------------------------------------------------------
  // 🧹 Cleanup
  // ---------------------------------------------------------------------------

  /// Clears only token-related data.
  Future<void> clearAll() async {
    try {
      await deleteToken();
      await deleteRefreshToken();
      await _cacheHelper.removeData(key: ApiConstants.tokenExpiryKey);
    } catch (e) {
      throw TokenException('Failed to clear token data: $e');
    }
  }
}

/// Domain-specific exception for token/session persistence failures.
class TokenException implements Exception {
  final String message;
  TokenException(this.message);

  @override
  String toString() => 'TokenException: $message';
}
