import 'dart:developer';
import 'dart:io';
import 'package:doha_graduation_project/core/utils/extensions/context_ext.dart';
import 'package:doha_graduation_project/core/utils/validators.dart';
import 'package:doha_graduation_project/scr/controllers/auth_notifier.dart';
import 'package:doha_graduation_project/scr/views/screens/auth/email_not_approved_screen.dart';
import 'package:doha_graduation_project/scr/views/screens/auth/verify_email_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/extensions/num_ext.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_text.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../shared/widgets/app_utils.dart';

class CreateAccountScreen extends ConsumerStatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  ConsumerState<CreateAccountScreen> createState() =>
      _CreateAccountScreenState();
}

class _CreateAccountScreenState extends ConsumerState<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  String? _selectedSection;
  File? _photo;

  static const List<String> _sections = ["Student", "Faculty"];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _mobileCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _photo = File(picked.path));
    }
  }

  Future<void> _onContinue() async {
    if (!_formKey.currentState!.validate()) return;
    if (_photo == null) {
      context.showCommonSnackbar(
        title: "Validation Error",
        message: "Please upload your image",
        backgroundColor: AppColors.error,
      );
    }

    final authNotifier = ref.read(authNotifierProvider.notifier);

    final response = await authNotifier.signup(
      email: _emailCtrl.text.trim(),
      phoneNumber: _mobileCtrl.text.trim(),
      image: _photo!,
      onEmailNotApproved: () {
        log(
          "====================>>>>>>>>>>>>>>>>>> showing not approve dialog",
        );
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const EmailNotApprovedDialog(),
        );
      },
      context: context,
    );

    if (response != null && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VerifyEmailScreen(email: _emailCtrl.text.trim()),
        ),
      );
    }
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
        title: const AppText.h3('Create Account'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              24.verticalSpace,

              // ─── Photo upload ─────────────────────────────
              Center(
                child: GestureDetector(
                  onTap: _pickPhoto,
                  child: Stack(
                    alignment: AlignmentGeometry.bottomRight,
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.white,
                          border: Border.all(
                            color: AppColors.border,
                            width: 2,
                            style: BorderStyle.solid,
                          ),
                          image: _photo != null
                              ? DecorationImage(
                                  image: FileImage(_photo!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _photo == null
                            ? const Icon(
                                Icons.image_outlined,
                                size: 32,
                                color: AppColors.grey600,
                              )
                            : null,
                      ),
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.camera_alt_outlined,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              10.verticalSpace,
              const Center(child: AppText.bodySm('Upload your photo')),

              28.verticalSpace,

              // ─── Email ────────────────────────────────────
              AppTextField(
                label: 'Email',
                hint: 'ahmed@university.edu',
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                helperText: '✦  Only approved university emails accepted',
                suffixIcon: const Icon(
                  Icons.alternate_email_rounded,
                  color: AppColors.grey500,
                  size: 20,
                ),
                validator: Validators.email,
              ),

              16.verticalSpace,

              // ─── Mobile ───────────────────────────────────
              AppTextField(
                label: 'Mobile',
                hint: '+974 5555 1234',
                controller: _mobileCtrl,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                suffixIcon: const Icon(
                  Icons.smartphone_outlined,
                  color: AppColors.grey500,
                  size: 20,
                ),
                validator: Validators.phone,
              ),

              16.verticalSpace,

              // ─── Section dropdown ─────────────────────────
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText.labelLg(
                    'Role',
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                  6.verticalSpace,
                  DropdownButtonFormField<String>(
                    value: _selectedSection,
                    hint: const AppText.bodyMd(
                      'Select your role',
                      color: AppColors.textgrey,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
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
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                    ),
                    validator: (v) =>
                        v == null ? 'Please select your section' : null,
                    onChanged: (v) => setState(() => _selectedSection = v),
                    items: _sections
                        .map(
                          (s) => DropdownMenuItem(
                            value: s,
                            child: AppText.bodyMd(s),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),

              36.verticalSpace,

              // ─── Continue button ──────────────────────────
              ValueListenableBuilder<bool>(
                valueListenable: ref
                    .read(authNotifierProvider.notifier)
                    .isLoading,
                builder: (context, isLoading, _) {
                  return AppButton.primary(
                    label: 'Continue to Verify',
                    onPressed: _onContinue,
                    isLoading: isLoading,
                    borderRadius: 50.circular,
                  );
                },
              ),
              20.verticalSpace,

              // ─── Already registered ───────────────────────
              const AppDividerWithLabel('Already Registered'),

              12.verticalSpace,

              AppButton.ghost(
                label: 'Sign In',
                isFullWidth: true,
                onPressed: () => Navigator.of(context).pop(),
                textColor: AppColors.primary,
              ),

              24.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
