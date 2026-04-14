import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
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

  Future<Either<Failure, void>> logout();
}
