import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/settings_service.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final SettingsService _settingsService;

  ThemeCubit({required SettingsService settingsService})
    : _settingsService = settingsService,
      super(const ThemeState(themeMode: ThemeMode.light)) {
    _loadSavedThemeMode();
  }

  void _loadSavedThemeMode() {
    final savedMode = _settingsService.getThemeMode();
    if (savedMode != null) {
      final themeMode = _stringToThemeMode(savedMode);
      if (state.themeMode != themeMode) {
        emit(ThemeState(themeMode: themeMode));
      }
    }
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    if (state.themeMode == themeMode) {
      return;
    }

    emit(ThemeState(themeMode: themeMode));
    await _settingsService.saveThemeMode(_themeModeToString(themeMode));
  }

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
