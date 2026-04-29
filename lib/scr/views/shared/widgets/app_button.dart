import 'package:flutter/material.dart';
import '../../../../core/utils/extensions/num_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../enums/app_enums.dart';
import 'app_text.dart';

// ─────────────────────────────────────────────────────────────
//  AppButton
// ─────────────────────────────────────────────────────────────

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isLoading;
  final bool isFullWidth;
  final double? width;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.lg,
    this.prefixIcon,
    this.suffixIcon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.width,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
  });

  const AppButton.primary({
    super.key,
    required this.label,
    this.onPressed,
    this.size = AppButtonSize.lg,
    this.prefixIcon,
    this.suffixIcon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.width,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
  }) : variant = AppButtonVariant.primary;

  const AppButton.secondary({
    super.key,
    required this.label,
    this.onPressed,
    this.size = AppButtonSize.lg,
    this.prefixIcon,
    this.suffixIcon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.width,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
  }) : variant = AppButtonVariant.secondary;

  const AppButton.outline({
    super.key,
    required this.label,
    this.onPressed,
    this.size = AppButtonSize.lg,
    this.prefixIcon,
    this.suffixIcon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.width,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
  }) : variant = AppButtonVariant.outline;

  const AppButton.ghost({
    super.key,
    required this.label,
    this.onPressed,
    this.size = AppButtonSize.md,
    this.prefixIcon,
    this.suffixIcon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.width,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
  }) : variant = AppButtonVariant.ghost;

  const AppButton.danger({
    super.key,
    required this.label,
    this.onPressed,
    this.size = AppButtonSize.lg,
    this.prefixIcon,
    this.suffixIcon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.width,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
  }) : variant = AppButtonVariant.danger;

  Color get _primary => AppColors.primary;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? 12.circular;

    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        width: isFullWidth ? double.infinity : width,
        height: _height,
        decoration: _decoration(radius),
        alignment: Alignment.center,
        child: isLoading ? _loader() : _content(),
      ),
    );
  }

  Widget _content() {
    return Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (prefixIcon != null) ...[prefixIcon!, 10.horizontalSpace],
        AppText(label, style: _textStyle()),
        if (suffixIcon != null) ...[10.horizontalSpace, suffixIcon!],
      ],
    );
  }

  Widget _loader() {
    return SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: textColor ?? _defaultTextColor,
      ),
    );
  }

  BoxDecoration _decoration(BorderRadius radius) {
    return BoxDecoration(
      color: backgroundColor ?? _defaultBackgroundColor,
      borderRadius: radius,
      border: _border(),
    );
  }

  Border? _border() {
    if (variant == AppButtonVariant.outline) {
      return Border.all(color: borderColor ?? _primary, width: 1.5);
    }
    if (variant == AppButtonVariant.social) {
      return Border.all(color: borderColor ?? AppColors.border, width: 1.5);
    }
    return null;
  }

  Color get _defaultBackgroundColor {
    switch (variant) {
      case AppButtonVariant.primary:
        return _primary;
      case AppButtonVariant.secondary:
        return AppColors.grey100;
      case AppButtonVariant.outline:
      case AppButtonVariant.social:
      case AppButtonVariant.ghost:
        return Colors.transparent;
      case AppButtonVariant.danger:
        return AppColors.error;
    }
  }

  Color get _defaultTextColor {
    switch (variant) {
      case AppButtonVariant.primary:
      case AppButtonVariant.danger:
        return AppColors.white;
      case AppButtonVariant.secondary:
        return AppColors.textPrimary;
      case AppButtonVariant.outline:
      case AppButtonVariant.social:
        return AppColors.textPrimary;
      case AppButtonVariant.ghost:
        return _primary;
    }
  }

  double get _height {
    switch (size) {
      case AppButtonSize.sm:
        return 36;
      case AppButtonSize.md:
        return 44;
      case AppButtonSize.lg:
        return 52;
    }
  }

  TextStyle _textStyle() {
    final base =
        size == AppButtonSize.sm ? AppTextStyles.buttonMd : AppTextStyles.buttonLg;
    return base.copyWith(color: textColor ?? _defaultTextColor);
  }
}
