import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class LogoutUseCase implements UseCase<void, NoParams> {
  final IAuthRepository repository;
  LogoutUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.logout();
  }
}
