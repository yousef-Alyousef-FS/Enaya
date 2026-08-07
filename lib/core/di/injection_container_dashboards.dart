import 'package:get_it/get_it.dart';

import '../../../features/dashboard/doctor/data/datasources/doctor_dashboard_remote_data_source.dart';
import '../../../features/dashboard/doctor/data/repositories/doctor_dashboard_repository_impl.dart';
import '../../../features/dashboard/doctor/domain/repositories/doctor_dashboard_repository.dart';
import '../../../features/dashboard/doctor/domain/usecases/get_doctor_dashboard_stats_usecase.dart';
import '../../../features/dashboard/doctor/presentation/cubit/doctor_dashboard_cubit.dart';
import '../../../features/dashboard/patient/data/datasources/patient_dashboard_remote_data_source.dart';
import '../../../features/dashboard/patient/data/repositories/patient_dashboard_repository_impl.dart';
import '../../../features/dashboard/patient/domain/repositories/patient_dashboard_repository.dart';
import '../../../features/dashboard/patient/domain/usecases/get_patient_dashboard_stats_usecase.dart';
import '../../../features/dashboard/patient/presentation/cubit/patient_dashboard_cubit.dart';
import '../../../features/dashboard/receptionist/presentation/cubit/receptionist_dashboard_cubit.dart';

final getIt = GetIt.instance;

Future<void> initDashboardsInjection() async {
  // Data Sources
  getIt.registerLazySingleton<DoctorDashboardRemoteDataSource>(
    () => DoctorDashboardRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<PatientDashboardRemoteDataSource>(
    () => PatientDashboardRemoteDataSourceImpl(getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<DoctorDashboardRepository>(
    () => DoctorDashboardRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<PatientDashboardRepository>(
    () => PatientDashboardRepositoryImpl(getIt()),
  );

  // Use Cases
  getIt.registerLazySingleton(() => GetDoctorDashboardStatsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetPatientDashboardStatsUseCase(getIt()));

  // Cubits
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

  getIt.registerFactory(() => PatientDashboardCubit(getIt()));
}
