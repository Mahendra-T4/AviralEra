import 'package:alert_info/alert_info.dart';
import 'package:flutter/material.dart';
import 'package:online_course/core/constants/app_colors.dart';

enum ToastType { success, error, warning, info }

class ToastUtils {
  static void showToast(
    BuildContext context,
    ToastType type,
    Color? textColor, {
    required String message,
    IconData? icon,
  }) {
    AlertInfo.show(
      padding: 60,
      context: context,
      text: message,
      duration: 3,

      backgroundColor: type == ToastType.success
          ? AppColors.successDark
          : type == ToastType.error
          ? AppColors.errorDark
          : type == ToastType.warning
          ? AppColors.warningDark
          : AppColors.infoDark,
      icon: icon,
      textColor: textColor,
    );
  }
}
