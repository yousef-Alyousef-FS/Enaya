import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

abstract class IAuthRepository {
  Future<Either<Failure, UserEntity>> login({required String usernameOrEmail, required String password});

  Future<Either<Failure, UserEntity>> signup({
    required String email,
    required String password,
    required String username,
    required String phone,
  });

  Future<Either<Failure, Unit>> forgotPassword({required String email});

  Future<Either<Failure, Unit>> resetPassword({
    required String email,
    required String verificationCode,
    required String newPassword,
  });

  Future<Either<Failure, Unit>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<Either<Failure, Unit>> sendEmailVerification({required String email});

  Future<Either<Failure, Unit>> verifyEmail({
    required String email,
    required String verificationCode,
  });

  Future<Either<Failure, Unit>> logout();
}
