import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:online_course/core/constants/app_colors.dart';
import 'package:online_course/features/notification/presentation/page/notifications.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Title of the app bar
  final String title;

  /// Whether to show the back button
  final bool showBackButton;

  /// Callback for back button
  final VoidCallback? onBackPressed;

  /// Whether to show the notification icon
  final bool showNotificationIcon;

  /// Callback for notification icon tap
  // final VoidCallback? onNotificationPressed;

  /// Number of unread notifications (badge count)
  final int notificationCount;

  /// Whether to show the settings icon
  final bool showSettingsIcon;

  /// Callback for settings icon tap
  final VoidCallback? onSettingsPressed;

  /// Whether to show search icon
  final bool showSearchIcon;

  /// Callback for search icon tap
  final VoidCallback? onSearchPressed;

  /// List of additional action buttons
  final List<PopupMenuEntry>? actionMenuItems;

  /// Callback for menu action
  final Function(dynamic)? onActionSelected;

  /// App bar background color
  final Color? backgroundColor;

  /// App bar elevation
  final double elevation;

  /// Title text style
  final TextStyle? titleStyle;

  /// Icon color
  final Color iconColor;

  /// Whether to center the title
  final bool centerTitle;

  /// Custom leading widget (overrides back button if provided)
  final Widget? customLeading;

  /// Whether to show a bottom border
  final bool showBottomBorder;

  /// Height of the app bar
  final double height;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.onBackPressed,
    this.showNotificationIcon = true,
    // this.onNotificationPressed,
    this.notificationCount = 0,
    this.showSettingsIcon = false,
    this.onSettingsPressed,
    this.showSearchIcon = false,
    this.onSearchPressed,
    this.actionMenuItems,
    this.onActionSelected,
    this.backgroundColor,
    this.elevation = 2,
    this.titleStyle,
    this.iconColor = Colors.white,
    this.centerTitle = false,
    this.customLeading,
    this.showBottomBorder = false,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        backgroundColor ??
        (isDark ? AppColors.darkSurface : AppColors.primaryBlueDark);

    // Theme-aware shadow color
    final shadowColor = isDark
        ? Colors.black.withValues(alpha: 0.3)
        : Colors.black.withValues(alpha: 0.1);
    final borderColor = isDark
        ? AppColors.lightGray.withValues(alpha: 0.15)
        : Colors.grey.withValues(alpha: 0.2);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: elevation,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
        border: showBottomBorder
            ? Border(bottom: BorderSide(color: borderColor, width: 1))
            : null,
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // leading:
        //     customLeading ??
        //     (showBackButton
        //         ? IconButton(
        //             icon: Icon(
        //               Icons.arrow_back_rounded,
        //               color: iconColor,
        //               size: 24,
        //             ),
        //             onPressed: onBackPressed ?? () => context.pop(context),
        //           )
        //         : null),
        title: Text(
          title,
          style:
              titleStyle ??
              TextStyle(
                color: iconColor,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
        ),
        centerTitle: centerTitle,
        actions: [
          // Search Icon
          if (showSearchIcon)
            IconButton(
              icon: Icon(Icons.search_rounded, color: iconColor, size: 24),
              onPressed: onSearchPressed,
            ),
          // Notification Icon
          if (showNotificationIcon) _buildNotificationIcon(context),
          // Settings Icon
          if (showSettingsIcon)
            IconButton(
              icon: Icon(Icons.settings_rounded, color: iconColor, size: 24),
              onPressed: onSettingsPressed,
            ),
          // More Options Menu
          if (actionMenuItems != null && actionMenuItems!.isNotEmpty)
            PopupMenuButton(
              icon: Icon(Icons.more_vert_rounded, color: iconColor, size: 24),
              itemBuilder: (context) => actionMenuItems ?? [],
              onSelected: onActionSelected,
            ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildNotificationIcon(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: Icon(Icons.notifications_on, color: iconColor, size: 30),
          onPressed: () {
            GoRouter.of(context).pushNamed(NotificationsPage.routeName);
          },
        ),
        // Badge
        if (notificationCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.error.withValues(alpha: 0.4),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                notificationCount > 99 ? '99+' : '$notificationCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

/// Variation: Simple Custom App Bar with minimal options
class SimpleCustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final bool showBackButton;
  final Color? backgroundColor;
  final Color textColor;

  const SimpleCustomAppBar({
    super.key,
    required this.title,
    this.onBackPressed,
    this.showBackButton = true,
    this.backgroundColor,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        backgroundColor ??
        (isDark ? AppColors.darkSurface : AppColors.primaryBlueDark);

    return Container(
      color: bgColor,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 56,
          child: Row(
            children: [
              if (showBackButton)
                IconButton(
                  icon: Icon(Icons.arrow_back_rounded, color: textColor),
                  onPressed: onBackPressed ?? () => Navigator.pop(context),
                )
              else
                const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

/// Variation: Gradient Custom App Bar with background gradient
class GradientCustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final LinearGradient gradient;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final bool showNotificationIcon;
  final VoidCallback? onNotificationPressed;
  final int notificationCount;
  final Color iconColor;

  const GradientCustomAppBar({
    super.key,
    required this.title,
    this.gradient = AppColors.primaryGradient,
    this.showBackButton = true,
    this.onBackPressed,
    this.showNotificationIcon = true,
    this.onNotificationPressed,
    this.notificationCount = 0,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 56,
          child: Row(
            children: [
              if (showBackButton)
                IconButton(
                  icon: Icon(Icons.arrow_back_rounded, color: iconColor),
                  onPressed: onBackPressed ?? () => Navigator.pop(context),
                ),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: iconColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (showNotificationIcon) _buildNotificationIcon(),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon() {
    return Stack(
      children: [
        IconButton(
          icon: Icon(Icons.notifications_none_rounded, color: iconColor),
          onPressed: onNotificationPressed,
        ),
        if (notificationCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                notificationCount > 99 ? '99+' : '$notificationCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
