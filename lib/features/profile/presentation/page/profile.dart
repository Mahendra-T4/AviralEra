import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:online_course/core/database/user_db.dart';
import 'package:online_course/core/service/connectivity/connectivity_checker.dart';
import 'package:online_course/core/service/connectivity/no_internat_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:online_course/core/constants/app_colors.dart';
import 'package:online_course/core/utils/custom_appbar.dart';
import 'package:online_course/features/profile/presentation/page/update_profile_page.dart';
import 'package:online_course/features/profile/presentation/page/settings_page.dart';
import 'package:online_course/features/profile/presentation/page/privacy_policy_page.dart';
import 'package:online_course/features/profile/presentation/page/contact_us_page.dart';
import 'package:online_course/features/profile/presentation/page/about_us_page.dart';
import 'package:online_course/features/profile/presentation/page/terms_and_conditions_page.dart';
import 'package:online_course/features/profile/presentation/page/refund_policy_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  static const String routeName = '/profile';

  ImageProvider? _getProfileImageProvider() {
    final storedImage = UserDB.profileImage.trim();
    if (storedImage.isEmpty ||
        storedImage.toLowerCase() == 'null' ||
        storedImage.toLowerCase() == 'undefined') {
      return null;
    }

    if (storedImage.startsWith('http://') ||
        storedImage.startsWith('https://')) {
      return NetworkImage(storedImage);
    }

    try {
      final file = File(storedImage);
      if (file.existsSync()) {
        return FileImage(file);
      }
    } catch (_) {}

    return null;
  }

  String getNameInitials() {
    String initials = '';
    final first = UserDB.firstName.trim();
    final last = UserDB.lastName.trim();
    if (first.isNotEmpty) {
      initials += first[0].toUpperCase();
    }
    if (last.isNotEmpty) {
      initials += last[0].toUpperCase();
    }
    return initials.isNotEmpty ? initials : '';
  }

  @override
  Widget build(BuildContext context) {
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
          appBar: CustomAppBar(title: 'My Profile'),

          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header
                  _buildProfileHeader(context),
                  const SizedBox(height: 32),
                  // Account Settings Section
                  _buildSectionTitle('Account', context),
                  const SizedBox(height: 12),
                  _buildMenuOption(
                    context,
                    icon: Icons.person_outline,
                    title: 'Update Profile',
                    subtitle: 'Edit your personal information',
                    onTap: () => context.pushNamed(UpdateProfilePage.routeName),
                  ),
                  const SizedBox(height: 12),
                  _buildMenuOption(
                    context,
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    subtitle: 'Manage app preferences',
                    onTap: () => context.pushNamed(SettingsPage.routeName),
                  ),
                  const SizedBox(height: 24),
                  // Support Section
                  _buildSectionTitle('Support & Information', context),
                  const SizedBox(height: 12),
                  _buildMenuOption(
                    context,
                    icon: Icons.security_outlined,
                    title: 'Privacy Policy',
                    subtitle: 'Your data and privacy rights',
                    onTap: () => context.pushNamed(PrivacyPolicyPage.routeName),
                  ),
                  const SizedBox(height: 12),

                  _buildMenuOption(
                    context,
                    icon: Icons.description_outlined,
                    title: 'Terms & Conditions',
                    subtitle: 'Read our terms of service',
                    onTap: () =>
                        context.pushNamed(TermsAndConditionsPage.routeName),
                  ),
                  const SizedBox(height: 12),
                  _buildMenuOption(
                    context,
                    icon: Icons.receipt_outlined,
                    title: 'Refund Policy',
                    subtitle: 'Learn about our refund process',
                    onTap: () => context.pushNamed(RefundPolicyPage.routeName),
                  ),
                  const SizedBox(height: 12),
                  _buildMenuOption(
                    context,
                    icon: Icons.mail_outline,
                    title: 'Contact Us',
                    subtitle: 'Get in touch with our support team',
                    onTap: () => context.pushNamed(ContactUsPage.routeName),
                  ),

                  const SizedBox(height: 12),
                  _buildMenuOption(
                    context,
                    icon: Icons.info_outline,
                    title: 'About Us',
                    subtitle: 'Learn more about our platform',
                    onTap: () => context.pushNamed(AboutUsPage.routeName),
                  ),
                  const SizedBox(height: 12),
                  _buildMenuOption(
                    context,
                    icon: Icons.star_outline,
                    title: 'Rate Us',
                    subtitle: 'Share your feedback on app stores',
                    onTap: () => _rateUs(context),
                  ),
                  const SizedBox(height: 24),
                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _showLogoutConfirmation(context),
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headerBgColor = isDark
        ? AppColors.darkSurface
        : AppColors.primaryBlueLight;
    final borderColor = isDark
        ? AppColors.lightGray.withValues(alpha: 0.2)
        : AppColors.lightGray;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    final subtextColor = Theme.of(context).textTheme.bodySmall!.color!;
    final displayName = '${UserDB.firstName} ${UserDB.lastName}'.trim();
    final userFullName = displayName.isNotEmpty ? displayName : '';
    final userBioOrEmail = UserDB.getBio.isNotEmpty
        ? UserDB.getBio
        : (UserDB.email.isNotEmpty ? UserDB.email : 'flutter developer');
    final imageProvider = _getProfileImageProvider();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: headerBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: AppColors.primaryBlue,
            backgroundImage: imageProvider,
            onBackgroundImageError: imageProvider != null ? (_, __) {} : null,
            child: imageProvider == null
                ? Text(
                    getNameInitials(),
                    style: const TextStyle(
                      fontSize: 32,
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 12),
          Text(
            userFullName,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            userBioOrEmail,
            style: TextStyle(fontSize: 14, color: subtextColor),
          ),
          // const SizedBox(height: 12),
          // SizedBox(
          //   width: double.infinity,
          //   child: ElevatedButton(
          //     onPressed: () => Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const UpdateProfilePage(),
          //       ),
          //     ),
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: AppColors.primaryBlue,
          //       foregroundColor: AppColors.white,
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(8),
          //       ),
          //     ),
          //     child: const Text('Edit Profile'),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildMenuOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final containerBgColor = isDark ? AppColors.darkSurface : AppColors.white;
    final borderColor = isDark
        ? AppColors.lightGray.withValues(alpha: 0.2)
        : AppColors.lightGray;
    final titleColor = Theme.of(context).textTheme.titleMedium!.color!;
    final subtitleColor = Theme.of(context).textTheme.bodySmall!.color!;

    return Material(
      color: containerBgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: AppColors.primaryBlue, size: 24),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w600, color: titleColor),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: subtitleColor),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: subtitleColor),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBgColor = isDark ? AppColors.darkSurface : Colors.white;
    final titleColor = isDark ? AppColors.white : AppColors.darkGray;
    final subtitleColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.mediumGray;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: dialogBgColor,
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Warning Icon Badge
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: AppColors.error,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  'Log Out',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // Subtitle/Message
                Text(
                  'Are you sure you want to log out of your account?',
                  style: TextStyle(
                    fontSize: 14,
                    color: subtitleColor,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    // Cancel Button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          if (Navigator.canPop(context)) Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(
                            color: isDark
                                ? AppColors.lightGray.withValues(alpha: 0.2)
                                : AppColors.lightGray,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: titleColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Confirm Logout Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          UserDB.logout(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _rateUs(BuildContext context) async {
    final InAppReview inAppReview = InAppReview.instance;

    try {
      // Show loading feedback
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Opening app store...'),
          duration: Duration(seconds: 1),
        ),
      );

      // Check if in-app review is available
      if (await inAppReview.isAvailable()) {
        // Request in-app review
        await inAppReview.requestReview();
      } else {
        // Fallback: Open app store directly
        // iOS App Store URL
        const String appStoreUrl =
            'https://apps.apple.com/app/aviral-era/id1234567890';
        // Android Google Play Store URL
        const String playStoreUrl =
            'https://play.google.com/store/apps/details?id=com.aviralera.online_course';

        try {
          // Try to open iOS App Store
          if (await canLaunchUrl(Uri.parse(appStoreUrl))) {
            await launchUrl(
              Uri.parse(appStoreUrl),
              mode: LaunchMode.externalApplication,
            );
          } else {
            // Try to open Android Google Play Store
            if (await canLaunchUrl(Uri.parse(playStoreUrl))) {
              await launchUrl(
                Uri.parse(playStoreUrl),
                mode: LaunchMode.externalApplication,
              );
            } else {
              _showErrorDialog(context, 'Unable to open app store');
            }
          }
        } catch (e) {
          _showErrorDialog(context, 'Error opening app store: $e');
        }
      }
    } catch (e) {
      _showErrorDialog(context, 'Error: $e');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBgColor = isDark ? AppColors.darkSurface : Colors.white;
    final textColor = Theme.of(context).textTheme.bodyMedium!.color!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: dialogBgColor,
          title: Text('Error', style: TextStyle(color: textColor)),
          content: Text(message, style: TextStyle(color: textColor)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
