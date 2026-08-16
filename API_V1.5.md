# Enaya Healthcare API Guide

Complete API reference for the Enaya healthcare management system. All endpoints are prefixed with `/api`.

## Standard Conventions

All responses follow this standard envelope format:

```json
{
    "success": true,
    "data": {},
    "message": "Optional message",
    "error": null,
    "errorCode": null
}
```

### Authentication

Protected endpoints require a Sanctum bearer token in the `Authorization` header:

```http
Authorization: Bearer <token>
Accept: application/json
```

### Phone Numbers

Phone numbers are normalized by the backend. The frontend may send Syrian phone numbers in these formats:

- `09xxxxxxxx` (Syrian domestic)
- `9639xxxxxxxx` (without +countrycode)
- `009639xxxxxxxx` (with 00 prefix)
- `+9639xxxxxxxx` (standard international)

All are stored and returned as `+9639xxxxxxxx`.

### Error Handling

- HTTP `401`: Unauthenticated — redirect to login
- HTTP `403`: Authenticated but forbidden — check permissions
- HTTP `404`: Resource not found
- HTTP `422`: Validation failed — returns Laravel validation error details
- HTTP `409`: Conflict — duplicate resource or business logic conflict

---

## Authentication Endpoints

All auth endpoints are public (no authentication required).

### Sign Up

`POST /api/auth/signup`

Create a new app user with the `patient` role. If a walk-in patient record exists with matching phone number, the new
account is automatically linked.

**Request:**

```json
{
    "username": "newuser123",
    "email": "newuser@enaya.com",
    "phone": "+963912345678",
    "password": "password123",
    "password_confirmation": "password123"
}
```

**Response `201`:**

```json
{
    "success": true,
    "data": {
        "user": {
            "id": 1,
            "email": "newuser@enaya.com",
            "username": "newuser123",
            "roleId": 3
        },
        "profileCompleted": false,
        "token": "plain-text-sanctum-token",
        "expiresAt": "2026-07-07T12:00:00.000000Z"
    },
    "error": null,
    "errorCode": null
}
```

**Patient Linking Behavior:**

- If `patients.phone` exists with `user_id = null`, links the new account to that existing walk-in record
- If no patient exists with that phone, creates an incomplete patient profile with `profile_completed = false`
- If phone already belongs to a linked patient, returns validation error

**Mobile/Frontend Next Steps:**

1. Store the returned Sanctum token securely
2. Read `profileCompleted` directly from this response
3. If `false`, navigate to complete-profile screen
4. If `true`, allow access to app

Note: this field is only present on the register response. On subsequent
logins, call `GET /api/patients/profile` and check `profile_completed`
there instead (see Patient Profile Endpoints below).

### Login

`POST /api/auth/login`

Authenticate with username/email and password.

**Request:**

```json
{
    "usernameOrEmail": "newuser@enaya.com",
    "password": "password123"
}
```

**Response `200`:**

Same token shape as signup response, without `profileCompleted`.
For patient accounts, check profile status via `GET /api/patients/profile`.

**Error Responses:**

- `401`: Email or password incorrect
- `403`: Account has been deactivated

### Current User

`GET /api/auth/me`

Get the authenticated user's profile.

**Authorization:** `auth:sanctum`

**Response `200`:**

```json
{
    "success": true,
    "data": {
        "user": {
            "id": 1,
            "email": "newuser@enaya.com",
            "username": "newuser123",
            "roleId": 3
        }
    },
    "error": null,
    "errorCode": null
}
```

### Refresh Token

`POST /api/auth/refresh-token`

Get a new access token. Invalidates the current token immediately.

**Authorization:** `auth:sanctum`

**Response `200`:**

```json
{
    "success": true,
    "token": "new-plain-text-sanctum-token",
    "expiresAt": "2026-07-10T12:00:00.000000Z",
    "error": null
}
```

### Logout

`POST /api/auth/logout`

Invalidate the current access token.

**Authorization:** `auth:sanctum`

**Response `200`:**

```json
{
    "success": true,
    "message": "Logged out successfully",
    "error": null
}
```

---

## Notification Endpoints

Base path: `/api`

### List Notifications

`GET /api/notifications`

Fetch the authenticated user's paginated notifications.

**Response `200`:**

```json
{
    "success": true,
    "data": {
        "current_page": 1,
        "data": [
            {
                "id": "1",
                "type": "App\\Notifications\\AppointmentCancelledNotification",
                "notifiable_type": "App\\Models\\User",
                "notifiable_id": 2,
                "data": {
                    "message": "Your appointment was cancelled."
                },
                "read_at": null,
                "created_at": "2026-08-15T12:00:00.000000Z",
                "updated_at": "2026-08-15T12:00:00.000000Z"
            }
        ],
        "per_page": 20,
        "total": 1
    },
    "error": null,
    "errorCode": null
}
```

### Get Unread Notifications Count

`GET /api/notifications/unread-count`

Return the count of unread notifications for the authenticated user.

**Response `200`:**

```json
{
    "success": true,
    "data": {
        "count": 3
    },
    "error": null,
    "errorCode": null
}
```

### Mark Notification as Read

`POST /api/notifications/{id}/read`

Mark one notification as read.

**Response `200`:**

```json
{
    "success": true,
    "data": null,
    "error": null,
    "errorCode": null
}
```

### Mark All Notifications as Read

`POST /api/notifications/read-all`

Mark all unread notifications as read for the authenticated user.

**Response `200`:**

```json
{
    "success": true,
    "data": null,
    "error": null,
    "errorCode": null
}
```

---

## Patient Profile Endpoints

**Authorization:** `auth:sanctum` + `role:patient`

Base path: `/api/patients`

### Get Profile

`GET /api/patients/profile`

Retrieve the authenticated patient's profile.

**Response `200`:**

```json
{
    "success": true,
    "data": {
        "id": 1,
        "user_id": 1,
        "email": "newuser@enaya.com",
        "account_name": "newuser123",
        "full_name": "New User",
        "phone": "+963912345678",
        "date_of_birth": "1995-05-20",
        "gender": "female",
        "address": "Damascus",
        "job": "Teacher",
        "emergency_contact": null,
        "profile_completed": false,
        "created_at": "2026-06-11T12:00:00.000000Z"
    }
}
```

**Response `404`:** if patient record not found

### Complete Profile

`POST /api/patients/complete-profile`

Complete the patient profile after signup. Only callable when `profile_completed` is `false`.

**Request:**

```json
{
    "full_name": "Jane Doe",
    "phone": "+963912345678",
    "date_of_birth": "1995-05-20",
    "gender": "female",
    "address": "Damascus",
    "job": "Teacher",
    "emergency_contact": "0963611111"
}
```

**Response `200`:**

```json
{
    "success": true,
    "message": "Profile completed successfully",
    "data": {
        "id": 1,
        "user_id": 1,
        "full_name": "Jane Doe",
        "phone": "+963912345678",
        "date_of_birth": "1995-05-20",
        "gender": "female",
        "address": "Damascus",
        "job": "Teacher",
        "emergency_contact": "0963611111",
        "profile_completed": true,
        "created_at": "2026-06-11T12:00:00.000000Z"
    }
}
```

