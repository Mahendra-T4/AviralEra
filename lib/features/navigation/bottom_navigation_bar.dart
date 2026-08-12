import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:online_course/core/constants/app_colors.dart';
import 'package:online_course/core/service/connectivity/connectivity_checker.dart';
import 'package:online_course/core/service/connectivity/no_internat_page.dart';
import 'package:online_course/features/home/presentation/page/home.dart';
import 'package:online_course/features/my_course/presentation/page/purchased_courses.dart';
import 'package:online_course/features/notification/presentation/page/notifications.dart';
import 'package:online_course/features/profile/presentation/page/about_us_page.dart';
import 'package:online_course/features/profile/presentation/page/contact_us_page.dart';
import 'package:online_course/features/profile/presentation/page/privacy_policy_page.dart';
import 'package:online_course/features/profile/presentation/page/settings_page.dart';
import 'package:online_course/features/profile/presentation/page/update_profile_page.dart';
import 'package:online_course/features/search/presentation/page/course_search_page.dart';
import 'package:online_course/features/test/presentation/page/my_test.dart';
import 'package:online_course/features/profile/presentation/page/profile.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key, this.child});
  final Widget? child;
  static const String routeName = '/bottom_nav';

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;

  final List<String> _pages = [
    HomePage.routeName,
    CourseSearchPage.routeName,
    PurchasedCoursesPage.routeName,
    MyTestPage.routeName,
    ProfilePage.routeName,
  ];

  // Routes where navbar should be neutral (no selection)
  static const String notificationRouteName = NotificationsPage.routeName;
  final List<String> _neutralRoutes = [
    notificationRouteName,
    SettingsPage.routeName,
    UpdateProfilePage.routeName,
    PrivacyPolicyPage.routeName,
    AboutUsPage.routeName,
    ContactUsPage.routeName,
    // ProfileInfo.routeName,
    // LodgeComplaintScreen.routeName,
    // PaymentScreen.routeName,
    // LedgerReportScreen.routeName,
    // DepositScreen.routeName,
  ];

  final List<String> _allRoutes = [
    SettingsPage.routeName,
    UpdateProfilePage.routeName,
    PrivacyPolicyPage.routeName,
    AboutUsPage.routeName,
    ContactUsPage.routeName,
  ];

  final List<BottomNavItem> _navItems = [
    BottomNavItem(
      icon: Icons.home_rounded,
      label: 'Home',
      color: AppColors.primaryBlue,
    ),
    BottomNavItem(
      icon: Icons.explore_rounded,
      label: 'Explore',
      color: AppColors.success,
    ),
    BottomNavItem(
      icon: Icons.play_circle_fill,
      label: 'My Courses',
      color: AppColors.accentOrange,
    ),

    BottomNavItem(
      icon: Icons.quiz,
      label: 'Tests',
      color: AppColors.tertiaryPurple,
    ),
    BottomNavItem(
      icon: Icons.person_rounded,
      label: 'Profile',
      color: AppColors.darkOrange,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      context.goNamed(_pages[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the bottom padding of the device
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    final currentPath = GoRouterState.of(context).uri.path;

    // Check if current path is a neutral route (like notification page)
    if (_neutralRoutes.contains(currentPath)) {
      _selectedIndex = -1; // Neutral - no item selected
    } else {
      _selectedIndex = _pages.indexOf(currentPath);
      if (_selectedIndex == -1) {
        _selectedIndex = _allRoutes.contains(currentPath)
            ? 1
            : 0; // Default to first tab if on a non-nav route
      }
    }

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
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: widget.child,
          ),
          bottomNavigationBar: _buildBottomNavBar(),
        );
      },
    );
  }

  Widget _buildBottomNavBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkSurface : AppColors.white;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              _navItems.length,
              (index) => _buildNavItem(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final item = _navItems[index];
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? item.color.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                if (isSelected)
                  ScaleTransition(
                    scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: Curves.elasticOut,
                      ),
                    ),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: item.color.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                Icon(
                  item.icon,
                  color: isSelected ? item.color : AppColors.mediumGray,
                  size: isSelected ? 28 : 24,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: TextStyle(
                fontSize: isSelected ? 12 : 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? item.color : AppColors.mediumGray,
                height: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavItem {
  final IconData icon;
  final String label;
  final Color color;

  BottomNavItem({required this.icon, required this.label, required this.color});
}
