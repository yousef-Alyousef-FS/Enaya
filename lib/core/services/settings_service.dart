import '../cache/cache_helper.dart';

/// Specialized service for managing app settings (theme, locale, etc.).
class SettingsService {
  final CacheHelper _cacheHelper;

  static const String _themeKey = 'app_theme_mode';
  static const String _languageKey = 'app_language';

  SettingsService({required CacheHelper cacheHelper})
    : _cacheHelper = cacheHelper;

  /// Persists the selected theme mode.
  Future<void> saveThemeMode(String themeMode) async {
    await _cacheHelper.setData(key: _themeKey, value: themeMode);
  }

  /// Retrieves the saved theme mode.
  String? getThemeMode() {
    return _cacheHelper.getData(key: _themeKey);
  }

  /// Persists the selected language code.
  Future<void> saveLanguage(String languageCode) async {
    await _cacheHelper.setData(key: _languageKey, value: languageCode);
  }

  /// Retrieves the saved language code.
  String? getLanguage() {
    return _cacheHelper.getData(key: _languageKey);
  }
}
