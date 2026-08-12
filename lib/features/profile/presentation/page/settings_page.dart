import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_course/core/constants/app_colors.dart';
import 'package:online_course/core/service/connectivity/connectivity_checker.dart';
import 'package:online_course/core/service/connectivity/no_internat_page.dart';
import 'package:online_course/core/utils/custom_appbar.dart';
import 'package:online_course/core/bloc/theme_bloc.dart';
import 'package:online_course/features/auth/presentation/pages/change_password/change_password_panel.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  static const String routeName = '/settings';

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
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
              appBar: CustomAppBar(title: 'Settings', showBackButton: true),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    // Notifications Section
                    _buildSection(
                      title: 'Notifications',
                      children: [
                        _buildSwitchTile(
                          icon: Icons.notifications,
                          title: 'Push Notifications',
                          subtitle: 'Receive push notifications',
                          value: _notificationsEnabled,
                          onChanged: (value) {
                            setState(() => _notificationsEnabled = value);
                          },
                        ),
                        _buildSwitchTile(
                          icon: Icons.email,
                          title: 'Email Notifications',
                          subtitle: 'Receive email updates',
                          value: _emailNotifications,
                          onChanged: (value) {
                            setState(() => _emailNotifications = value);
                          },
                        ),
                      ],
                    ),
            
                    // Appearance Section
                    _buildSection(
                      title: 'Appearance',
                      children: [
                        _buildThemeSwitchTile(
                          isDarkMode: themeState.isDarkMode,
                          onThemeChanged: (isDark) {
                            context.read<ThemeBloc>().add(
                              SetThemeEvent(isDarkMode: isDark),
                            );
                          },
                        ),
                      ],
                    ),
            
                    // Account Section
                    _buildSection(
                      title: 'Account',
                      children: [
                        _buildActionTile(
                          icon: Icons.lock,
                          title: 'Change Password',
                          subtitle: 'Update your password',
                          onTap: () {
                            context.pushNamed(ChangePasswordPanel.routeName);
                          },
                        ),
                      ],
                    ),
            
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          }
        );
      },
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final containerBgColor = isDark ? AppColors.darkSurface : AppColors.white;
    final borderColor = isDark
        ? AppColors.lightGray.withValues(alpha:0.2)
        : AppColors.lightGray;
    final titleColor = Theme.of(context).textTheme.titleMedium!.color!;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: containerBgColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              children: [
                for (int i = 0; i < children.length; i++) ...[
                  children[i],
                  if (i < children.length - 1)
                    Divider(color: borderColor, height: 1),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    final titleColor = Theme.of(context).textTheme.titleMedium!.color!;
    final subtitleColor = Theme.of(context).textTheme.bodySmall!.color!;

    return ListTile(
      leading: Icon(icon, color: AppColors.primaryBlue),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600, color: titleColor),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: subtitleColor),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primaryBlue,
      ),
    );
  }

  Widget _buildThemeSwitchTile({
    required bool isDarkMode,
    required Function(bool) onThemeChanged,
  }) {
    final titleColor = Theme.of(context).textTheme.titleMedium!.color!;
    final subtitleColor = Theme.of(context).textTheme.bodySmall!.color!;

    return ListTile(
      leading: Icon(
        isDarkMode ? Icons.dark_mode : Icons.light_mode,
        color: AppColors.primaryBlue,
      ),
      title: Text(
        'Dark Mode',
        style: TextStyle(fontWeight: FontWeight.w600, color: titleColor),
      ),
      subtitle: Text(
        isDarkMode ? 'Dark theme enabled' : 'Light theme enabled',
        style: TextStyle(fontSize: 12, color: subtitleColor),
      ),
      trailing: Switch(
        value: isDarkMode,
        onChanged: onThemeChanged,
        activeColor: AppColors.primaryBlue,
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final titleColor = Theme.of(context).textTheme.titleMedium!.color!;
    final subtitleColor = Theme.of(context).textTheme.bodySmall!.color!;

    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppColors.primaryBlue),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600, color: titleColor),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: subtitleColor),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: subtitleColor),
    );
  }
}
