import 'package:get_it/get_it.dart';
import '../../features/medical_history/data/datasources/medical_history_remote_data_source.dart';
import '../../features/medical_history/data/repositories/medical_history_repository_impl.dart';
import '../../features/medical_history/domain/repositories/medical_history_repository.dart';
import '../../features/medical_history/domain/usecases/get_medical_history_usecase.dart';
import '../../features/medical_history/presentation/cubit/medical_history_cubit.dart';

final getIt = GetIt.instance;

Future<void> initMedicalHistoryInjection() async {
  // Data Source
  getIt.registerLazySingleton<MedicalHistoryRemoteDataSource>(
    () => MedicalHistoryRemoteDataSourceImpl(getIt()),
  );

  // Repository
  getIt.registerLazySingleton<MedicalHistoryRepository>(
    () => MedicalHistoryRepositoryImpl(getIt()),
  );

  // UseCases
  getIt.registerLazySingleton(() => GetMedicalHistoryUseCase(getIt()));

  // Cubit
  getIt.registerFactory(
    () => MedicalHistoryCubit(getMedicalHistoryUseCase: getIt()),
  );
}
