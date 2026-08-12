import 'package:flutter/material.dart';
import 'package:online_course/core/constants/app_colors.dart';
import 'package:online_course/core/utils/custom_text.dart';
import 'package:online_course/features/home/data/source/metor_data.dart';

class TopMentors extends StatelessWidget {
  const TopMentors({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Top Mentors', style: Theme.of(context).textTheme.titleLarge),
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: mentors.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final isDark = Theme.of(context).brightness == Brightness.dark;
                final cardBgColor = isDark ? AppColors.darkSurface : Colors.white;
                final avatarBgColor = isDark
                    ? AppColors.white.withValues(alpha: 0.1)
                    : AppColors.primaryBlueDark.withValues(alpha: 0.1);
                final avatarIconColor =
                    isDark ? AppColors.darkTextPrimary : AppColors.primaryBlueDark;

                return Container(
                  width: 120,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cardBgColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha:0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: avatarBgColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          mentors[index].imageUrl,
                          size: 30,
                          color: avatarIconColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: CustomText(
                          text: mentors[index].mentorName,
                          textAlign: TextAlign.center,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.getTextColor(context),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
