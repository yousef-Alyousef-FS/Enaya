import 'package:logger/logger.dart';

import '../../../../core/network/base_response.dart';
import '../../../../core/services/mock_data_service.dart';
import '../../../../core/services/token_manager.dart';
import '../models/auth_responses.dart';
import 'auth_remote_data_source.dart';

class AuthMockDataSourceImpl implements AuthRemoteDataSource {
  final MockDataService mockDataService;
  final TokenManager tokenManager;
  final Logger _logger = Logger();

  AuthMockDataSourceImpl({
    required this.mockDataService,
    required this.tokenManager,
  });

  // ---------------------------------------------------------------------------
  // 🔥 Helper: Execute mock request with unified logging + error handling
  // ---------------------------------------------------------------------------
  Future<T> _execute<T>({
    required String actionName,
    required Future<T> Function() request,
    void Function(T response)? onSuccess,
    void Function(T response)? onFailure,
  }) async {
    try {
      _logger.i('🚀 بدء عملية $actionName (Mock)');

      final response = await request();

      // Handle success/failure
      if (response is BaseResponse) {
        if (response.success) {
          _logger.i('✅ نجاح عملية $actionName');
          onSuccess?.call(response);
        } else {
          _logger.e('❌ فشل عملية $actionName: ${response.error}');
          onFailure?.call(response);
        }
      }

      return response;
    } catch (e, stack) {
      _logger.e('💥 خطأ أثناء $actionName: $e', stackTrace: stack);
      throw Exception('فشل $actionName: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // 🔐 Login
  // ---------------------------------------------------------------------------
  @override
  Future<LoginResponse> login({
    required String usernameOrEmail,
    required String password,
  }) async {
    return _execute<LoginResponse>(
      actionName: 'تسجيل الدخول',
      request: () => mockDataService.auth.login(usernameOrEmail, password),
      onSuccess: (response) async {
        final token = response.data?.token ?? '';
        if (token.isNotEmpty) {
          await tokenManager.saveToken(token);
          _logger.i('🔑 تم حفظ التوكن بنجاح');
        }
        _logger.i('👤 المستخدم: ${response.data?.user.userName}');
      },
    );
  }

  // ---------------------------------------------------------------------------
  // 📝 Signup
  // ---------------------------------------------------------------------------
  @override
  Future<SignupResponse> signup({
    required String userName,
    required String email,
    required String password,
    required String phone,
  }) async {
    return _execute<SignupResponse>(
      actionName: 'التسجيل',
      request: () => mockDataService.auth.signup(
        username: userName,
        email: email,
        password: password,
        phone: phone,
      ),
      onSuccess: (response) async {
        final token = response.data?.token ?? '';
        if (token.isNotEmpty) {
          await tokenManager.saveToken(token);
          _logger.i('🔑 تم حفظ التوكن بنجاح');
        }
        _logger.i('👤 المستخدم: ${response.data?.user.userName}');
      },
    );
  }

  // ---------------------------------------------------------------------------
  // 🚪 Logout
  // ---------------------------------------------------------------------------
  @override
  Future<void> logout() async {
    await _execute<BaseResponse>(
      actionName: 'تسجيل الخروج',
      request: () => mockDataService.auth.logout(),
      onSuccess: (_) async {
        await tokenManager.clearAll();
        _logger.i('🧹 تم مسح التوكن والبيانات بنجاح');
      },
    );
  }

  // ---------------------------------------------------------------------------
  // 🔑 Forgot Password
  // ---------------------------------------------------------------------------
  @override
  Future<ForgotPasswordResponse> forgotPassword({
    required String email,
  }) async {
    return _execute<ForgotPasswordResponse>(
      actionName: 'إعادة تعيين كلمة المرور',
      request: () => mockDataService.auth.forgotPassword( email),
      onSuccess: (_) {
        _logger.i('📩 تم إرسال رابط إعادة التعيين');
      },
    );
  }
}

