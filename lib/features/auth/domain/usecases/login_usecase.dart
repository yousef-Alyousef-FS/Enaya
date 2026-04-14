// Auth Feature - Domain Layer (UseCase)
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final IAuthRepository repository;
  LoginUseCase(this.repository);
  Future<Either<Failure, User>> call({
    required String usernameOrEmail,
    required String password,
  }) {
    return repository.login(usernameOrEmail: usernameOrEmail, password: password);
  }
}