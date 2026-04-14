import '../../../../core/view_models/base_view_model.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';

class AuthViewModel extends BaseViewModel {
  final LoginUseCase _loginUseCase;
  final SignupUsecase _signupUseCase;

  User? _currentUser;

  AuthViewModel({
    required LoginUseCase loginUseCase,
    required SignupUsecase signupUseCase,
  }) : _loginUseCase = loginUseCase,
       _signupUseCase = signupUseCase;

  User? get currentUser => _currentUser;

  Future<void> login(String usernameOrEmail, String password) async {
    setState(ViewState.loading);
    final result = await _loginUseCase(
      usernameOrEmail: usernameOrEmail,
      password: password,
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
      email: email,
      password: password,
      username: username,
      phone: phone,
    );

    result.fold(
      (failure) => setError(failure.message),
      (user) => setState(ViewState.success),
    );
  }
}
