import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignupParams {
  final String email;
  final String password;
  final String username;
  final String phone;

  SignupParams({
    required this.email,
    required this.password,
    required this.username,
    required this.phone,
  });
}

class SignupUsecase implements UseCase<UserEntity, SignupParams> {
  final IAuthRepository repository;
  SignupUsecase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(SignupParams params) {
    return repository.signup(
      email: params.email,
      password: params.password,
      username: params.username,
      phone: params.phone,
    );
  }
}
