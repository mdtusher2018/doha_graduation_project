import 'package:doha_graduation_project/core/utils/extensions/validators.dart';
import 'package:doha_graduation_project/features/auth/create_account_screen.dart';
import 'package:doha_graduation_project/features/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/extensions/num_ext.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_text.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../shared/widgets/app_utils.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  void _onSignIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => _isLoading = false);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const DashboardScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                40.verticalSpace,
                // ─── Icon ────────────────────────────────────
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: 20.circular,
                  ),
                  child: const Icon(
                    Icons.login_rounded,
                    color: AppColors.white,
                    size: 32,
                  ),
                ),

                20.verticalSpace,

                AppText.h2('Sign In'),
                6.verticalSpace,
                AppText.bodyMd(
                  'Access your graduation dashboard',
                  color: AppColors.textPrimary,
                  textAlign: TextAlign.center,
                ),
                48.verticalSpace,
                // ─── Email field ──────────────────────────────
                AppTextField(
                  controller: _emailCtrl,
                  hint: 'ahmed@university.edu',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  suffixIcon: const Icon(
                    Icons.mail_outline_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  validator: Validators.email,
                  onSubmitted: (_) => _onSignIn(),
                ),

                24.verticalSpace,

                // ─── Sign In button ───────────────────────────
                AppButton.primary(
                  label: 'Sign In',
                  onPressed: _onSignIn,
                  isLoading: _isLoading,
                  borderRadius: 50.circular,
                ),

                16.verticalSpace,

                // ─── Divider ──────────────────────────────────
                const AppDividerWithLabel("Don't have an account?"),

                16.verticalSpace,

                // ─── Create account button ────────────────────
                AppButton.outline(
                  label: 'Create New Account',
                  backgroundColor: AppColors.white,
                  borderColor: AppColors.border,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateAccountScreen(),
                      ),
                    );
                  },

                  prefixIcon: const Icon(
                    Icons.auto_awesome_outlined,
                    color: AppColors.primary,
                    size: 18,
                  ),
                  borderRadius: 50.circular,
                  textColor: AppColors.primary,
                ),

                const Spacer(flex: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
