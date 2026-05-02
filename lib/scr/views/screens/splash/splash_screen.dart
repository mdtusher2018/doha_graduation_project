import 'package:doha_graduation_project/core/di/core_providers.dart';
import 'package:doha_graduation_project/core/services/storage/storage_key.dart';
import 'package:doha_graduation_project/core/theme/app_colors.dart';
import 'package:doha_graduation_project/core/utils/extensions/context_ext.dart';

import 'package:doha_graduation_project/core/utils/helper.dart';
import 'package:doha_graduation_project/scr/views/screens/dashboard/dashboard_screen.dart';

import 'package:doha_graduation_project/scr/views/screens/splash/role_selection_screen.dart';
import 'package:doha_graduation_project/scr/views/shared/designs/background_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Splash / intro screen — mimics the PDF cover page
/// Navigates to SignInScreen after 2.5 s
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
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

    Future.delayed(const Duration(milliseconds: 2500), () async {
      if (mounted) {
        final token = await ref
            .read(localStorageProvider)
            .read(StorageKey.accessToken);
        if (token != null && decodeJwtPayload(token)['role'] != "staff") {
          context.navigateTo(DashboardScreen(), clearStack: true);
        } else {
          context.navigateTo(const RoleSelectionScreen());
        }
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
