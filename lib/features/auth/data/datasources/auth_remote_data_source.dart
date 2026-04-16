import 'package:dio/dio.dart';
import 'package:enaya/core/constants/api_constants.dart';
import '../models/auth_responses.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String usernameOrEmail,
    required String password,
  });

  Future<UserModel> signup({
    required String userName,
    required String email,
    required String password,
    required String phone,
  });

  Future<ForgotPasswordResponse> forgotPassword({required String email});

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<UserModel> login({
    required String usernameOrEmail,
    required String password,
  }) async {
    final response = await dio.post(
      ApiConstants.login,
      data: {'usernameOrEmail': usernameOrEmail, 'password': password},
    );

    return UserModel.fromJson(response.data['user']);
  }

  @override
  Future<UserModel> signup({
    required String userName,
    required String email,
    required String password,
    required String phone,
  }) async {
    final response = await dio.post(
      ApiConstants.signup,
      data: {
        'userName': userName,
        'email': email,
        'password': password,
        'phone': phone,
      },
    );
    return UserModel.fromJson(response.data['user']);
  }

  @override
  Future<ForgotPasswordResponse> forgotPassword({required String email}) async {
    final response = await dio.post(
      ApiConstants.forgotPassword,
      data: {'email': email},
    );
    return ForgotPasswordResponse.fromJson(response.data);
  }

  @override
  Future<void> logout() {
    throw UnimplementedError();
  }
}
