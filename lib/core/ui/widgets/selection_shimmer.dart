import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class SelectionShimmer extends StatelessWidget {
  const SelectionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 5,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, _) {
          return Shimmer(
            duration: const Duration(seconds: 2),
            color: AppColors.white,
            colorOpacity: 0.5,
            child: Container(
              width: 90,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.white60,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        },
      ),
    );
  }
}
