import 'package:equatable/equatable.dart';

class LoginRequest extends Equatable {
  const LoginRequest({required this.usernameOrEmail, required this.password});

  final String usernameOrEmail;
  final String password;

  @override
  List<Object?> get props => [usernameOrEmail, password];

  factory LoginRequest.fromJson(Map<String, dynamic> json) {
    return LoginRequest(
      usernameOrEmail: json['usernameOrEmail'] as String,
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'usernameOrEmail': usernameOrEmail, 'password': password};
  }
}

class SignupRequest extends Equatable {
  const SignupRequest({
    required this.userName,
    required this.email,
    required this.password,
    required this.phone,
  });

  final String userName;
  final String email;
  final String password;
  final String phone;

  @override
  List<Object?> get props => [userName, email, password, phone];

  factory SignupRequest.fromJson(Map<String, dynamic> json) {
    return SignupRequest(
      userName: json['userName'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      phone: json['phone'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'email': email,
      'password': password,
      'phone': phone,
    };
  }
}

class ForgotPasswordRequest extends Equatable {
  const ForgotPasswordRequest({required this.email});

  final String email;

  @override
  List<Object?> get props => [email];

  factory ForgotPasswordRequest.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordRequest(email: json['email'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'email': email};
  }
}

class ResetPasswordRequest extends Equatable {
  const ResetPasswordRequest({
    required this.token,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });

  final String token;
  final String email;
  final String password;
  final String passwordConfirmation;

  @override
  List<Object?> get props => [token, email, password, passwordConfirmation];

  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) {
    return ResetPasswordRequest(
      token: json['token'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      passwordConfirmation: json['passwordConfirmation'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };
  }
}
