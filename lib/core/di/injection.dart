import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Import Barrel Files (The Clean Way)
import '../../features/auth/auth_imports.dart';
import '../../features/appointments/appointments_imports.dart';
import '../../features/dashboard/dashboard_imports.dart';

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
  final dio = DioFactory.getDio();

  getIt.registerLazySingleton<CacheHelper>(
    () => CacheHelper(
      sharedPreferences: sharedPrefs,
      secureStorage: secureStorage,
    ),
  );
  getIt.registerLazySingleton(() => InternetConnection());
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));

  // 2. Services
  getIt.registerLazySingleton(
    () => TokenManager(secureStorage: secureStorage, cacheHelper: getIt()),
  );
  getIt.registerLazySingleton(() => MockDataService());

  // 3. Dio Factory
  getIt.registerLazySingleton(() => dio);

  // 4. Auth Feature
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () =>
        AuthMockDataSourceImpl(mockDataService: getIt(), tokenManager: getIt()),
  );
  getIt.registerLazySingleton<IAuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: getIt(), networkInfo: getIt()),
  );
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => SignupUsecase(getIt()));
  getIt.registerLazySingleton(() => ForgotPasswordUseCase(getIt()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt()));
  getIt.registerFactory(
    () => AuthViewModel(
      loginUseCase: getIt(),
      signupUseCase: getIt(),
      forgotPasswordUseCase: getIt(),
      logoutUseCase: getIt(),
    ),
  );

  // 5. Appointments Feature
  getIt.registerLazySingleton<AppointmentRemoteDataSource>(
    () => AppointmentRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<AppointmentRepository>(
    () => AppointmentRepositoryImpl(getIt()),
  );

  getIt.registerLazySingleton(() => CreateAppointmentUseCase(getIt()));
  getIt.registerLazySingleton(() => GetAppointmentsByDateUseCase(getIt()));
  getIt.registerLazySingleton(() => GetTodayAppointmentsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetAppointmentByIdUseCase(getIt()));
  getIt.registerLazySingleton(() => GetAppointmentsByDoctorUseCase(getIt()));
  getIt.registerLazySingleton(() => GetAppointmentsByPatientUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateAppointmentStatusUseCase(getIt()));
  getIt.registerLazySingleton(() => RescheduleAppointmentUseCase(getIt()));
  getIt.registerLazySingleton(() => CancelAppointmentUseCase(getIt()));
  getIt.registerLazySingleton(() => DeleteAppointmentUseCase(getIt()));

  getIt.registerFactory(
    () => AppointmentState(
      createAppointmentUseCase: getIt(),
      getAppointmentsByDateUseCase: getIt(),
      getTodayAppointmentsUseCase: getIt(),
      userRoleId: 3,
    ),
  );

  // 6. Reception Dashboard Feature
  getIt.registerFactory(
    () => ReceptionDashboardState(
      getTodayAppointmentsUseCase: getIt(),
      updateAppointmentStatusUseCase: getIt(),
      userRoleId: 3,
    ),
  );
}
