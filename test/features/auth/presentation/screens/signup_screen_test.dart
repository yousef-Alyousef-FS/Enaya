import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:enaya/features/auth/domain/usecases/change_password_usecase.dart';
import 'package:enaya/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:enaya/features/auth/domain/usecases/login_usecase.dart';
import 'package:enaya/features/auth/domain/usecases/logout_usecase.dart';
import 'package:enaya/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:enaya/features/auth/domain/usecases/send_email_verification_usecase.dart';
import 'package:enaya/features/auth/domain/usecases/signup_usecase.dart';
import 'package:enaya/features/auth/domain/usecases/verify_email_usecase.dart';
import 'package:enaya/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:enaya/features/auth/presentation/cubit/auth_state.dart';
import 'package:enaya/features/auth/presentation/screens/signup_screen.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockSignupUseCase extends Mock implements SignupUsecase {}

class MockForgotPasswordUseCase extends Mock implements ForgotPasswordUseCase {}

class MockResetPasswordUseCase extends Mock implements ResetPasswordUseCase {}

class MockChangePasswordUseCase extends Mock implements ChangePasswordUseCase {}

class MockSendEmailVerificationUseCase extends Mock implements SendEmailVerificationUseCase {}

class MockVerifyEmailUseCase extends Mock implements VerifyEmailUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

void main() {
  testWidgets('shows server validation error without crashing', (WidgetTester tester) async {
    final cubit = AuthCubit(
      loginUseCase: MockLoginUseCase(),
      signupUseCase: MockSignupUseCase(),
      forgotPasswordUseCase: MockForgotPasswordUseCase(),
      resetPasswordUseCase: MockResetPasswordUseCase(),
      changePasswordUseCase: MockChangePasswordUseCase(),
      sendEmailVerificationUseCase: MockSendEmailVerificationUseCase(),
      verifyEmailUseCase: MockVerifyEmailUseCase(),
      logoutUseCase: MockLogoutUseCase(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(value: cubit, child: const SignupScreen()),
      ),
    );

    cubit.emit(
      const AuthState(
        isLoading: false,
        errorMessage: 'The username has already been taken.',
        isSuccess: false,
        currentUser: null,
      ),
    );

    await tester.pump();

    expect(find.text('The username has already been taken.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
