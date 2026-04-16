#  Auth Module API Documentation

This document outlines the requests and responses for the Authentication module in the Enaya Project.

##  Base Configuration
- **Content-Type:** `application/json`
- **Accept:** `application/json`

---

## 1. Login
Authenticates a user and returns a session token.

- **Endpoint:** `/auth/login`
- **Method:** `POST`

###  Request Body
```json
{
  "usernameOrEmail": "user@example.com",
  "password": "password123"
}
```

###  Response (Success)
```json
{
  "success": true,
  "data": {
    "user": {
      "id": 1,
      "email": "user@example.com",
      "userName": "John Doe",
      "phone": "+966500000000",
      "roleId": 2
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expiresAt": "2025-12-31T23:59:59Z"
  },
  "error": null,
  "errorCode": null
}
```

---

## 2. Signup (Patients Only)
Registers a new patient account.

- **Endpoint:** `/auth/signup`
- **Method:** `POST`

###  Request Body
```json
{
  "userName": "John Doe",
  "email": "john.doe@example.com",
  "password": "securePassword123",
  "phone": "+966501234567"
}
```

###  Response (Success)
Same structure as **Login Response**.

---

## 3. Forgot Password
Triggers a password reset email.

- **Endpoint:** `/auth/forgot-password`
- **Method:** `POST`

###  Request Body
```json
{
  "email": "user@example.com"
}
```

###  Response
```json
{
  "success": true,
  "message": "Reset link has been sent to your email",
  "error": null,
  "errorCode": null
}
```

---

## 4. Logout
Invalidates the current session token.

- **Endpoint:** `/auth/logout`
- **Method:** `POST`
- **Headers:** `Authorization: Bearer <token>`

###  Response
```json
{
  "success": true,
  "message": "Logged out successfully",
  "error": null
}
```

---

## 5. Refresh Token
Obtains a new access token using an existing one.

- **Endpoint:** `/auth/refresh-token`
- **Method:** `POST`

###  Response
```json
{
  "success": true,
  "token": "new_access_token_here",
  "expiresAt": "2025-12-31T23:59:59Z",
  "error": null
}
```

---

## 🛠 Role IDs Reference
| Role ID | Role Name    | Description                         |
|---------|--------------|-------------------------------------|
| 1       | Receptionist | Access to receptionist dashboard    |
| 2       | Doctor       | Access to doctor dashboard          |
| 3       | Patient      | Access to patient mobile app        |


---

## ⚠️ Standard Error Response
In case of any failure (4xx or 5xx), the response will follow this structure:

```json
{
  "success": false,
  "data": null,
  "error": "Detailed error message here",
  "errorCode": 401
}
```
