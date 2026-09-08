import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class ForgotPasswordUseCase implements UseCase<Unit, String> {
  final IAuthRepository repository;
  ForgotPasswordUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String email) {
    return repository.forgotPassword(email: email);
  }
}
