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
