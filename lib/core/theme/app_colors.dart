import 'package:flutter/material.dart';

/// Doha Institute for Graduate Studies — Brand Colors
abstract class AppColors {
  // ─── Brand ──────────────────────────────────────────────
  static const Color primary = Color(0xFF7B1C35); // Crimson
  static const Color primaryLight = Color.fromARGB(255, 175, 35, 75);
  static const Color primaryDark = Color(0xFF5A1226);

  // ─── Surface ─────────────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF2F2F2);
  static const Color surface = Color(0xFFFFFFFF);

  // ─── Text ────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF5A5A5A);
  static const Color textgrey = Color(0xFF9E9E9E);

  // ─── Border / Divider ────────────────────────────────────
  static const Color border = Color.fromARGB(255, 189, 185, 185);
  static const Color divider = Color.fromARGB(255, 31, 31, 31);

  // ─── Greys ───────────────────────────────────────────────
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color black = Color(0xFF000000);

  // ─── Status ──────────────────────────────────────────────
  static const Color success = Color(0xFF27a900);
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color error = Color(0xFFD32F2F);
  static const Color errorLight = Color(0xFFFFEBEE);
  static const Color warning = Color(0xFFF57C00);
  static const Color warningLight = Color(0xFFFFF3E0);
  static const Color info = Color.fromARGB(255, 0, 38, 255);
  static const Color infoLight = Color(0xFFE3F2FD);

  // ─── Shimmer ─────────────────────────────────────────────
  static const Color shimmer = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);

  // ─── Accent ──────────────────────────────────────────────
  static const Color accent = Color(0xFF7B1C35);
  static const Color star = Color(0xFFFFC107);
}
