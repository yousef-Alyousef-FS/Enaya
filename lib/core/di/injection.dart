import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:enaya/features/auth/auth_imports.dart';
import 'package:enaya/features/appointments/domain/services/time_slot_generator.dart';

import 'package:enaya/features/dashboard/receptionist/presentation/cubit/receptionist_dashboard_cubit.dart';
import 'package:enaya/features/dashboard/doctor/presentation/cubit/doctor_dashboard_cubit.dart';
import 'package:enaya/features/dashboard/patient/presentation/cubit/patient_dashboard_cubit.dart';

import 'package:enaya/core/cache/cache_helper.dart';
import 'package:enaya/core/network/dio_factory.dart';
import 'package:enaya/core/network/network_info.dart';
import 'package:enaya/core/services/session_manager.dart';
import 'package:enaya/core/services/settings_service.dart';
import 'package:enaya/core/services/token_manager.dart';
import 'package:enaya/core/services/mock/mock_data_service.dart';
import 'package:enaya/core/constants/dev_config.dart';
import 'package:enaya/core/theme/cubit/theme_cubit.dart';

import 'package:enaya/features/patients/domain/repositories/patients_repository.dart';
import 'package:enaya/features/patients/data/repositories/patients_repository_impl.dart';
import 'package:enaya/features/patients/domain/usecases/search_patients_usecase.dart';
import 'package:enaya/features/patients/domain/usecases/get_patients_usecase.dart';

import '../../features/appointments/data/datasources/appointment_mock_data_source.dart';
import '../../features/appointments/data/datasources/appointment_remote_data_source.dart';
import '../../features/appointments/data/datasources/doctor_directory_data_source.dart';
import '../../features/appointments/data/datasources/doctor_directory_remote_data_source.dart';
import '../../features/appointments/data/datasources/doctor_availability_data_source.dart';
import '../../features/appointments/data/datasources/doctor_availability_remote_data_source.dart';
import '../../features/appointments/data/cache/appointment_cache_helper.dart';
import '../../features/appointments/data/cache/doctor_availability_cache_helper.dart';
import '../../features/appointments/data/repositories/appointment_repository_impl.dart';
import '../../features/appointments/data/repositories/doctor_availability_repository_impl.dart';
import '../../features/appointments/data/repositories/doctor_directory_repository_impl.dart';
import '../../features/appointments/domain/repositories/appointment_repository.dart';
import '../../features/appointments/domain/repositories/doctor_availability_repository.dart';
import '../../features/appointments/domain/repositories/doctor_directory_repository.dart';
import '../../features/appointments/domain/usecases/cancel_appointment_usecase.dart';
import '../../features/appointments/domain/usecases/create_appointment_usecase.dart';
import '../../features/appointments/domain/usecases/delete_appointment_usecase.dart';
import '../../features/appointments/domain/usecases/generate_time_slots_usecase.dart';
import '../../features/appointments/domain/usecases/get_available_doctors_usecase.dart';
import '../../features/appointments/domain/usecases/get_appointment_by_id_usecase.dart';
import '../../features/appointments/domain/usecases/get_appointment_details_usecase.dart';
import '../../features/appointments/domain/usecases/get_appointments_stats_usecase.dart';
import '../../features/appointments/domain/usecases/get_appointments_usecase.dart';
import '../../features/appointments/domain/usecases/get_available_slots_usecase.dart';
import '../../features/appointments/domain/usecases/get_doctor_schedule_usecase.dart';
import '../../features/appointments/domain/usecases/reschedule_appointment_usecase.dart';
import '../../features/appointments/domain/usecases/save_doctor_schedule_usecase.dart';
import '../../features/appointments/domain/usecases/search_available_slots_usecase.dart';
import '../../features/appointments/domain/usecases/update_appointment_status_usecase.dart';
import '../../features/appointments/presentation/cubit/details/appointment_details_cubit.dart';
import '../../features/appointments/presentation/cubit/form/appointment_schedule_cubit.dart';
import '../../features/appointments/presentation/cubit/form/doctor_schedule_cubit.dart';
import '../../features/appointments/presentation/cubit/list/appointments_overview_cubit.dart';
import '../../features/appointments/presentation/cubit/list/doctor_appointments_cubit.dart';
import '../../features/appointments/presentation/cubit/list/patient_appointments_cubit.dart';

final getIt = GetIt.instance;

