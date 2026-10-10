import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flutter/material.dart';

class EditProfileSubmitButton extends StatelessWidget {
  final ValueNotifier<bool> isEnabledNotifier;
  final double screenHeight;
  final AppLocalizations localizations;
  final VoidCallback onSubmit;

  const EditProfileSubmitButton({
    super.key,
    required this.isEnabledNotifier,
    required this.screenHeight,
    required this.localizations,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isEnabledNotifier,
      builder: (context, isEnabled, _) {
        return SizedBox(
          width: double.infinity,
          height: screenHeight * 0.06,
          child: ElevatedButton(
            onPressed: isEnabled ? onSubmit : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.purpleBase,
              disabledBackgroundColor: AppColors.white80,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Text(localizations.update, style: AppStyles.medium16Inter),
          ),
        );
      },
    );
  }
}
