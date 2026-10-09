import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static final ThemeData lightTheme = _buildTheme(brightness: Brightness.light);

  static final ThemeData darkTheme = _buildTheme(brightness: Brightness.dark);

  static ThemeData _buildTheme({required Brightness brightness}) {
    final isDark = brightness == Brightness.dark;

    final backgroundColor = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;

    final surfaceColor = isDark
        ? AppColors.darkSurface
        : AppColors.lightSurface;

    final textColor = isDark ? AppColors.darkText : AppColors.lightText;

    final secondaryTextColor = isDark
        ? AppColors.darkSecondaryText
        : AppColors.lightSecondaryText;

    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.purpleBase,
          brightness: brightness,
        ).copyWith(
          primary: AppColors.purpleBase,
          onPrimary: Colors.white,
          surface: surfaceColor,
          onSurface: textColor,
          outline: borderColor,
          onSurfaceVariant: secondaryTextColor,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: backgroundColor,
      canvasColor: backgroundColor,
      cardColor: surfaceColor,

      // Text defaults
      textTheme: ThemeData(
        brightness: brightness,
      ).textTheme.apply(bodyColor: textColor, displayColor: textColor),

      // App bar
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 25,
        elevation: 0,
        titleTextStyle: AppStyles.medium20.copyWith(color: textColor),
        iconTheme: IconThemeData(color: textColor, size: 20),
      ),

      // Bottom navigation
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: AppColors.purpleBase,
        unselectedItemColor: secondaryTextColor,
        type: BottomNavigationBarType.fixed,
      ),

      // Elevated buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.purpleBase,
          foregroundColor: Colors.white,
          elevation: 0,
          textStyle: AppStyles.medium16Inter,
          disabledBackgroundColor: isDark
              ? AppColors.darkBorder
              : AppColors.grey20,
          disabledForegroundColor: secondaryTextColor,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),

      // Outlined buttons
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor,
          overlayColor: AppColors.purpleBase.withValues(alpha: 0.08),
          elevation: 0,
          textStyle: AppStyles.medium16Roboto.copyWith(color: textColor),
          side: BorderSide(color: borderColor),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),

      // Text fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,

        floatingLabelBehavior: FloatingLabelBehavior.always,

        floatingLabelStyle: WidgetStateTextStyle.resolveWith((states) {
          if (states.contains(WidgetState.error)) {
            return const TextStyle(color: AppColors.red);
          }

          return TextStyle(color: secondaryTextColor);
        }),

        hintStyle: TextStyle(color: secondaryTextColor),
        labelStyle: TextStyle(color: secondaryTextColor),
        errorStyle: const TextStyle(color: AppColors.red),

        contentPadding: const EdgeInsets.only(
          top: 16,
          bottom: 16,
          left: 16,
          right: 16,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: borderColor, width: 1.3),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: borderColor, width: 1.3),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.purpleBase, width: 1.6),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.red, width: 1),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.red, width: 1.6),
        ),
      ),
    );
  }
}
