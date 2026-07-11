# Appointments API Documentation (Enaya App)
**Version:** 1.0.0 (API-Ready Draft)

This document specifies the required endpoints for the Appointments feature. The Frontend state management is already optimized to consume these structures.

---

## 1. List & Filter Appointments
`GET /appointments`

Fetches a paginated list of appointments with support for advanced filtering (Receptionist, Doctor, and Patient views).

**Query Parameters:**
| Parameter | Type | Required | Description |
| :--- | :--- | :--- | :--- |
| `page` | Integer | No | Page number for pagination (Default: 1) |
| `limit` | Integer | No | Items per page (Default: 50) |
| `doctor_id` | String | No | Filter by specific doctor |
| `patient_id` | String | No | Filter by specific patient |
| `status` | String | No | Filter by status (scheduled, arrived, completed, etc.) |
| `date` | String | No | Start date (ISO 8601: YYYY-MM-DD) |
| `end_date` | String | No | End date for range search |
| `query` | String | No | Search by patient name or appointment ID |

**Response (Success):**
```json
{
  "data": [
    {
      "id": "app-123",
      "patient_id": "p1",
      "patient_name": "Ahmed Ali",
      "doctor_id": "d1",
      "doctor_name": "Dr. Sarah",
      "date_time": "2026-05-28T10:30:00Z",
      "status": "scheduled",
      "reason": "Dental Checkup",
      "queue_number": 5
    }
  ],
  "meta": {
    "current_page": 1,
    "total_pages": 10,
    "total_items": 500
  }
}
```

---

## 2. Create Appointment
`POST /appointments`

Creates a new medical appointment.

**Request Body:**
```json
{
  "patient_id": "p1",
  "doctor_id": "d1",
  "date_time": "2026-05-28T10:30:00Z",
  "reason": "Consultation",
  "notes": "Patient has previous history"
}
```

**Validation Errors (422 Unprocessable Entity):**
The Frontend is ready to map these fields automatically.
```json
{
  "message": "Validation failed",
  "errors": {
    "date_time": "This slot is already booked by another user",
    "doctor_id": "Doctor is unavailable on selected date"
  }
}
```

---

## 3. Update Status (Business Logic)
`PATCH /appointments/{id}/status`

Used by Doctors (Start Visit, Complete) and Receptionists (Check-in).

**Request Body:**
```json
{
  "status": "arrived",
  "reason": "Patient reached clinic", 
  "updated_by": "receptionist_id"
}
```

---

## 4. Reschedule Appointment
`PUT /appointments/{id}/reschedule`

**Request Body:**
```json
{
  "new_date_time": "2026-05-30T11:00:00Z"
}
```

---

## 5. Dashboard Statistics
`GET /appointments/stats`

Fetches summary numbers for the Dashboard grids.

**Query Parameters:** `date`, `doctor_id`.

**Response:**
```json
{
  "total": 45,
  "scheduled": 10,
  "arrived": 5,
  "completed": 25,
  "cancelled": 5
}
```

---

## 6. Doctor Availability (Slots)
`GET /doctors/{id}/available-slots`

**Query Parameters:** `date` (YYYY-MM-DD).

**Response:**
```json
{
  "slots": [
    "09:00", "09:30", "10:00", "14:00"
  ]
}
```

---

### Implementation Notes for Backend:
1. **Concurrency:** Handle race conditions for the same time slot using transactions.
2. **Audit Log:** Any status change should be logged with the user ID who initiated it.
3. **Pagination:** Ensure headers include total count for the `hasMore` logic in the app.
