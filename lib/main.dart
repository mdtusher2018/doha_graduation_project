import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart';
import 'features/splash/splash_screen.dart';

void main() {
  runApp(const DohaGradApp());
}

class DohaGradApp extends StatelessWidget {
  const DohaGradApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doha Institute Graduation',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
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
