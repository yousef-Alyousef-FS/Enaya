import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

import '../../../../core/services/token_manager.dart';
import '../models/user_model.dart';
import 'auth_remote_data_source.dart';

class AuthMockDataSourceImpl implements AuthRemoteDataSource {
  final TokenManager tokenManager;
  List<Map<String, dynamic>>? _usersCache;
  final Map<String, String> _resetCodesByEmail = <String, String>{};
  final Map<String, String> _verificationCodesByEmail = <String, String>{};

  AuthMockDataSourceImpl({required this.tokenManager});

  Future<List<Map<String, dynamic>>> _loadUsers() async {
    if (_usersCache != null) {
      return _usersCache!;
    }

    final jsonString = await rootBundle.loadString('assets/mock_data/auth_responses.json');
    final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
    final users = decoded['users'];

    if (users is! List) {
      throw const FormatException('Invalid mock auth users format');
    }

    _usersCache = users.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
    return _usersCache!;
  }

  DioException _badResponse({required int statusCode, required String message}) {
    return DioException(
      requestOptions: RequestOptions(path: '/auth/mock'),
      response: Response(
        requestOptions: RequestOptions(path: '/auth/mock'),
        statusCode: statusCode,
        data: {'message': message},
      ),
      type: DioExceptionType.badResponse,
    );
  }

  Future<void> _persistAuthSession({required UserModel user, required String token}) async {
    await tokenManager.saveToken(token);
    await tokenManager.saveTokenExpiry(DateTime.now().add(const Duration(hours: 24)));
    await tokenManager.saveUserData(user.toJson());
  }

  @override
  Future<UserModel> login({required String usernameOrEmail, required String password}) async {
    final users = await _loadUsers();

    final matched = users.cast<Map<String, dynamic>?>().firstWhere((user) {
      if (user == null) return false;
      final email = user['email']?.toString();
      final username = user['username']?.toString();
      final userPassword = user['password']?.toString();
      return (email == usernameOrEmail || username == usernameOrEmail) && userPassword == password;
    }, orElse: () => null);

    if (matched == null) {
      throw _badResponse(statusCode: 401, message: 'بيانات الدخول غير صحيحة');
    }

    final user = UserModel.fromJson(matched);
    final token =
        matched['token']?.toString() ?? 'mock_token_${DateTime.now().millisecondsSinceEpoch}';

    await _persistAuthSession(user: user, token: token);
    return user;
  }

  @override
  Future<UserModel> signup({
    required String email,
    required String password,
    required String username,
    required String phone,
  }) async {
    final users = await _loadUsers();

    final exists = users.any(
      (user) =>
          user['email']?.toString().toLowerCase() == email.toLowerCase() ||
          user['username']?.toString().toLowerCase() == username.toLowerCase(),
    );

    if (exists) {
      throw _badResponse(statusCode: 409, message: 'البريد الإلكتروني أو اسم المستخدم موجود مسبقا');
    }

    final maxId = users
        .map((user) => user['id'])
        .whereType<int>()
        .fold<int>(0, (previous, current) => current > previous ? current : previous);

    final generatedToken = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';

    final user = UserModel(
      id: maxId + 1,
      email: email,
      userName: username,
      phone: phone,
      roleId: 3,
    );
    users.add({...user.toJson(), 'password': password, 'token': generatedToken});

    await _persistAuthSession(user: user, token: generatedToken);

    return user;
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    final users = await _loadUsers();
    final exists = users.any(
      (user) => user['email']?.toString().toLowerCase() == email.toLowerCase(),
    );

    if (!exists) {
      throw _badResponse(statusCode: 404, message: 'البريد الإلكتروني غير مسجل');
    }

    _resetCodesByEmail[email.toLowerCase()] = '123456';
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String verificationCode,
    required String newPassword,
  }) async {
    final users = await _loadUsers();
    final emailKey = email.toLowerCase();
    final expectedCode = _resetCodesByEmail[emailKey];

    if (expectedCode == null) {
      throw _badResponse(statusCode: 400, message: 'يرجى طلب إعادة تعيين كلمة المرور أولا');
    }

    if (expectedCode != verificationCode) {
      throw _badResponse(statusCode: 422, message: 'رمز التحقق غير صحيح');
    }

    final index = users.indexWhere((u) => u['email']?.toString().toLowerCase() == emailKey);
    if (index == -1) {
      throw _badResponse(statusCode: 404, message: 'البريد الإلكتروني غير مسجل');
    }

    users[index]['password'] = newPassword;
    _resetCodesByEmail.remove(emailKey);
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final users = await _loadUsers();
    final currentUser = tokenManager.getUserData();
    final email = currentUser?['email']?.toString();

    if (email == null || email.isEmpty) {
      throw _badResponse(statusCode: 401, message: 'المستخدم غير مسجل الدخول');
    }

    final index = users.indexWhere(
      (u) => u['email']?.toString().toLowerCase() == email.toLowerCase(),
    );
    if (index == -1) {
      throw _badResponse(statusCode: 404, message: 'المستخدم غير موجود');
    }

    final savedPassword = users[index]['password']?.toString();
    if (savedPassword != currentPassword) {
      throw _badResponse(statusCode: 422, message: 'كلمة المرور الحالية غير صحيحة');
    }

    users[index]['password'] = newPassword;
  }

  @override
  Future<void> sendEmailVerification({required String email}) async {
    final users = await _loadUsers();
    final exists = users.any(
      (user) => user['email']?.toString().toLowerCase() == email.toLowerCase(),
    );

    if (!exists) {
      throw _badResponse(statusCode: 404, message: 'البريد الإلكتروني غير مسجل');
    }

    _verificationCodesByEmail[email.toLowerCase()] = '654321';
  }

  @override
  Future<void> verifyEmail({required String email, required String verificationCode}) async {
    final emailKey = email.toLowerCase();
    final expectedCode = _verificationCodesByEmail[emailKey];

    if (expectedCode == null) {
      throw _badResponse(statusCode: 400, message: 'يرجى طلب رمز التحقق أولا');
    }

    if (expectedCode != verificationCode) {
      throw _badResponse(statusCode: 422, message: 'رمز التحقق غير صحيح');
    }

    _verificationCodesByEmail.remove(emailKey);
  }

  @override
  Future<void> logout() async {
    await tokenManager.clearAll();
  }
}
