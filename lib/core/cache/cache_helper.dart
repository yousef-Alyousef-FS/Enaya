import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Unified local persistence helper for normal and sensitive values.
///
/// - SharedPreferences: non-sensitive primitives.
/// - FlutterSecureStorage: credentials/tokens and secrets.
class CacheHelper {
  final SharedPreferences sharedPreferences;
  final FlutterSecureStorage secureStorage;

  CacheHelper({required this.sharedPreferences, required this.secureStorage});

  //----------------------------------------------------------------------------
  //        Normal Storage (Shared Preferences)
  //----------------------------------------------------------------------------

  /// Saves primitive values in SharedPreferences.
  Future<bool> setData({required String key, required dynamic value}) async {
    if (value is String) return await sharedPreferences.setString(key, value);
    if (value is int) return await sharedPreferences.setInt(key, value);
    if (value is bool) return await sharedPreferences.setBool(key, value);
    if (value is double) return await sharedPreferences.setDouble(key, value);
    return false;
  }

  /// Reads a previously stored value from SharedPreferences.
  dynamic getData({required String key}) {
    return sharedPreferences.get(key);
  }

  /// Removes one value from SharedPreferences.
  Future<bool> removeData({required String key}) async {
    return await sharedPreferences.remove(key);
  }

  //----------------------------------------------------------------------------
  //        Secure Storage (Tokens, Sensitive Info)
  //----------------------------------------------------------------------------

  /// Saves a sensitive string in secure storage.
  Future<void> saveSecuredString(String key, String value) async {
    await secureStorage.write(key: key, value: value);
  }

  /// Reads a sensitive string from secure storage.
  Future<String?> getSecuredString(String key) async {
    return await secureStorage.read(key: key);
  }

  /// Deletes a sensitive key from secure storage.
  Future<void> deleteSecuredString(String key) async {
    await secureStorage.delete(key: key);
  }

  /// Clears both normal and secure local storage.
  Future<void> clearAll() async {
    await sharedPreferences.clear();
    await secureStorage.deleteAll();
  }
}
