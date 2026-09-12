import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Shimmer.fromColors(
              baseColor: AppColors.white60,
              highlightColor: Colors.grey.shade100,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Shimmer.fromColors(
            baseColor: AppColors.white60,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: 110,
              height: 12,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Shimmer.fromColors(
            baseColor: AppColors.white60,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: 60,
              height: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}