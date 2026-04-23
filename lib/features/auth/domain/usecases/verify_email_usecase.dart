import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class VerifyEmailParams {
  final String email;
  final String verificationCode;

  VerifyEmailParams({required this.email, required this.verificationCode});
}

class VerifyEmailUseCase implements UseCase<Unit, VerifyEmailParams> {
  final IAuthRepository repository;

  VerifyEmailUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(VerifyEmailParams params) {
    return repository.verifyEmail(email: params.email, verificationCode: params.verificationCode);
  }
}
