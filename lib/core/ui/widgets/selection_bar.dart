import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_dimensions.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flutter/material.dart';

class SelectionBar extends StatelessWidget {
  final List<String> items;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const SelectionBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.defaultScreenPadding,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (context, index) {
          return const SizedBox(width: 24);
        },
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () => onItemSelected(index),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 3,
                    color: isSelected
                        ? AppColors.purple60
                        : AppColors.white70,
                  ),
                ),
              ),
              child: Text(
                items[index],
                style: AppStyles.regular16.copyWith(
                  color: isSelected ? AppColors.purple60 : AppColors.white70,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
