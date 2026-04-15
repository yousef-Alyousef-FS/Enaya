import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/forgot_password_entity.dart';
import '../repositories/auth_repository.dart';

class ForgotPasswordUseCase implements UseCase<ForgotPasswordEntity, String> {
  final IAuthRepository repository;
  ForgotPasswordUseCase(this.repository);

  @override
  Future<Either<Failure, ForgotPasswordEntity>> call(String email) {
    return repository.forgotPassword(email: email);
  }
}
