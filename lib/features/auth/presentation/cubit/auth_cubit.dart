import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/change_password_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/send_email_verification_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../domain/usecases/verify_email_usecase.dart';
import 'auth_state.dart';

/// Auth orchestration cubit that delegates operations to use cases.
class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final SignupUsecase _signupUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final ChangePasswordUseCase _changePasswordUseCase;
  final SendEmailVerificationUseCase _sendEmailVerificationUseCase;
  final VerifyEmailUseCase _verifyEmailUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthCubit({
    required LoginUseCase loginUseCase,
    required SignupUsecase signupUseCase,
    required ForgotPasswordUseCase forgotPasswordUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
    required ChangePasswordUseCase changePasswordUseCase,
    required SendEmailVerificationUseCase sendEmailVerificationUseCase,
    required VerifyEmailUseCase verifyEmailUseCase,
    required LogoutUseCase logoutUseCase,
  }) : _loginUseCase = loginUseCase,
       _signupUseCase = signupUseCase,
       _forgotPasswordUseCase = forgotPasswordUseCase,
       _resetPasswordUseCase = resetPasswordUseCase,
       _changePasswordUseCase = changePasswordUseCase,
       _sendEmailVerificationUseCase = sendEmailVerificationUseCase,
       _verifyEmailUseCase = verifyEmailUseCase,
       _logoutUseCase = logoutUseCase,
       super(const AuthState.initial());

  /// Authenticates user with username/email and password.
  Future<void> login(String usernameOrEmail, String password) async {
    await _handleResult<UserEntity>(
      _loginUseCase(
        LoginParams(usernameOrEmail: usernameOrEmail, password: password),
      ),
      onSuccess: (user) => emit(
        state.copyWith(
          isLoading: false,
          clearErrorMessage: true,
          isSuccess: true,
          currentUser: user,
        ),
      ),
    );
  }

  /// Creates a new user account.
  Future<void> signup(
    String email,
    String password,
    String username,
    String phone,
  ) async {
    await _handleResult<UserEntity>(
      _signupUseCase(
        SignupParams(
          email: email,
          password: password,
          username: username,
          phone: phone,
        ),
      ),
      onSuccess: (user) => emit(
        state.copyWith(
          isLoading: false,
          clearErrorMessage: true,
          isSuccess: true,
          currentUser: user,
        ),
      ),
    );
  }

  /// Initiates forgot-password flow by email.
  Future<void> forgotPassword(String email) async {
    await _handleResult<void>(
      _forgotPasswordUseCase(email),
      onSuccess: (_) => emit(
        state.copyWith(
          isLoading: false,
          clearErrorMessage: true,
          isSuccess: true,
        ),
      ),
    );
  }

  /// Resets password using verification code and new password.
  Future<void> resetPassword({
    required String email,
    required String verificationCode,
    required String newPassword,
  }) async {
    await _handleResult<void>(
      _resetPasswordUseCase(
        ResetPasswordParams(
          email: email,
          verificationCode: verificationCode,
          newPassword: newPassword,
        ),
      ),
      onSuccess: (_) => emit(
        state.copyWith(
          isLoading: false,
          clearErrorMessage: true,
          isSuccess: true,
        ),
      ),
    );
  }

  /// Changes password for currently authenticated account.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _handleResult<void>(
      _changePasswordUseCase(
        ChangePasswordParams(
          currentPassword: currentPassword,
          newPassword: newPassword,
        ),
      ),
      onSuccess: (_) => emit(
        state.copyWith(
          isLoading: false,
          clearErrorMessage: true,
          isSuccess: true,
        ),
      ),
    );
  }

  /// Requests verification code email.
  Future<void> sendEmailVerification(String email) async {
    await _handleResult<void>(
      _sendEmailVerificationUseCase(email),
      onSuccess: (_) => emit(
        state.copyWith(
          isLoading: false,
          clearErrorMessage: true,
          isSuccess: true,
        ),
      ),
    );
  }

  /// Verifies email using code sent to the user.
  Future<void> verifyEmail({
    required String email,
    required String verificationCode,
  }) async {
    await _handleResult<void>(
      _verifyEmailUseCase(
        VerifyEmailParams(email: email, verificationCode: verificationCode),
      ),
      onSuccess: (_) => emit(
        state.copyWith(
          isLoading: false,
          clearErrorMessage: true,
          isSuccess: true,
        ),
      ),
    );
  }

  /// Clears local session state via logout use case.
  Future<void> logout() async {
    await _handleResult<void>(
      _logoutUseCase(NoParams()),
      onSuccess: (_) => emit(
        state.copyWith(
          isLoading: false,
          clearErrorMessage: true,
          isSuccess: true,
          clearCurrentUser: true,
        ),
      ),
    );
  }

  /// Clears transient success/error flags for next screen action.
  void clearStatus() {
    emit(state.copyWith(clearErrorMessage: true, isSuccess: false));
  }

  /// Shared async operation wrapper used by all auth flows.
  Future<void> _handleResult<T>(
    Future<Either<Failure, T>> call, {
    required void Function(T data) onSuccess,
  }) async {
    emit(
      state.copyWith(
        isLoading: true,
        clearErrorMessage: true,
        isSuccess: false,
      ),
    );

    final result = await call;

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
          isSuccess: false,
        ),
      ),
      onSuccess,
    );

    // End auth operation dispatch flow.
  }
}
