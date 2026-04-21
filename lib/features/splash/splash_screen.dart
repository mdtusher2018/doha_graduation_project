import 'dart:math';

import 'package:doha_graduation_project/core/theme/app_colors.dart';
import 'package:doha_graduation_project/features/auth/sign_in_screen.dart';
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

              child: CustomPaint(
                size: const Size(500, 500),
                painter: SymbolPatternPainter(),
              ),
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

class SymbolPainter extends CustomPainter {
  final double t; // 0.0 → small/tight, 1.0+ → large/wide

  SymbolPainter({this.t = 0.5});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    canvas.translate(center.dx, center.dy);

    final paint = Paint()
      ..color = const Color.fromARGB(255, 255, 0, 21)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    final s = size.width * 0.25 * t;

    /// 🔴 TOP ARM
    canvas.save();
    canvas.translate(0, -s * 2);
    _drawArm(canvas, paint, size);
    canvas.restore();

    /// 🔴 BOTTOM ARM (flipped)
    canvas.save();
    canvas.translate(s, s * 2);
    canvas.rotate(pi);
    _drawArm(canvas, paint, size);
    canvas.restore();

    /// 🔺 LEFT TRIANGLE (rotated 90°)
    canvas.save();
    canvas.translate(-s * 2 + 20, s / 2);
    canvas.rotate(-pi / 2);
    _drawTriangle(canvas, paint, size);
    canvas.restore();

    /// 🔺 RIGHT TRIANGLE (rotated 90°)
    canvas.save();
    canvas.translate(s * 2 + 30, -s / 2);
    canvas.rotate(pi / 2);
    _drawTriangle(canvas, paint, size);
    canvas.restore();
  }

  void _drawArm(Canvas canvas, Paint paint, Size size) {
    final s = size.width * 0.25 * t; // master scale

    Path path = Path();

    // 🔺 Triangle
    path.moveTo(0, 0);
    path.lineTo(1.0 * s, 0);
    path.lineTo(1.2 * s, 0.2 * s);
    path.lineTo(0.5 * s, 1.0 * s);
    path.lineTo(-0.2 * s, 0.2 * s);
    path.close();

    canvas.drawPath(path, paint);

    // 🔁 Curve
    path = Path();

    path.moveTo(-1.2 * s, 0);

    path.quadraticBezierTo(-0.6 * s, 1.2 * s, 0.5 * s, 1.6 * s);

    path.quadraticBezierTo(1.5 * s, 1.2 * s, 2.2 * s, 0);

    canvas.drawPath(path, paint);
  }

  void _drawTriangle(Canvas canvas, Paint paint, Size size) {
    final s = size.width * 0.25 * t;

    Path path = Path();

    // 🔺 Triangle
    path.moveTo(0, 0);
    path.lineTo(1.0 * s, 0);
    path.lineTo(1.2 * s, 0.2 * s);
    path.lineTo(0.5 * s, 1.0 * s);
    path.lineTo(-0.2 * s, 0.2 * s);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant SymbolPainter oldDelegate) {
    return oldDelegate.t != t;
  }
}

class SymbolPatternPainter extends CustomPainter {
  final double t;

  SymbolPatternPainter({this.t = 0.25});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    const double tileSize = 140.0;

    for (double x = 0; x < size.width; x += tileSize) {
      for (double y = 0; y < size.height; y += tileSize) {
        canvas.save();

        // move to tile center
        canvas.translate(x + tileSize / 2, y + tileSize / 2);

        // optional rotation variation for pattern feel
        canvas.rotate((x + y) % 2 == 0 ? 0 : pi / 2);

        _drawSymbol(canvas, paint, tileSize, size);

        canvas.restore();
      }
    }
  }

  void _drawSymbol(Canvas canvas, Paint paint, double tileSize, Size size) {
    final s = tileSize * 0.25 * t;

    /// 🔴 TOP ARM
    canvas.save();
    canvas.translate(0, -s * 2);
    _drawArm(canvas, paint, size);
    canvas.restore();

    /// 🔴 BOTTOM ARM (flipped)
    canvas.save();
    canvas.translate(s + 80 * t, s * 2 + 260 * t);
    canvas.rotate(pi);
    _drawArm(canvas, paint, size);
    canvas.restore();

    /// 🔺 LEFT TRIANGLE (rotated 90°)
    canvas.save();
    canvas.translate(-s * 2 - 90 * t, s / 2 + 180 * t);
    canvas.rotate(-pi / 2);
    _drawTriangle(canvas, paint, size);
    canvas.restore();

    /// 🔺 RIGHT TRIANGLE (rotated 90°)
    canvas.save();
    canvas.translate(s * 2 + 200 * t, -s / 2 + 100 * t);
    canvas.rotate(pi / 2);
    _drawTriangle(canvas, paint, size);
    canvas.restore();
  }

  void _drawArm(Canvas canvas, Paint paint, Size size) {
    final s = size.width * 0.25 * t; // master scale

    Path path = Path();

    // 🔺 Triangle
    path.moveTo(0, 0);
    path.lineTo(1.0 * s, 0);
    path.lineTo(1.2 * s, 0.2 * s);
    path.lineTo(0.5 * s, 1.0 * s);
    path.lineTo(-0.2 * s, 0.2 * s);
    path.close();

    canvas.drawPath(path, paint);

    // 🔁 Curve
    path = Path();

    path.moveTo(-1.2 * s, 0);

    path.quadraticBezierTo(-0.6 * s, 1.2 * s, 0.5 * s, 1.6 * s);

    path.quadraticBezierTo(1.5 * s, 1.2 * s, 2.2 * s, 0);

    canvas.drawPath(path, paint);
  }

  void _drawTriangle(Canvas canvas, Paint paint, Size size) {
    final s = size.width * 0.25 * t;

    Path path = Path();

    // 🔺 Triangle
    path.moveTo(0, 0);
    path.lineTo(1.0 * s, 0);
    path.lineTo(1.2 * s, 0.2 * s);
    path.lineTo(0.5 * s, 1.0 * s);
    path.lineTo(-0.2 * s, 0.2 * s);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant SymbolPatternPainter oldDelegate) {
    return oldDelegate.t != t;
  }
}
