import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../cache/cache_helper.dart';
import '../network/dio_factory.dart';
import '../network/network_info.dart';
import '../services/session_manager.dart';
import '../services/settings_service.dart';
import '../services/token_manager.dart';
import '../theme/cubit/theme_cubit.dart';

final getIt = GetIt.instance;

Future<void> initCoreInjection() async {
  // External
  final sharedPrefs = await SharedPreferences.getInstance();
  const secureStorage = FlutterSecureStorage();

  getIt.registerLazySingleton<CacheHelper>(
    () => CacheHelper(sharedPreferences: sharedPrefs, secureStorage: secureStorage),
  );
  getIt.registerLazySingleton(() => InternetConnection());
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));

  // Core Services
  getIt.registerLazySingleton<TokenManager>(() => TokenManager(cacheHelper: getIt()));
  getIt.registerLazySingleton<SessionManager>(() => SessionManager(cacheHelper: getIt()));
  getIt.registerLazySingleton<SettingsService>(() => SettingsService(cacheHelper: getIt()));

  // Theme
  getIt.registerLazySingleton(() => ThemeCubit(settingsService: getIt<SettingsService>()));

  // Network
  getIt.registerLazySingleton(() => DioFactory.getDio());
}
