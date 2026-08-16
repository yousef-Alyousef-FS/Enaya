class ApiConstants {
  static const String baseUrl = "https://enaya-backend.vercel.app/api/";
  // Auth
  static const String login = "auth/login";
  static const String logout = "auth/logout";
  static const String signup = "auth/signup";
  static const String me = "auth/me";
  static const String refreshToken = "auth/refresh-token";

  // Patient Profile
  static const String patientProfile = "patients/profile";
  static const String completeProfile = "patients/complete-profile";

  // Doctors
  static const String doctorsDirectory = "doctors";
  static const String adminDoctors = "admin/doctors";
  static const String departmentDoctors = "patients/department-doctors";

  // Patient Appts
  static const String patientAppointments = "patient/appointments";
  static const String patientAvailableSlots =
      "patient/appointments/available-slots";
  static const String patientAvailableDays =
      "patient/appointments/available-days";

  // Receptionist Appts
  static const String receptionPatients = "reception/patients";
  static const String receptionAppointments = "receptionist/appointments";
  static const String receptionAvailableDays =
      "receptionist/appointments/available-days";

  // Doctor Appts
  static const String doctorAppointments = "doctor/appointments";
  static const String doctorAvailableSlots =
      "doctor/appointments/available-slots";
  static const String doctorAvailableDays =
      "doctor/appointments/available-days";
  static const String doctorPatients = "doctor/{doctor}/patients";

  // Dashboards
  static const String receptionistDashboard = "receptionist/dashboard";

  // Doctor Sessions (linked to appointments)
  static String doctorSessionList(int appointmentId) =>
      "doctor/appointments/$appointmentId/sessions/list";
  static String doctorSessionStart(int appointmentId) =>
      "doctor/appointments/$appointmentId/sessions/start";
  static String doctorSessionEnd(int appointmentId) =>
      "doctor/appointments/$appointmentId/sessions/end";

  // Doctor Prescriptions (linked to sessions)
  static String doctorPrescriptions(int sessionId) =>
      "doctor/sessions/$sessionId/prescriptions";
  static String doctorPrescriptionDetail(int sessionId, int prescriptionId) =>
      "doctor/sessions/$sessionId/prescriptions/$prescriptionId";

  // Storage Keys
  static const String tokenKey = "user_token";
  static const String refreshTokenKey = "refresh_token";
  static const String userDataKey = "user_data";
  static const String tokenExpiryKey = "token_expiry";
}
