import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class ResetPasswordParams {
  final String email;
  final String verificationCode;
  final String newPassword;

  ResetPasswordParams({
    required this.email,
    required this.verificationCode,
    required this.newPassword,
  });
}

class ResetPasswordUseCase implements UseCase<Unit, ResetPasswordParams> {
  final IAuthRepository repository;

  ResetPasswordUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(ResetPasswordParams params) {
    return repository.resetPassword(
      email: params.email,
      verificationCode: params.verificationCode,
      newPassword: params.newPassword,
    );
  }
}
