import 'package:get_it/get_it.dart';

import '../../../features/patients/data/datasources/patients_remote_data_source.dart';
import '../../../features/patients/data/repositories/patients_repository_impl.dart';
import '../../../features/patients/domain/repositories/patients_repository.dart';
import '../../../features/patients/domain/usecases/complete_patient_profile_usecase.dart';
import '../../../features/patients/domain/usecases/get_patient_profile_usecase.dart';
import '../../../features/patients/domain/usecases/get_patients_usecase.dart';
import '../../../features/patients/domain/usecases/search_patients_usecase.dart';
import '../../../features/patients/presentation/state/patient_profile_cubit.dart';

final getIt = GetIt.instance;

Future<void> initPatientsInjection() async {
  // Data Sources
  getIt.registerLazySingleton<PatientsRemoteDataSource>(
    () => PatientsRemoteDataSourceImpl(getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<PatientsRepository>(
    () => PatientsRepositoryImpl(remoteDataSource: getIt()),
  );

  // Use Cases
  getIt.registerLazySingleton(() => SearchPatientsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetPatientsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetPatientProfileUseCase(getIt()));
  getIt.registerLazySingleton(() => CompletePatientProfileUseCase(getIt()));

  // Cubits
  getIt.registerFactory(
    () => PatientProfileCubit(
      getProfileUseCase: getIt(),
      completeProfileUseCase: getIt(),
    ),
  );
}
