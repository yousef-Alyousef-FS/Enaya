import 'package:get_it/get_it.dart';
import '../../features/prescriptions/data/datasources/prescription_remote_data_source.dart';
import '../../features/prescriptions/data/repositories/prescription_repository_impl.dart';
import '../../features/prescriptions/domain/repositories/prescription_repository.dart';
import '../../features/prescriptions/domain/usecases/add_prescription_usecase.dart';
import '../../features/prescriptions/domain/usecases/delete_prescription_usecase.dart';
import '../../features/prescriptions/domain/usecases/get_prescriptions_usecase.dart';
import '../../features/prescriptions/domain/usecases/update_prescription_usecase.dart';
import '../../features/prescriptions/presentation/cubit/prescription_cubit.dart';
import '../../features/session/data/datasources/session_remote_data_source.dart';
import '../../features/session/data/repositories/session_repository_impl.dart';
import '../../features/session/domain/repositories/session_repository.dart';
import '../../features/session/domain/usecases/end_session_usecase.dart';
import '../../features/session/domain/usecases/get_session_details_usecase.dart';
import '../../features/session/domain/usecases/start_session_usecase.dart';
import '../../features/session/presentation/cubit/session_cubit.dart';

final getIt = GetIt.instance;

Future<void> initDoctorSessionInjection() async {
  // ---- Session feature ----
  getIt.registerLazySingleton<SessionRemoteDataSource>(
    () => SessionRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<SessionRepository>(
    () => SessionRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton(() => GetSessionUseCase(getIt()));
  getIt.registerLazySingleton(() => StartSessionUseCase(getIt()));
  getIt.registerLazySingleton(() => EndSessionUseCase(getIt()));

  getIt.registerFactory(
    () => SessionCubit(
      getSessionUseCase: getIt(),
      startSessionUseCase: getIt(),
      endSessionUseCase: getIt(),
    ),
  );

  // ---- Prescriptions feature ----
  getIt.registerLazySingleton<PrescriptionRemoteDataSource>(
    () => PrescriptionRemoteDataSourceImpl(dio: getIt()),
  );
  getIt.registerLazySingleton<PrescriptionRepository>(
    () => PrescriptionRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton(() => GetPrescriptionsUseCase(getIt()));
  getIt.registerLazySingleton(() => AddPrescriptionUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdatePrescriptionUseCase(getIt()));
  getIt.registerLazySingleton(() => DeletePrescriptionUseCase(getIt()));

  getIt.registerFactory(
    () => PrescriptionCubit(
      getPrescriptionsUseCase: getIt(),
      addPrescriptionUseCase: getIt(),
      updatePrescriptionUseCase: getIt(),
      deletePrescriptionUseCase: getIt(),
    ),
  );
}