**Response `403`:** if profile is already completed

### Update Profile

`PUT /api/patients/profile`

Update patient profile fields. All fields optional.

**Request:**

```json
{
    "name": "Updated Username",
    "email": "updated@example.com",
    "phone": "+963933333333",
    "date_of_birth": "1990-01-01",
    "gender": "male",
    "address": "Homs",
    "job": "Engineer",
    "emergency_contact": "0963611111"
}
```

**Response `200`:**

```json
{
    "success": true,
    "message": "Profile updated successfully",
    "data": {
        "id": 1,
        "user_id": 1,
        "name": "Updated Username",
        "email": "updated@example.com",
        "phone": "+963933333333",
        "date_of_birth": "1990-01-01",
        "gender": "male",
        "address": "Homs",
        "job": "Engineer",
        "emergency_contact": "0963611111",
        "profile_completed": true,
        "created_at": "2026-06-11T12:00:00.000000Z"
    }
}
```

## Patient Doctor Management

**Authorization:** `auth:sanctum` + `role:patient`

Base path: `/api/doctors`

### List Doctors

`GET /api/doctors`

Retrieve a listing of all doctors.

**Response `200`:**

```json
{
    "success": true,
    "data": [
        {
            "id": 1,
            "user_id": 1,
            "full_name": "Dr. John Doe",
            "email": "john.doe@example.com",
            "phone": "+963912345678",
            "date_of_birth": "1980-01-01",
            "gender": "male",
            "specialty": "Cardiology",
            "department": {
                "id": 1,
                "name": "Cardiology"
            },
            "working_hours_start": "09:00",
            "working_hours_end": "17:00"
        }
    ],
    "message": "Doctors retrieved successfully."
}
```

### Get Doctor Details

`GET /api/doctors/{doctor}`

Retrieve the details of a specific doctor.

**Response `200`:**

```json
{
    "success": true,
    "data": {
        "id": 1,
        "user_id": 1,
        "full_name": "Dr. John Doe",
        "email": "john.doe@example.com",
        "phone": "+963912345678",
        "date_of_birth": "1980-01-01",
        "gender": "male",
        "specialty": "Cardiology",
        "department": {
            "id": 1,
            "name": "Cardiology"
        },
        "working_hours_start": "09:00",
        "working_hours_end": "17:00"
    },
    "message": "Doctor retrieved successfully."
}
```

### List Departments

`GET /api/doctors/departments`

Retrieve a listing of all departments.

**Response `200`:**

```json
{
    "success": true,
    "data": [
        {
            "id": 1,
            "name": "Cardiology"
        },
        {
            "id": 2,
            "name": "Pediatrics"
        }
    ],
    "message": "Departments retrieved successfully."
}
```

---

## Patient Appointments

**Authorization:** `auth:sanctum` + `role:patient`

Base path: `/api/patient/appointments`

### List Appointments

`GET /api/patient/appointments`

Get patient's appointments with optional filtering.

**Query Parameters:**

| Name        | Type | Values                                                                 | Description                  |
|-------------|------|------------------------------------------------------------------------|------------------------------|
| `status`    | enum | scheduled, confirmed, arrived, inProgress, completed, canceled, noShow | Filter by appointment status |
| `doctor_id` | int  |                                                                        | Filter by doctor ID          |
| `timeline`  | enum | upcoming, past                                                         | Filter by timeline           |

**Response `200`:**

```json
{
    "success": true,
    "data": [
        {
            "id": 1,
            "patient_id": 1,
            "doctor_id": 1,
            "scheduled_at": "2026-06-20T10:00:00.000000Z",
            "status": "scheduled",
            "visit_reason": "Regular Checkup",
            "notes": "First time",
            "created_at": "2026-06-11T12:00:00.000000Z"
        }
    ],
    "meta": {
        "current_page": 1,
        "last_page": 2,
        "per_page": 20,
        "total": 31
    }
}
```

### Get Appointment

`GET /api/patient/appointments/{appointment}`

Get detailed appointment information.

**Response `200`:**

```json
{
    "success": true,
    "data": {
        "id": 1,
        "patient_id": 1,
        "doctor_id": 1,
        "scheduled_at": "2026-06-20T10:00:00.000000Z",
        "status": "scheduled",
        "visit_reason": "Regular Checkup",
        "notes": "First time",
            "created_at": "2026-06-11T12:00:00.000000Z"
    }
}
```

### Book Appointment

`POST /api/patient/appointments`

Create a new appointment. The system checks doctor availability using pessimistic locking.

**Request:**

```json
{
    "doctor_id": 1,
    "scheduled_at": "2026-06-20 10:00:00",
    "visit_reason": "Regular Checkup",
    "notes": "First time"
}
```

**Response `201`:**

```json
{
    "success": true,
    "message": "Appointment booked successfully!",
    "data": {
        "id": 1,
        "patient_id": 1,
        "doctor_id": 1,
        "scheduled_at": "2026-06-20T10:00:00.000000Z",
        "status": "scheduled",
        "visit_reason": "Regular Checkup",
        "notes": "First time",
            "created_at": "2026-06-11T12:00:00.000000Z"
    }
}
```

**Response `422`:** if time slot already booked

### Get Available Slots

`GET /api/patient/appointments/available-slots`

Get available time slots for a doctor on a specific date.

**Query Parameters:**

| Name        | Type | Required | Description       |
|-------------|------|----------|-------------------|
| `doctor_id` | int  | Yes      | Doctor ID         |
| `date`      | date | Yes      | Date (YYYY-MM-DD) |

**Response `200`:**

```json
{
    "success": true,
    "data": [
        "09:00",
        "09:30",
        "10:00",
        "10:30"
    ]
}
```

### Get Available Days

`GET /api/patient/appointments/available-days`

Get days with available slots for a doctor for the next month starting from today.

**Query Parameters:**

| Name        | Type | Required | Description |
|-------------|------|----------|-------------|
| `doctor_id` | int  | Yes      | Doctor ID   |

**Response `200`:**

```json
{
    "success": true,
    "data": [
        "2026-06-20",
        "2026-06-21",
        "2026-06-25"
    ]
}
```

### Cancel Appointment

`PATCH /api/patient/appointments/{appointment}/cancel`

Cancel patient's own appointment.

**Request:**

```json
{
    "reason": "Cannot make it"
}
```

**Response `200`:**

```json
{
    "success": true,
    "message": "Appointment cancelled.",
    "data": {
        "id": 1,
        "status": "canceled"
    }
}
```

**Response `403`:** if appointment doesn't belong to the patient

### Reschedule Appointment

`PATCH /api/patient/appointments/{appointment}/reschedule`

Change appointment time.

**Request:**

```json
{
    "scheduled_at": "2026-06-21 14:00:00"
}
```

**Response `200`:**

```json
{
    "success": true,
    "message": "Appointment rescheduled.",
    "data": {
        ...
    }
}
```

