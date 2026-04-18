import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/view_models/base_view_model.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';

class AuthViewModel extends BaseViewModel {
  final LoginUseCase _loginUseCase;
  final SignupUsecase _signupUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final LogoutUseCase _logoutUseCase;

  User? _currentUser;

  AuthViewModel({
        required LoginUseCase loginUseCase,
        required SignupUsecase signupUseCase,
        required ForgotPasswordUseCase forgotPasswordUseCase,
        required LogoutUseCase logoutUseCase,
  })  : _loginUseCase = loginUseCase,
        _signupUseCase = signupUseCase,
        _forgotPasswordUseCase = forgotPasswordUseCase,
        _logoutUseCase = logoutUseCase;


  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  // ---------------------------------------------------------------------------
  // 🔥 Helper: توحيد التعامل مع النتائج
  // ---------------------------------------------------------------------------
  Future<void> _handleResult<T>(
      Future<Either<Failure, T>> call, {
        required Function(T data) onSuccess,
      }) async
  {
    setState(ViewState.loading);

    final result = await call;

    result.fold(
          (failure) => setError(failure.message),
          (data) {
        onSuccess(data);
        setState(ViewState.success);
      },
    );
  }

  // ---------------------------------------------------------------------------
  // 🔐 Login
  // ---------------------------------------------------------------------------
  Future<void> login(String usernameOrEmail, String password) async {
    await _handleResult<User>(
      _loginUseCase(
        LoginParams(usernameOrEmail: usernameOrEmail, password: password),
      ),
      onSuccess: (user) => _currentUser = user,
    );
  }

  // ---------------------------------------------------------------------------
  // 📝 Signup
  // ---------------------------------------------------------------------------
  Future<void> signup(
      String email,
      String password,
      String username,
      String phone,
      ) async
  {
    await _handleResult<User>(
      _signupUseCase(
        SignupParams(
          email: email,
          password: password,
          username: username,
          phone: phone,
        ),
      ),
      onSuccess: (user) => _currentUser = user,
    );
  }

  // ---------------------------------------------------------------------------
  // 🔑 Forgot Password
  // ---------------------------------------------------------------------------
  Future<void> forgotPassword(String email) async {
    await _handleResult<void>(
      _forgotPasswordUseCase(email),
      onSuccess: (_) {},
    );
  }

  // ---------------------------------------------------------------------------
  // 🚪 Logout
  // ---------------------------------------------------------------------------
  Future<void> logout() async {
    await _handleResult<void>(
      _logoutUseCase(NoParams()),
      onSuccess: (_) => _currentUser = null,
    );
  }

  // ---------------------------------------------------------------------------
  // 🧹 Reset user manually (optional)
  // ---------------------------------------------------------------------------
  void resetUser() {
    _currentUser = null;
    notifyListeners();
  }
}
