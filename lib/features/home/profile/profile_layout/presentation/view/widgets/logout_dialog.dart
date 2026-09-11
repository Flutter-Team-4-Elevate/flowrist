import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flutter/material.dart';

class LogoutDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const LogoutDialog({super.key, required this.onConfirm});

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onConfirm,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => LogoutDialog(onConfirm: onConfirm),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenSize = MediaQuery.sizeOf(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: AppColors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          screenSize.width * 0.06,
          screenSize.height * 0.035,
          screenSize.width * 0.06,
          screenSize.height * 0.025,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.logOut.toUpperCase(),
              style: AppStyles.bold20Inter.copyWith(
                fontSize: 18,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: screenSize.height * 0.015),
            Text(
              l10n.confirmLogout,
              textAlign: TextAlign.center,
              style: AppStyles.regular14Inter.copyWith(
                color: AppColors.blackBase,
              ),
            ),
            SizedBox(height: screenSize.height * 0.03),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: const StadiumBorder(),
                      side: const BorderSide(color: AppColors.white80),
                    ),
                    child: Text(
                      l10n.cancel,
                      style: AppStyles.regular14Inter.copyWith(
                        color: AppColors.blackBase,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: AppColors.purpleBase,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: const StadiumBorder(),
                    ),
                    child: Text(l10n.logOut, style: AppStyles.medium16Inter),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
