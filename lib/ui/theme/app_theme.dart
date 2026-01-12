import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_fonts.dart';

abstract final class AppTextStyles {
  static const header1 = TextStyle(
    fontFamily: AppFonts.montserrat,
    fontWeight: FontWeight.w700,
    fontSize: 30,
    height: 1.17,
  );

  static const header2 = TextStyle(
    fontFamily: AppFonts.montserrat,
    fontWeight: FontWeight.w700,
    fontSize: 60,
    height: 0.58,
  );

  static const body1 = TextStyle(
    fontFamily: AppFonts.montserrat,
    fontWeight: FontWeight.w300,
    fontSize: 24,
    height: 1.08,
    letterSpacing: 0.5,
  );

  static const body2 = TextStyle(
    fontFamily: AppFonts.montserrat,
    fontWeight: FontWeight.w600,
    fontSize: 22,
    height: 1.27,
  );

  static const body3 = TextStyle(
    fontFamily: AppFonts.montserrat,
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 1.25,
    letterSpacing: 0.1,
  );

  static const body4 = TextStyle(
    fontFamily: AppFonts.montserrat,
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 1.33,
    letterSpacing: 0.5,
  );
}

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: AppColors.background1,
  fontFamily: AppFonts.montserrat,
  colorScheme: const ColorScheme.light(
    primary: AppColors.accentPrimary,
    secondary: AppColors.accentSecondary,
    error: AppColors.layerError,
    surface: AppColors.layerPrimary,
    onPrimary: AppColors.textPrimary,
    onSecondary: AppColors.textPrimary,
    onSurface: AppColors.textSecondary,
    onError: AppColors.textPrimary,
  ),
  textTheme: const TextTheme(
    displayLarge: AppTextStyles.header2,
    displayMedium: AppTextStyles.header1,
    bodyLarge: AppTextStyles.body1,
    titleMedium: AppTextStyles.body2,
    bodyMedium: AppTextStyles.body3,
    bodySmall: AppTextStyles.body4,
  ),
);

