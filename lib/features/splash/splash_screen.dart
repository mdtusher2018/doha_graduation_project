import 'package:doha_graduation_project/features/auth/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';

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
      backgroundColor: const Color(0xFFF2F2F2),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ─── Geometric pattern background ───────────────
          CustomPaint(painter: _PatternPainter()),

          // ─── Centred logo ───────────────────────────────
          Center(
            child: FadeTransition(
              opacity: _fade,
              child: const _DohaInstituteLogo(),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Logo ──────────────────────────────────────────────────────────────────

class _DohaInstituteLogo extends StatelessWidget {
  const _DohaInstituteLogo();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 10 Anniversary mark
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _TenMark(),
            const SizedBox(height: 4),
            const Text(
              'ANNIVERSARY',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 9,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
                color: Color(0xFF9E9E9E),
              ),
            ),
          ],
        ),
        Container(
          width: 1,
          height: 64,
          color: const Color(0xFFBDBDBD),
          margin: const EdgeInsets.symmetric(horizontal: 16),
        ),
        // Institute name
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'DOHA INSTITUTE',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                color: Color(0xFF5A1226),
              ),
            ),
            Text(
              'FOR GRADUATE STUDIES',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 9,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.2,
                color: Color(0xFF9E9E9E),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TenMark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52,
      height: 48,
      child: Stack(
        children: [
          // Grey "10"
          const Text(
            '10',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 52,
              fontWeight: FontWeight.w800,
              height: 1,
              color: Color(0xFFCCCCCC),
            ),
          ),
          // Crimson diagonal slash overlay
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 6,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(3),
              ),
              transform: Matrix4.rotationZ(-0.3),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Background pattern ─────────────────────────────────────────────────────

class _PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFDDDDDD).withOpacity(0.5)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const step = 60.0;
    final rows = (size.height / step).ceil() + 1;
    final cols = (size.width / step).ceil() + 1;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final cx = c * step;
        final cy = r * step;
        final half = step / 2;

        // Diamond shape
        final path = Path()
          ..moveTo(cx, cy - half * 0.4)
          ..lineTo(cx + half * 0.4, cy)
          ..lineTo(cx, cy + half * 0.4)
          ..lineTo(cx - half * 0.4, cy)
          ..close();
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
