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

  AuthRepositoryImpl({required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, User>> login({
    required String usernameOrEmail,
    required String password,
  }) async
  {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }

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
  Future<Either<Failure, User>> signup({
    required String email,
    required String password,
    required String username,
    required String phone,
  }) async
  {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }

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
  Future<Either<Failure, Unit>> forgotPassword({required String email}) async
  {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }

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
  }) async
  {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }

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
  }) async
  {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }

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
  Future<Either<Failure, Unit>> sendEmailVerification({required String email}) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }

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
  }) async
  {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      await remoteDataSource.verifyEmail(email: email, verificationCode: verificationCode);
      return const Right(unit);
    } catch (error) {
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async
  {
    try {
      await remoteDataSource.logout();
      return const Right(unit);
    } catch (error) {
      return Left(ApiErrorHandler.handle(error));
    }
  }
}
