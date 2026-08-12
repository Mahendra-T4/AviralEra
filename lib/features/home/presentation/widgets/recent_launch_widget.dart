import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:online_course/core/constants/app_colors.dart';
import 'package:online_course/core/utils/custom_text.dart';
import 'package:online_course/features/my_course/presentation/page/course_details-page.dart';

class RecentLaunchWidget extends StatelessWidget {
  const RecentLaunchWidget({super.key});

  static const List<Map<String, dynamic>> _recentLaunches = [
    {
      'title': 'Advanced UI/UX in Flutter',
      'instructor': 'Sarah Connor',
      'price': 2500,
      'thumbnail': 'assets/images/app-covor-image.jpg',
      'tag': 'New',
      'tagColor': Color(0xFF11998E),
      'rating': '4.9',
    },
    {
      'title': 'Next.js 14 Fullstack',
      'instructor': 'Mike Johnson',
      'price': 3200,
      'thumbnail': 'assets/images/react_covor_image.jpg',
      'tag': 'Trending',
      'tagColor': Color(0xFF4776E6),
      'rating': '4.8',
    },
    {
      'title': 'Figma Prototyping',
      'instructor': 'Emma Watson',
      'price': 1800,
      'thumbnail': 'assets/images/graphic-covor-image.jpg',
      'tag': 'Hot',
      'tagColor': Color(0xFFE6550A),
      'rating': '4.7',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBgColor = isDark ? AppColors.darkSurface : Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _SectionHeader(
            title: 'Recently Launched',
            actionLabel: 'See All',
            onAction: () {},
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 158,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _recentLaunches.length,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: 16, right: 4),
            itemBuilder: (context, index) {
              final course = _recentLaunches[index];
              final tagColor = course['tagColor'] as Color;

              return GestureDetector(
                onTap: () {
                  GoRouter.of(context).pushNamed(CourseDetailsPage.routeName);
                },
                child: Container(
                  width: 310,
                  margin: const EdgeInsets.only(right: 12, bottom: 6),
                  decoration: BoxDecoration(
                    color: cardBgColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.black.withValues(alpha: 0.04),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Thumbnail
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                        child: Stack(
                          children: [
                            Image.asset(
                              course['thumbnail'],
                              width: 108,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Container(
                              width: 108,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.25),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Tag badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: tagColor.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  course['tag'],
                                  style: TextStyle(
                                    color: tagColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              CustomText(
                                text: course['title'],
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.getTextColor(context),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.person_outline_rounded,
                                    size: 12,
                                    color: AppColors.getSecondaryTextColor(context),
                                  ),
                                  const SizedBox(width: 3),
                                  Flexible(
                                    child: CustomText(
                                      text: course['instructor'],
                                      fontSize: 11,
                                      color: AppColors.getSecondaryTextColor(context),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '₹${course['price']}',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF4776E6),
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star_rounded,
                                        size: 13,
                                        color: Color(0xFFFFB800),
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        course['rating'],
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.getSecondaryTextColor(
                                              context),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Reusable section header with accent indicator
class _SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _SectionHeader({
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4776E6), Color(0xFF8E54E9)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.getTextColor(context),
                letterSpacing: -0.4,
              ),
            ),
          ],
        ),
        if (actionLabel != null && onAction != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              actionLabel!,
              style: const TextStyle(
                color: Color(0xFFE6550A),
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
      ],
    );
  }
}
