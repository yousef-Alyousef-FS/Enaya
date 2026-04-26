import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Import Barrel Files (The Clean Way)
import '../../features/appointments/domain/usecases/generate_time_slots_usecase.dart';
import '../../features/auth/auth_imports.dart';
import '../../features/appointments/data/datasources/appointment_mock_data_source.dart';
import '../../features/appointments/appointments_imports.dart';
import '../../features/appointments/domain/services/time_slot_generator.dart';
import '../../features/dashboard/receptionist/data/datasources/receptionist_dashboard_mock_data_source.dart';
import '../../features/dashboard/receptionist/data/repositories/receptionist_dashboard_repository_impl.dart';
import '../../features/dashboard/receptionist/domain/repositories/receptionist_dashboard_repository.dart';
import '../../features/dashboard/receptionist/domain/usecases/get_receptionist_dashboard_stats_usecase.dart';
import '../../features/dashboard/receptionist/presentation/cubit/receptionist_dashboard_cubit.dart';

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
  getIt.registerLazySingleton(
    () => TokenManager(secureStorage: secureStorage, cacheHelper: getIt()),
  );
  getIt.registerLazySingleton(() => MockDataService());

  // 3. Dio Factory
  getIt.registerLazySingleton(() => DioFactory.getDio());

  // 4. Auth Feature
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(tokenManager: getIt(), dio: getIt()),
  );
  getIt.registerLazySingleton<IAuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: getIt(), networkInfo: getIt()),
  );

  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => SignupUsecase(getIt()));
  getIt.registerLazySingleton(() => ForgotPasswordUseCase(getIt()));
  getIt.registerLazySingleton(() => ResetPasswordUseCase(getIt()));
  getIt.registerLazySingleton(() => ChangePasswordUseCase(getIt()));
  getIt.registerLazySingleton(() => SendEmailVerificationUseCase(getIt()));
  getIt.registerLazySingleton(() => VerifyEmailUseCase(getIt()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt()));
  getIt.registerFactory(
    () => AuthCubit(
      loginUseCase: getIt(),
      signupUseCase: getIt(),
      forgotPasswordUseCase: getIt(),
      resetPasswordUseCase: getIt(),
      changePasswordUseCase: getIt(),
      sendEmailVerificationUseCase: getIt(),
      verifyEmailUseCase: getIt(),
      logoutUseCase: getIt(),
    ),
  );

  // 5. Appointments Feature
  getIt.registerLazySingleton<AppointmentRemoteDataSource>(() => AppointmentMockDataSourceImpl());
  getIt.registerLazySingleton<AppointmentManagementRepository>(
    () => AppointmentManagementRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<PatientAppointmentsRepository>(
    () => PatientAppointmentsRepositoryImpl(getIt()),
  );

  getIt.registerLazySingleton(() => CreateAppointmentUseCase(getIt()));
  getIt.registerLazySingleton(() => GetAppointmentsByDateUseCase(getIt()));
  getIt.registerLazySingleton(() => GetTodayAppointmentsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetAppointmentByIdUseCase(getIt()));
  getIt.registerLazySingleton(() => GetAppointmentsByDoctorUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateAppointmentStatusUseCase(getIt()));
  getIt.registerLazySingleton(() => RescheduleAppointmentUseCase(getIt()));
  getIt.registerLazySingleton(
    () => CancelAppointmentUseCase(managementRepository: getIt(), patientRepository: getIt()),
  );
  getIt.registerLazySingleton(() => DeleteAppointmentUseCase(getIt()));
  getIt.registerLazySingleton(() => GetAvailableSlotsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetAppointmentsStatsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetPatientAppointmentsUseCase(getIt()));

  // Receptionist Dashboard
  getIt.registerLazySingleton<ReceptionistDashboardMockDataSource>(
    () => ReceptionistDashboardMockDataSourceImpl(),
  );

  getIt.registerLazySingleton<ReceptionistDashboardRepository>(
    () => ReceptionistDashboardRepositoryImpl(getIt<ReceptionistDashboardMockDataSource>()),
  );
  getIt.registerLazySingleton(
    () => GetReceptionistDashboardUseCase(getIt<ReceptionistDashboardRepository>()),
  );
  getIt.registerFactory(() => ReceptionistDashboardCubit(getIt<GetReceptionistDashboardUseCase>()));

  // Services
  getIt.registerLazySingleton(() => TimeSlotGenerator());
  getIt.registerLazySingleton(
    () => GenerateTimeSlotsUseCase(repository: getIt(), generator: getIt()),
  );

  getIt.registerFactory(
    () => AppointmentsOverviewCubit(
      getAppointmentsByDateUseCase: getIt(),
      getTodayAppointmentsUseCase: getIt(),
    ),
  );

  getIt.registerFactory(
    () => AppointmentScheduleCubit(
      createAppointmentUseCase: getIt(),
      generateTimeSlotsUseCase: getIt(),
    ),
  );
}
