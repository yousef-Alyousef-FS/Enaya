import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/forgot_password_entity.dart';

part 'auth_responses.freezed.dart';
part 'auth_responses.g.dart';

@freezed
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    required bool success,
    LoginResponseData? data,
    String? error,
    int? errorCode,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

@freezed
class LoginResponseData with _$LoginResponseData {
  const factory LoginResponseData({
    required UserResponse user,
    required String token,
    required String expiresAt,
  }) = _LoginResponseData;

  factory LoginResponseData.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseDataFromJson(json);
}

@freezed
class SignupResponse with _$SignupResponse {
  const factory SignupResponse({
    required bool success,
    SignupResponseData? data,
    String? error,
    int? errorCode,
  }) = _SignupResponse;

  factory SignupResponse.fromJson(Map<String, dynamic> json) =>
      _$SignupResponseFromJson(json);
}

@freezed
class SignupResponseData with _$SignupResponseData {
  const factory SignupResponseData({
    required UserResponse user,
    required String token,
    required String expiresAt,
  }) = _SignupResponseData;

  factory SignupResponseData.fromJson(Map<String, dynamic> json) =>
      _$SignupResponseDataFromJson(json);
}

@freezed
class UserResponse with _$UserResponse {
  const factory UserResponse({
    required int id,
    required String email,
    required String userName,
    required String phone,
    required int roleId,
  }) = _UserResponse;

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);
}

@freezed
class LogoutResponse with _$LogoutResponse {
  const factory LogoutResponse({
    required bool success,
    String? message,
    String? error,
    int? errorCode,
  }) = _LogoutResponse;

  factory LogoutResponse.fromJson(Map<String, dynamic> json) =>
      _$LogoutResponseFromJson(json);
}

@freezed
class ForgotPasswordResponse with _$ForgotPasswordResponse {
  const factory ForgotPasswordResponse({
    required bool success,
    String? message,
    String? error,
    int? errorCode,
  }) = _ForgotPasswordResponse;

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordResponseFromJson(json);
}

extension ForgotPasswordResponseMapper on ForgotPasswordResponse {
  ForgotPasswordEntity toEntity() {
    return ForgotPasswordEntity(
      success: success,
      message: message ?? error ?? "Unknown error occurred",
    );
  }
}

@freezed
class RefreshTokenResponse with _$RefreshTokenResponse {
  const factory RefreshTokenResponse({
    required bool success,
    String? token,
    String? expiresAt,
    String? error,
    int? errorCode,
  }) = _RefreshTokenResponse;

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenResponseFromJson(json);
}
