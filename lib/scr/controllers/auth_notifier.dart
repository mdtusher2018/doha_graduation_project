// auth_notifier.dart
import 'dart:io';

import 'package:doha_graduation_project/core/base-notifier.dart';
import 'package:doha_graduation_project/core/services/network/api_endpoints.dart';
import 'package:doha_graduation_project/core/services/network/dio_client.dart';
import 'package:doha_graduation_project/core/theme/app_colors.dart';
import 'package:doha_graduation_project/core/utils/extensions/context_ext.dart';

import 'package:doha_graduation_project/scr/models/otp_response.dart';
import 'package:doha_graduation_project/scr/models/otp_verified_response.dart';
import 'package:doha_graduation_project/scr/models/staff_login_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:dio/dio.dart';

final authNotifierProvider = StateNotifierProvider<AuthNotifier, void>((ref) {
  final dio = ref.read(dioClientProvider);
  return AuthNotifier(dio: dio);
});

class AuthNotifier extends BaseNotifier<void> {
  AuthNotifier({required this.dio}) : super(null);

  final Dio dio;

  // ─── Signup ─────────────────────────────
  Future<OtpResponse?> signup({
    required String email,
    required String phoneNumber,
    required File image,
    required void Function() onEmailNotApproved,
    required BuildContext context,
  }) async {
    return safeCall<OtpResponse>(
      task: () async {
        final formData = FormData.fromMap({
          'email': email,
          'phoneNumber': phoneNumber,

          // 🔥 IMAGE UPLOAD
          'profile': await MultipartFile.fromFile(
            image.path,
            filename: image.path.split('/').last,
          ),
        });

        final response = await dio.patch(
          ApiEndpoints.register,
          data: formData,

          // 🔥 IMPORTANT for multipart
          options: Options(contentType: 'multipart/form-data'),
        );

        return OtpResponse.fromJson(response.data);
      },

      showSuccessSnack: true,
      successMessage: "OTP sent to your email",

      // 🔥 SPECIAL ERROR HANDLER
      onError: (message, error) {
        if (error is DioException) {
          final data = error.response?.data;

          final isNotApproved =
              data is Map &&
              data['err'] != null &&
              data['err']['statusCode'] == 404 &&
              data['errorSources'] != null;

          final isEmailBlocked = message.contains(
            "This email is not listed yet",
          );

          if (isNotApproved || isEmailBlocked) {
            onEmailNotApproved();
          } else {
            context.showCommonSnackbar(
              title: "Error",
              message: message,
              backgroundColor: AppColors.error,
            );
          }
        }
      },
    );
  }

  // ─── Login ──────────────────────────────
  Future<OtpResponse?> login({required String email}) async {
    return safeCall<OtpResponse>(
      task: () async {
        final response = await dio.post(
          ApiEndpoints.login,
          data: {'email': email},
        );
        return OtpResponse.fromJson(response.data);
      },
      showSuccessSnack: true,
      successMessage: "OTP sent to your email",
    );
  }

  Future<StaffLoginModel?> staffLogin({
    required String email,
    required String password,
  }) async {
    return safeCall<StaffLoginModel>(
      task: () async {
        final response = await dio.post(
          ApiEndpoints.staffLogin,
          data: {'email': email, "password": password},
        );
        return StaffLoginModel.fromJson(response.data);
      },
      showSuccessSnack: true,
      successMessage: "OTP sent to your email",
    );
  }

  // ─── Verify OTP ─────────────────────────
  Future<OtpVerificationResponse?> verifyOtp({required String otp}) async {
    return safeCall<OtpVerificationResponse>(
      task: () async {
        final response = await dio.post(
          ApiEndpoints.verifyOtp,
          data: {'otp': otp},
        );
        return OtpVerificationResponse.fromJson(response.data);
      },
      showSuccessSnack: true,
      successMessage: "OTP verified successfully",
    );
  }

  // ─── Resend OTP ─────────────────────────
  Future<OtpResponse?> resendOtp({required String email}) async {
    return safeCall<OtpResponse>(
      task: () async {
        final response = await dio.post(
          ApiEndpoints.resendOtp,
          data: {'email': email},
        );
        return OtpResponse.fromJson(response.data);
      },
      showSuccessSnack: true,
      successMessage: "OTP resent successfully",
    );
  }
}
