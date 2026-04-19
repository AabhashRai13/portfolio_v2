import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:my_portfolio/constants/dark_colors.dart';
import 'package:my_portfolio/core/resources/styles/blog_palette.dart';

final TextTheme _baseTextTheme = GoogleFonts.poppinsTextTheme(
  ThemeData.dark().textTheme,
);

ThemeData get kDarkTheme => ThemeData.dark().copyWith(
      scaffoldBackgroundColor: DarkColor.scaffoldBg,
      primaryColor: DarkColor.primary,
      colorScheme: const ColorScheme.dark(
        primary: DarkColor.primary,
        secondary: DarkColor.secondary,
        tertiary: DarkColor.accent,
        surface: DarkColor.surfaceElevated,
        onSurface: DarkColor.textPrimary,
      ),
      extensions: const <ThemeExtension<dynamic>>[
        BlogPalette.dark,
      ],
      textTheme: _baseTextTheme.copyWith(
        headlineLarge: _baseTextTheme.headlineLarge?.copyWith(
          color: DarkColor.textPrimary,
          fontSize: 42,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
        headlineMedium: _baseTextTheme.headlineMedium?.copyWith(
          color: DarkColor.textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
        titleLarge: _baseTextTheme.titleLarge?.copyWith(
          color: DarkColor.accent,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
        ),
        bodyLarge: _baseTextTheme.bodyLarge?.copyWith(
          color: DarkColor.textPrimary,
          fontSize: 16,
          letterSpacing: 0.5,
          height: 1.6,
        ),
        bodyMedium: _baseTextTheme.bodyMedium?.copyWith(
          color: DarkColor.textSecondary,
          fontSize: 14,
          letterSpacing: 0.25,
          height: 1.5,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DarkColor.primary,
          foregroundColor: DarkColor.scaffoldBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          shadowColor: Colors.black.withValues(alpha: 0.4),
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
      cardTheme: CardThemeData(
        color: DarkColor.surfaceElevated,
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      dividerColor: DarkColor.dividerSoft,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: DarkColor.surfaceSubtle,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: DarkColor.borderSoft),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: DarkColor.primary,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: DarkColor.borderSoft),
        ),
        hoverColor: DarkColor.primary.withValues(alpha: 0.12),
        labelStyle: const TextStyle(color: DarkColor.textSecondary),
        floatingLabelStyle: const TextStyle(color: DarkColor.primary),
        hintStyle: const TextStyle(color: DarkColor.textMuted),
      ),
      iconTheme: const IconThemeData(
        color: DarkColor.primary,
        size: 24,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: DarkColor.secondary,
        foregroundColor: DarkColor.textLight,
        elevation: 4,
      ),
    );
