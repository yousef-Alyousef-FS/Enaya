import 'package:logger/logger.dart';

import '../../../../core/services/mock_data_service.dart';
import '../../../../core/services/token_manager.dart';
import '../models/auth_responses.dart';
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

      if (response.success && response.data != null) {
        final userData = response.data!.user;
        final token = response.data!.token;

        if (token.isNotEmpty) {
          // حفظ التوكن بشكل آمن
          await tokenManager.saveToken(token);
          _logger.i('✅ تم حفظ التوكن بنجاح');
        }

        final userModel = UserModel(
          id: userData.id,
          email: userData.email,
          userName: userData.userName,
          phone: userData.phone,
          roleId: userData.roleId,
        );

        _logger.i('✅ تم تسجيل الدخول بنجاح: ${userModel.userName}');
        return userModel;
      } else {
        final error = response.error ?? 'خطأ في التحقق من البيانات';
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
    required String phone,
  }) async {
    try {
      _logger.i('📝 بدء عملية التسجيل: $email');

      final response = await mockDataService.mockSignup(
        username: userName,
        email: email,
        password: password,
        phone: phone,
      );

      if (response.success && response.data != null) {
        final userData = response.data!.user;
        final token = response.data!.token;

        if (token.isNotEmpty) {
          // حفظ التوكن للمستخدم الجديد
          await tokenManager.saveToken(token);
          _logger.i('✅ تم حفظ التوكن بنجاح');
        }

        final userModel = UserModel(
          id: userData.id,
          email: userData.email,
          userName: userData.userName,
          phone: userData.phone,
          roleId: userData.roleId,
        );

        _logger.i('✅ تم التسجيل بنجاح: ${userModel.userName}');
        return userModel;
      } else {
        final error = response.error ?? 'فشل التسجيل';
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

      final response = await mockDataService.mockLogout();

      if (response.success) {
        // حذف جميع بيانات المستخدم والتوكن
        await tokenManager.clearAll();
        _logger.i('✅ تم تسجيل الخروج بنجاح');
      } else {
        throw Exception(response.error ?? 'فشل تسجيل الخروج');
      }
    } catch (e) {
      _logger.e('❌ خطأ في عملية تسجيل الخروج: $e');
      throw Exception('فشل تسجيل الخروج: $e');
    }
  }

  @override
  Future<ForgotPasswordResponse> forgotPassword({required String email}) async {
    try {
      _logger.i('🔑 بدء عملية إعادة تعيين كلمة المرور: $email');
      final response = await mockDataService.mockForgotPassword(email: email);
      if (!response.success) {
        _logger.e('❌ خطأ في إعادة التعيين: ${response.error}');
      } else {
        _logger.i('✅ طلب إعادة التعيين ناجح');
      }
      return response;
    } catch (e) {
      _logger.e('❌ خطأ في عملية إعادة التعيين: $e');
      return ForgotPasswordResponse(
        success: false,
        error: 'فشل إعادة تعيين كلمة المرور: $e',
        errorCode: 500,
      );
    }
  }
}
