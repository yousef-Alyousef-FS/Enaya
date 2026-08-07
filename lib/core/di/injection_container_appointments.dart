import 'package:get_it/get_it.dart';

import '../../../features/appointments/data/cache/appointment_cache_helper.dart';
import '../../../features/appointments/data/cache/doctor_availability_cache_helper.dart';
import '../../../features/appointments/data/datasources/appointment_remote_data_source.dart';
import '../../../features/appointments/data/datasources/doctor_availability_data_source.dart';
import '../../../features/appointments/data/datasources/doctor_availability_remote_data_source.dart';
import '../../../features/appointments/data/datasources/doctor_directory_data_source.dart';
import '../../../features/appointments/data/datasources/doctor_directory_remote_data_source.dart';
import '../../../features/appointments/data/repositories/appointment_repository_impl.dart';
import '../../../features/appointments/data/repositories/doctor_availability_repository_impl.dart';
import '../../../features/appointments/data/repositories/doctor_directory_repository_impl.dart';
import '../../../features/appointments/domain/repositories/appointment_repository.dart';
import '../../../features/appointments/domain/repositories/doctor_availability_repository.dart';
import '../../../features/appointments/domain/repositories/doctor_directory_repository.dart';
import '../../../features/appointments/domain/services/time_slot_generator.dart';
import '../../../features/appointments/domain/usecases/cancel_appointment_usecase.dart';
import '../../../features/appointments/domain/usecases/create_appointment_usecase.dart';
import '../../../features/appointments/domain/usecases/delete_appointment_usecase.dart';
import '../../../features/appointments/domain/usecases/generate_time_slots_usecase.dart';
import '../../../features/appointments/domain/usecases/get_appointment_by_id_usecase.dart';
import '../../../features/appointments/domain/usecases/get_appointment_details_usecase.dart';
import '../../../features/appointments/domain/usecases/get_appointments_stats_usecase.dart';
import '../../../features/appointments/domain/usecases/get_appointments_usecase.dart';
import '../../../features/appointments/domain/usecases/get_available_days_usecase.dart';
import '../../../features/appointments/domain/usecases/get_available_doctors_usecase.dart';
import '../../../features/appointments/domain/usecases/get_available_slots_usecase.dart';
import '../../../features/appointments/domain/usecases/reschedule_appointment_usecase.dart';
import '../../../features/appointments/domain/usecases/search_available_slots_usecase.dart';
import '../../../features/appointments/domain/usecases/update_appointment_status_usecase.dart';
import '../../../features/appointments/presentation/cubit/details/appointment_details_cubit.dart';
import '../../../features/appointments/presentation/cubit/form/appointment_schedule_cubit.dart';
import '../../../features/appointments/presentation/cubit/form/doctor_availability_cubit.dart';
import '../../../features/appointments/presentation/cubit/list/doctor_appointments_cubit.dart';
import '../../../features/appointments/presentation/cubit/list/patient_appointments_cubit.dart';
import '../../../features/appointments/presentation/cubit/list/receptionist_appointments_cubit.dart';

final getIt = GetIt.instance;

Future<void> initAppointmentsInjection() async {
  // Services
  getIt.registerLazySingleton(() => TimeSlotGenerator());

  // Data Sources
  getIt.registerLazySingleton<AppointmentRemoteDataSource>(
    () => AppointmentRemoteDataSourceImpl(getIt(), getIt()),
  );
  getIt.registerLazySingleton<DoctorAvailabilityDataSource>(
    () => DoctorAvailabilityRemoteDataSource(getIt()),
  );
  getIt.registerLazySingleton<DoctorDirectoryDataSource>(
    () => DoctorDirectoryRemoteDataSource(getIt(), getIt()),
  );

  // Cache Helpers
  getIt.registerLazySingleton<AppointmentCacheHelper>(
    () => AppointmentCacheHelper(cacheHelper: getIt()),
  );
  getIt.registerLazySingleton<DoctorAvailabilityCacheHelper>(
    () => DoctorAvailabilityCacheHelper(cacheHelper: getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<IAppointmentRepository>(
    () => AppointmentRepositoryImpl(
      remote: getIt(),
      networkInfo: getIt(),
      cacheHelper: getIt(),
    ),
  );
  getIt.registerLazySingleton<DoctorAvailabilityRepository>(
    () => DoctorAvailabilityRepositoryImpl(
      dataSource: getIt(),
      cacheHelper: getIt(),
    ),
  );
  getIt.registerLazySingleton<DoctorDirectoryRepository>(
    () => DoctorDirectoryRepositoryImpl(dataSource: getIt()),
  );

  // Use Cases
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
  getIt.registerLazySingleton(() => GetAvailableDaysUseCase(getIt()));
  getIt.registerLazySingleton(() => GetAppointmentsStatsUseCase(getIt()));
  getIt.registerLazySingleton(
    () => SearchAvailableSlotsUseCase(
      appointmentRepository: getIt(),
      availabilityRepository: getIt(),
      generator: getIt(),
    ),
  );
  getIt.registerLazySingleton(
    () => GenerateTimeSlotsUseCase(
      appointmentRepository: getIt(),
      availabilityRepository: getIt(),
      generator: getIt(),
    ),
  );

  // Cubits
  getIt.registerFactory(
    () => ReceptionistAppointmentsCubit(
      getAppointmentsUseCase: getIt(),
      getStatsUseCase: getIt(),
      updateStatusUseCase: getIt(),
      cancelUseCase: getIt(),
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
      searchAvailableSlotsUseCase: getIt(),
      rescheduleAppointmentUseCase: getIt(),
      getAvailableDaysUseCase: getIt(),
      getAvailableSlotsUseCase: getIt(),
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
    () => DoctorAvailabilityCubit(
      repository: getIt(),
      getAppointmentsUseCase: getIt(),
    ),
  );
  getIt.registerFactory(
    () => PatientAppointmentsCubit(getAppointmentsUseCase: getIt()),
  );
}
