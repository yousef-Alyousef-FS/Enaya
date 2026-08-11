import 'package:get_it/get_it.dart';

import '../../features/profile/data/datasources/profile_remote_data_source.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/get_profile_usecase.dart';
import '../../features/profile/presentaion/cubit/profile_cubit.dart';
import '../../features/update_profile/data/datasources/update_profile_remote_data_source.dart';
import '../../features/update_profile/data/repositories/update_profile_repository_impl.dart';
import '../../features/update_profile/domain/repositories/update_profile_repository.dart';
import '../../features/update_profile/domain/usecases/update_profile_usecase.dart';
import '../../features/update_profile/presentation/cubit/update_profile_cubit.dart';

final getIt = GetIt.instance;

Future<void> initProfileInjection() async {
  // Profile
  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<ProfileRepository>(
    () =>
        ProfileRepositoryImpl(remoteDataSource: getIt(), networkInfo: getIt()),
  );
  getIt.registerLazySingleton(() => GetProfileUseCase(getIt()));
  getIt.registerFactory(() => ProfileCubit(getIt()));

  // Update Profile
  getIt.registerLazySingleton<UpdateProfileRemoteDataSource>(
    () => UpdateProfileRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<UpdateProfileRepository>(
    () => UpdateProfileRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton(() => UpdateProfileUseCase(getIt()));
  getIt.registerFactory(() => UpdateProfileCubit(getIt()));
}
