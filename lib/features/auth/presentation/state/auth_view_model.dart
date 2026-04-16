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
  }) : _loginUseCase = loginUseCase,
       _signupUseCase = signupUseCase,
       _forgotPasswordUseCase = forgotPasswordUseCase,
       _logoutUseCase = logoutUseCase;

  User? get currentUser => _currentUser;

  Future<void> forgotPassword(String email) async {
    setState(ViewState.loading);
    final result = await _forgotPasswordUseCase(email);

    result.fold((failure) => setError(failure.message), (response) {
      if (response.success) {
        setState(ViewState.success);
      } else {
        setError(response.message);
      }
    });
  }

  Future<void> login(String usernameOrEmail, String password) async {
    setState(ViewState.loading);
    final result = await _loginUseCase(
      LoginParams(usernameOrEmail: usernameOrEmail, password: password),
    );

    result.fold((failure) => setError(failure.message), (user) {
      _currentUser = user;
      setState(ViewState.success);
    });
  }

  Future<void> signup(
    String email,
    String password,
    String username,
    String phone,
  ) async {
    setState(ViewState.loading);
    final result = await _signupUseCase(
      SignupParams(
        email: email,
        password: password,
        username: username,
        phone: phone,
      ),
    );

    result.fold((failure) => setError(failure.message), (user) {
      _currentUser = user;
      setState(ViewState.success);
    });
  }

  Future<void> logout() async {
    setState(ViewState.loading);
    final result = await _logoutUseCase(NoParams());

    result.fold((failure) => setError(failure.message), (_) {
      _currentUser = null;
      setState(ViewState.success);
    });
  }
}
