import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:online_course/core/constants/app_colors.dart';
import 'package:online_course/core/service/connectivity/connectivity_checker.dart';
import 'package:online_course/core/service/connectivity/no_internat_page.dart';
import 'package:online_course/core/utils/custom_text.dart';
import 'package:online_course/features/download/presentation/page/download.dart';

import 'package:online_course/features/my_course/data/source/purchased_courses_data.dart';
import 'package:online_course/features/my_course/presentation/page/course_details-page.dart';
import 'package:online_course/features/my_course/presentation/widgets/purchased_course_card.dart';
import 'package:online_course/features/my_course/presentation/widgets/purchased_course_list_item.dart';
import 'package:online_course/features/home/data/source/popular_data.dart';

class PurchasedCoursesPage extends StatefulWidget {
  const PurchasedCoursesPage({super.key});
  static const String routeName = '/purchased-courses';

  @override
  State<PurchasedCoursesPage> createState() => _PurchasedCoursesPageState();
}

class _PurchasedCoursesPageState extends State<PurchasedCoursesPage> {
  late List<PurchasedCourseModel> filteredCourses;
  bool isGridView = true;
  String selectedFilter = 'All';
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredCourses = List.from(purchasedCourses);
  }

  void _applyFilters() {
    filteredCourses = purchasedCourses.where((course) {
      final matchesFilter =
          selectedFilter == 'All' ||
          course.category == selectedFilter ||
          (selectedFilter == 'In Progress' &&
              course.progressPercentage < 100) ||
          (selectedFilter == 'Completed' && course.progressPercentage >= 100);

      final matchesSearch =
          searchQuery.isEmpty ||
          course.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          course.instructor.toLowerCase().contains(searchQuery.toLowerCase());

      return matchesFilter && matchesSearch;
    }).toList();
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchQuery = value;
      _applyFilters();
    });
  }

  void _toggleViewMode() {
    setState(() {
      isGridView = !isGridView;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : AppColors.veryLightGray;

    return StreamBuilder(
      stream: InternetConnectivityChecker().connectionStream,
      initialData: true, // Assume connected initially
      builder: (context, snapshot) {
        // Handle error state
        if (snapshot.hasError) {
          return const NoInternetPage();
        }

        // Handle disconnected state
        if (snapshot.data == false) {
          return const NoInternetPage();
        }

        // Handle loading state
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          backgroundColor: bgColor,
          body: CustomScrollView(
            slivers: [
              // Header Section
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 50,
                    left: 16,
                    right: 16,
                    bottom: 20,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back Button and Title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // GestureDetector(
                          //   onTap: () => Navigator.pop(context),
                          //   child: Container(
                          //     decoration: BoxDecoration(
                          //       color: Colors.white.withValues(alpha:0.2),
                          //       shape: BoxShape.circle,
                          //     ),
                          //     padding: const EdgeInsets.all(8),
                          //     child: const Icon(
                          //       Icons.arrow_back_ios_new,
                          //       color: Colors.white,
                          //       size: 20,
                          //     ),
                          //   ),
                          // ),
                          const Text(
                            'My Courses',
                            style: TextStyle(
                              color: AppColors.accentOrangeLight,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Row(
                            spacing: 10,
                            children: [
                              SizedBox(
                                width: 36,
                                child: GestureDetector(
                                  onTap: () {
                                    GoRouter.of(
                                      context,
                                    ).go(DownloadPanel.routeName);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.2,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: Icon(
                                      Icons.download,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 36,
                                child: GestureDetector(
                                  onTap: _toggleViewMode,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.2,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: Icon(
                                      isGridView
                                          ? Icons.view_list_rounded
                                          : Icons.grid_view_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Search Bar
                      Container(
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurface : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          onChanged: _onSearchChanged,
                          decoration: InputDecoration(
                            hintText: 'Search courses...',
                            hintStyle: TextStyle(
                              color: AppColors.getSecondaryTextColor(context),
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              color: AppColors.primaryBlueDark,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              // Courses Count
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text:
                            '${filteredCourses.length} course${filteredCourses.length != 1 ? 's' : ''}',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBlueDark,
                        isSemibold: true,
                      ),
                      GestureDetector(
                        onTap: () {
                          // Show sort options
                          _showSortBottomSheet();
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.sort_rounded,
                              color: AppColors.accentOrange,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            CustomText(
                              text: 'Sort',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.accentOrange,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Courses List/Grid
              if (filteredCourses.isEmpty)
                SliverToBoxAdapter(child: _buildEmptyState())
              else if (isGridView)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.60,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => PurchasedCourseCard(
                        course: filteredCourses[index],
                        onTap: () => _onCourseTap(filteredCourses[index]),
                      ),
                      childCount: filteredCourses.length,
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => PurchasedCourseListItem(
                      course: filteredCourses[index],
                      onTap: () => _onCourseTap(filteredCourses[index]),
                      onContinueTap: () =>
                          _onContinueTap(filteredCourses[index]),
                    ),
                    childCount: filteredCourses.length,
                  ),
                ),

              // Related Courses Section
              SliverToBoxAdapter(child: _buildRelatedCourses(isDark)),

              // Bottom Spacing
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 60),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.accentOrange.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.school_rounded,
                size: 48,
                color: AppColors.accentOrange,
              ),
            ),
            const SizedBox(height: 16),
            const CustomText(
              text: 'No Courses Found',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlueDark,
              isSemibold: true,
            ),
            const SizedBox(height: 8),
            const CustomText(
              text: 'Try adjusting your search or filters',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.darkTextSecondary,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                setState(() {
                  searchQuery = '';
                  selectedFilter = 'All';
                  _applyFilters();
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accentOrange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const CustomText(
                  text: 'Reset Filters',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onCourseTap(PurchasedCourseModel course) {
    GoRouter.of(context).pushNamed(CourseDetailsPage.routeName);
  }

  void _onContinueTap(PurchasedCourseModel course) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Continuing: ${course.title}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'Sort By',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlueDark,
              isSemibold: true,
            ),
            const SizedBox(height: 16),
            _buildSortOption('Recently Added'),
            _buildSortOption('Progress: High to Low'),
            _buildSortOption('Progress: Low to High'),
            _buildSortOption('Rating: High to Low'),
            _buildSortOption('Price: Low to High'),
            _buildSortOption('Price: High to Low'),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String option) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sorted by: $option'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: option,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.darkTextSecondary,
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppColors.accentOrange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRelatedCourses(bool isDark) {
    // Determine related courses by matching keywords from purchased courses
    final purchasedKeywords =
        purchasedCourses.map((c) => c.title.toLowerCase()).join(' ') +
        ' ' +
        purchasedCourses.map((c) => c.category.toLowerCase()).join(' ');

    // Simple matching logic
    final List<PopularData> relatedCourses = populars.where((popularCourse) {
      final title = popularCourse.label.toLowerCase();
      // If the popular course shares any words with the purchased courses/categories
      final hasMatch = title
          .split(' ')
          .any((word) => word.length > 3 && purchasedKeywords.contains(word));
      return hasMatch;
    }).toList();

    // If no related courses found, default to populars
    final displayCourses = relatedCourses.isNotEmpty
        ? relatedCourses
        : populars;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: const CustomText(
              text: 'Related Courses For You',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlueDark,
              isSemibold: true,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: displayCourses.length,
              itemBuilder: (context, index) {
                final course = displayCourses[index];
                return Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 16.0),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        child: Image.asset(
                          course.imageUrl,
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 100,
                              color: AppColors.lightGray,
                              child: const Icon(
                                Icons.image_not_supported,
                                color: AppColors.mediumGray,
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course.label,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : AppColors.darkGray,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '₹${course.fees}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.accentOrange,
                              ),
                            ),
                          ],
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
