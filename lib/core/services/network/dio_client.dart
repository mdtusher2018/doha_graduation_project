import 'package:dio/dio.dart';
import 'package:doha_graduation_project/core/config/app_config.dart';
import 'package:doha_graduation_project/core/di/core_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'interceptors/logging_interceptor.dart';

part 'dio_client.g.dart';

@riverpod
Dio dioClient(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: Duration(milliseconds: AppConfig.connectTimeout),
      receiveTimeout: Duration(milliseconds: AppConfig.receiveTimeout),
      sendTimeout: Duration(milliseconds: AppConfig.sendTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.addAll([
    ref.read(authInterceptorProvider),
    ref.read(refreshTokenInterceptorProvider(dio)),
    if (!const bool.fromEnvironment('dart.vm.product')) LoggingInterceptor(),
  ]);

  return dio;
}
