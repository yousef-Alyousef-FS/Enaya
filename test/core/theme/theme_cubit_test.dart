import 'package:enaya/core/cache/cache_helper.dart';
import 'package:enaya/core/services/settings_service.dart';
import 'package:enaya/core/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeSettingsService extends SettingsService {
  FakeSettingsService(CacheHelper cacheHelper) : super(cacheHelper: cacheHelper);

  final List<String> savedThemeModes = [];

  @override
  Future<void> saveThemeMode(String themeMode) async {
    savedThemeModes.add(themeMode);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeSettingsService settingsService;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final cacheHelper = CacheHelper(
      sharedPreferences: prefs,
      secureStorage: const FlutterSecureStorage(),
    );
    settingsService = FakeSettingsService(cacheHelper);
  });

  test('does not persist duplicate theme mode updates', () async {
    final cubit = ThemeCubit(settingsService: settingsService);

    await cubit.setThemeMode(ThemeMode.dark);
    await cubit.setThemeMode(ThemeMode.dark);

    expect(settingsService.savedThemeModes, ['dark']);
  });
}
