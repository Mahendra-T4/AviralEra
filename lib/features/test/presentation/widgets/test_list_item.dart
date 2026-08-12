import 'package:flutter/material.dart';
import 'package:online_course/core/constants/app_colors.dart';
import 'package:online_course/core/utils/custom_text.dart';
import 'package:online_course/features/test/data/source/test_data.dart';

class TestListItem extends StatelessWidget {
  final TestModel test;
  final VoidCallback onTap;
  final VoidCallback? onStartTap;

  const TestListItem({
    super.key,
    required this.test,
    required this.onTap,
    this.onStartTap,
  });

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

  String _formatDate(DateTime date) {
    return '${date.day} ${_getMonthName(date.month)} ${date.year}';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
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
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left Status Indicator
            Container(
              width: 6,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                color: _getStatusColor(),
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Badges
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomText(
                            text: test.title,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? Colors.white
                                : AppColors.primaryBlueDark,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            isSemibold: true,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: _getDifficultyColor().withValues(alpha:0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: CustomText(
                            text: test.difficulty,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: _getDifficultyColor(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Course and Type
                    Row(
                      children: [
                        Expanded(
                          child: CustomText(
                            text: test.courseTitle,
                            fontSize: 11,
                            color: isDark
                                ? AppColors.darkTextSecondary.withValues(alpha:0.7)
                                : AppColors.darkTextSecondary,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.accentOrange.withValues(alpha:0.25)
                                : AppColors.accentOrange.withValues(alpha:0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: CustomText(
                            text: test.testType,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accentOrange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Test Details Row
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
                                text: '${test.totalQuestions} Questions',
                                fontSize: 10,
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
                                fontSize: 10,
                                color: AppColors.darkTextSecondary,
                              ),
                            ],
                          ),
                        ),
                        if (test.deadline != null)
                          Expanded(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_rounded,
                                  size: 12,
                                  color: test.isExpired
                                      ? AppColors.error
                                      : AppColors.darkTextSecondary,
                                ),
                                const SizedBox(width: 3),
                                Expanded(
                                  child: CustomText(
                                    text: test.isExpired
                                        ? 'Expired'
                                        : _formatDate(test.deadline!),
                                    fontSize: 10,
                                    color: test.isExpired
                                        ? AppColors.error
                                        : AppColors.darkTextSecondary,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Status and Score Row
                    Row(
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
                            if (test.attempts > 0)
                              CustomText(
                                text:
                                    ' (${test.attempts}/${test.maxAttempts} attempts)',
                                fontSize: 9,
                                color: AppColors.darkTextSecondary,
                              ),
                          ],
                        ),
                        if (test.score != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  (test.isPassed
                                          ? AppColors.success
                                          : AppColors.error)
                                      .withValues(alpha:0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: CustomText(
                              text: '${test.score!.toStringAsFixed(0)}%',
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: test.isPassed
                                  ? AppColors.success
                                  : AppColors.error,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Action Button
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: test.status == 'Not Started'
                  ? GestureDetector(
                      onTap: onStartTap,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.accentOrange,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    )
                  : test.status == 'In Progress'
                  ? GestureDetector(
                      onTap: onStartTap,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.info,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Icon(Icons.abc, color: Colors.white, size: 20),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha:0.2),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.success,
                        size: 20,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
