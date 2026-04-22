import 'package:doha_graduation_project/core/theme/app_colors.dart';
import 'package:doha_graduation_project/features/auth/sign_in_screen.dart';
import 'package:doha_graduation_project/shared/designs/background_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Splash / intro screen — mimics the PDF cover page
/// Navigates to SignInScreen after 2.5 s
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();

    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ─── Color-blind friendly gradient background ─────────
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                tileMode: TileMode.clamp,
                colors: [
                  Color.fromARGB(255, 255, 255, 255),
                  Color.fromARGB(255, 219, 219, 219),
                ],
              ),
            ),
          ),

          // ─── Geometric pattern overlay (optional transparency) ───
          FadeTransition(
            opacity: _fade,
            child: Opacity(
              opacity: 0.5,

              child: CustomPaint(painter: SymbolPatternPainter()),
            ),
          ),

          // ─── Centred logo ───────────────────────────────
          Center(
            child: FadeTransition(
              opacity: _fade,
              child: Image.asset(
                'assets/images/logo.png',
                width: 240,
                height: 120,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
