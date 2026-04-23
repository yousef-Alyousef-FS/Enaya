# Auth API Documentation (Final Client)

## Overview

This document describes the real auth client APIs implemented by the Flutter app.

Main implementation:

- [Auth remote datasource](lib/features/auth/data/datasources/auth_remote_data_source.dart)
- [DI wiring](lib/core/di/injection.dart)
- [API constants](lib/core/constants/api_constants.dart)

## Base URL

Configured in:

- [ApiConstants.baseUrl](lib/core/constants/api_constants.dart)

Current value:

- `https://your-api-url.com/api/`

## Authentication Headers

Automatically attached by Dio interceptor:

- `Content-Type: application/json`
- `Accept: application/json`
- `language: <device-locale>`
- `Authorization: Bearer <token>` when token exists

Reference:

- [Dio factory](lib/core/network/dio_factory.dart)

## Core Response Contracts

### 1) Login / Signup Success Contract

The client supports both response shapes:

Shape A (preferred):

```json
{
  "data": {
    "user": {
      "id": 1,
      "email": "user@example.com",
      "username": "user1",
      "phone": "+966500000000",
      "roleId": 3
    },
    "token": "access_token_value",
    "refresh_token": "refresh_token_value",
    "expires_at": "2026-12-31T23:59:59Z"
  }
}
```

Shape B (accepted fallback):

```json
{
  "user": {
    "id": 1,
    "email": "user@example.com",
    "username": "user1",
    "phone": "+966500000000",
    "roleId": 3
  },
  "token": "access_token_value",
  "refresh_token": "refresh_token_value",
  "expires_at": "2026-12-31T23:59:59Z"
}
```

Required for app login session:

- `token` is required
- `user` object is required (or user fields directly)

Persisted locally on success:

- access token
- refresh token (if provided)
- token expiry (`expires_at` / `expiresAt`, fallback: `now + 24h`)
- normalized user object

### 2) Error Contract

Preferred error response body:

```json
{
  "message": "Readable error message"
}
```

Also supported by app error handler:

- `error`
- `errors` map (validation errors)

Reference:

- [API error handler](lib/core/network/api_error_handler.dart)

---

## Endpoints

## 1) Login

- Method: `POST`
- Path: `auth/login`
- Constant: `ApiConstants.login`

Request body:

```json
{
  "usernameOrEmail": "doctor@enaya.com",
  "password": "doctor123"
}
```

Expected success codes:

- `200`

Success body:

- Must follow one of the login/signup contracts above.

---

## 2) Signup

- Method: `POST`
- Path: `auth/signup`
- Constant: `ApiConstants.signup`

Request body:

```json
{
  "email": "new.user@enaya.com",
  "password": "12345678",
  "username": "newuser",
  "phone": "+966500000000"
}
```

Expected success codes:

- `200`
- `201`

Success body:

- Must follow one of the login/signup contracts above.

---

## 3) Forgot Password

- Method: `POST`
- Path: `auth/forgot-password`
- Constant: `ApiConstants.forgotPassword`

Request body:

```json
{
  "email": "user@example.com"
}
```

Expected success codes:

- `200`
- `202`
- `204`

Success body:

- ignored by client

---

## 4) Reset Password

- Method: `POST`
- Path: `auth/reset-password`
- Constant: `ApiConstants.resetPassword`

Request body:

```json
{
  "email": "user@example.com",
  "verificationCode": "123456",
  "newPassword": "newStrongPassword123"
}
```

Expected success codes:

- `200`
- `204`

Success body:

- ignored by client

---

## 5) Change Password

- Method: `POST`
- Path: `auth/change-password`
- Constant: `ApiConstants.changePassword`

Request body:

```json
{
  "currentPassword": "oldPassword123",
  "newPassword": "newPassword123"
}
```

Expected success codes:

- `200`
- `204`

Success body:

- ignored by client

---

## 6) Send Email Verification

- Method: `POST`
- Path: `auth/send-email-verification`
- Constant: `ApiConstants.sendEmailVerification`

Request body:

```json
{
  "email": "user@example.com"
}
```

Expected success codes:

- `200`
- `202`
- `204`

Success body:

- ignored by client

---

## 7) Verify Email

- Method: `POST`
- Path: `auth/verify-email`
- Constant: `ApiConstants.verifyEmail`

Request body:

```json
{
  "email": "user@example.com",
  "verificationCode": "654321"
}
```

Expected success codes:

- `200`
- `204`

Success body:

- ignored by client

---

## 8) Logout

- Method: `POST`
- Path: `auth/logout`
- Constant: `ApiConstants.logout`

Request body:

```json
{}
```

Expected success codes:

- `200`
- `204`

Client behavior:

- always clears local auth session (token, refresh token, user data, expiry)

---

## 9) Refresh Token (Interceptor Flow)

- Method: `POST`
- Path: `auth/refresh`
- Constant: `ApiConstants.refreshToken`
- Trigger: automatic on `401` from protected endpoints

Request body:

```json
{
  "refresh_token": "refresh_token_value"
}
```

Expected success body:

```json
{
  "token": "new_access_token",
  "refresh_token": "new_refresh_token"
}
```

On failure:

- client clears local auth session
