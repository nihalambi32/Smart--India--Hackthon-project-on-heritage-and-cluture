// app_theme.dart
// Theme configuration for Virasat – Roots & Radiance
// Smart India Hackathon 2026

import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors inspired by Indian Heritage and Architecture
  static const Color primaryCrimson = Color(0xFF8B2500); // Royal Terracotta / Sandstone Red
  static const Color primaryDark = Color(0xFF5E1700);
  static const Color primaryLight = Color(0xFFC04E26);

  static const Color accentGold = Color(0xFFD4AF37); // Royal Temple Brass / Antique Gold
  static const Color saffronWarm = Color(0xFFE26D28); // Festive Saffron
  static const Color peacockTeal = Color(0xFF0F4C5C); // Peacock Feather Teal / Heritage Lakes
  static const Color emeraldHeritage = Color(0xFF2D6A4F); // Sacred Grove Emerald

  static const Color backgroundLight = Color(0xFFFAF7F2); // Warm Ivory / Sandstone Cream
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardSurface = Color(0xFFFFFFFF);
  static const Color borderSubtle = Color(0xFFEBDDCB); // Warm Sandstone Outline

  static const Color textPrimary = Color(0xFF271C17); // Deep Espresso
  static const Color textSecondary = Color(0xFF6B584E); // Earthy Taupe
  static const Color textMuted = Color(0xFF9A887E);

  // Dark Theme Palette
  static const Color backgroundDark = Color(0xFF141211);
  static const Color surfaceDark = Color(0xFF1F1C1A);
  static const Color cardSurfaceDark = Color(0xFF2A2623);
  static const Color borderSubtleDark = Color(0xFF3E3834);
  static const Color textPrimaryDark = Color(0xFFF3ECE4);
  static const Color textSecondaryDark = Color(0xFFB5A69B);

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryCrimson,
      scaffoldBackgroundColor: backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: primaryCrimson,
        onPrimary: Colors.white,
        primaryContainer: Color(0xFFFFDBCF),
        onPrimaryContainer: primaryDark,
        secondary: peacockTeal,
        onSecondary: Colors.white,
        secondaryContainer: Color(0xFFC7E7EE),
        onSecondaryContainer: Color(0xFF042932),
        tertiary: accentGold,
        onTertiary: Colors.black,
        surface: surfaceLight,
        onSurface: textPrimary,
        error: Color(0xFFBA1A1A),
        onError: Colors.white,
      ),
      fontFamily: 'serif',
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundLight,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 2,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          fontFamily: 'serif',
        ),
        iconTheme: IconThemeData(color: primaryCrimson),
      ),
      cardTheme: CardTheme(
        color: cardSurface,
        elevation: 1.5,
        shadowColor: primaryCrimson.withOpacity(0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderSubtle, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryCrimson,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryCrimson,
          side: const BorderSide(color: primaryCrimson, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        selectedColor: primaryCrimson.withOpacity(0.12),
        secondarySelectedColor: primaryCrimson,
        labelStyle: const TextStyle(
          color: textPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        secondaryLabelStyle: const TextStyle(
          color: primaryCrimson,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: borderSubtle),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        hintStyle: const TextStyle(color: textMuted, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderSubtle),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryCrimson, width: 2),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: borderSubtle,
        thickness: 1,
        space: 24,
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: saffronWarm,
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: saffronWarm,
        onPrimary: Colors.black,
        primaryContainer: Color(0xFF672300),
        onPrimaryContainer: Color(0xFFFFDBCF),
        secondary: accentGold,
        onSecondary: Colors.black,
        surface: surfaceDark,
        onSurface: textPrimaryDark,
      ),
      cardTheme: CardTheme(
        color: cardSurfaceDark,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderSubtleDark, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundDark,
        foregroundColor: textPrimaryDark,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: textPrimaryDark,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          fontFamily: 'serif',
        ),
      ),
    );
  }
}
