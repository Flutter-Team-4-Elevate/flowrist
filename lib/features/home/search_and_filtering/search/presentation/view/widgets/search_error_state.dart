import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flutter/material.dart';

class SearchErrorState extends StatelessWidget {
  final String errorMessage;

  const SearchErrorState({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
        child: Text(
          errorMessage,
          textAlign: TextAlign.center,
          style: AppStyles.regular14Inter.copyWith(color: AppColors.red),
        ),
      ),
    );
  }
}
