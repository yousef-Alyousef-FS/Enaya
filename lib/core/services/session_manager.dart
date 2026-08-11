import 'dart:convert';

import '../cache/cache_helper.dart';
import '../constants/api_constants.dart';

/// Specialized service for managing the active user session and cached profile data.
class SessionManager {
  final CacheHelper _cacheHelper;

  SessionManager({required CacheHelper cacheHelper})
    : _cacheHelper = cacheHelper;

  /// Saves serialized user payload in non-secure cache.
  Future<void> saveUserData(Map<String, dynamic> user) async {
    try {
      await _cacheHelper.setData(
        key: ApiConstants.userDataKey,
        value: jsonEncode(user),
      );
    } catch (e) {
      throw SessionException('Failed to save user data: $e');
    }
  }

  /// Reads and decodes cached user payload.
  Map<String, dynamic>? getUserData() {
    try {
      final jsonString = _cacheHelper.getData(key: ApiConstants.userDataKey);
      if (jsonString == null) return null;
      return jsonDecode(jsonString);
    } catch (_) {
      return null;
    }
  }

  /// Checks if a user is currently cached (active session).
  bool get hasActiveSession => getUserData() != null;

  /// Convenience accessor for current raw user payload.
  Map<String, dynamic>? get currentUser => getUserData();

  /// Returns first non-empty string value for any provided key.
  String? readStringValue(List<String> keys) {
    final data = currentUser;
    if (data == null) return null;

    for (final key in keys) {
      final value = data[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString().trim();
      }
    }

    return null;
  }

  String? get currentUserId => readStringValue(['id', 'userId', 'user_id']);

  String? get currentUserName =>
      readStringValue(['name', 'userName', 'username']);

  String? get currentUserEmail => readStringValue(['email']);

  String? get currentUserPhone => readStringValue(['phone', 'mobile']);

  int? get currentRoleId {
    final data = currentUser;
    if (data == null) return null;

    final rawRole = data['roleId'] ?? data['role_id'] ?? data['role'];
    if (rawRole is int) return rawRole;

    final rawString = rawRole?.toString().trim().toLowerCase();
    if (rawString == null || rawString.isEmpty) return null;

    switch (rawString) {
      case 'receptionist':
        return 1;
      case 'doctor':
        return 2;
      case 'patient':
        return 3;
      default:
        return int.tryParse(rawString);
    }
  }

  /// Clears the user session data.
  Future<void> clearSession() async {
    try {
      await _cacheHelper.removeData(key: ApiConstants.userDataKey);
    } catch (e) {
      throw SessionException('Failed to clear session data: $e');
    }
  }
}

class SessionException implements Exception {
  final String message;
  SessionException(this.message);

  @override
  String toString() => 'SessionException: $message';
}
