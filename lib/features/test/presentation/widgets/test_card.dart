import 'package:flutter/material.dart';
import 'package:online_course/core/constants/app_colors.dart';
import 'package:online_course/core/utils/custom_text.dart';
import 'package:online_course/features/test/data/source/test_data.dart';

class TestCard extends StatelessWidget {
  final TestModel test;
  final VoidCallback onTap;

  const TestCard({super.key, required this.test, required this.onTap});

  Color _getDifficultyColor() {
    switch (test.difficulty) {
      case 'Easy':
        return AppColors.success;
      case 'Medium':
        return AppColors.warning;
      case 'Hard':
        return AppColors.error;
      default:
        return AppColors.info;
    }
  }

  Color _getStatusColor() {
    switch (test.status) {
      case 'Completed':
        return AppColors.success;
      case 'In Progress':
        return AppColors.info;
      case 'Not Started':
        return AppColors.warning;
      default:
        return AppColors.darkTextSecondary;
    }
  }

  IconData _getStatusIcon() {
    switch (test.status) {
      case 'Completed':
        return Icons.check_circle_rounded;
      case 'In Progress':
        return Icons.schedule_rounded;
      case 'Not Started':
        return Icons.lock_clock_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBgColor = isDark ? AppColors.darkSurface : Colors.white;
    final shadowColor = isDark
        ? Colors.black.withValues(alpha:0.2)
        : Colors.black.withValues(alpha:0.08);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Badge
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                gradient: LinearGradient(
                  colors: [
                    _getDifficultyColor().withValues(alpha:0.15),
                    _getDifficultyColor().withValues(alpha:0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor(),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomText(
                      text: test.difficulty,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accentOrange.withValues(alpha:0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomText(
                      text: test.testType,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accentOrange,
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: test.title,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.primaryBlueDark,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      isSemibold: true,
                    ),
                    const SizedBox(height: 4),
                    CustomText(
                      text: test.courseTitle,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppColors.darkTextSecondary.withValues(alpha:0.7)
                          : AppColors.darkTextSecondary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Test Details
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.help_outline_rounded,
                                size: 12,
                                color: AppColors.darkTextSecondary,
                              ),
                              const SizedBox(width: 3),
                              CustomText(
                                text: '${test.totalQuestions} Q',
                                fontSize: 11,
                                color: AppColors.darkTextSecondary,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.schedule_rounded,
                                size: 12,
                                color: AppColors.darkTextSecondary,
                              ),
                              const SizedBox(width: 3),
                              CustomText(
                                text: '${test.duration}m',
                                fontSize: 11,
                                color: AppColors.darkTextSecondary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Status and Score
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getStatusColor().withValues(alpha:0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _getStatusIcon(),
                                size: 14,
                                color: _getStatusColor(),
                              ),
                              const SizedBox(width: 4),
                              CustomText(
                                text: test.status,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: _getStatusColor(),
                              ),
                            ],
                          ),
                          if (test.score != null)
                            CustomText(
                              text: '${test.score!.toStringAsFixed(0)}%',
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: test.isPassed
                                  ? AppColors.success
                                  : AppColors.error,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
