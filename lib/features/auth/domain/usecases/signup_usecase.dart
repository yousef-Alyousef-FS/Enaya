import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignupUsecase {
  final IAuthRepository repository;
  SignupUsecase(this.repository);

  Future<Either<Failure, User>> call({
    required String email,
    required String password,
    required String username,
    required String phone,
  }) {
    return repository.signup(
      email: email,
      password: password,
      username: username,
      phone: phone,
    );
  }
}
