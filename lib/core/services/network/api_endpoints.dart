class ApiEndpoints {
  ApiEndpoints._();

  // ─── Auth ───────────────────────────────────────────────────────────────────
  static const String login = '/auth/login';
  static const String staffLogin = '/auth/login/staff';
  static const String register = '/users/register';
  static const String refreshToken = '/auth/refresh-token';

  // ─── OTP ────────────────────────────────────────────────────────────────────
  static const String verifyOtp = '/otp/verify-otp';
  static const String resendOtp = '/otp/resend-otp';

  static const String dashboard = "/all-data";

  static const String baseImageUrl = "http://10.10.10.78:5000";
}
