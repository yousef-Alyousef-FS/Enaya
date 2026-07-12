import 'package:get_it/get_it.dart';
import '../../../features/auth/auth_imports.dart';

final getIt = GetIt.instance;

Future<void> initAuthInjection() async {
  // Data Sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(tokenManager: getIt(), sessionManager: getIt(), dio: getIt()),
  );

  // Repository
  getIt.registerLazySingleton<IAuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: getIt(), networkInfo: getIt()),
  );

  // Use Cases
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => SignupUsecase(getIt()));
  getIt.registerLazySingleton(() => ForgotPasswordUseCase(getIt()));
  getIt.registerLazySingleton(() => ResetPasswordUseCase(getIt()));
  getIt.registerLazySingleton(() => ChangePasswordUseCase(getIt()));
  getIt.registerLazySingleton(() => SendEmailVerificationUseCase(getIt()));
  getIt.registerLazySingleton(() => VerifyEmailUseCase(getIt()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt()));

  // Cubit
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
}
