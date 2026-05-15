import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/settings_service.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final SettingsService _settingsService;

  ThemeCubit({required SettingsService settingsService})
    : _settingsService = settingsService,
      super(const ThemeState(themeMode: ThemeMode.system)) {
    _loadSavedThemeMode();
  }

  /// تحميل الـ theme mode المحفوظ من التخزين
  void _loadSavedThemeMode() {
    final savedMode = _settingsService.getThemeMode();
    if (savedMode != null) {
      final themeMode = _stringToThemeMode(savedMode);
      emit(ThemeState(themeMode: themeMode));
    }
  }

  /// تحديث الـ theme mode وحفظه
  Future<void> setThemeMode(ThemeMode themeMode) async {
    emit(ThemeState(themeMode: themeMode));
    await _settingsService.saveThemeMode(_themeModeToString(themeMode));
  }

  /// تبديل بين الوضع الفاتح والغامق
  Future<void> toggleTheme() async {
    final currentMode = state.themeMode;
    final newMode = currentMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    await setThemeMode(newMode);
  }

  /// تحويل الـ string إلى ThemeMode
  ThemeMode _stringToThemeMode(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  /// تحويل ThemeMode إلى string
  String _themeModeToString(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}
