import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../features/auth/data/datasources/auth_mock_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/signup_usecase.dart';
import '../../features/auth/presentation/state/auth_view_model.dart';
import '../cache/cache_helper.dart';
import '../network/dio_factory.dart';
import '../network/network_info.dart';
import '../services/token_manager.dart';
import '../services/mock_data_service.dart';

final getIt = GetIt.instance;

Future<void> initGetIt() async {
  // 1. External & Core
  final sharedPrefs = await SharedPreferences.getInstance();
  const secureStorage = FlutterSecureStorage();

  getIt.registerLazySingleton<CacheHelper>(
    () => CacheHelper(sharedPreferences: sharedPrefs, secureStorage: secureStorage),
  );

  getIt.registerLazySingleton(() => InternetConnection());
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));

  // 2. Services
  getIt.registerLazySingleton(() => TokenManager(
    secureStorage: secureStorage,
    cacheHelper: getIt(),
  ));

  getIt.registerLazySingleton(() => MockDataService());

  // 3. Dio Factory
  final dio = DioFactory.getDio();
  getIt.registerLazySingleton(() => dio);

  // 4. Auth Feature
  // التبديل هنا: نستخدم AuthMockDataSourceImpl مع الخدمات الجديدة
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthMockDataSourceImpl(
      mockDataService: getIt(),
      tokenManager: getIt(),
    ),
  );

  getIt.registerLazySingleton<IAuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => SignupUsecase(getIt()));

  getIt.registerFactory(
    () => AuthViewModel(loginUseCase: getIt(), signupUseCase: getIt()),
  );
}
