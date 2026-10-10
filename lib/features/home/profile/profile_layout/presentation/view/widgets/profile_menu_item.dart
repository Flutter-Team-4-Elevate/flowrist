import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flutter/material.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData? icon;
  final String title;
  final Widget? trailing;
  final VoidCallback onTap;
  final double? horizontalPadding;

  const ProfileMenuItem({
    super.key,
    this.icon,
    required this.title,
    this.trailing,
    required this.onTap,
    this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: horizontalPadding != null
          ? EdgeInsets.symmetric(horizontal: horizontalPadding!)
          : null,
      leading: icon != null
          ? Icon(
              icon,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: .7),
              size: 20,
            )
          : null,
      title: Text(
        title,
        style: AppStyles.regular14Inter.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      trailing:
          trailing ??
          Icon(
            Icons.chevron_right,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: .7),
            size: 20,
          ),
      onTap: onTap,
    );
  }
}
