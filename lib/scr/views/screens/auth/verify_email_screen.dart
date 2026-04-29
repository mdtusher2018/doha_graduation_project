import 'dart:async';
import 'package:doha_graduation_project/core/di/core_providers.dart';
import 'package:doha_graduation_project/core/services/storage/storage_key.dart';
import 'package:doha_graduation_project/scr/controllers/auth_notifier.dart';
import 'package:doha_graduation_project/scr/views/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/extensions/num_ext.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_text.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  final String email;
  const VerifyEmailScreen({super.key, required this.email});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  int _secondsLeft = 180;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = 180);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft == 0) {
        t.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  String get _otp => _controllers.map((c) => c.text).join();

  Future<void> _onVerify() async {
    if (_otp.length < 6) return;

    final authNotifier = ref.read(authNotifierProvider.notifier);

    final response = await authNotifier.verifyOtp(otp: _otp);

    if (response != null && mounted) {
      ref
          .read(localStorageProvider)
          .write(StorageKey.accessToken, response.data.accessToken);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
        (route) => false,
      );
    }
  }

  void _onFieldChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            size: 18,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              24.verticalSpace,
              const AppText.h2('Check Your Email'),
              10.verticalSpace,
              AppText.bodyMd(
                "We've sent a 6-digit code to",
                color: AppColors.textSecondary,
                textAlign: TextAlign.center,
              ),
              4.verticalSpace,
              AppText.bodyMd(
                widget.email,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.center,
              ),
              24.verticalSpace,
              // ─── OTP boxes ────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  6,
                  (i) => _OtpBox(
                    controller: _controllers[i],
                    focusNode: _focusNodes[i],
                    onChanged: (v) => _onFieldChanged(v, i),
                  ),
                ),
              ),

              8.verticalSpace,

              // ─── Timer / Resend ───────────────────────────
              if (_secondsLeft == 0) ...[
                GestureDetector(
                  onTap: () async {
                    final authNotifier = ref.read(
                      authNotifierProvider.notifier,
                    );

                    final response = await authNotifier.resendOtp(
                      email: widget.email,
                    );

                    if (response != null && mounted) {
                      ref
                          .read(localStorageProvider)
                          .write(
                            StorageKey.accessToken,
                            response.data.otpToken,
                          );
                      _startTimer();
                    }
                  },
                  child: const AppText.bodySm(
                    'Resend Code',
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ] else ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText.bodySm(
                      'Code expires in  ',
                      color: AppColors.textSecondary,
                    ),
                    AppText.bodySm(
                      '0:${_secondsLeft.toString().padLeft(2, '0')}',
                      color: _secondsLeft > 0
                          ? AppColors.primary
                          : AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ],
              24.verticalSpace,

              // ─── Verify button ────────────────────────────
              ValueListenableBuilder<bool>(
                valueListenable: ref
                    .read(authNotifierProvider.notifier)
                    .isLoading,
                builder: (context, isLoading, _) {
                  return AppButton.primary(
                    label: 'Verify & Continue',
                    onPressed: _otp.length == 6 ? _onVerify : null,
                    isLoading: isLoading,
                    borderRadius: 50.circular,
                    backgroundColor: _otp.length == 6
                        ? AppColors.primary
                        : AppColors.grey300,
                  );
                },
              ),

              32.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Single OTP digit box ────────────────────────────────────────────────────

class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 46,
      height: 54,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: onChanged,
        style: AppTextStyles.h3.copyWith(color: AppColors.primary),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: AppColors.white,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: 12.circular,
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: 12.circular,
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: 12.circular,
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
      ),
    );
  }
}
