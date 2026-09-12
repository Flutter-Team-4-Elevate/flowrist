import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/core/ui/widgets/app_text_field.dart';
import 'package:flutter/material.dart';

class EditProfilePasswordField extends StatelessWidget {
  final TextEditingController controller;
  final AppLocalizations localizations;
  final VoidCallback onChangePassword;

  const EditProfilePasswordField({
    super.key,
    required this.controller,
    required this.localizations,
    required this.onChangePassword,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: localizations.password,
      hint: localizations.password,
      controller: controller,
      obscureText: true,
      validator: (_) => null,
      suffixIcon: TextButton(
        onPressed: onChangePassword,
        child: Text(
          localizations.change,
          style: AppStyles.medium16Inter.copyWith(color: AppColors.purpleBase),
        ),
      ),
      localizations: localizations,
    );
  }
}
