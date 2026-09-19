import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/features/home/home/presentation/home_layout/view/widgets/shimmer_widgets/banner_shimmer.dart';
import 'package:flowrist/features/home/home/presentation/home_layout/view/widgets/shimmer_widgets/category_shimmer.dart';
import 'package:flowrist/features/home/home/presentation/home_layout/view/widgets/shimmer_widgets/header_shimmer.dart';
import 'package:flowrist/features/home/home/presentation/home_layout/view/widgets/shimmer_widgets/occasion_shimmer.dart';
import 'package:flowrist/features/home/home/presentation/home_layout/view/widgets/shimmer_widgets/product_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.white40,
      highlightColor: AppColors.white60,

      child: ListView(
        padding: EdgeInsets.zero,
        children: const [
          HeaderShimmer(),
          BannerShimmer(),
          CategoryShimmer(),
          ProductShimmer(),
          OccasionShimmer(),
        ],
      ),
    );
  }
}
