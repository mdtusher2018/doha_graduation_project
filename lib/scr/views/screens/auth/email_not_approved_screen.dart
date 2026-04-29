import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/extensions/num_ext.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_text.dart';

class EmailNotApprovedDialog extends StatelessWidget {
  const EmailNotApprovedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              const Icon(
                Icons.cancel_outlined,
                color: AppColors.primary,
                size: 40,
              ),

              24.verticalSpace,

              const AppText.h2(
                'Email not approved',
                textAlign: TextAlign.center,
              ),

              12.verticalSpace,

              const AppText.bodyMd(
                'Your email is not in the approved list.\nPlease contact the administration.',
                textAlign: TextAlign.center,
                color: AppColors.textSecondary,
              ),

              8.verticalSpace,

              // Contact card (same as before)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: 8.circular,
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _ContactRow(
                      icon: Icons.email_outlined,
                      label: 'graduation@di.edu.qa',
                    ),
                    SizedBox(height: 8),
                    _ContactRow(
                      icon: Icons.phone_outlined,
                      label: '+974 4454 1234',
                    ),
                    SizedBox(height: 8),
                    _ContactRow(
                      icon: Icons.access_time_outlined,
                      label: 'Sun – Thu, 8:00 AM – 4:00 PM',
                    ),
                  ],
                ),
              ),

              24.verticalSpace,

              AppButton.primary(
                label: 'Close',
                onPressed: () => Navigator.of(context).pop(),
                borderRadius: 50.circular,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ContactRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.grey500),
        8.horizontalSpace,
        AppText.bodySm(label, color: AppColors.textSecondary),
      ],
    );
  }
}