---

## Patient Prescriptions

**Authorization:** `auth:sanctum` + `role:patient`

Base path: `/api/prescriptions/patient`

### List Prescriptions

`GET /api/prescriptions/patient`

Get all prescriptions for patient's sessions.

**Response `200`:**

```json
{
    "success": true,
    "data": [
        {
            "id": 1,
            "appointment_session_id": 1,
            "medication_name": "Aspirin",
            "dosage": "500mg",
            "frequency": "Twice daily",
            "duration": 7,
            "notes": "Take with food",
            "created_at": "2026-06-11T12:00:00.000000Z",
            "updated_at": "2026-06-11T12:00:00.000000Z"
        }
    ],
    "meta": {
        "current_page": 1,
        "last_page": 2,
        "per_page": 20,
        "total": 24
    }
}
```

### Get Prescription

`GET /api/prescriptions/patient/{prescription}`

Get detailed prescription information.

**Response `200`:**

```json
{
    "success": true,
    "data": {
        "id": 1,
        "appointment_session_id": 1,
        "medication_name": "Aspirin",
        "dosage": "500mg",
        "frequency": "Twice daily",
        "duration": 7,
        "notes": "Take with food",
        "created_at": "2026-06-11T12:00:00.000000Z",
        "updated_at": "2026-06-11T12:00:00.000000Z"
    }
}
```

**Response `403`:** if prescription doesn't belong to patient

---

## Patient Appointment Sessions

**Authorization:** `auth:sanctum` + `role:patient`

Base path: `/api/sessions/patient`

### List Sessions

`GET /api/sessions/patient`

Get all appointment sessions for patient.

**Response `200`:**

```json
{
    "success": true,
    "data": [
        {
            "id": 1,
            "appointment_id": 1,
            "started_at": "2026-06-20 10:00:00",
            "ended_at": "2026-06-20 10:30:00",
            "notes": "Prescribed aspirin",
            "patient_complaint": "Chest pain",
            "diagnosis": "Heartburn",
            "status": "completed",
            "prescriptions": [],
            "created_at": "2026-06-20T10:00:00.000000Z",
            "updated_at": "2026-06-20T10:30:00.000000Z"
        }
    ],
    "meta": {
        "current_page": 1,
        "last_page": 1,
        "per_page": 20,
        "total": 7
    }
}
```

### Get Session

`GET /api/sessions/patient/{session}`

Get detailed session information including prescriptions.

**Response `200`:**

```json
{
    "success": true,
    "data": {
        "id": 1,
        "appointment_id": 1,
        "started_at": "2026-06-20 10:00:00",
        "ended_at": "2026-06-20 10:30:00",
        "notes": "Prescribed aspirin",
        "patient_complaint": "Chest pain",
        "diagnosis": "Heartburn",
        "status": "completed",
            "prescriptions": [
            {
                "id": 1,
                "appointment_session_id": 1,
                "medication_name": "Aspirin",
                "dosage": "500mg",
                "frequency": "Twice daily",
                "duration": 7,
                "notes": "Take with food",
                "created_at": "2026-06-11T12:00:00.000000Z",
                "updated_at": "2026-06-11T12:00:00.000000Z"
            }
        ],
        "created_at": "2026-06-20T10:00:00.000000Z",
        "updated_at": "2026-06-20T10:30:00.000000Z"
    }
}
```

**Response `403`:** if session doesn't belong to patient

---

## Receptionist Patient Management

**Authorization:** `auth:sanctum` + `role:receptionist`

Base path: `/api/reception/patients`

### List Patients

`GET /api/reception/patients`

List all patients with optional filtering.

**Query Parameters:**

| Name           | Type   | Values       | Description                   |
|----------------|--------|--------------|-------------------------------|
| `search`       | string |              | Search by name or phone       |
| `gender`       | enum   | male, female | Filter by gender              |
| `has_account`  | bool   | true, false  | Filter by account status      |
| `with_trashed` | bool   | true, false  | Include soft-deleted patients |

**Response `200`:**

```json
{
    "success": true,
    "data": {
        "current_page": 1,
        "data": [
            {
                "id": 1,
                "user_id": null,
                "full_name": "Jane Doe",
                "phone": "+963912345678",
                "date_of_birth": "1995-05-20",
                "gender": "female",
                "address": "Damascus",
                "job": "Teacher",
                "emergency_contact": null,
                "created_at": "2026-06-11T12:00:00.000000Z"
            }
        ],
        "first_page_url": "http://localhost/api/reception/patients?page=1",
        "from": 1,
        "last_page": 2,
        "last_page_url": "http://localhost/api/reception/patients?page=2",
        "next_page_url": "http://localhost/api/reception/patients?page=2",
        "path": "http://localhost/api/reception/patients",
        "per_page": 20,
        "prev_page_url": null,
        "to": 1,
        "total": 23
    }
}
```

### Create Walk-In Patient

`POST /api/reception/patients`

Register a new walk-in patient.

**Request:**

```json
{
    "full_name": "Jane Doe",
    "phone": "+963912345678",
    "date_of_birth": "1995-05-20",
    "gender": "female",
    "address": "Damascus",
    "job": "Teacher",
    "emergency_contact": "0963611111"
}
```

**Response `201`:**

```json
{
    "success": true,
    "message": "Patient created successfully",
    "data": {
        "id": 1,
        "user_id": null,
        "full_name": "Jane Doe",
        "phone": "+963912345678",
        "profile_completed": true
    }
}
```

**Response `409`:** if patient with this phone already exists

### Get Patient

`GET /api/reception/patients/{patient}`

Get patient details.

**Response `200`:**

```json
{
    "success": true,
    "data": {
        "id": 1,
        "user_id": null,
        "full_name": "Jane Doe",
        "phone": "+963912345678",
        "date_of_birth": "1995-05-20",
        "gender": "female",
        "address": "Damascus",
        "job": "Teacher",
        "profile_completed": true
    }
}
```

### Update Patient

`PUT /api/reception/patients/{patient}`

Update walk-in patient. Requires `edit-app-patients` permission for app-linked patients.

**Request:** Same fields as create

**Response `200`:** Updated patient data

**Response `403`:** if trying to edit app-linked patient without permission

### Delete Patient

`DELETE /api/reception/patients/{patient}`

Soft-delete patient (can be restored). Requires `delete-app-patients` permission for app-linked patients.

**Response `200`:**

```json
{
    "success": true,
    "message": "Patient deleted successfully"
}
```

### Restore Patient

`PUT /api/reception/patients/{patient}/restore`

Restore a soft-deleted patient.

**Response `200`:**

```json
{
    "success": true,
    "message": "Patient restored successfully.",
    "data": {
        ...
    }
}
```

### Force Delete Patient

`DELETE /api/reception/patients/{patient}/force-delete`

Permanently delete patient (cannot be restored).

**Response `200`:**

```json
{
    "success": true,
    "message": "Patient permanently deleted successfully."
}
```

---

## Receptionist Doctor Management

