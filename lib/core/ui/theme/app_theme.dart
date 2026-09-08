import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    colorSchemeSeed: AppColors.purpleBase,
    scaffoldBackgroundColor: AppColors.whiteBase,

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.whiteBase,
      titleSpacing: 25,
      elevation: 0,
      titleTextStyle: AppStyles.medium20,
      iconTheme: IconThemeData(color: AppColors.blackBase, size: 20),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: AppColors.purpleBase,
      unselectedItemColor: AppColors.white80,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.purpleBase,
        elevation: 0,
        textStyle: AppStyles.medium16Inter,
        foregroundColor: AppStyles.medium16Inter.color,
        disabledBackgroundColor: AppColors.grey20,
        padding: EdgeInsets.symmetric(vertical: 14),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        overlayColor: Colors.red,
        elevation: 0,
        textStyle: AppStyles.medium16Roboto,
        foregroundColor: AppStyles.medium16Roboto.color,
        disabledBackgroundColor: AppColors.grey20,
        side: BorderSide(color: AppColors.grey30),
        padding: EdgeInsets.symmetric(vertical: 14),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      floatingLabelStyle: WidgetStateTextStyle.resolveWith((states) {
        if (states.contains(WidgetState.error)) {
          return const TextStyle(color: AppColors.red);
        }
        return const TextStyle(color: AppColors.grey);
      }),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: AppColors.red, width: 1),
      ),

      errorStyle: TextStyle(color: AppColors.red),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: AppColors.red, width: 1),
      ),

      floatingLabelBehavior: FloatingLabelBehavior.always,
      hintStyle: TextStyle(color: AppColors.grey),
      labelStyle: TextStyle(color: AppColors.grey),
      contentPadding: EdgeInsets.only(top: 16, bottom: 16, left: 16),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: AppColors.grey90, width: 1.3),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: AppColors.grey90, width: 1.3),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: AppColors.grey90, width: 1.6),
      ),
    ),
  );
}
