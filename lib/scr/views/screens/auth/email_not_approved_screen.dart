import 'package:doha_graduation_project/core/utils/extensions/context_ext.dart';
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

              AppText.h2(
                context.l10n.emailNotApproved,
                textAlign: TextAlign.center,
              ),

              12.verticalSpace,

              AppText.bodyMd(
                context.l10n.emailNotApprovedMessage,
                textAlign: TextAlign.center,
                color: AppColors.textSecondary,
              ),

              24.verticalSpace,

              AppButton.primary(
                label: context.l10n.closeButton,
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
