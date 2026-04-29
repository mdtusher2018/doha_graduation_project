import 'package:dio/dio.dart';
import 'package:doha_graduation_project/core/services/network/interceptors/auth_interceptor.dart';
import 'package:doha_graduation_project/core/services/network/interceptors/refresh_token_interceptor.dart';
import 'package:doha_graduation_project/core/services/storage/local_storage_service.dart';
import 'package:doha_graduation_project/core/services/storage/local_storage_service_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'core_providers.g.dart';


@riverpod
AuthInterceptor authInterceptor(Ref ref) {
  return AuthInterceptor(ref.read(localStorageProvider));
}

@riverpod
RefreshTokenInterceptor refreshTokenInterceptor(Ref ref, Dio dio) {
  return RefreshTokenInterceptor(
    dio: dio,
    secureStorage: ref.read(localStorageProvider),
  );
}

@riverpod
LocalStorageService localStorage(Ref ref) {
  final local = LocalStorageServiceImpl();
  return local;
}
