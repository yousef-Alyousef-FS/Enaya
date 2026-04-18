import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_error_handler.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/auth_responses.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  // ---------------------------------------------------------------------------
  // 🔥 Helper: توحيد التعامل مع الأخطاء
  // ---------------------------------------------------------------------------
  Future<Either<Failure, T>> _safeCall<T>(Future<T> Function() call) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      final result = await call();
      return Right(result);
    } catch (error) {
      return Left(ApiErrorHandler.handle(error));
    }
  }

  // ---------------------------------------------------------------------------
  // 🔐 Login
  // ---------------------------------------------------------------------------
  @override
  Future<Either<Failure, User>> login({
    required String usernameOrEmail,
    required String password,
  }) async {
    return _safeCall<User>(() async {
      final response = await remoteDataSource.login(
        usernameOrEmail: usernameOrEmail,
        password: password,
      );

      if (response.success && response.data != null) {
        return response.data!.user.toEntity();
      }

      throw ServerFailure(response.error ?? "Login failed");
    });
  }

  // ---------------------------------------------------------------------------
  // 📝 Signup
  // ---------------------------------------------------------------------------
  @override
  Future<Either<Failure, User>> signup({
    required String email,
    required String password,
    required String username,
    required String phone,
  }) async {
    return _safeCall<User>(() async {
      final response = await remoteDataSource.signup(
        email: email,
        password: password,
        userName: username,
        phone: phone,
      );

      if (response.success && response.data != null) {
        return response.data!.user.toEntity();
      }

      throw ServerFailure(response.error ?? "Signup failed");
    });
  }

  // ---------------------------------------------------------------------------
  // 🔑 Forgot Password
  // ---------------------------------------------------------------------------
  @override
  Future<Either<Failure, Unit>> forgotPassword({
    required String email,
  }) async {
    return _safeCall<Unit>(() async {
      final response = await remoteDataSource.forgotPassword(email: email);

      if (response.success) {
        return unit;
      }

      throw ServerFailure(response.error ?? "Request failed");
    });
  }

  // ---------------------------------------------------------------------------
  // 🚪 Logout
  // ---------------------------------------------------------------------------
  @override
  Future<Either<Failure, Unit>> logout() async {
    return _safeCall<Unit>(() async {
      await remoteDataSource.logout();
      return unit;
    });
  }
}
