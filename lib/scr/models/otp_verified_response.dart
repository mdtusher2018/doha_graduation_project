// otp_verification_response.dart

class OtpVerificationResponse {
  final bool success;
  final String message;
  final OtpVerificationData data;

  OtpVerificationResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory OtpVerificationResponse.fromJson(Map<String, dynamic> json) {
    return OtpVerificationResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: OtpVerificationData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class OtpVerificationData {
  final String accessToken;
  final String refreshToken;

  OtpVerificationData({required this.accessToken, required this.refreshToken});

  factory OtpVerificationData.fromJson(Map<String, dynamic> json) {
    return OtpVerificationData(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }
}
