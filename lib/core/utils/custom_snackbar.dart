import 'package:flutter/material.dart';
import 'package:online_course/core/constants/app_colors.dart';

enum SnackBarType { success, error, warning, info }

enum SnackBarPosition { top, bottom }

class CustomSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
    SnackBarPosition position = SnackBarPosition.bottom,
    SnackBarAction? action,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color backgroundColor;
    Color textColor;
    IconData iconData;
    Color accentColor;

    switch (type) {
      case SnackBarType.success:
        backgroundColor = isDark
            ? AppColors.successDark
            : AppColors.successLight;
        textColor = isDark ? AppColors.success : AppColors.successDark;
        accentColor = AppColors.success;
        iconData = Icons.check_circle_rounded;
        break;
      case SnackBarType.error:
        backgroundColor = isDark ? AppColors.errorDark : AppColors.errorLight;
        textColor = isDark ? AppColors.error : AppColors.errorDark;
        accentColor = AppColors.error;
        iconData = Icons.error_rounded;
        break;
      case SnackBarType.warning:
        backgroundColor = isDark
            ? AppColors.warningDark
            : AppColors.warningLight;
        textColor = isDark ? AppColors.warning : AppColors.warningDark;
        accentColor = AppColors.warning;
        iconData = Icons.warning_rounded;
        break;
      case SnackBarType.info:
        backgroundColor = isDark ? AppColors.infoDark : AppColors.infoLight;
        textColor = isDark ? AppColors.info : AppColors.infoDark;
        accentColor = AppColors.info;
        iconData = Icons.info_rounded;
        break;
    }

    if (position == SnackBarPosition.top) {
      _showTopSnackBar(
        context,
        message: message,
        backgroundColor: backgroundColor,
        textColor: textColor,
        accentColor: accentColor,
        iconData: iconData,
        duration: duration,
      );
    } else {
      final snackBar = SnackBar(
        content: Row(
          children: [
            Container(
              width: 4,
              height: 30,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Icon(iconData, color: accentColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        elevation: 8,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        duration: duration,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: action,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  static void _showTopSnackBar(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    required Color textColor,
    required Color accentColor,
    required IconData iconData,
    required Duration duration,
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 16,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha:0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 30,
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(iconData, color: accentColor, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }

  static void success(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
    SnackBarPosition position = SnackBarPosition.bottom,
  }) {
    show(
      context,
      message: message,
      type: SnackBarType.success,
      duration: duration,
      position: position,
    );
  }

  static void error(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackBarPosition position = SnackBarPosition.bottom,
  }) {
    show(
      context,
      message: message,
      type: SnackBarType.error,
      duration: duration,
      position: position,
    );
  }

  static void warning(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackBarPosition position = SnackBarPosition.bottom,
  }) {
    show(
      context,
      message: message,
      type: SnackBarType.warning,
      duration: duration,
      position: position,
    );
  }

  static void info(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackBarPosition position = SnackBarPosition.bottom,
  }) {
    show(
      context,
      message: message,
      type: SnackBarType.info,
      duration: duration,
      position: position,
    );
  }
}
