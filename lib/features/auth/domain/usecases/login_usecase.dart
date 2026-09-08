import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginParams {
  final String usernameOrEmail;
  final String password;

  LoginParams({required this.usernameOrEmail, required this.password});
}

class LoginUseCase implements UseCase<UserEntity, LoginParams> {
  final IAuthRepository repository;
  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) {
    return repository.login(
      usernameOrEmail: params.usernameOrEmail,
      password: params.password,
    );
  }
}
