import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_images.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfileAppBar extends StatelessWidget {
  final VoidCallback onNotificationTap;

  const ProfileAppBar({super.key, required this.onNotificationTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenSize = MediaQuery.sizeOf(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.05,
        vertical: screenSize.height * 0.012,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(AppImages.appLogo, height: 24, width: 24),
              const SizedBox(width: 6),
              Text(l10n.flowery, style: AppStyles.appTitle),
            ],
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: onNotificationTap,
                icon: const Icon(
                  Icons.notifications_none,
                  color: AppColors.blackBase,
                  size: 26,
                ),
              ),
              // Positioned(
              //   right: 8,
              //   top: 8,
              //   child: Container(
              //     padding: const EdgeInsets.all(4),
              //     decoration: const BoxDecoration(
              //       color: AppColors.red,
              //       shape: BoxShape.circle,
              //     ),
              //     constraints: const BoxConstraints(
              //       minWidth: 16,
              //       minHeight: 16,
              //     ),
              //     child: const Text(
              //       '3',
              //       style: TextStyle(
              //         color: AppColors.white,
              //         fontSize: 10,
              //         fontWeight: FontWeight.bold,
              //       ),
              //       textAlign: TextAlign.center,
              //     ),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
