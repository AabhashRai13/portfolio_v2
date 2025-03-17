import 'package:flutter/material.dart';

import '../constants/colors.dart';

ThemeData get kCustomTheme => ThemeData.light().copyWith(
  scaffoldBackgroundColor: CustomColor.scaffoldBg,
  
  // General Theme
  primaryColor: CustomColor.primary,
  colorScheme: const ColorScheme.light(
    primary: CustomColor.primary,
    secondary: CustomColor.secondary,
  ),
  
  // Text Theme
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      color: CustomColor.textPrimary,
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: TextStyle(
      color: CustomColor.textPrimary,
      fontSize: 24,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: TextStyle(
      color: CustomColor.textPrimary,
      fontSize: 16,
    ),
    bodyMedium: TextStyle(
      color: CustomColor.textSecondary,
      fontSize: 14,
    ),
  ),
  
  // Card Theme
  cardTheme: CardTheme(
    color: CustomColor.bgLight1,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  
  // Button Theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: CustomColor.primary,
      foregroundColor: CustomColor.textLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 12,
      ),
      textStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
    ),
  ),
);
