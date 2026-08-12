import 'package:flutter/material.dart';
import 'package:online_course/core/constants/app_colors.dart';
import 'package:online_course/core/service/connectivity/connectivity_checker.dart';
import 'package:online_course/core/service/connectivity/no_internat_page.dart';
import 'package:online_course/core/utils/custom_text.dart';
import 'package:online_course/features/test/data/source/test_data.dart';
import 'package:online_course/features/test/presentation/widgets/test_card.dart';
import 'package:online_course/features/test/presentation/widgets/test_list_item.dart';

class MyTestPage extends StatefulWidget {
  const MyTestPage({super.key});
  static const String routeName = '/my-tests';

  @override
  State<MyTestPage> createState() => _MyTestPageState();
}

class _MyTestPageState extends State<MyTestPage> {
  late List<TestModel> filteredTests;
  bool isGridView = true;
  String selectedStatus = 'All';
  String selectedDifficulty = 'All';
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredTests = List.from(allTests);
  }

  void _filterTests() {
    filteredTests = allTests.where((test) {
      final matchesStatus =
          selectedStatus == 'All' || test.status == selectedStatus;
      final matchesDifficulty =
          selectedDifficulty == 'All' || test.difficulty == selectedDifficulty;
      final matchesSearch =
          searchQuery.isEmpty ||
          test.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          test.courseTitle.toLowerCase().contains(searchQuery.toLowerCase());

      return matchesStatus && matchesDifficulty && matchesSearch;
    }).toList();
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchQuery = value;
      _filterTests();
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
                    top: 20,
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
                      SizedBox(height: MediaQuery.of(context).padding.top),
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
                          CustomText(
                            text: 'My Tests',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            isSemibold: true,
                          ),
                          SizedBox(
                            width: 36,
                            child: GestureDetector(
                              onTap: _toggleViewMode,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
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
                            hintText: 'Search tests...',
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

              // Stats Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Total Tests',
                          '${allTests.length}',
                          Icons.school_rounded,
                          AppColors.primaryBlueDark,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          'Completed',
                          '${allTests.where((t) => t.status == 'Completed').length}',
                          Icons.check_circle_rounded,
                          AppColors.success,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          'In Progress',
                          '${allTests.where((t) => t.status == 'In Progress').length}',
                          Icons.schedule_rounded,
                          AppColors.info,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Tests Count
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: CustomText(
                    text:
                        '${filteredTests.length} test${filteredTests.length != 1 ? 's' : ''} found',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBlueDark,
                  ),
                ),
              ),

              // Tests List/Grid
              if (filteredTests.isEmpty)
                SliverToBoxAdapter(child: _buildEmptyState())
              else if (isGridView)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.85,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 16,
                        ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => TestCard(
                        test: filteredTests[index],
                        onTap: () => _onTestTap(filteredTests[index]),
                      ),
                      childCount: filteredTests.length,
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => TestListItem(
                      test: filteredTests[index],
                      onTap: () => _onTestTap(filteredTests[index]),
                      onStartTap: () => _onStartTest(filteredTests[index]),
                    ),
                    childCount: filteredTests.length,
                  ),
                ),

              // Bottom Spacing
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBgColor = isDark ? AppColors.darkSurface : Colors.white;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 6),
          CustomText(
            text: value,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
          const SizedBox(height: 4),
          CustomText(
            text: label,
            fontSize: 10,
            color: AppColors.darkTextSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final containerBgColor = isDark ? AppColors.darkSurface : Colors.white;

    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 60),
        decoration: BoxDecoration(
          color: containerBgColor,
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
                Icons.quiz_rounded,
                size: 48,
                color: AppColors.accentOrange,
              ),
            ),
            const SizedBox(height: 16),
            CustomText(
              text: 'No Tests Found',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlueDark,
              isSemibold: true,
            ),
            const SizedBox(height: 8),
            CustomText(
              text: 'Try adjusting your filters or search query',
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
                  selectedStatus = 'All';
                  selectedDifficulty = 'All';
                  _filterTests();
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
                child: CustomText(
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

  void _onTestTap(TestModel test) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening: ${test.title}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _onStartTest(TestModel test) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting: ${test.title}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
