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
    tertiary: CustomColor.accent,
    surface: CustomColor.bgLight1,
  ),
  
  // Text Theme
  textTheme: GoogleFonts.poppinsTextTheme().copyWith(
    headlineLarge: TextStyle(
      color: CustomColor.textPrimary,
      fontSize: 42,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.5,
      shadows: [
        Shadow(
          color: CustomColor.primary.withValues(alpha: 0.2),
          offset: const Offset(2, 2),
          blurRadius: 4,
        ),
      ],
    ),
    headlineMedium: const TextStyle(
      color: CustomColor.textPrimary,
      fontSize: 28,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.3,
    ),
    titleLarge: const TextStyle(
      color: CustomColor.accent,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
    ),
    bodyLarge: const TextStyle(
      color: CustomColor.textPrimary,
      fontSize: 16,
      letterSpacing: 0.5,
      height: 1.6,
    ),
    bodyMedium: const TextStyle(
      color: CustomColor.textSecondary,
      fontSize: 14,
      letterSpacing: 0.25,
      height: 1.5,  
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
      shadowColor: CustomColor.primary.withValues(alpha: 0.4),
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
      textStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        fontSize: 16,
        letterSpacing: 0.5,
      ),
    ),
  ),
  
  // Card Theme
  cardTheme: CardThemeData(
    color: CustomColor.bgLight1,
    elevation: 8,
    shadowColor: CustomColor.primary.withValues(alpha: 0.1),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
  
  // Input Decoration Theme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: CustomColor.bgLight1,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: CustomColor.grey.withValues(alpha: 0.3),
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
        color: CustomColor.grey.withValues(alpha: 0.3),
      ),
    ),
    hoverColor: CustomColor.primary.withValues(alpha: 0.3),
    labelStyle: TextStyle(
      color: CustomColor.textSecondary.withValues(alpha: 0.8),
    ),
    floatingLabelStyle: const TextStyle(
      color: CustomColor.primary,
    ),
  ),
  
  // Icon Theme
  iconTheme: const IconThemeData(
    color: CustomColor.primary,
    size: 24,
  ),
  
  // Floating Action Button Theme
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: CustomColor.secondary,
    foregroundColor: CustomColor.textLight,
    elevation: 4,
    splashColor: CustomColor.yellow.withValues(alpha: 0.3),
  ),
);
