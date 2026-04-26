class ApiConstants {
  static const String baseUrl = "https://enaya-backend-production.up.railway.app/api/";
  static const String login = "auth/login";
  static const String logout = "auth/logout";
  static const String signup = "auth/signup";
  static const String forgotPassword = "auth/forgot-password";
  static const String resetPassword = "auth/reset-password";
  static const String changePassword = "auth/change-password";
  static const String sendEmailVerification = "auth/send-email-verification";
  static const String verifyEmail = "auth/verify-email";
  static const String refreshToken = "auth/refresh-token";
  
  // Dashboard
  static const String receptionistDashboard = "/dashboard/receptionist";

  // Storage Keys
  static const String tokenKey = "user_token";
  static const String refreshTokenKey = "refresh_token";
  static const String userDataKey = "user_data";
  static const String tokenExpiryKey = "token_expiry";
}