**Authorization:** `auth:sanctum` + `role:receptionist`

Base path: `/api/receptionist/doctors`

### List Doctors

`GET /api/receptionist/doctors`

Retrieve a listing of all doctors.

**Response `200`:**

```json
{
    "success": true,
    "data": [
        {
            "id": 1,
            "user_id": 1,
            "full_name": "Dr. John Doe",
            "email": "john.doe@example.com",
            "phone": "+963912345678",
            "date_of_birth": "1980-01-01",
            "gender": "male",
            "specialty": "Cardiology",
            "department": {
                "id": 1,
                "name": "Cardiology"
            },
            "working_hours_start": "09:00",
            "working_hours_end": "17:00"
        }
    ],
    "message": "Doctors retrieved successfully."
}
```

### Get Doctor Details

`GET /api/receptionist/doctors/{doctor}`

Retrieve the details of a specific doctor.

**Response `200`:**

```json
{
    "success": true,
    "data": {
        "id": 1,
        "user_id": 1,
        "full_name": "Dr. John Doe",
        "email": "john.doe@example.com",
        "phone": "+963912345678",
        "date_of_birth": "1980-01-01",
        "gender": "male",
        "specialty": "Cardiology",
        "department": {
            "id": 1,
            "name": "Cardiology"
        },
        "working_hours_start": "09:00",
        "working_hours_end": "17:00"
    },
    "message": "Doctor retrieved successfully."
}
```

### List Departments

`GET /api/receptionist/doctors/departments`

Retrieve a listing of all departments.

**Response `200`:**

```json
{
    "success": true,
    "data": [
        {
            "id": 1,
            "name": "Cardiology"
        },
        {
            "id": 2,
            "name": "Pediatrics"
        }
    ],
    "message": "Departments retrieved successfully."
}
```

---

## Receptionist Appointment Management

**Authorization:** `auth:sanctum` + `role:receptionist`

Base path: `/api/receptionist/appointments`

### List Appointments

`GET /api/receptionist/appointments`

List appointments with filtering. Defaults to today's appointments.

**Query Parameters:**

| Name        | Type   | Format   | Description                  |
|-------------|--------|----------|------------------------------|
| `date`      | date   | Y-m-d    | Filter by single date        |
| `date_from` | date   | Y-m-d    | Filter from date             |
| `date_to`   | date   | Y-m-d    | Filter to date               |
| `doctor_id` | int    |          | Filter by doctor             |
| `status`    | enum   | See list | Filter by status             |
| `search`    | string |          | Search by patient name/phone |

**Response `200`:**

```json
{
    "success": true,
    "data": [
        {
            "id": 1,
            "patient_id": 1,
            "doctor_id": 1,
            "scheduled_at": "2026-06-20T10:00:00.000000Z",
            "status": "arrived",
            "visit_reason": "Regular Checkup",
            "session": null
        }
    ]
}
```

### Create Appointment

`POST /api/receptionist/appointments`

Create appointment on behalf of a patient (walk-in or app user).

**Request:**

```json
{
    "patient_id": 1,
    "doctor_id": 1,
    "scheduled_at": "2026-06-20 10:00:00",
    "visit_reason": "Regular Checkup",
    "notes": "Walk-in"
}
```

**Response `201`:**

```json
{
    "success": true,
    "message": "Appointment booked successfully",
    "data": {
        ...
    }
}
```

### Get Appointment

`GET /api/receptionist/appointments/{appointment}`

Get appointment details.

**Response `200`:** Appointment data

### Confirm Appointment

`PATCH /api/receptionist/appointments/{appointment}/confirm`

Confirm a scheduled appointment.

**Response `200`:**

```json
{
    "success": true,
    "message": "Appointment confirmed.",
    "data": {
        ...
    }
}
```

### Mark Arrived

`PATCH /api/receptionist/appointments/{appointment}/arrived`

Mark patient as arrived.

**Response `200`:**

```json
{
    "success": true,
    "message": "Patient marked as arrived.",
    "data": {
        ...
    }
}
```

### Reschedule Appointment

`PATCH /api/receptionist/appointments/{appointment}/reschedule`

Change appointment time.

**Request:**

```json
{
    "scheduled_at": "2026-06-21 14:00:00"
}
```

**Response `200`:**

```json
{
    "success": true,
    "message": "Appointment rescheduled.",
    "data": {
        ...
    }
}
```

### Cancel Appointment

`PATCH /api/receptionist/appointments/{appointment}/cancel`

Cancel appointment.

**Request:**

```json
{
    "reason": "Patient requested cancellation"
}
```

**Response `200`:**

```json
{
    "success": true,
    "message": "Appointment cancelled.",
    "data": {
        ...
    }
}
```

### Mark No-Show

`PATCH /api/receptionist/appointments/{appointment}/no-show`

Mark patient as no-show.

**Response `200`:**

```json
{
    "success": true,
    "message": "Marked as no-show.",
    "data": {
        ...
    }
}
```

### Get Available Days

`GET /api/receptionist/appointments/available-days`

Get days with available slots for a doctor for the next month starting from today.

**Query Parameters:**

| Name        | Type | Required | Description |
|-------------|------|----------|-------------|
| `doctor_id` | int  | Yes      | Doctor ID   |

**Response `200`:**

```json
{
    "success": true,
    "data": [
        "2026-06-20",
        "2026-06-21",
        "2026-06-25"
    ]
}
```

---

## Doctor Profile

**Authorization:** `auth:sanctum` + `role:doctor`

### Get Doctor Profile

`GET /api/doctor/profile`

Retrieve the authenticated doctor's profile information, including personal details and working hours.

**Response `200`:**

```json
{
    "success": true,
    "data": {
        "id": 1,
        "user": {
            "id": 2,
            "name": "Dr. Ahmed",
            "email": "doctor@enaya.com"
        },
        "full_name": "Dr. Ahmed Al-Hassan",
        "phone": "+963912345678",
        "date_of_birth": "1985-05-14",
        "gender": "male",
        "specialty": "Cardiology",
        "working_hours_start": "09:00",
        "working_hours_end": "17:00",
        "department": {
            "id": 1,
            "name": "Cardiology"
        }
    }
}
```

### Update Working Hours

`PUT /api/doctor/profile/working-hours`

Update the authenticated doctor's working hours.

**Request:**

```json
{
    "working_hours_start": "09:00",
    "working_hours_end": "17:00"
}
```

**Response `200`:**

```json
{
    "success": true,
    "message": "Working hours updated successfully",
    "data": {
        "id": 1,
        "user": {
            "id": 2,
            "name": "Dr. Ahmed",
            "email": "doctor@enaya.com"
        },
        "full_name": "Dr. Ahmed Al-Hassan",
        "phone": "+963912345678",
        "specialty": "Cardiology",
        "working_hours_start": "09:00",
        "working_hours_end": "17:00",
        "department": {
            "id": 1,
            "name": "Cardiology"
        }
    }
}
```

**Response `422`:** if the provided time range is invalid.

---

## Doctor Appointments

