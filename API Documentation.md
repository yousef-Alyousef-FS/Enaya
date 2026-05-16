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

---

## Appointments API Documentation (Ready for Current Client)

## Overview

This section describes the appointments-related APIs that are ready to be used by the current Flutter client implementation.

Main implementation:

- [Appointment remote datasource](lib/features/appointments/data/datasources/appointment_remote_data_source.dart)
- [Doctor directory remote datasource](lib/features/appointments/data/datasources/doctor_directory_remote_data_source.dart)
- [Doctor availability remote datasource](lib/features/appointments/data/datasources/doctor_availability_remote_data_source.dart)
- [Appointment repository](lib/features/appointments/data/repositories/appointment_repository_impl.dart)
- [Availability repository](lib/features/appointments/data/repositories/doctor_availability_repository_impl.dart)

## Core Response Contract

The client expects standard API payloads to be wrapped in `data`:

```json
{
  "data": {}
}
```

For list responses:

```json
{
  "data": []
}
```

## Endpoints

## 1) Get Appointments

- Method: `GET`
- Path: `/appointments`
- Query params:
  - `date` (YYYY-MM-DD)
  - `end_date` (YYYY-MM-DD)
  - `doctor_id`
  - `patient_id`
  - `status`
  - `page`
  - `limit`
- Expected success code: `200`

Response shape:

```json
{
  "data": [
    {
      "id": "1",
      "patientId": "p1",
      "patientName": "Ahmed Ali",
      "patientPhone": "+966500000000",
      "doctorId": "d1",
      "doctorName": "Dr. Samir",
      "dateTime": "2026-05-16T09:00:00Z",
      "status": "scheduled",
      "reason": "Regular Checkup",
      "notes": "Optional notes",
      "queueNumber": 3,
      "cancelledBy": null,
      "cancellationReason": null
    }
  ]
}
```

## 2) Get Appointment By ID

- Method: `GET`
- Path: `/appointments/{appointmentId}`
- Expected success code: `200`

Response shape:

```json
{
  "data": {
    "id": "1",
    "patientId": "p1",
    "patientName": "Ahmed Ali",
    "patientPhone": "+966500000000",
    "doctorId": "d1",
    "doctorName": "Dr. Samir",
    "dateTime": "2026-05-16T09:00:00Z",
    "status": "scheduled",
    "reason": "Regular Checkup",
    "notes": "Optional notes",
    "queueNumber": 3,
    "cancelledBy": null,
    "cancellationReason": null
  }
}
```

## 3) Create Appointment

- Method: `POST`
- Path: `/appointments`
- Expected success codes: `200`, `201`

Request body:

```json
{
  "id": "temporary-or-server-generated",
  "patientId": "p1",
  "patientName": "Ahmed Ali",
  "patientPhone": "+966500000000",
  "doctorId": "d1",
  "doctorName": "Dr. Samir",
  "dateTime": "2026-05-16T09:00:00Z",
  "status": "scheduled",
  "reason": "Regular Checkup",
  "notes": "Optional notes",
  "queueNumber": 3,
  "cancelledBy": null,
  "cancellationReason": null
}
```

## 4) Update Appointment Status

- Method: `PUT`
- Path: `/appointments/{appointmentId}/status`
- Expected success code: `200`

Request body:

```json
{
  "status": "arrived",
  "reason": "Optional reason"
}
```

## 5) Cancel Appointment

- Method: `PUT`
- Path: `/appointments/{appointmentId}/cancel`
- Expected success code: `200`

Request body:

```json
{
  "cancelled_by": "doctor",
  "reason": "Patient requested cancellation"
}
```

## 6) Reschedule Appointment

- Method: `PUT`
- Path: `/appointments/{appointmentId}/reschedule`
- Expected success code: `200`

Request body:

```json
{
  "new_date_time": "2026-05-16T10:30:00Z"
}
```

## 7) Delete Appointment

- Method: `DELETE`
- Path: `/appointments/{appointmentId}`
- Expected success codes: `200`, `204`

## 8) Get Available Slots

- Method: `GET`
- Path: `/appointments/available-slots`
- Query params:
  - `doctor_id`
  - `date` (YYYY-MM-DD)
- Expected success code: `200`

Response shape:

```json
{
  "data": ["09:00", "09:30", "10:00", "10:30"]
}
```

## 9) Appointments Stats

- Method: `GET`
- Path: `/appointments/stats`
- Query params:
  - `date` (optional)
  - `doctor_id` (optional)
- Expected success code: `200`

Response shape:

```json
{
  "data": {
    "total_appointments": 20,
    "scheduled": 5,
    "confirmed": 4,
    "completed": 7,
    "cancelled": 2,
    "no_show": 1,
    "utilization_rate": 75.5,
    "completion_rate": 68.0,
    "by_doctor": [
      {
        "doctor_id": "d1",
        "doctor_name": "Dr. Samir",
        "total_appointments": 12,
        "completed": 8,
        "completion_rate": 66.7,
        "average_wait_time": 14.2
      }
    ]
  }
}
```

## 10) Get Doctors Directory

- Method: `GET`
- Path: `/doctors`
- Expected success code: `200`

Response shape:

```json
{
  "data": [
    { "id": "d1", "name": "Dr. Samir" },
    { "id": "d2", "name": "Dr. Laila" }
  ]
}
```

## 11) Get Doctor Availability

- Method: `GET`
- Path: `/doctors/{doctorId}/availability`
- Expected success code: `200`

Response shape:

```json
{
  "data": {
    "doctor_id": "d1",
    "appointment_duration_minutes": 30,
    "working_days": [
      {
        "day_of_week": 1,
        "start_time": "09:00",
        "end_time": "17:00",
        "breaks": [
          {
            "start_time": "13:00",
            "end_time": "14:00"
          }
        ]
      }
    ],
    "off_days": ["2026-05-18T00:00:00Z"]
  }
}
```

## 12) Save Doctor Availability

- Method: `POST`
- Path: `/doctors/{doctorId}/availability`
- Expected success codes: `200`, `201`

Request body:

```json
{
  "doctor_id": "d1",
  "appointment_duration_minutes": 30,
  "working_days": [
    {
      "day_of_week": 1,
      "start_time": "09:00",
      "end_time": "17:00",
      "breaks": [
        {
          "start_time": "13:00",
          "end_time": "14:00"
        }
      ]
    }
  ],
  "off_days": ["2026-05-18T00:00:00Z"]
}
```

## Required Status Values

- `scheduled`
- `confirmed`
- `arrived`
- `inProgress`
- `completed`
- `cancelled`
- `noShow`
- `rescheduled`
