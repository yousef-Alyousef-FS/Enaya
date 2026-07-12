import 'package:get_it/get_it.dart';
import '../../../features/patients/data/repositories/patients_repository_impl.dart';
import '../../../features/patients/domain/repositories/patients_repository.dart';
import '../../../features/patients/domain/usecases/get_patients_usecase.dart';
import '../../../features/patients/domain/usecases/search_patients_usecase.dart';

final getIt = GetIt.instance;

Future<void> initPatientsInjection() async {
  getIt.registerLazySingleton<PatientsRepository>(() => PatientsRepositoryImpl());
  getIt.registerLazySingleton(() => SearchPatientsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetPatientsUseCase(getIt()));
}
