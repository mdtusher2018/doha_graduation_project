import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/utils/extensions/num_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'app_text.dart';

/// Unified text field matching Doha Institute design:
/// - Outlined with subtle border
/// - Crimson focus highlight
/// - Suffix/prefix icon support
class AppTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final String? helperText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  final double borderRadius;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;
  final bool showPasswordToggle;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final TextCapitalization textCapitalization;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.helperText,
    this.controller,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.borderRadius = 12.0,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.inputFormatters,
    this.validator,
    this.autovalidateMode,
    this.showPasswordToggle = false,
    this.contentPadding,
    this.fillColor,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          AppText.labelLg(
            widget.label!,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
          6.verticalSpace,
        ],
        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          obscureText: _obscure,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          inputFormatters: widget.inputFormatters,
          validator: widget.validator,
          autovalidateMode: widget.autovalidateMode,
          textCapitalization: widget.textCapitalization,
          onTap: widget.onTap,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          style: AppTextStyles.bodyMd.copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: AppTextStyles.bodyMd.copyWith(color: AppColors.textgrey),
            errorText: widget.errorText,
            helperText: widget.helperText,
            helperStyle: AppTextStyles.bodyXs.copyWith(
              color: AppColors.textgrey,
            ),
            filled: true,
            fillColor:
                widget.fillColor ??
                (widget.enabled ? AppColors.white : AppColors.grey100),
            contentPadding:
                widget.contentPadding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            prefixIcon: widget.prefixIcon != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 14, right: 8),
                    child: widget.prefixIcon,
                  )
                : null,
            prefixIconConstraints: const BoxConstraints(
              minWidth: 44,
              minHeight: 44,
            ),
            suffixIcon: widget.showPasswordToggle
                ? _buildPasswordToggle()
                : widget.suffixIcon != null
                ? Padding(padding: 14.paddingRight, child: widget.suffixIcon)
                : null,
            suffixIconConstraints: const BoxConstraints(
              minWidth: 44,
              minHeight: 44,
            ),
            border: _border(AppColors.border),
            enabledBorder: _border(AppColors.border),
            focusedBorder: _border(AppColors.primary, width: 1.5),
            errorBorder: _border(AppColors.error),
            focusedErrorBorder: _border(AppColors.error, width: 1.5),
            disabledBorder: _border(AppColors.grey200),
            errorStyle: AppTextStyles.bodyXs.copyWith(color: AppColors.error),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordToggle() {
    return GestureDetector(
      onTap: () => setState(() => _obscure = !_obscure),
      child: Padding(
        padding: 14.paddingRight,
        child: Icon(
          _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: AppColors.grey500,
          size: 20,
        ),
      ),
    );
  }

  OutlineInputBorder _border(Color color, {double width = 2.0}) {
    return OutlineInputBorder(
      borderRadius: widget.borderRadius.circular,
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
