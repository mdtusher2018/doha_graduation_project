// otp_response.dart

class OtpResponse {
  final bool success;
  final String message;
  final OtpData data;

  OtpResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: OtpData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class OtpData {
  final String otpToken;

  OtpData({required this.otpToken});

  factory OtpData.fromJson(Map<String, dynamic> json) {
    return OtpData(otpToken: json['otpToken'] as String);
  }
}
