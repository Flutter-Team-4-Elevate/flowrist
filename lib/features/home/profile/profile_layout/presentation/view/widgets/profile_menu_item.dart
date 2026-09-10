import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flutter/material.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData? icon;
  final String title;
  final Widget? trailing;
  final VoidCallback onTap;

  const ProfileMenuItem({
    super.key,
    this.icon,
    required this.title,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      leading: icon != null
          ? Icon(icon, color: AppColors.grey, size: 20)
          : null,
      title: Text(
        title,
        style: AppStyles.regular14Inter.copyWith(color: AppColors.blackBase),
      ),
      trailing:
          trailing ??
          const Icon(Icons.chevron_right, color: AppColors.grey, size: 20),
      onTap: onTap,
    );
  }
}
