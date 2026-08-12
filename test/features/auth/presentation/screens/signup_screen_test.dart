import 'package:enaya/core/di/injection.dart';
import 'package:enaya/features/auth/domain/usecases/change_password_usecase.dart';
import 'package:enaya/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:enaya/features/auth/domain/usecases/login_usecase.dart';
import 'package:enaya/features/auth/domain/usecases/logout_usecase.dart';
import 'package:enaya/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:enaya/features/auth/domain/usecases/send_email_verification_usecase.dart';
import 'package:enaya/features/auth/domain/usecases/signup_usecase.dart';
import 'package:enaya/features/auth/domain/usecases/verify_email_usecase.dart';
import 'package:enaya/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:enaya/features/auth/presentation/screens/signup_screen.dart';
import 'package:enaya/features/patients/domain/usecases/get_patient_profile_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockSignupUseCase extends Mock implements SignupUsecase {}

class MockForgotPasswordUseCase extends Mock implements ForgotPasswordUseCase {}

class MockResetPasswordUseCase extends Mock implements ResetPasswordUseCase {}

class MockChangePasswordUseCase extends Mock implements ChangePasswordUseCase {}

class MockSendEmailVerificationUseCase extends Mock
    implements SendEmailVerificationUseCase {}

class MockVerifyEmailUseCase extends Mock implements VerifyEmailUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockGetPatientProfileUseCase extends Mock
    implements GetPatientProfileUseCase {}

void main() {
  late MockLoginUseCase mockLoginUseCase;
  late MockSignupUseCase mockSignupUseCase;
  late MockForgotPasswordUseCase mockForgotPasswordUseCase;
  late MockResetPasswordUseCase mockResetPasswordUseCase;
  late MockChangePasswordUseCase mockChangePasswordUseCase;
  late MockSendEmailVerificationUseCase mockSendEmailVerificationUseCase;
  late MockVerifyEmailUseCase mockVerifyEmailUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockGetPatientProfileUseCase mockGetPatientProfileUseCase;

  setUp(() async {
    await GetIt.instance.reset();

    mockLoginUseCase = MockLoginUseCase();
    mockSignupUseCase = MockSignupUseCase();
    mockForgotPasswordUseCase = MockForgotPasswordUseCase();
    mockResetPasswordUseCase = MockResetPasswordUseCase();
    mockChangePasswordUseCase = MockChangePasswordUseCase();
    mockSendEmailVerificationUseCase = MockSendEmailVerificationUseCase();
    mockVerifyEmailUseCase = MockVerifyEmailUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockGetPatientProfileUseCase = MockGetPatientProfileUseCase();

    getIt.registerLazySingleton<LoginUseCase>(() => mockLoginUseCase);
    getIt.registerLazySingleton<SignupUsecase>(() => mockSignupUseCase);
    getIt.registerLazySingleton<ForgotPasswordUseCase>(
      () => mockForgotPasswordUseCase,
    );
    getIt.registerLazySingleton<ResetPasswordUseCase>(
      () => mockResetPasswordUseCase,
    );
    getIt.registerLazySingleton<ChangePasswordUseCase>(
      () => mockChangePasswordUseCase,
    );
    getIt.registerLazySingleton<SendEmailVerificationUseCase>(
      () => mockSendEmailVerificationUseCase,
    );
    getIt.registerLazySingleton<VerifyEmailUseCase>(
      () => mockVerifyEmailUseCase,
    );
    getIt.registerLazySingleton<LogoutUseCase>(() => mockLogoutUseCase);
    getIt.registerLazySingleton<GetPatientProfileUseCase>(
      () => mockGetPatientProfileUseCase,
    );

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
        getPatientProfileUseCase: getIt(),
      ),
    );
  });

  Widget createWidgetUnderTest() {
    final router = GoRouter(
      initialLocation: '/signup',
      routes: [
        GoRoute(
          path: '/signup',
          builder: (context, state) => const SignupScreen(),
        ),
      ],
    );

    return MaterialApp.router(routerConfig: router);
  }

  testWidgets('Should show validation error when fields are empty', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    final signupButton = find.byKey(const ValueKey('signup_btn'));
    await tester.tap(signupButton);
    await tester.pump();

    expect(find.text('required'), findsOneWidget);
  });
}
