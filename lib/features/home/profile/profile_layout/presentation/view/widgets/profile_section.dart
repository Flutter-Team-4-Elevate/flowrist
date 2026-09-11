import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileSection extends StatelessWidget {
  final List<Widget> children;
  final bool showBottomDivider;

  const ProfileSection({
    super.key,
    required this.children,
    this.showBottomDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...children,
        if (showBottomDivider)
          const Divider(height: 1, thickness: 2, color: AppColors.white60),
      ],
    );
  }
}
