import 'package:flutter/material.dart';
import 'package:online_course/core/constants/app_colors.dart';
import 'package:online_course/core/utils/custom_text.dart';

class NoInternetPage extends StatelessWidget {
  // final VoidCallback onRetry;
  static const String routeName = '/no-internat';

  const NoInternetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : AppColors.veryLightGray;
    final iconBgColor = isDark
        ? AppColors.white.withValues(alpha: 0.05)
        : AppColors.primaryBlue.withValues(alpha: 0.05);
    final iconColor = isDark ? AppColors.white : AppColors.primaryBlue;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Animated Illustration / Icon Container
              Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.wifi_off_rounded,
                  size: 100,
                  color: iconColor,
                ),
              ),
              const SizedBox(height: 40),

              // Title
              CustomText(
                text: 'Ooops!',
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.getTextColor(context),
                isSemibold: true,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Subtitle
              CustomText(
                text: 'No Internet Connection Found.',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.getTextColor(context),
                isSemibold: true,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomText(
                  text:
                      'Please check your internet connection and try again to continue learning.',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.getSecondaryTextColor(context),
                  textAlign: TextAlign.center,
                  // height: 1.5,
                ),
              ),
              const SizedBox(height: 48),

              // Retry Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Try Again',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
