import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isSelected;
  final Color? iconColor;

  const FilterButton({
    super.key,
    this.onPressed,
    this.isSelected = false,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor =
        iconColor ?? (isSelected ? AppColors.purpleBase : AppColors.white70);

    return SizedBox(
      height: 50,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: isSelected
              ? AppColors.lightPink
              : Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          side: BorderSide(
            color: effectiveColor,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Icon(Icons.sort, color: effectiveColor, size: 24),
      ),
    );
  }
}
