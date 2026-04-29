import 'package:doha_graduation_project/core/utils/extensions/context_ext.dart';
import 'package:doha_graduation_project/scr/views/screens/auth/sign_in_screen.dart';
import 'package:doha_graduation_project/scr/views/screens/auth/staff_sign_in.dart';
import 'package:doha_graduation_project/scr/views/shared/widgets/app_button.dart';
import 'package:doha_graduation_project/scr/views/shared/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:doha_graduation_project/core/theme/app_colors.dart';

import 'package:doha_graduation_project/core/utils/extensions/num_ext.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? _selectedRole;

  final List<_RoleItem> roles = const [
    _RoleItem(
      title: "Student",
      subtitle: "Access academic dashboard",
      icon: Icons.school_rounded,
    ),
    _RoleItem(
      title: "Faculty",
      subtitle: "Access Faculty dashboard",
      icon: Icons.badge_rounded,
    ),
    _RoleItem(
      title: "Staff",
      subtitle: "Administrative access",
      icon: Icons.apartment_rounded,
    ),
  ];

  void _onContinue() {
    if (_selectedRole == null) {
      context.showCommonSnackbar(
        title: "Validation Error",
        message: "Please select your role",
      );
      return;
    }
    ;
    if (_selectedRole == "Staff") {
      context.navigateTo(StaffSignInScreen(), clearStack: true);
    } else {
      context.navigateTo(SignInScreen(), clearStack: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              40.verticalSpace,

              // ─── Header ─────────────────────────────
              AppText.h1("Choose Your Role"),

              8.verticalSpace,
              AppText.bodyLg("Select how you want to use the platform"),

              32.verticalSpace,

              // ─── Role Cards ─────────────────────────
              Expanded(
                child: ListView.separated(
                  itemCount: roles.length,
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder: (_, __) => 16.verticalSpace,
                  itemBuilder: (context, index) {
                    final role = roles[index];
                    final isSelected = _selectedRole == role.title;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedRole = role.title;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withOpacity(0.08)
                              : AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.border,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            // icon
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.grey100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                role.icon,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textSecondary,
                              ),
                            ),

                            16.horizontalSpace,

                            // text
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    role.title,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  4.verticalSpace,
                                  Text(
                                    role.subtitle,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            if (isSelected)
                              const Icon(
                                Icons.check_circle,
                                color: AppColors.primary,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // ─── Continue Button ─────────────────────
              SafeArea(
                child: AppButton.primary(
                  label: "Continue",
                  onPressed: _onContinue,
                ),
              ),
              16.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleItem {
  final String title;
  final String subtitle;
  final IconData icon;

  const _RoleItem({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