**Authorization:** `auth:sanctum` + `role:doctor`

Base path: `/api/doctor/appointments`

### List Appointments

`GET /api/doctor/appointments`

List doctor's appointments. Defaults to today's appointments.

**Query Parameters:**

| Name       | Type | Values          | Description        |
|------------|------|-----------------|--------------------|
| `status`   | enum | See status list | Filter by status   |
| `date`     | date | Y-m-d           | Filter by date     |
| `timeline` | enum | upcoming, past  | Filter by timeline |

**Response `200`:**

```json
{
    "success": true,
    "data": [
        {
            "id": 1,
            "patient_id": 1,
            "doctor_id": 1,
            "scheduled_at": "2026-06-20T10:00:00.000000Z",
            "status": "arrived",
            "visit_reason": "Regular Checkup",
            "patient": {
                ...
            }
        }
    ],
    "meta": {
        "current_page": 1,
        "last_page": 2,
        "per_page": 20,
        "total": 24
    }
}
```

### Get Appointment

`GET /api/doctor/appointments/{appointment}`

Get appointment details.

**Response `200`:** Appointment data

**Response `403`:** if appointment doesn't belong to doctor

### Confirm Appointment

`PATCH /api/doctor/appointments/{appointment}/confirm`

Confirm a scheduled appointment.

**Response `200`:**

```json
{
    "success": true,
    "message": "Appointment confirmed.",
    "data": {
        ...
    }
}
```

### Cancel Appointment

`PATCH /api/doctor/appointments/{appointment}/cancel`

Cancel appointment.

**Response `200`:**

```json
{
    "success": true,
    "message": "Appointment cancelled.",
    "data": {
        ...
    }
}
```

### Mark No-Show

`PATCH /api/doctor/appointments/{appointment}/no-show`

Mark patient as no-show.

**Response `200`:**

```json
{
    "success": true,
    "message": "Marked as no-show.",
    "data": {
        ...
    }
}
```

### Get Available Slots

`GET /api/doctor/appointments/available-slots`

Get available time slots for a doctor on a specific date.

**Query Parameters:**

| Name        | Type | Required | Description       |
|-------------|------|----------|-------------------|
| `doctor_id` | int  | Yes      | Doctor ID         |
| `date`      | date | Yes      | Date (YYYY-MM-DD) |

**Response `200`:**

```json
{
    "success": true,
    "data": [
        "09:00",
        "09:30",
        "10:00",
        "10:30"
    ]
}
```

### Get Available Days

`GET /api/doctor/appointments/available-days`

Get days with available slots for a doctor for the next month starting from today.

**Query Parameters:**

| Name        | Type | Required | Description |
|-------------|------|----------|-------------|
| `doctor_id` | int  | Yes      | Doctor ID   |

**Response `200`:**

```json
{
    "success": true,
    "data": [
        "2026-06-20",
        "2026-06-21",
        "2026-06-25"
    ]
}
```

---

## Doctor Appointment Sessions

**Authorization:** `auth:sanctum` + `role:doctor`

Base path: `/api/doctor/appointments/{appointment}/sessions`

### List Sessions

`GET /api/doctor/appointments/{appointment}/sessions/list`

List all sessions for an appointment.

**Response `200`:**

```json
{
    "success": true,
    "data": {
        "sessions": [
            {
                "id": 1,
                "appointment_id": 1,
                "started_at": "2026-06-20T10:00:00.000000Z",
                "ended_at": "2026-06-20T10:30:00.000000Z",
                "status": "completed",
                "patient_complaint": "Chest pain",
                "diagnosis": "Heartburn",
                "notes": "Follow up in 2 weeks",
                "prescriptions": []
            }
        ]
    },
    "meta": {
        "current_page": 1,
        "last_page": 1,
        "per_page": 20,
        "total": 3
    }
}
```

### Start Session

`POST /api/doctor/appointments/{appointment}/sessions/start`

Start a new appointment session. Appointment must be in `arrived`, `confirmed`, or `scheduled` status.

**Request:**

```json
{
    "patient_complaint": "Chest pain",
    "notes": "Patient looks healthy"
}
```

**Response `201`:**

```json
{
    "success": true,
    "data": {
        "session": {
            "id": 1,
            "appointment_id": 1,
            "started_at": "2026-06-20T10:00:00.000000Z",
            "status": "active",
            "patient_complaint": "Chest pain",
            "notes": "Patient looks healthy"
        }
    }
}
```

**Response `422`:** if appointment not in valid state or active session exists

### End Session

`POST /api/doctor/appointments/{appointment}/sessions/end`

Complete the appointment session.

**Request:**

```json
{
    "diagnosis": "Heartburn",
    "notes": "Follow up in 2 weeks"
}
```

**Response `200`:**

```json
{
    "success": true,
    "data": {
        "session": {
            "id": 1,
            "status": "completed",
            "ended_at": "2026-06-20T10:30:00.000000Z",
            "diagnosis": "Heartburn",
            "notes": "Follow up in 2 weeks"
        }
    }
}
```

### Get Session

`GET /api/doctor/appointments/{appointment}/sessions/{session}`

Get session details.

**Response `200`:**

```json
{
    "success": true,
    "data": {
        "session": {
            ...
        }
    }
}
```

### Update Session

`PATCH /api/doctor/appointments/{appointment}/sessions/{session}`

Update session notes or status. Cannot modify completed sessions.

**Request:**

```json
{
    "diagnosis": "Updated diagnosis",
    "patient_complaint": "Updated complaint",
    "notes": "Updated notes",
    "status": "active"
}
```

**Response `200`:**

```json
{
    "success": true,
    "data": {
        "session": {
            ...
        }
    }
}
```

---

## Doctor Prescriptions

**Authorization:** `auth:sanctum` + `role:doctor`

Base path: `/api/doctor/sessions/{session}`

### Create Prescription

`POST /api/doctor/sessions/{session}/prescriptions`

Add prescription to session (only during active session).

**Request:**

```json
{
    "medication_name": "Aspirin",
    "dosage": "500mg",
    "frequency": "Twice daily",
    "duration_days": 7,
    "instructions": "Take with food"
}
```

**Response `201`:**

```json
{
    "success": true,
    "data": {
        "prescription": {
            "id": 1,
            "appointment_session_id": 1,
            "medication_name": "Aspirin",
            "dosage": "500mg",
            "frequency": "Twice daily",
            "duration_days": 7,
            "instructions": "Take with food"
        }
    }
}
```

**Response `422`:** if session not active

### Update Prescription

`PATCH /api/doctor/sessions/{session}/prescriptions/{prescription}`

Update an existing prescription.

**Request:**

```json
{
    "medication_name": "Updated Medication",
    "dosage": "1000mg",
    "frequency": "Once daily",
    "duration_days": 14,
    "instructions": "Take with water"
}
```

**Response `200`:**

