import 'package:doha_graduation_project/core/di/core_providers.dart';
import 'package:doha_graduation_project/core/services/storage/storage_key.dart';
import 'package:doha_graduation_project/core/utils/extensions/context_ext.dart';
import 'package:doha_graduation_project/core/utils/validators.dart';
import 'package:doha_graduation_project/scr/controllers/auth_notifier.dart';
import 'package:doha_graduation_project/scr/views/screens/staff_dashboard/staff_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/extensions/num_ext.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_text.dart';
import '../../shared/widgets/app_text_field.dart';

class StaffSignInScreen extends ConsumerStatefulWidget {
  const StaffSignInScreen({super.key});

  @override
  ConsumerState<StaffSignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<StaffSignInScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    final authNotifier = ref.read(authNotifierProvider.notifier);

    final response = await authNotifier.staffLogin(
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text.trim(),
    );

    if (response != null && mounted) {
      ref
          .read(localStorageProvider)
          .write(StorageKey.accessToken, response.accessToken);
      context.navigateTo(StaffDashboardPage(), clearStack: true);
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
                      color: AppColors.grey500,
                      size: 20,
                    ),
                    validator: Validators.email,
                    onSubmitted: (_) => _onSignIn(),
                  ),

                  24.verticalSpace,
                  AppTextField(
                    controller: _passCtrl,
                    showPasswordToggle: true,
                    hint: 'Enter your password',
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,

                    validator: Validators.password,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
