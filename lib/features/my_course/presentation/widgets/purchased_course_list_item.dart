import 'package:flutter/material.dart';
import 'package:online_course/core/constants/app_colors.dart';
import 'package:online_course/core/utils/custom_text.dart';
import 'package:online_course/features/my_course/data/source/purchased_courses_data.dart';

class PurchasedCourseListItem extends StatelessWidget {
  final PurchasedCourseModel course;
  final VoidCallback onTap;
  final VoidCallback? onContinueTap;

  const PurchasedCourseListItem({
    super.key,
    required this.course,
    required this.onTap,
    this.onContinueTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Course Image
            Container(
              width: 120,
              height: 140,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                image: DecorationImage(
                  image: AssetImage(course.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Course Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomText(
                            text: course.title,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlueDark,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            isSemibold: true,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accentOrange.withValues(alpha:0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: CustomText(
                            text: course.category,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accentOrange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    CustomText(
                      text: 'By ${course.instructor}',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkTextSecondary,
                    ),
                    const SizedBox(height: 6),
                    // Rating and Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: 14,
                              color: AppColors.accentOrange,
                            ),
                            const SizedBox(width: 3),
                            CustomText(
                              text: '${course.rating}',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryBlueDark,
                            ),
                          ],
                        ),
                        CustomText(
                          text: '₹${course.price.toStringAsFixed(0)}',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accentOrangeDark,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Progress Bar with Details
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text:
                                  '${course.completedLessons}/${course.totalLessons} lessons',
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: AppColors.darkTextSecondary,
                            ),
                            CustomText(
                              text:
                                  '${course.progressPercentage.toStringAsFixed(0)}%',
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accentOrange,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: LinearProgressIndicator(
                            value: course.progressPercentage / 100,
                            minHeight: 5,
                            backgroundColor: AppColors.darkTextSecondary
                                .withValues(alpha:0.15),
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
            // Continue Button or Completed Badge
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: course.progressPercentage >= 100
                  ? Container(
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha:0.15),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.check_circle,
                        color: AppColors.success,
                        size: 24,
                      ),
                    )
                  : GestureDetector(
                      onTap: onContinueTap,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.accentOrange,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: AppColors.white,
                          size: 24,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