```json
{
    "success": true,
    "data": {
        "prescription": {
            "id": 1,
            "appointment_session_id": 1,
            "medication_name": "Updated Medication",
            "dosage": "1000mg",
            "frequency": "Once daily",
            "duration_days": 14,
            "instructions": "Take with water",
            "created_at": "2026-06-11T12:00:00.000000Z",
            "updated_at": "2026-06-11T12:00:00.000000Z"
        }
    }
}
```

### Delete Prescription

`DELETE /api/doctor/sessions/{session}/prescriptions/{prescription}`

Remove prescription from session (only during active session).

**Response `200`:**

```json
{
    "success": true,
    "data": null
}
```

**Response `404`:** if prescription doesn't belong to session

---

## Doctor Patient List

**Authorization:** `auth:sanctum` + `role:doctor`

Base path: `/api/doctor/{doctor}`

### List Doctor's Patients

`GET /api/doctor/{doctor}/patients`

Get all patients who have appointments with this doctor.

**Query Parameters:**

| Name                | Type   | Values       | Description                  |
|---------------------|--------|--------------|------------------------------|
| `search`            | string |              | Search by name or phone      |
| `gender`            | enum   | male, female | Filter by gender             |
| `has_account`       | bool   | true, false  | Filter by account status     |
| `profile_completed` | bool   | true, false  | Filter by profile completion |
| `created_from`      | date   | Y-m-d        | Filter from creation date    |
| `created_to`        | date   | Y-m-d        | Filter to creation date      |
| `birth_from`        | date   | Y-m-d        | Filter from birth date       |
| `birth_to`          | date   | Y-m-d        | Filter to birth date         |

**Response `200`:**

```json
{
    "success": true,
    "message": "Patients fetched successfully",
    "data": [
        {
            "id": 1,
            "user_id": null,
            "full_name": "Jane Doe",
            "phone": "+963912345678",
            "date_of_birth": "1995-05-20",
            "gender": "female",
            "address": "Damascus",
            "job": "Teacher",
            "profile_completed": true,
            "created_at": "2026-06-07 12:00:00"
        }
    ],
    "meta": {
        "current_page": 1,
        "last_page": 1,
        "per_page": 15,
        "total": 1
    }
}
```

### Get Patient Details

`GET /api/doctor/{doctor}/patients/{patient}`

Get patient profile with all appointments from this doctor.

**Response `200`:**

```json
{
    "success": true,
    "data": {
        "id": 1,
        "user_id": null,
        "full_name": "Jane Doe",
        "phone": "+963912345678",
        "appointments": [
            {
                "id": 1,
                "scheduled_at": "2026-06-20T10:00:00.000000Z",
                "status": "completed",
                "appointmentSession": {
                    "id": 1,
                    "prescriptions": [
                        ...
                    ]
                }
            }
        ]
    }
}
```

**Response `403`:** if doctor doesn't have appointments with patient

---

## Admin User Management

**Authorization:** `auth:sanctum` + `role:admin`

Base path: `/api/admin/users`

### List Users

`GET /api/admin/users`

List all system users.

**Query Parameters:**

| Name     | Type   | Values                               | Description             |
|----------|--------|--------------------------------------|-------------------------|
| `search` | string |                                      | Search by name or email |
| `role`   | enum   | doctor, receptionist, patient, admin | Filter by role          |
| `page`   | int    |                                      | Pagination page         |

**Response `200`:**

```json
{
    "success": true,
    "data": {
        "current_page": 1,
        "data": [
            {
                "id": 1,
                "name": "Dr. House",
                "email": "house@enaya.com",
                "roles": [
                    "doctor"
                ]
            }
        ],
        "last_page": 1
    }
}
```

### Create User

`POST /api/admin/users`

Create new user (doctor or receptionist).

**For Doctor:**

```json
{
    "name": "Dr. Sam",
    "email": "sam@enaya.com",
    "password": "password123",
    "role": "doctor",
    "phone": "0963611111",
    "date_of_birth": "1980-01-15",
    "gender": "male",
    "specialty": "Cardiology",
    "department_id": 2,
    "working_hours_start": "08:00",
    "working_hours_end": "14:00"
}
```

**For Receptionist:**

```json
{
    "name": "Nadia",
    "email": "nadia@enaya.com",
    "password": "password123",
    "role": "receptionist"
}
```

**Response `201`:**

```json
{
    "success": true,
    "message": "User created successfully.",
    "data": {
        "id": 5,
        "name": "Nadia",
        "email": "nadia@enaya.com",
        "roles": [
            "receptionist"
        ]
    }
}
```

### Get User

`GET /api/admin/users/{user}`

Get user details. Returns different format based on role (patient profile or doctor details).

**Response `200`:** User resource with role-specific data

### Update User

`PUT /api/admin/users/{user}`

Update user information.

**Fields:**

- `name` - User name
- `email` - Email address
- `specialty` - Doctor specialty (doctors only)
- `department_id` - Department (doctors only)

**Response `200`:**

```json
{
    "success": true,
    "message": "User updated successfully.",
    "data": {
        ...
    }
}
```

### Delete User

`DELETE /api/admin/users/{user}`

Delete user account.

**Response `200`:**

```json
{
    "success": true,
    "message": "User deleted successfully."
}
```

**Response `403`:** if trying to delete own account

### Activate User

`PATCH /api/admin/users/{user}/activate`

Activate a user account.

**Response `200`:**

```json
{
    "success": true,
    "message": "User activated successfully.",
    "data": {
        ...
    }
}
```

### Deactivate User

`PATCH /api/admin/users/{user}/deactivate`

Deactivate a user account.

**Response `200`:**

```json
{
    "success": true,
    "message": "User deactivated successfully.",
    "data": {
        ...
    }
}
```

**Response `403`:** if trying to deactivate own account

---

## Admin Patient Management

**Authorization:** `auth:sanctum` + `role:admin`

Base path: `/api/admin/patients`

### List Patients

`GET /api/admin/patients`

List all patients.

**Query Parameters:**

| Name                | Type   | Values       | Description               |
|---------------------|--------|--------------|---------------------------|
| `search`            | string |              | Search by name or phone   |
| `gender`            | enum   | male, female | Filter by gender          |
| `has_account`       | bool   | true, false  | Filter by account status  |
| `profile_completed` | bool   | true, false  | Filter by completion      |
| `created_from`      | date   | Y-m-d        | Filter from creation date |
| `created_to`        | date   | Y-m-d        | Filter to creation date   |
| `birth_from`        | date   | Y-m-d        | Filter from birth date    |
| `birth_to`          | date   | Y-m-d        | Filter to birth date      |
| `with_trashed`      | bool   | true, false  | Include deleted patients  |
| `page`              | int    |              | Pagination page           |

**Response `200`:**

```json
{
    "success": true,
    "data": {
        "current_page": 1,
        "data": [
            {
                "id": 1,
                "full_name": "Jane Doe",
                "phone": "+963912345678",
                "profile_completed": true
            }
        ],
        "last_page": 1
    }
}
```

### Create Patient

`POST /api/admin/patients`

Create new patient record.

**Request:**

