import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class SendEmailVerificationUseCase implements UseCase<Unit, String> {
  final IAuthRepository repository;

  SendEmailVerificationUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String email) {
    return repository.sendEmailVerification(email: email);
  }
}
