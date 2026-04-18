import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  final SharedPreferences sharedPreferences;
  final FlutterSecureStorage secureStorage;

  CacheHelper({
    required this.sharedPreferences,
    required this.secureStorage,
  });

  //----------------------------------------------------------------------------
  //        Normal Storage (Shared Preferences)
  //----------------------------------------------------------------------------

  Future<bool> setData({required String key, required dynamic value}) async {
    if (value is String) return await sharedPreferences.setString(key, value);
    if (value is int) return await sharedPreferences.setInt(key, value);
    if (value is bool) return await sharedPreferences.setBool(key, value);
    if (value is double) return await sharedPreferences.setDouble(key, value);
    return false;
  }
  dynamic getData({required String key}) {
    return sharedPreferences.get(key);
  }
  Future<bool> removeData({required String key}) async {
    return await sharedPreferences.remove(key);
  }
  //----------------------------------------------------------------------------
  //        Secure Storage (Tokens, Sensitive Info)
  //----------------------------------------------------------------------------
  Future<void> saveSecuredString(String key, String value) async {
    await secureStorage.write(key: key, value: value);
  }
  Future<String?> getSecuredString(String key) async {
    return await secureStorage.read(key: key);
  }
  Future<void> deleteSecuredString(String key) async {
    await secureStorage.delete(key: key);
  }
  Future<void> clearAll() async {
    await sharedPreferences.clear();
    await secureStorage.deleteAll();
  }
}
