import 'package:flutter/material.dart';
import '../../../../core/utils/extensions/num_ext.dart';
import '../../../../core/theme/app_colors.dart';

/// Base card container
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? color;
  final BorderRadius? borderRadius;
  final Border? border;
  final List<BoxShadow>? boxShadow;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.color,
    this.borderRadius,
    this.border,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color ?? AppColors.white,
          borderRadius: borderRadius ?? 16.circular,
          border: border ?? Border.all(color: AppColors.border, width: 1),
          boxShadow: boxShadow ??
              [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
        ),
        child: ClipRRect(
          borderRadius: borderRadius ?? 16.circular,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: padding ?? 16.paddingAll,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
