import 'package:doha_graduation_project/core/di/core_providers.dart';
import 'package:doha_graduation_project/core/services/storage/storage_key.dart';
import 'package:doha_graduation_project/core/utils/extensions/context_ext.dart';
import 'package:doha_graduation_project/core/utils/validators.dart';
import 'package:doha_graduation_project/scr/controllers/auth_notifier.dart';
import 'package:doha_graduation_project/scr/views/screens/auth/create_account_screen.dart';
import 'package:doha_graduation_project/scr/views/screens/auth/verify_email_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/extensions/num_ext.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_text.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../shared/widgets/app_utils.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _emailCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    final authNotifier = ref.read(authNotifierProvider.notifier);

    final response = await authNotifier.login(email: _emailCtrl.text.trim());

    if (response != null && mounted) {
      ref
          .read(localStorageProvider)
          .write(StorageKey.accessToken, response.data.otpToken);
      context.navigateTo(VerifyEmailScreen(email: _emailCtrl.text.trim()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authNotifier = ref.read(authNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  40.verticalSpace,

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

                  // 👇 Listen to ValueNotifier<bool>
                  ValueListenableBuilder<bool>(
                    valueListenable: authNotifier.isLoading,
                    builder: (context, isLoading, _) {
                      return AppButton.primary(
                        label: 'Sign In',
                        onPressed: _onSignIn,
                        isLoading: isLoading,
                        borderRadius: 50.circular,
                      );
                    },
                  ),

                  16.verticalSpace,

                  const AppDividerWithLabel("Don't have an account?"),

                  16.verticalSpace,

                  AppButton.outline(
                    label: 'Create New Account',
                    backgroundColor: AppColors.white,
                    borderColor: AppColors.border,
                    onPressed: () {
                      context.navigateTo(const CreateAccountScreen());
                     
                    },
                    prefixIcon: const Icon(
                      Icons.auto_awesome_outlined,
                      color: AppColors.primary,
                      size: 18,
                    ),
                    borderRadius: 50.circular,
                    textColor: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
