import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.purpleBase,
        foregroundColor: textColor ?? AppColors.whiteBase,
        side: borderColor != null ? BorderSide(color: borderColor!) : null,
      ),
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(
              text,
              style: AppStyles.medium16Inter.copyWith(
                color: textColor ?? AppColors.whiteBase,
              ),
            ),
    );
  }
}
