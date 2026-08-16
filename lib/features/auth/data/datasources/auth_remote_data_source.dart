import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/session_manager.dart';
import '../../../../core/services/token_manager.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String usernameOrEmail,
    required String password,
  });

  Future<UserModel> signup({
    required String email,
    required String password,
    required String username,
    required String phone,
  });

  Future<void> logout();

  Future<UserModel> getMe();

  Future<void> forgotPassword({required String email});
  Future<void> resetPassword({
    required String email,
    required String verificationCode,
    required String newPassword,
  });
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
  Future<void> sendEmailVerification({required String email});
  Future<void> verifyEmail({
    required String email,
    required String verificationCode,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  final TokenManager tokenManager;
  final SessionManager sessionManager;

  AuthRemoteDataSourceImpl({
    required this.dio,
    required this.tokenManager,
    required this.sessionManager,
  });

  Map<String, dynamic> _asResponseData(Response response) {
    final data = response.data;
    if (data is Map<String, dynamic>) {
      if (data['success'] == false) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
      return data;
    }
    throw const FormatException('Invalid auth API response format');
  }

  @override
  Future<UserModel> login({
    required String usernameOrEmail,
    required String password,
  }) async {
    final response = await dio.post(
      ApiConstants.login,
      data: {'usernameOrEmail': usernameOrEmail, 'password': password},
    );

    final responseData = _asResponseData(response);
    final data = responseData['data'] as Map<String, dynamic>;

    final userJson = data['user'] as Map<String, dynamic>;
    final user = UserModel.fromJson(userJson);

    await _persistAuthSession(
      token: data['token'].toString(),
      expiry: data['expiresAt']?.toString(),
      user: user,
    );

    return user;
  }

  @override
  Future<UserModel> signup({
    required String email,
    required String password,
    required String username,
    required String phone,
  }) async {
    final response = await dio.post(
      ApiConstants.signup,
      data: {
        'email': email,
        'password': password,
        'username': username,
        'phone': phone,
        'password_confirmation': password,
      },
    );

    final responseData = _asResponseData(response);
    final data = responseData['data'] as Map<String, dynamic>;

    final userJson = data['user'] as Map<String, dynamic>;

    final user = UserModel.fromJson({
      ...userJson,
      'phone':
          userJson['phone'] ??
          phone, // Fallback to provided phone if missing in response
      'profileCompleted': data['profileCompleted'],
    });

    await _persistAuthSession(
      token: data['token'].toString(),
      expiry: data['expiresAt']?.toString(),
      user: user,
    );

    return user;
  }

  @override
  Future<UserModel> getMe() async {
    final response = await dio.get(ApiConstants.me);
    final responseData = _asResponseData(response);
    final data = responseData['data'] as Map<String, dynamic>;
    return UserModel.fromJson(data['user']);
  }

  @override
  Future<void> logout() async {
    try {
      await dio.post(ApiConstants.logout);
    } finally {
      await tokenManager.clearAll();
      await sessionManager.clearSession();
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    throw UnimplementedError();
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String verificationCode,
    required String newPassword,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> sendEmailVerification({required String email}) async {
    throw UnimplementedError();
  }

  @override
  Future<void> verifyEmail({
    required String email,
    required String verificationCode,
  }) async {
    throw UnimplementedError();
  }

  Future<void> _persistAuthSession({
    required String token,
    String? expiry,
    required UserModel user,
  }) async {
    await tokenManager.saveToken(token);
    if (expiry != null) {
      final date = DateTime.tryParse(expiry);
      if (date != null) {
        await tokenManager.saveTokenExpiry(date);
      }
    }
    await sessionManager.saveUserData(user.toJson());
  }
}
