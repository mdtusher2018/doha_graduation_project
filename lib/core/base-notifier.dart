import 'package:dio/dio.dart';
import 'package:doha_graduation_project/core/theme/app_colors.dart';
import 'package:doha_graduation_project/core/utils/extensions/context_ext.dart';
import 'package:doha_graduation_project/core/utils/global_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

abstract class BaseNotifier<T> extends StateNotifier<T> {
  BaseNotifier(super.state);

  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<String?> errorMessage = ValueNotifier(null);

  Future<R?> safeCall<R>({
    required Future<R> Function() task,
    String? successMessage,
    bool showErrorSnack = true,
    bool showSuccessSnack = false,
    void Function()? onStart,
    void Function()? onComplete,

    void Function(String message, dynamic error)? onError,
  }) async {
    try {
      onStart?.call();
      isLoading.value = true;
      errorMessage.value = null;

      final result = await task();

      if (showSuccessSnack && successMessage != null) {
        final context = navigatorKey.currentContext;
        if (context != null) {
          context.showCommonSnackbar(
            title: "Success",
            message: successMessage,
            backgroundColor: AppColors.success,
          );
        }
      }

      return result;
    } catch (e, stack) {
      debugPrint("❌ Exception: $e\n$stack");

      final message = _mapErrorToMessage(e);
      errorMessage.value = message;

      // 🔥 NEW: pass raw error too
      onError?.call(message, e);

      if (showErrorSnack) {
        final context = navigatorKey.currentContext;
        if (context != null) {
          context.showCommonSnackbar(
            title: "Error",
            message: message,
            backgroundColor: AppColors.error,
          );
        }
      }

      return null;
    } finally {
      isLoading.value = false;
      onComplete?.call();
    }
  }

  String _mapErrorToMessage(dynamic error) {
    if (error is DioException) {
      final response = error.response;

      // ✅ Server responded with structured error
      if (response != null && response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;

        // 🔥 1. Try errorSources first (most specific)
        if (data['errorSources'] is List &&
            (data['errorSources'] as List).isNotEmpty) {
          final firstError = data['errorSources'][0];
          if (firstError is Map<String, dynamic>) {
            return firstError['message'] ??
                data['message'] ??
                "Something went wrong";
          }
        }

        // 🔥 2. Fallback to main message
        if (data['message'] != null) {
          return data['message'];
        }
      }

      // ❗ 3. Handle network / Dio-level issues
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return "Connection timed out. Please try again.";
        case DioExceptionType.sendTimeout:
          return "Request took too long. Try again.";
        case DioExceptionType.receiveTimeout:
          return "Server is not responding. Try later.";
        case DioExceptionType.connectionError:
          return "No internet connection.";
        case DioExceptionType.badCertificate:
          return "Security error. Please try again.";
        case DioExceptionType.cancel:
          return "Request cancelled.";
        case DioExceptionType.unknown:
        default:
          return error.message ?? "Unexpected error occurred.";
      }
    }

    // 🔸 Non-Dio errors
    return error.toString();
  }
}
