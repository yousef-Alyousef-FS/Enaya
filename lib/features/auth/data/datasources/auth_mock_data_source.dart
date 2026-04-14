import 'package:logger/logger.dart';

import '../../../../core/services/mock_data_service.dart';
import '../../../../core/services/token_manager.dart';
import '../models/user_model.dart';
import 'auth_remote_data_source.dart';

class AuthMockDataSourceImpl implements AuthRemoteDataSource {
  final MockDataService mockDataService;
  final TokenManager tokenManager;
  final Logger _logger = Logger();

  AuthMockDataSourceImpl({
    required this.mockDataService,
    required this.tokenManager,
  });

  @override
  Future<UserModel> login({
    required String usernameOrEmail,
    required String password,
  }) async {
    try {
      _logger.i('🔐 بدء عملية تسجيل الدخول: $usernameOrEmail');

      final response = await mockDataService.mockLogin(
        usernameOrEmail: usernameOrEmail,
        password: password,
      );

      if (response['success'] == true) {
        final user = response['user'] as Map<String, dynamic>;
        final token = response['token'] as String?;

        if (token != null) {
          // حفظ التوكن بشكل آمن
          await tokenManager.saveToken(token);
          _logger.i('✅ تم حفظ التوكن بنجاح');
        }

        final userModel = UserModel(
          id: user['id'] as int,
          email: user['email'] as String,
          userName: user['userName'] as String,
          phone: user['phone'] as String,
          roleId: user['roleId'] as int,
        );

        _logger.i('✅ تم تسجيل الدخول بنجاح: ${userModel.userName}');
        return userModel;
      } else {
        final error = response['error'] as String? ?? 'خطأ في التحقق من البيانات';
        _logger.e('❌ فشل تسجيل الدخول: $error');
        throw Exception(error);
      }
    } catch (e) {
      _logger.e('❌ خطأ في عملية تسجيل الدخول: $e');
      throw Exception('فشل تسجيل الدخول: $e');
    }
  }

  @override
  Future<UserModel> signup({
    required String userName,
    required String email,
    required String password,
    required String phone
  }) async {
    try {
      _logger.i('📝 بدء عملية التسجيل: $email');

      final response = await mockDataService.mockSignup(
        username: userName,
        email: email,
        password: password,
        phone: '', // يمكن إضافة هذا كمعامل لاحقاً
      );

      if (response['success'] == true) {
        final user = response['user'] as Map<String, dynamic>;
        final token = response['token'] as String?;

        if (token != null) {
          // حفظ التوكن للمستخدم الجديد
          await tokenManager.saveToken(token);
          _logger.i('✅ تم حفظ التوكن بنجاح');
        }

        final userModel = UserModel(
          id: user['id'] as int,
          email: user['email'] as String,
          userName: user['userName'] as String,
          phone: user['phone'] as String? ?? '',
          roleId: user['roleId'] as int,
        );

        _logger.i('✅ تم التسجيل بنجاح: ${userModel.userName}');
        return userModel;
      } else {
        final error = response['error'] as String? ?? 'فشل التسجيل';
        _logger.e('❌ فشل التسجيل: $error');
        throw Exception(error);
      }
    } catch (e) {
      _logger.e('❌ خطأ في عملية التسجيل: $e');
      throw Exception('فشل التسجيل: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      _logger.i('🚪 بدء عملية تسجيل الخروج');

      await mockDataService.mockLogout();

      // حذف جميع بيانات المستخدم والتوكن
      await tokenManager.clearAll();

      _logger.i('✅ تم تسجيل الخروج بنجاح');
    } catch (e) {
      _logger.e('❌ خطأ في عملية تسجيل الخروج: $e');
      throw Exception('فشل تسجيل الخروج: $e');
    }
  }
}
