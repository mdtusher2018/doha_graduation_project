import 'package:doha_graduation_project/core/config/flavor_config.dart';
import 'package:doha_graduation_project/core/di/core_providers.dart';
import 'package:doha_graduation_project/core/services/notification/notification_service.dart';
import 'package:doha_graduation_project/core/services/storage/local_storage_service_impl.dart';
import 'package:doha_graduation_project/core/utils/global_keys.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_colors.dart';
import 'scr/views/screens/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FlavorConfig.initialize(
    baseUrl: 'http://10.10.10.78:5000/api/v1',
    socketUrl: 'http://10.10.10.78:5000',
    googleMapsApiKey: 'YOUR_KEY',
    agoraAppId: '87317ef9a331453ca1463797ba82cd41',
    stripePublishableKey: 'STRIPE_KEY',
  );

  // Init LocalStorageService (SharedPreferences + SecureStorage) + Hive
  final localStorage = LocalStorageServiceImpl();
  await localStorage.init();

  await NotificationService.init();

  if (kDebugMode) {
    /// 🔴 Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);

      debugPrint('🔥 FLUTTER ERROR: ${details.exception}');
      debugPrint('STACK: ${details.stack}');
    };

    /// 🔴 Platform / async errors (Flutter 3.3+)
    PlatformDispatcher.instance.onError = (error, stack) {
      debugPrint('🔥 PLATFORM ERROR: $error');
      debugPrint('STACK: $stack');
      return true;
    };
  }
  runApp(
    ProviderScope(
      overrides: [localStorageProvider.overrideWithValue(localStorage)],
      child: const DohaGradApp(),
    ),
  );
}

class DohaGradApp extends StatelessWidget {
  const DohaGradApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doha Institute Graduation',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      navigatorKey: navigatorKey,
      home: SplashScreen(),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Inter',
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        background: AppColors.background,
        surface: AppColors.white,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
