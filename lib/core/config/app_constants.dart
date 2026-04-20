class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'YourAppName';
  static const String appVersion = '1.0.0';

  // Durations
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration snackbarDuration = Duration(seconds: 3);
  static const Duration debounceDelay = Duration(milliseconds: 500);

  // Limits
  static const int otpLength = 6;
  static const int otpResendableAfter = 30;

  // Regex
  static const String emailRegex =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phoneRegex = r'^\+?[0-9]{8,15}$';
  static const String passwordRegex =
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';

  // Supported Locales
  static const List<String> supportedLocales = ['en', 'ar', 'fr'];
  static const String defaultLocale = 'en';
}
