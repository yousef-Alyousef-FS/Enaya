import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/api_error_handler.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserEntity>> login({
    required String usernameOrEmail,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.login(
        usernameOrEmail: usernameOrEmail,
        password: password,
      );
      return Right(user);
    } catch (error) {
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signup({
    required String email,
    required String password,
    required String username,
    required String phone,
  }) async {
    // [TECH_DEBT]: Don't block request based on local check if it's giving false negatives.
    // Instead, let Dio attempt the request and catch connection errors in ApiErrorHandler.
    try {
      final user = await remoteDataSource.signup(
        email: email,
        password: password,
        username: username,
        phone: phone,
      );
      return Right(user);
    } catch (error) {
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<Failure, Unit>> forgotPassword({required String email}) async {
    try {
      await remoteDataSource.forgotPassword(email: email);
      return const Right(unit);
    } catch (error) {
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<Failure, Unit>> resetPassword({
    required String email,
    required String verificationCode,
    required String newPassword,
  }) async {
    try {
      await remoteDataSource.resetPassword(
        email: email,
        verificationCode: verificationCode,
        newPassword: newPassword,
      );
      return const Right(unit);
    } catch (error) {
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<Failure, Unit>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await remoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return const Right(unit);
    } catch (error) {
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendEmailVerification({
    required String email,
  }) async {
    try {
      await remoteDataSource.sendEmailVerification(email: email);
      return const Right(unit);
    } catch (error) {
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<Failure, Unit>> verifyEmail({
    required String email,
    required String verificationCode,
  }) async {
    try {
      await remoteDataSource.verifyEmail(
        email: email,
        verificationCode: verificationCode,
      );
      return const Right(unit);
    } catch (error) {
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(unit);
    } catch (error) {
      return Left(ApiErrorHandler.handle(error));
    }
  }
}
