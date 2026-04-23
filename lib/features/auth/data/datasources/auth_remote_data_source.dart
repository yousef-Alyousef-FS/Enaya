import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/token_manager.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String usernameOrEmail, required String password});

  Future<UserModel> signup({
    required String email,
    required String password,
    required String username,
    required String phone,
  });

  Future<void> forgotPassword({required String email});

  Future<void> resetPassword({
    required String email,
    required String verificationCode,
    required String newPassword,
  });

  Future<void> changePassword({required String currentPassword, required String newPassword});

  Future<void> sendEmailVerification({required String email});

  Future<void> verifyEmail({required String email, required String verificationCode});

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  final TokenManager tokenManager;

  AuthRemoteDataSourceImpl({required this.dio, required this.tokenManager});

  Map<String, dynamic> _asMap(dynamic value, {required String errorMessage}) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    throw FormatException(errorMessage);
  }

  Map<String, dynamic> _asResponseData(Response response) {
    return _asMap(response.data, errorMessage: 'Invalid auth API response format');
  }

  void _validateStatusCode(Response response, List<int> expectedCodes) {
    final statusCode = response.statusCode;

    if (statusCode != null && expectedCodes.contains(statusCode)) {
      return;
    }

    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      type: DioExceptionType.badResponse,
    );
  }

  DateTime _resolveTokenExpiry(Map<String, dynamic> payload) {
    final expiryRaw = payload['expires_at'] ?? payload['expiresAt'];

    if (expiryRaw is String) {
      final parsed = DateTime.tryParse(expiryRaw);
      if (parsed != null) {
        return parsed;
      }
    }

    return DateTime.now().add(const Duration(hours: 24));
  }

  Map<String, dynamic> _resolvePayload(Map<String, dynamic> responseData) {
    final data = responseData['data'];

    if (data is Map || data is Map<String, dynamic>) {
      return _asMap(data, errorMessage: 'Invalid auth API payload format');
    }

    return responseData;
  }

  Map<String, dynamic> _resolveUserJson(Map<String, dynamic> payload) {
    final user = payload['user'];

    if (user != null) {
      return _asMap(user, errorMessage: 'Invalid user payload in auth API response');
    }

    if (payload.containsKey('id') &&
        payload.containsKey('email') &&
        (payload.containsKey('username') || payload.containsKey('userName'))) {
      return payload;
    }

    throw const FormatException('Missing user data in auth API response');
  }

  Future<void> _persistAuthSession({
    required UserModel user,
    required Map<String, dynamic> payload,
  }) async {
    final token = payload['token']?.toString();

    if (token == null || token.isEmpty) {
      throw const FormatException('Missing token in auth API response');
    }

    await tokenManager.saveToken(token);

    final refreshToken =
        payload['refresh_token']?.toString() ?? payload['refreshToken']?.toString();
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await tokenManager.saveRefreshToken(refreshToken);
    }

    await tokenManager.saveTokenExpiry(_resolveTokenExpiry(payload));
    await tokenManager.saveUserData(user.toJson());
  }

  @override
  Future<UserModel> login({required String usernameOrEmail, required String password}) async {
    final response = await dio.post(
      ApiConstants.login,
      data: {'usernameOrEmail': usernameOrEmail, 'password': password},
    );

    _validateStatusCode(response, [200]);

    final responseData = _asResponseData(response);
    final payload = _resolvePayload(responseData);
    final user = UserModel.fromJson(_resolveUserJson(payload));

    await _persistAuthSession(user: user, payload: payload);

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
      data: {'email': email, 'password': password, 'username': username, 'phone': phone , 'password_confirmation':password},
    );

    _validateStatusCode(response, [200, 201]);

    final responseData = _asResponseData(response);
    final payload = _resolvePayload(responseData);
    final user = UserModel.fromJson(_resolveUserJson(payload));

    await _persistAuthSession(user: user, payload: payload);

    return user;
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    final response = await dio.post(ApiConstants.forgotPassword, data: {'email': email});
    _validateStatusCode(response, [200, 202, 204]);
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String verificationCode,
    required String newPassword,
  }) async {
    final response = await dio.post(
      ApiConstants.resetPassword,
      data: {'email': email, 'verificationCode': verificationCode, 'newPassword': newPassword},
    );

    _validateStatusCode(response, [200, 204]);
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final response = await dio.post(
      ApiConstants.changePassword,
      data: {'currentPassword': currentPassword, 'newPassword': newPassword},
    );

    _validateStatusCode(response, [200, 204]);
  }

  @override
  Future<void> sendEmailVerification({required String email}) async {
    final response = await dio.post(ApiConstants.sendEmailVerification, data: {'email': email});

    _validateStatusCode(response, [200, 202, 204]);
  }

  @override
  Future<void> verifyEmail({required String email, required String verificationCode}) async {
    final response = await dio.post(
      ApiConstants.verifyEmail,
      data: {'email': email, 'verificationCode': verificationCode},
    );

    _validateStatusCode(response, [200, 204]);
  }

  @override
  Future<void> logout() async {
    try {
      final response = await dio.post(ApiConstants.logout);
      _validateStatusCode(response, [200, 204]);
    } finally {
      await tokenManager.clearAll();
    }
  }
}