```json
{
    "full_name": "Jane Doe",
    "phone": "+963912345678",
    "date_of_birth": "1995-05-20",
    "gender": "female",
    "address": "Damascus",
    "job": "Teacher",
    "emergency_contact": "0963611111"
}
```

**Response `201`:**

```json
{
    "success": true,
    "message": "Patient created successfully.",
    "data": {
        ...
    }
}
```

**Response `409`:** if phone number already exists

### Get Patient

`GET /api/admin/patients/{patient}`

Get patient details including linked user if available.

**Response `200`:** Patient resource with user data

### Update Patient

`PUT /api/admin/patients/{patient}`

Update patient information. Admins can edit any patient.

**Request:** Same fields as create

**Response `200`:**

```json
{
    "success": true,
    "message": "Patient updated successfully.",
    "data": {
        ...
    }
}
```

### Delete Patient

`DELETE /api/admin/patients/{patient}`

Soft-delete patient (can be restored).

**Response `200`:**

```json
{
    "success": true,
    "message": "Patient deleted successfully."
}
```

### Restore Patient

`PUT /api/admin/patients/{patient}/restore`

Restore soft-deleted patient.

**Response `200`:**

```json
{
    "success": true,
    "message": "Patient restored successfully.",
    "data": {
        ...
    }
}
```

### Force Delete Patient

`DELETE /api/admin/patients/{patient}/force-delete`

Permanently delete patient (cannot be restored).

**Response `200`:**

```json
{
    "success": true,
    "message": "Patient permanently deleted successfully."
}
```

---

## Admin Doctor Management

**Authorization:** `auth:sanctum` + `role:admin`

Base path: `/api/admin/doctors`

### List Doctors

`GET /api/admin/doctors`

List all doctors.

**Query Parameters:**

| Name            | Type   | Values       | Description          |
|-----------------|--------|--------------|----------------------|
| `search`        | string |              | Search by name       |
| `specialty`     | string |              | Filter by specialty  |
| `department_id` | int    |              | Filter by department |
| `gender`        | enum   | male, female | Filter by gender     |
| `per_page`      | int    |              | Results per page     |

**Response `200`:**

```json
{
    "success": true,
    "data": {
        "current_page": 1,
        "data": [
            {
                "id": 1,
                "user_id": 1,
                "full_name": "Dr. Sam",
                "specialty": "Cardiology",
                "department": {
                    ...
                }
            }
        ],
        "last_page": 1
    }
}
```

### Create Doctor

`POST /api/admin/doctors`

Create new doctor with user account.

**Request:**

```json
{
    "name": "Dr. Sam",
    "email": "sam@enaya.com",
    "password": "password123",
    "phone": "0963611111",
    "date_of_birth": "1980-01-15",
    "gender": "male",
    "specialty": "Cardiology",
    "department_id": 2,
    "working_hours_start": "08:00",
    "working_hours_end": "14:00"
}
```

**Response `201`:**

```json
{
    "success": true,
    "data": {
        ...
    },
    "error": null
}
```

### Get Doctor

`GET /api/admin/doctors/{doctor}`

Get doctor details.

**Response `200`:**

```json
{
    "success": true,
    "data": {
        ...
    },
    "error": null
}
```

### Update Doctor

`PUT /api/admin/doctors/{doctor}`

Update doctor information.

**Response `200`:**

```json
{
    "success": true,
    "data": {
        ...
    },
    "error": null
}
```

### Delete Doctor

`DELETE /api/admin/doctors/{doctor}`

Soft-delete doctor and deactivate user.

**Response `200`:**

```json
{
    "success": true,
    "message": "Doctor deleted successfully",
    "data": null,
    "error": null
}
```

### Restore Doctor

`PUT /api/admin/doctors/{doctor}/restore`

Restore soft-deleted doctor and reactivate user.

**Response `200`:**

```json
{
    "success": true,
    "message": "Doctor restored successfully",
    "data": {
        ...
    },
    "error": null
}
```

### Reset Doctor Password

`PATCH /api/admin/doctors/{doctor}/reset-password`

Reset doctor's password.

**Request:**

```json
{
    "password": "newpassword123",
    "password_confirmation": "newpassword123"
}
```

**Response `200`:**

```json
{
    "success": true,
    "data": null,
    "error": null
}
```

---

## Admin Department Management

**Authorization:** `auth:sanctum` + `role:admin`

Base path: `/api/admin/departments`

### List Departments

`GET /api/admin/departments`

List all departments.

**Query Parameters:**

| Name     | Type   | Description               |
|----------|--------|---------------------------|
| `search` | string | Filter by department name |

**Response `200`:**

```json
{
    "success": true,
    "message": "Departments fetched successfully",
    "data": [
        {
            "id": 1,
            "name": "Cardiology"
        }
    ],
    "meta": {
        "current_page": 1,
        "last_page": 1,
        "per_page": 10,
        "total": 1
    }
}
```

### Create Department

`POST /api/admin/departments`

Create new department.

**Request:**

```json
{
    "name": "Cardiology"
}
```

**Response `201`:**

```json
{
    "success": true,
    "message": "Department created successfully",
    "data": {
        "id": 1,
        "name": "Cardiology"
    }
}
```

### Get Department

`GET /api/admin/departments/{department}`

Get department details.

**Response `200`:**

```json
{
    "success": true,
    "data": {
        ...
    }
}
```

### Update Department

`PUT /api/admin/departments/{department}`

Update department.

**Request:**

```json
{
    "name": "Updated Name"
}
```

**Response `200`:**

```json
{
    "success": true,
    "message": "Department updated successfully",
    "data": {
        ...
    }
}
```

### Delete Department

`DELETE /api/admin/departments/{department}`

Delete department. Fails if doctors are assigned.

**Response `200`:**

```json
{
    "success": true,
    "message": "Department deleted successfully"
}
```

**Response `422`:** if department has active doctors

---

## Admin Appointment Management

**Authorization:** `auth:sanctum` + `role:admin`

Base path: `/api/admin/appointments`

### List Appointments

`GET /api/admin/appointments`

List clinic's appointments with pagination, ordered by latest scheduled time.

**Query Parameters:**

| Name        | Type   | Format   | Description                  |
|-------------|--------|----------|------------------------------|
| `date`      | date   | Y-m-d    | Filter by single date        |
| `date_from` | date   | Y-m-d    | Filter from date             |
| `date_to`   | date   | Y-m-d    | Filter to date               |
| `doctor_id` | int    |          | Filter by doctor             |
| `status`    | enum   | See list | Filter by status             |
| `search`    | string |          | Search patient/reason        |
| `per_page`  | int    |          | Items per page (default: 15) |

**Response `200`:**

```json
{
    "success": true,
    "data": [
        {
            "id": 1,
            "patient_id": 1,
            "doctor_id": 1,
            "scheduled_at": "2026-06-20T10:00:00.000000Z",
            "status": "scheduled",
            "visit_reason": "Regular Checkup",
            "patient": {
                ...
            },
            "doctor": {
                ...
            }
        }
    ],
    "meta": {
        "current_page": 1,
        "last_page": 1,
        "per_page": 15,
        "total": 1
    }
}
```

