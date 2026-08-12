import 'package:flutter/material.dart';
import 'package:online_course/core/constants/app_colors.dart';

class AppTheme {
  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.primaryBlue,
    scaffoldBackgroundColor: AppColors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryBlue,
      foregroundColor: AppColors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        color: AppColors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryBlue,
        side: const BorderSide(color: AppColors.primaryBlue),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.primaryBlue),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.primaryBlueLighter,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.lightGray),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.lightGray),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: AppColors.primaryBlue,
        fontWeight: FontWeight.bold,
        fontSize: 32,
        letterSpacing: 0.5,
      ),
      displayMedium: TextStyle(
        color: AppColors.primaryBlue,
        fontWeight: FontWeight.bold,
        fontSize: 28,
        letterSpacing: 0.25,
      ),
      displaySmall: TextStyle(
        color: AppColors.primaryBlue,
        fontWeight: FontWeight.bold,
        fontSize: 24,
        letterSpacing: 0,
      ),
      headlineLarge: TextStyle(
        color: AppColors.primaryBlue,
        fontWeight: FontWeight.bold,
        fontSize: 24,
        letterSpacing: 0,
      ),
      headlineMedium: TextStyle(
        color: AppColors.primaryBlue,
        fontWeight: FontWeight.w600,
        fontSize: 20,
        letterSpacing: 0.15,
      ),
      headlineSmall: TextStyle(
        color: AppColors.primaryBlue,
        fontWeight: FontWeight.w600,
        fontSize: 18,
        letterSpacing: 0.1,
      ),
      titleLarge: TextStyle(
        color: AppColors.primaryBlue,
        fontWeight: FontWeight.w600,
        fontSize: 18,
        letterSpacing: 0.1,
      ),
      titleMedium: TextStyle(
        color: AppColors.primaryBlue,
        fontWeight: FontWeight.w600,
        fontSize: 16,
        letterSpacing: 0.15,
      ),
      titleSmall: TextStyle(
        color: AppColors.primaryBlue,
        fontWeight: FontWeight.w600,
        fontSize: 14,
        letterSpacing: 0.1,
      ),
      bodyLarge: TextStyle(color: AppColors.darkGray, fontSize: 16),
      bodyMedium: TextStyle(color: AppColors.darkGray, fontSize: 14),
      bodySmall: TextStyle(color: AppColors.mediumGray, fontSize: 12),
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryBlue,
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1E1E1E),
      foregroundColor: AppColors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        color: AppColors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryBlue,
        side: const BorderSide(color: AppColors.primaryBlue),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.primaryBlue),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2C2C2C),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF3C3C3C)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF3C3C3C)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
      ),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF1E1E1E),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: Color(0xFFF5F5F5),
        fontWeight: FontWeight.bold,
        fontSize: 32,
        letterSpacing: 0.5,
      ),
      displayMedium: TextStyle(
        color: Color(0xFFF5F5F5),
        fontWeight: FontWeight.bold,
        fontSize: 28,
        letterSpacing: 0.25,
      ),
      displaySmall: TextStyle(
        color: Color(0xFFF5F5F5),
        fontWeight: FontWeight.bold,
        fontSize: 24,
        letterSpacing: 0,
      ),
      headlineLarge: TextStyle(
        color: Color(0xFFF5F5F5),
        fontWeight: FontWeight.bold,
        fontSize: 24,
        letterSpacing: 0,
      ),
      headlineMedium: TextStyle(
        color: Color(0xFFF5F5F5),
        fontWeight: FontWeight.w600,
        fontSize: 20,
        letterSpacing: 0.15,
      ),
      headlineSmall: TextStyle(
        color: Color(0xFFF5F5F5),
        fontWeight: FontWeight.w600,
        fontSize: 18,
        letterSpacing: 0.1,
      ),
      titleLarge: TextStyle(
        color: Color(0xFFF5F5F5),
        fontWeight: FontWeight.w600,
        fontSize: 18,
        letterSpacing: 0.1,
      ),
      titleMedium: TextStyle(
        color: Color(0xFFF5F5F5),
        fontWeight: FontWeight.w600,
        fontSize: 16,
        letterSpacing: 0.15,
      ),
      titleSmall: TextStyle(
        color: Color(0xFFF5F5F5),
        fontWeight: FontWeight.w600,
        fontSize: 14,
        letterSpacing: 0.1,
      ),
      bodyLarge: TextStyle(color: Color(0xFFE0E0E0), fontSize: 16),
      bodyMedium: TextStyle(color: Color(0xFFE0E0E0), fontSize: 14),
      bodySmall: TextStyle(color: Color(0xFFB0B0B0), fontSize: 12),
    ),
  );
}
