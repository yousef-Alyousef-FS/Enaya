// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginResponseImpl _$$LoginResponseImplFromJson(Map<String, dynamic> json) =>
    _$LoginResponseImpl(
      success: json['success'] as bool,
      data: json['data'] == null
          ? null
          : LoginResponseData.fromJson(json['data'] as Map<String, dynamic>),
      error: json['error'] as String?,
      errorCode: (json['errorCode'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$LoginResponseImplToJson(_$LoginResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'error': instance.error,
      'errorCode': instance.errorCode,
    };

_$LoginResponseDataImpl _$$LoginResponseDataImplFromJson(
  Map<String, dynamic> json,
) => _$LoginResponseDataImpl(
  user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
  token: json['token'] as String,
  expiresAt: json['expiresAt'] as String,
);

Map<String, dynamic> _$$LoginResponseDataImplToJson(
  _$LoginResponseDataImpl instance,
) => <String, dynamic>{
  'user': instance.user,
  'token': instance.token,
  'expiresAt': instance.expiresAt,
};

_$SignupResponseImpl _$$SignupResponseImplFromJson(Map<String, dynamic> json) =>
    _$SignupResponseImpl(
      success: json['success'] as bool,
      data: json['data'] == null
          ? null
          : SignupResponseData.fromJson(json['data'] as Map<String, dynamic>),
      error: json['error'] as String?,
      errorCode: (json['errorCode'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$SignupResponseImplToJson(
  _$SignupResponseImpl instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'error': instance.error,
  'errorCode': instance.errorCode,
};

_$SignupResponseDataImpl _$$SignupResponseDataImplFromJson(
  Map<String, dynamic> json,
) => _$SignupResponseDataImpl(
  user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
  token: json['token'] as String,
  expiresAt: json['expiresAt'] as String,
);

Map<String, dynamic> _$$SignupResponseDataImplToJson(
  _$SignupResponseDataImpl instance,
) => <String, dynamic>{
  'user': instance.user,
  'token': instance.token,
  'expiresAt': instance.expiresAt,
};

_$UserResponseImpl _$$UserResponseImplFromJson(Map<String, dynamic> json) =>
    _$UserResponseImpl(
      id: (json['id'] as num).toInt(),
      email: json['email'] as String,
      userName: json['userName'] as String,
      phone: json['phone'] as String,
      roleId: (json['roleId'] as num).toInt(),
    );

Map<String, dynamic> _$$UserResponseImplToJson(_$UserResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'userName': instance.userName,
      'phone': instance.phone,
      'roleId': instance.roleId,
    };

_$LogoutResponseImpl _$$LogoutResponseImplFromJson(Map<String, dynamic> json) =>
    _$LogoutResponseImpl(
      success: json['success'] as bool,
      message: json['message'] as String?,
      error: json['error'] as String?,
      errorCode: (json['errorCode'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$LogoutResponseImplToJson(
  _$LogoutResponseImpl instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'error': instance.error,
  'errorCode': instance.errorCode,
};

_$ForgotPasswordResponseImpl _$$ForgotPasswordResponseImplFromJson(
  Map<String, dynamic> json,
) => _$ForgotPasswordResponseImpl(
  success: json['success'] as bool,
  message: json['message'] as String?,
  error: json['error'] as String?,
  errorCode: (json['errorCode'] as num?)?.toInt(),
);

Map<String, dynamic> _$$ForgotPasswordResponseImplToJson(
  _$ForgotPasswordResponseImpl instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'error': instance.error,
  'errorCode': instance.errorCode,
};

_$RefreshTokenResponseImpl _$$RefreshTokenResponseImplFromJson(
  Map<String, dynamic> json,
) => _$RefreshTokenResponseImpl(
  success: json['success'] as bool,
  token: json['token'] as String?,
  expiresAt: json['expiresAt'] as String?,
  error: json['error'] as String?,
  errorCode: (json['errorCode'] as num?)?.toInt(),
);

Map<String, dynamic> _$$RefreshTokenResponseImplToJson(
  _$RefreshTokenResponseImpl instance,
) => <String, dynamic>{
  'success': instance.success,
  'token': instance.token,
  'expiresAt': instance.expiresAt,
  'error': instance.error,
  'errorCode': instance.errorCode,
};