/// Registers app-wide dependencies using GetIt.
Future<void> initGetIt() async {
  // 1. External & Core
  final sharedPrefs = await SharedPreferences.getInstance();
  const secureStorage = FlutterSecureStorage();

  getIt.registerLazySingleton<CacheHelper>(
    () => CacheHelper(
      sharedPreferences: sharedPrefs,
      secureStorage: secureStorage,
    ),
  );
  getIt.registerLazySingleton(() => InternetConnection());
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));

  // 2. Services
  getIt.registerLazySingleton<TokenManager>(
    () => TokenManager(cacheHelper: getIt()),
  );
  getIt.registerLazySingleton<SessionManager>(
    () => SessionManager(cacheHelper: getIt()),
  );
  getIt.registerLazySingleton<SettingsService>(
    () => SettingsService(cacheHelper: getIt()),
  );
  getIt.registerLazySingleton(() => MockDataService());

  // 2.1 Theme Management
  getIt.registerLazySingleton(
    () => ThemeCubit(settingsService: getIt<SettingsService>()),
  );

  // 3. Dio Factory
  getIt.registerLazySingleton(() => DioFactory.getDio());

  // 4. Auth Feature
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      tokenManager: getIt(),
      sessionManager: getIt(),
      dio: getIt(),
    ),
  );
  // Alternative: register mock if needed
  // getIt.registerLazySingleton<AuthRemoteDataSource>(
  //   () => AuthMockDataSourceImpl(tokenManager: getIt(), sessionManager: getIt()),
  // );
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

  // 4.1 Patients Feature
  getIt.registerLazySingleton<PatientsRepository>(
    () => PatientsRepositoryImpl(),
  );
  getIt.registerLazySingleton(() => SearchPatientsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetPatientsUseCase(getIt()));

  // 5. Appointments Feature
  getIt.registerLazySingleton<AppointmentRemoteDataSource>(
    () => DevConfig.isDevMode
        ? AppointmentMockDataSourceImpl()
        : AppointmentRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<AppointmentCacheHelper>(
    () => AppointmentCacheHelper(cacheHelper: getIt()),
  );
  getIt.registerLazySingleton<IAppointmentRepository>(
    () => AppointmentRepositoryImpl(
      remote: getIt(),
      networkInfo: getIt(),
      cacheHelper: getIt(),
    ),
  );

  // Doctor Availability Data Sources
  getIt.registerLazySingleton<DoctorAvailabilityDataSource>(
    () => DevConfig.isDevMode
        ? DoctorAvailabilityMockDataSource()
        : DoctorAvailabilityRemoteDataSource(getIt()),
  );

  getIt.registerLazySingleton<DoctorAvailabilityCacheHelper>(
    () => DoctorAvailabilityCacheHelper(cacheHelper: getIt()),
  );

  getIt.registerLazySingleton<DoctorAvailabilityRepository>(
    () => DoctorAvailabilityRepositoryImpl(
      dataSource: getIt(),
      cacheHelper: getIt(),
    ),
  );
  getIt.registerLazySingleton<DoctorDirectoryDataSource>(
    () => DevConfig.isDevMode
        ? DoctorDirectoryMockDataSource()
        : DoctorDirectoryRemoteDataSource(getIt()),
  );
  getIt.registerLazySingleton<DoctorDirectoryRepository>(
    () => DoctorDirectoryRepositoryImpl(dataSource: getIt()),
  );

  getIt.registerLazySingleton(() => GetAppointmentsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetAppointmentDetailsUseCase(getIt()));
  getIt.registerLazySingleton(() => CreateAppointmentUseCase(getIt()));
  getIt.registerLazySingleton(() => GetAvailableDoctorsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetAppointmentByIdUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateAppointmentStatusUseCase(getIt()));
  getIt.registerLazySingleton(() => RescheduleAppointmentUseCase(getIt()));
  getIt.registerLazySingleton(
    () => CancelAppointmentUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton(() => DeleteAppointmentUseCase(getIt()));
  getIt.registerLazySingleton(() => GetAvailableSlotsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetAppointmentsStatsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetDoctorScheduleUseCase(getIt()));
  getIt.registerLazySingleton(() => SaveDoctorScheduleUseCase());
  getIt.registerLazySingleton(
    () => SearchAvailableSlotsUseCase(
      appointmentRepository: getIt(),
      availabilityRepository: getIt(),
      generator: getIt(),
    ),
  );

  // 6. Dashboards
  getIt.registerFactory(
    () => ReceptionistDashboardCubit(
      getStatsUseCase: getIt(),
      getAppointmentsUseCase: getIt(),
    ),
  );

  getIt.registerFactory(
    () => DoctorDashboardCubit(
      getStatsUseCase: getIt(),
      getAppointmentsUseCase: getIt(),
      updateStatusUseCase: getIt(),
    ),
  );

  getIt.registerFactory(
    () => PatientDashboardCubit(
      getIt(), // getPatientDashboardStatsUseCase (Keep for now or unify later)
    ),
  );

  // Services
  getIt.registerLazySingleton(() => TimeSlotGenerator());
  getIt.registerLazySingleton(
    () => GenerateTimeSlotsUseCase(
      appointmentRepository: getIt(),
      availabilityRepository: getIt(),
      generator: getIt(),
    ),
  );

  getIt.registerFactory(
    () => AppointmentsManagerCubit(
      getAppointmentsUseCase: getIt<GetAppointmentsUseCase>(),
      getStatsUseCase: getIt<GetAppointmentsStatsUseCase>(),
      updateStatusUseCase: getIt<UpdateAppointmentStatusUseCase>(),
      cancelUseCase: getIt<CancelAppointmentUseCase>(),
    ),
  );

  getIt.registerFactory(
    () => DoctorAppointmentsCubit(
      getAppointmentsUseCase: getIt(),
      updateStatusUseCase: getIt(),
      cancelAppointmentUseCase: getIt(),
      rescheduleAppointmentUseCase: getIt(),
    ),
  );

  getIt.registerFactory(
    () => AppointmentScheduleCubit(
      getAvailableDoctorsUseCase: getIt(),
      createAppointmentUseCase: getIt(),
      generateTimeSlotsUseCase: getIt(),
      searchAvailableSlotsUseCase: getIt(),
      rescheduleAppointmentUseCase: getIt(),
    ),
  );

  getIt.registerFactory(
    () => AppointmentDetailsCubit(
      updateStatusUseCase: getIt(),
      cancelUseCase: getIt(),
      rescheduleUseCase: getIt(),
      getByIdUseCase: getIt(),
      deleteUseCase: getIt(),
    ),
  );

  getIt.registerFactory(
    () => DoctorScheduleCubit(
      getScheduleUseCase: getIt(),
      saveScheduleUseCase: getIt(),
    ),
  );

  getIt.registerFactory(
    () => PatientAppointmentsCubit(getAppointmentsUseCase: getIt()),
  );
}
