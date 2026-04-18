import '../../../features/auth/data/models/auth_responses.dart';
import 'mock_base_service.dart';

class MockAuthService extends MockBaseService {
  /// -------------------------------
  /// LOGIN
  /// -------------------------------
  Future<LoginResponse> login(String usernameOrEmail, String password) async {
    await delay();

    try {
      final data = await loadJson('auth_responses.json');

      // تحويل users إلى List<Map<String, dynamic>>
      final users = (data['users'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList();

      if (users == null || users.isEmpty) {
        return LoginResponse(
          success: false,
          error: 'لا توجد بيانات مستخدمين',
          errorCode: 500,
        );
      }

      // البحث عن المستخدم
      final matchedUser = users.firstWhere(
            (user) =>
        (user['email'] == usernameOrEmail ||
            user['username'] == usernameOrEmail) &&
            user['password'] == password,
        orElse: () => {},
      );

      if (matchedUser.isEmpty) {
        return LoginResponse(
          success: false,
          error: 'بيانات الدخول غير صحيحة',
          errorCode: 401,
        );
      }

      // بناء UserResponse
      final userResponse = UserResponse(
        id: matchedUser['id'] as int,
        email: matchedUser['email'] as String,
        userName: matchedUser['username'] as String,
        phone: matchedUser['phone'] as String,
        roleId: matchedUser['roleId'] as int,
      );

      final loginData = LoginResponseData(
        user: userResponse,
        token: matchedUser['token'] as String,
        expiresAt: DateTime.now()
            .add(const Duration(hours: 24))
            .toIso8601String(),
      );

      return LoginResponse(success: true, data: loginData);
    } catch (e) {
      logger.e('Login mock failed: $e');
      return LoginResponse(
        success: false,
        error: 'خطأ في محاكاة تسجيل الدخول',
        errorCode: 500,
      );
    }
  }

  /// -------------------------------
  /// SIGNUP
  /// -------------------------------
  Future<SignupResponse> signup({
    required String username,
    required String email,
    required String password,
    required String phone,
  }) async {
    await delay();

    try {
      final data = await loadJson('auth_responses.json');

      final users = (data['users'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList();

      // التحقق من وجود المستخدم مسبقاً
      if (users != null) {
        final exists = users.any((user) =>
        user['email'] == email || user['username'] == username);

        if (exists) {
          return SignupResponse(
            success: false,
            error: 'البريد الإلكتروني أو اسم المستخدم موجود مسبقاً',
            errorCode: 409,
          );
        }
      }

      // إنشاء مستخدم جديد
      final newUser = <String, dynamic>{
        'id': (users?.length ?? 0) + 1,
        'username': username,
        'email': email,
        'phone': phone,
        'password': password,
        'roleId': 4,
        'token': _generateToken(),
      };

      final userResponse = UserResponse(
        id: newUser['id'] as int,
        email: newUser['email'] as String,
        userName: newUser['username'] as String,
        phone: newUser['phone'] as String,
        roleId: newUser['roleId'] as int,
      );

      final signupData = SignupResponseData(
        user: userResponse,
        token: newUser['token'] as String,
        expiresAt: DateTime.now()
            .add(const Duration(hours: 24))
            .toIso8601String(),
      );

      return SignupResponse(success: true, data: signupData);
    } catch (e) {
      logger.e('Signup mock failed: $e');
      return SignupResponse(
        success: false,
        error: 'خطأ في محاكاة التسجيل',
        errorCode: 500,
      );
    }
  }

  /// -------------------------------
  /// LOGOUT
  /// -------------------------------
  Future<LogoutResponse> logout() async {
    await delay(200, 500);

    return LogoutResponse(
      success: true,
      message: 'تم تسجيل الخروج بنجاح',
    );
  }


  /// -------------------------------
  /// FORGOT PASSWORD
  /// -------------------------------
  Future<ForgotPasswordResponse> forgotPassword(String email) async {
    await delay();

    try {
      final data = await loadJson('auth_responses.json');

      final users = (data['users'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList();

      final exists = users?.any((u) => u['email'] == email) ?? false;

      if (!exists) {
        return ForgotPasswordResponse(
          success: false,
          error: 'البريد الإلكتروني غير مسجل',
          errorCode: 404,
        );
      }

      return ForgotPasswordResponse(
        success: true,
        message: 'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني',
      );
    } catch (e) {
      logger.e('Forgot password mock failed: $e');
      return ForgotPasswordResponse(
        success: false,
        error: 'خطأ في محاكاة إعادة تعيين كلمة المرور',
        errorCode: 500,
      );
    }
  }

  /// -------------------------------
  /// TOKEN GENERATOR
  /// -------------------------------
  String _generateToken() {
    final ts = DateTime.now().millisecondsSinceEpoch;
    return 'mock_token_$ts';
  }
}
