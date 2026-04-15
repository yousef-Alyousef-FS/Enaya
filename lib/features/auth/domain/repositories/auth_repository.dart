import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/forgot_password_entity.dart';
import '../entities/user_entity.dart';

abstract class IAuthRepository {
  Future<Either<Failure, User>> login({
    required String usernameOrEmail,
    required String password,
  });

  Future<Either<Failure, User>> signup({
    required String email,
    required String password,
    required String username,
    required String phone,
  });

  Future<Either<Failure, ForgotPasswordEntity>> forgotPassword({
    required String email,
  });

  Future<Either<Failure, void>> logout();
}
