import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';

ThemeData get kCustomTheme => ThemeData.light().copyWith(
  scaffoldBackgroundColor: CustomColor.scaffoldBg,
  
  // General Theme
  primaryColor: CustomColor.primary,
  colorScheme: const ColorScheme.light(
    primary: CustomColor.primary,
    secondary: CustomColor.secondary,
    surface: CustomColor.bgLight1,
    error: CustomColor.error,
  ),
  
  // Text Theme
  textTheme: GoogleFonts.poppinsTextTheme().copyWith(
    headlineLarge: const TextStyle(
      color: CustomColor.textGold,
      fontSize: 32,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.5,
    ),
    headlineMedium: const TextStyle(
      color: CustomColor.textPrimary,
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.3,
    ),
    titleLarge: const TextStyle(
      color: CustomColor.primary,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
    ),
    titleMedium: const TextStyle(
      color: CustomColor.textAccent,
      fontSize: 18,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
    ),
    bodyLarge: const TextStyle(
      color: CustomColor.textPrimary,
      fontSize: 16,
      letterSpacing: 0.5,
      height: 1.5,
    ),
    bodyMedium: const TextStyle(
      color: CustomColor.textSecondary,
      fontSize: 14,
      letterSpacing: 0.25,
      height: 1.4,
    ),
    labelLarge: const TextStyle(
      color: CustomColor.primary,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    ),
  ),
  
  // Card Theme
  cardTheme: CardTheme(
    color: CustomColor.bgLight1,
    elevation: 4,
    shadowColor: CustomColor.primary.withOpacity(0.2),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(
        color: CustomColor.secondary.withOpacity(0.1),
        width: 1,
      ),
    ),
  ),
  
  // Button Theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: CustomColor.primary,
      foregroundColor: CustomColor.textLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      shadowColor: CustomColor.primary.withOpacity(0.3),
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
      textStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        letterSpacing: 0.5,
      ),
    ),
  ),
  
  // Input Decoration Theme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: CustomColor.bgLight1,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: CustomColor.secondary.withOpacity(0.2),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: CustomColor.primary,
        width: 2,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: CustomColor.secondary.withOpacity(0.2),
      ),
    ),
    labelStyle: const TextStyle(
      color: CustomColor.textSecondary,
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: CustomColor.error,
        width: 2,
      ),
    ),
  ),
  
  // Icon Theme
  iconTheme: const IconThemeData(
    color: CustomColor.primary,
    size: 24,
  ),
  
  // Divider Theme
  dividerTheme: DividerThemeData(
    color: CustomColor.secondary.withOpacity(0.2),
    thickness: 1,
    space: 24,
  ),
);