### Create Appointment

`POST /api/admin/appointments`

Create appointment on behalf of a patient (walk-in or app user).

**Request:**

```json
{
    "patient_id": 1,
    "doctor_id": 1,
    "scheduled_at": "2026-06-20 10:00:00",
    "visit_reason": "Regular Checkup",
    "notes": "Admin booked"
}
```

**Response `201`:**

```json
{
    "success": true,
    "message": "Appointment booked successfully",
    "data": {
        "id": 1,
        "patient_id": 1,
        "doctor_id": 1,
        "scheduled_at": "2026-06-20T10:00:00.000000Z",
        "status": "scheduled",
        "visit_reason": "Regular Checkup",
        "notes": "Admin booked",
        "patient": {
            ...
        },
        "doctor": {
            ...
        }
    }
}
```

### Get Appointment Stats

`GET /api/admin/appointments/stats`

Get appointment statistics and breakdown by status.

**Query Parameters:**

| Name        | Type | Format | Description      |
|-------------|------|--------|------------------|
| `date_from` | date | Y-m-d  | Filter from date |
| `date_to`   | date | Y-m-d  | Filter to date   |
| `doctor_id` | int  |        | Filter by doctor |

**Response `200`:**

```json
{
    "success": true,
    "data": {
        "total": 50,
        "scheduled": 10,
        "confirmed": 15,
        "arrived": 5,
        "in_progress": 2,
        "completed": 15,
        "cancelled": 2,
        "no_show": 1,
        "completion_rate": 0.30
    }
}
```

### Get Appointment

`GET /api/admin/appointments/{appointment}`

Get appointment details including all sessions.

**Response `200`:** Appointment resource with sessions

### Confirm Appointment

`PATCH /api/admin/appointments/{appointment}/confirm`

Confirm a scheduled appointment.

**Response `200`:**

```json
{
    "success": true,
    "message": "Appointment confirmed.",
    "data": {
        ...
    }
}
```

### Mark Arrived

`PATCH /api/admin/appointments/{appointment}/arrived`

Mark patient as arrived.

**Response `200`:**

```json
{
    "success": true,
    "message": "Patient marked as arrived.",
    "data": {
        ...
    }
}
```

### Cancel Appointment

`PATCH /api/admin/appointments/{appointment}/cancel`

Cancel any appointment.

**Request:**

```json
{
    "reason": "Admin cancellation"
}
```

**Response `200`:**

```json
{
    "success": true,
    "message": "Appointment cancelled.",
    "data": {
        ...
    }
}
```

### Mark No-Show

`PATCH /api/admin/appointments/{appointment}/no-show`

Mark appointment as no-show.

**Response `200`:**

```json
{
    "success": true,
    "message": "Marked as no-show.",
    "data": {
        ...
    }
}
```

### Reschedule Appointment

`PATCH /api/admin/appointments/{appointment}/reschedule`

Reschedule appointment.

**Request:**

```json
{
    "scheduled_at": "2026-06-21 14:00:00"
}
```

**Response `200`:**

```json
{
    "success": true,
    "message": "Appointment rescheduled.",
    "data": {
        ...
    }
}
```

### Get Available Slots

`GET /api/admin/appointments/available-slots`

Get available time slots for a doctor on a specific date.

**Query Parameters:**

| Name        | Type | Required | Description       |
|-------------|------|----------|-------------------|
| `doctor_id` | int  | Yes      | Doctor ID         |
| `date`      | date | Yes      | Date (YYYY-MM-DD) |

**Response `200`:**

```json
{
    "success": true,
    "data": [
        "09:00",
        "09:30",
        "10:00",
        "10:30"
    ]
}
```

---

## Admin Dashboard

**Authorization:** `auth:sanctum` + `role:admin`

### Dashboard Metrics

`GET /api/admin/dashboard`

Get comprehensive dashboard data including KPIs, recent activity, and charts.

**Response `200`:**

```json
{
    "success": true,
    "data": {
        "total_patients": 150,
        "total_doctors": 12,
        "total_receptionists": 5,
        "appointments_today": 8,
        "appointments_this_week": 45,
        "pending_appointments": 3,
        "completed_today": 5,
        "recent_patients": [
            {
                "id": 5,
                "full_name": "Jane Doe",
                "phone": "+963912345678",
                "created_at": "2026-06-11T12:00:00.000000Z"
            }
        ],
        "recent_appointments": [
            {
                "id": 10,
                "doctor_id": 2,
                "patient_id": 5,
                "scheduled_at": "2026-06-11T14:00:00.000000Z",
                "status": "scheduled",
                "visit_reason": "Regular Checkup"
            }
        ],
        "appointments_last_7_days": [
            {
                "date": "2026-06-05",
                "total": 5
            },
            {
                "date": "2026-06-06",
                "total": 7
            }
        ]
    }
}
```

---

## Appointment Status Values

Valid appointment statuses throughout the system:

| Status     | Description                |
|------------|----------------------------|
| scheduled  | Initial booking status     |
| confirmed  | Receptionist confirmed     |
| arrived    | Patient arrived in clinic  |
| inProgress | During session with doctor |
| completed  | Session finished           |
| canceled   | Cancelled by any party     |
| noShow     | Patient didn't show up     |

---

## Common Features & Filters

### Date Range Filtering

Most list endpoints support `date_from` and `date_to` query parameters to filter by date range:

```
GET /api/admin/appointments?date_from=2026-06-01&date_to=2026-06-30
```

### Search Functionality

Search endpoints intelligently match across multiple fields:

- **Patient search**: Matches full name and phone (handles various phone formats)
- **User search**: Matches name and email
- **Appointment search**: Matches patient info, visit reason, and notes

### Pagination

List endpoints return paginated results:

```json
{
    "success": true,
    "data": {
        "current_page": 1,
        "data": [
            ...
        ],
        "last_page": 5,
        "per_page": 15,
        "total": 67
    }
}
```

### Soft Deletes

Patients and doctors support soft deletion (recovery possible). Use `with_trashed=true` query parameter to include
deleted records.

### Role-Based Access

All endpoints enforce role-based access control through middleware:

- `role:patient` - Patient endpoints
- `role:receptionist` - Receptionist endpoints
- `role:doctor` - Doctor endpoints
- `role:admin` - Admin endpoints

---

## Error Responses

All error responses follow this format:

```json
{
    "success": false,
    "data": null,
    "error": "Error message describing what went wrong",
    "errorCode": "ERROR_CODE_or_http_status"
}
```

Common HTTP Status Codes:

- `400` - Bad Request
- `401` - Unauthenticated
- `403` - Forbidden / Unauthorized
- `404` - Not Found
- `409` - Conflict (duplicate, business logic violation)
- `422` - Unprocessable Entity (validation failed)
- `500` - Server Error

---

## Token Expiration

- Access tokens expire after **30 days**
- Use the refresh token endpoint to get a new token before expiration
- The `expiresAt` field in auth responses indicates token expiration time
