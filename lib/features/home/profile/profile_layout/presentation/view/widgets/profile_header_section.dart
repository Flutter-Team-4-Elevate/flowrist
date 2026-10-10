import 'package:flowrist/core/constants/app_images.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfileHeaderSection extends StatelessWidget {
  final String userName;
  final String userEmail;
  final VoidCallback onEditName;

  const ProfileHeaderSection({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.onEditName,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final avatarDiameter = screenSize.width * 0.22;

    return Column(
      children: [
        SizedBox(height: screenSize.height * 0.015),
        ClipOval(
          child: SvgPicture.asset(
            AppImages.appLogo,
            width: avatarDiameter,
            height: avatarDiameter,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: screenSize.height * 0.012),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              userName,
              style: AppStyles.medium18Inter.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: .8),
              ),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: onEditName,
              child: Icon(
                Icons.edit_outlined,
                size: 16,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: .8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          userEmail,
          style: AppStyles.regular14Inter.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: .8),
          ),
        ),
        SizedBox(height: screenSize.height * 0.025),
      ],
    );
  }
}
