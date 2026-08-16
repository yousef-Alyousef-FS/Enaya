import 'package:get_it/get_it.dart';
import '../../features/notifications/data/repositories/notifications_repository.dart';
import '../../features/notifications/presentation/cubit/notifications_cubit.dart';

final getIt = GetIt.instance;

Future<void> initNotificationsInjection() async {
  // Repositories
  getIt.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepositoryImpl(getIt()),
  );

  // Cubits
  getIt.registerFactory(() => NotificationsCubit(getIt()));
}
