import 'package:equatable/equatable.dart';
import '../../domain/entities/forgot_password_entity.dart';

class LoginResponse extends Equatable {
  const LoginResponse({
    required this.success,
    this.data,
    this.error,
    this.errorCode,
  });

  final bool success;
  final LoginResponseData? data;
  final String? error;
  final int? errorCode;

  @override
  List<Object?> get props => [success, data, error, errorCode];

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] as bool,
      data: json['data'] != null
          ? LoginResponseData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      error: json['error'] as String?,
      errorCode: json['errorCode'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
      'error': error,
      'errorCode': errorCode,
    };
  }
}

class LoginResponseData extends Equatable {
  const LoginResponseData({
    required this.user,
    required this.token,
    required this.expiresAt,
  });

  final UserResponse user;
  final String token;
  final String expiresAt;

  @override
  List<Object?> get props => [user, token, expiresAt];

  factory LoginResponseData.fromJson(Map<String, dynamic> json) {
    return LoginResponseData(
      user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String,
      expiresAt: json['expiresAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'user': user.toJson(), 'token': token, 'expiresAt': expiresAt};
  }
}

class SignupResponse extends Equatable {
  const SignupResponse({
    required this.success,
    this.data,
    this.error,
    this.errorCode,
  });

  final bool success;
  final SignupResponseData? data;
  final String? error;
  final int? errorCode;

  @override
  List<Object?> get props => [success, data, error, errorCode];

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      success: json['success'] as bool,
      data: json['data'] != null
          ? SignupResponseData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      error: json['error'] as String?,
      errorCode: json['errorCode'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
      'error': error,
      'errorCode': errorCode,
    };
  }
}

class SignupResponseData extends Equatable {
  const SignupResponseData({
    required this.user,
    required this.token,
    required this.expiresAt,
  });

  final UserResponse user;
  final String token;
  final String expiresAt;

  @override
  List<Object?> get props => [user, token, expiresAt];

  factory SignupResponseData.fromJson(Map<String, dynamic> json) {
    return SignupResponseData(
      user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String,
      expiresAt: json['expiresAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'user': user.toJson(), 'token': token, 'expiresAt': expiresAt};
  }
}

class UserResponse extends Equatable {
  const UserResponse({
    required this.id,
    required this.email,
    required this.userName,
    required this.phone,
    required this.roleId,
  });

  final int id;
  final String email;
  final String userName;
  final String phone;
  final int roleId;

  @override
  List<Object?> get props => [id, email, userName, phone, roleId];

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'] as int,
      email: json['email'] as String,
      userName: json['userName'] as String,
      phone: json['phone'] as String,
      roleId: json['roleId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'userName': userName,
      'phone': phone,
      'roleId': roleId,
    };
  }
}

class LogoutResponse extends Equatable {
  const LogoutResponse({
    required this.success,
    this.message,
    this.error,
    this.errorCode,
  });

  final bool success;
  final String? message;
  final String? error;
  final int? errorCode;

  @override
  List<Object?> get props => [success, message, error, errorCode];

  factory LogoutResponse.fromJson(Map<String, dynamic> json) {
    return LogoutResponse(
      success: json['success'] as bool,
      message: json['message'] as String?,
      error: json['error'] as String?,
      errorCode: json['errorCode'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'error': error,
      'errorCode': errorCode,
    };
  }
}

class ForgotPasswordResponse extends Equatable {
  const ForgotPasswordResponse({
    required this.success,
    this.message,
    this.error,
    this.errorCode,
  });

  final bool success;
  final String? message;
  final String? error;
  final int? errorCode;

  @override
  List<Object?> get props => [success, message, error, errorCode];

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponse(
      success: json['success'] as bool,
      message: json['message'] as String?,
      error: json['error'] as String?,
      errorCode: json['errorCode'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'error': error,
      'errorCode': errorCode,
    };
  }
}

extension ForgotPasswordResponseMapper on ForgotPasswordResponse {
  ForgotPasswordEntity toEntity() {
    return ForgotPasswordEntity(
      success: success,
      message: message ?? error ?? "Unknown error occurred",
    );
  }
}

class RefreshTokenResponse extends Equatable {
  const RefreshTokenResponse({
    required this.success,
    this.token,
    this.expiresAt,
    this.error,
    this.errorCode,
  });

  final bool success;
  final String? token;
  final String? expiresAt;
  final String? error;
  final int? errorCode;

  @override
  List<Object?> get props => [success, token, expiresAt, error, errorCode];

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponse(
      success: json['success'] as bool,
      token: json['token'] as String?,
      expiresAt: json['expiresAt'] as String?,
      error: json['error'] as String?,
      errorCode: json['errorCode'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'token': token,
      'expiresAt': expiresAt,
      'error': error,
      'errorCode': errorCode,
    };
  }
}
