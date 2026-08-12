import 'package:flutter/material.dart';
import 'package:online_course/core/constants/app_colors.dart';
import 'package:online_course/core/utils/custom_text.dart';
import 'package:online_course/features/my_course/data/source/purchased_courses_data.dart';

class PurchasedCourseCard extends StatelessWidget {
  final PurchasedCourseModel course;
  final VoidCallback onTap;

  const PurchasedCourseCard({
    super.key,
    required this.course,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Image with Badge
            Stack(
              children: [
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    image: DecorationImage(
                      image: AssetImage(course.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accentOrange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomText(
                      text: course.category,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
            // Course Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: course.title,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlueDark,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      isSemibold: true,
                    ),
                    const SizedBox(height: 4),
                    CustomText(
                      text: course.instructor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkTextSecondary,
                    ),
                    const SizedBox(height: 8),
                    // Rating
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 14,
                          color: AppColors.accentOrange,
                        ),
                        const SizedBox(width: 4),
                        CustomText(
                          text: '${course.rating}',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryBlueDark,
                        ),
                        const SizedBox(width: 4),
                        CustomText(
                          text: '(${course.reviewCount})',
                          fontSize: 11,
                          color: AppColors.darkTextSecondary,
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Progress Bar
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: 'Progress',
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: AppColors.darkTextSecondary,
                            ),
                            CustomText(
                              text:
                                  '${course.progressPercentage.toStringAsFixed(0)}%',
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryBlueDark,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: course.progressPercentage / 100,
                            minHeight: 4,
                            backgroundColor: AppColors.darkTextSecondary
                                .withValues(alpha:0.2),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.accentOrange,
                            ),
                          ),
                        ),
                      ],
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
