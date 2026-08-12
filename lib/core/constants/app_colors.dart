import 'package:flutter/material.dart';

class AppColors {
  /// Private constructor to prevent instantiation
  AppColors._();

  static const Color primaryBlue = Color(0xFF1F4788);

  /// Lighter shade of primary blue for interactions
  static const Color primaryBlueDark = Color(0xFF21426b);

  static const Color accentOrange = Color(0xFFF5b24d);

  static const Color darkOrange = Color(0xFFfb7d2a);

  static const Color darkGrey = Color(0xFF2b2b2b);

  /// Light blue for backgrounds and disabled states
  static const Color primaryBlueLight = Color(0xFFf3f4f6);

  /// Very light blue for subtle backgrounds
  static const Color primaryBlueLighter = Color(0xFFF5F9FF);

  // ============================================================================
  // SECONDARY COLORS - Complementary Colors
  // ============================================================================

  /// Vibrant accent color for CTAs and highlights
  /// Used for secondary buttons and interactive elements

  /// Darker orange for hover/pressed states
  static const Color accentOrangeDark = Color(0xFFE67E00);

  /// Light orange for backgrounds
  static const Color accentOrangeLight = Color(0xFFFFF5E6);

  // ============================================================================
  // TERTIARY COLORS - Additional Brand Colors
  // ============================================================================

  /// Professional purple for special features
  static const Color tertiaryPurple = Color(0xFF7C3AED);

  /// Light purple for backgrounds
  static const Color tertiaryPurpleLight = Color(0xFFF3E8FF);

  // ============================================================================
  // STATUS COLORS - Semantic Colors for Feedback
  // ============================================================================

  /// Success state - Green
  static const Color success = Color(0xFF10B981);
  static const Color successDark = Color(0xFF059669);
  static const Color successLight = Color(0xFFECFDF5);

  /// Error state - Red
  static const Color error = Color(0xFFEF4444);
  static const Color errorDark = Color(0xFFDC2626);
  static const Color errorLight = Color(0xFFFEE2E2);

  /// Warning state - Amber
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningDark = Color(0xFFD97706);
  static const Color warningLight = Color(0xFFFEF3C7);

  /// Info state - Cyan
  static const Color info = Color(0xFF06B6D4);
  static const Color infoDark = Color(0xFF0891B2);
  static const Color infoLight = Color(0xFFECF3FF);

  // ============================================================================
  // NEUTRAL COLORS - Grayscale
  // ============================================================================

  /// Pure black for text and strong contrasts
  static const Color black = Color(0xFF000000);

  /// Dark gray for primary text and icons
  static const Color darkGray = Color(0xFF1F2937);

  /// Medium gray for secondary text
  static const Color mediumGray = Color(0xFF6B7280);

  /// Light gray for borders and dividers
  static const Color lightGray = Color(0xFFE5E7EB);

  /// Very light gray for backgrounds
  static const Color veryLightGray = Color(0xFFF9FAFB);

  /// Almost white for card backgrounds
  static const Color offWhite = Color(0xFFFAFAFA);

  /// Pure white
  static const Color white = Color(0xFFFFFFFF);

  // ============================================================================
  // DARK MODE COLORS
  // ============================================================================

  /// Dark background for dark mode
  static const Color darkBackground = Color(0xFF121212);

  /// Dark surface for dark mode cards
  static const Color darkSurface = Color(0xFF1E1E1E);

  /// Dark text primary for dark mode
  static const Color darkTextPrimary = Color(0xFFFFFFFF);

  /// Dark text secondary for dark mode
  static const Color darkTextSecondary = Color(0xFFB3B3B3);

  // ============================================================================
  // GRADIENT COLORS
  // ============================================================================

  /// Primary blue gradient (for decorative backgrounds)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, primaryBlueDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Orange accent gradient
  static const LinearGradient accentGradient = LinearGradient(
    colors: [accentOrange, accentOrangeDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Premium gradient (blue to purple)
  static const LinearGradient premiumGradient = LinearGradient(
    colors: [primaryBlue, tertiaryPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ============================================================================
  // SHADOW COLORS
  // ============================================================================

  /// Subtle shadow for elevated elements
  static const Color shadowColor = Color(0x1F000000);

  /// Medium shadow for cards
  static const Color shadowColorMedium = Color(0x3F000000);

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Get color based on brightness (light or dark mode)
  static Color getTextColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? darkTextPrimary : darkGray;
  }

  /// Get secondary text color based on brightness
  static Color getSecondaryTextColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? darkTextSecondary : mediumGray;
  }

  /// Get background color based on brightness
  static Color getBackgroundColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? darkBackground : veryLightGray;
  }
}
