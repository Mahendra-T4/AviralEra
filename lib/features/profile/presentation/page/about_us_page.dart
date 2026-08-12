import 'package:flutter/material.dart';
import 'package:online_course/assets/assets.dart';
import 'package:online_course/core/constants/app_colors.dart';
import 'package:online_course/core/service/connectivity/connectivity_checker.dart';
import 'package:online_course/core/service/connectivity/no_internat_page.dart';
import 'package:online_course/core/utils/custom_appbar.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});
  static const String routeName = '/about-us';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBgColor = isDark ? AppColors.darkSurface : Colors.white;
    final textColor = Theme.of(context).textTheme.bodyMedium!.color!;

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
          appBar: CustomAppBar(title: 'About Us', showBackButton: true),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo/Banner
                Center(
                  child: Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: dialogBgColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primaryBlue),
                    ),
                    child: Column(
                      children: [
                        Image.asset(Assets.aviralEraLogo, height: 100, width: 100),
                        const SizedBox(height: 16),
        
                        Text(
                          'Your Path to Online Learning',
                          style: TextStyle(fontSize: 14, color: textColor),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
        
                // About Section
                _buildSection(
                  context,
                  title: 'About Aviral Era',
                  content:
                      'Aviral Era is a leading online learning platform dedicated to providing high-quality educational courses to students worldwide. We believe in making education accessible, affordable, and engaging for everyone.\n\nOur mission is to empower learners with knowledge and skills they need to succeed in the digital age.',
                ),
                const SizedBox(height: 16),
        
                // Our Mission
                _buildSection(
                  context,
                  title: 'Our Mission',
                  content:
                      'To democratize education by providing world-class learning experiences that are:\n\n• Accessible to everyone, regardless of location or background\n• Affordable without compromising quality\n• Flexible to fit your lifestyle and schedule\n• Engaging through interactive content and expert instructors\n• Relevant to current industry needs and standards',
                ),
                const SizedBox(height: 16),
        
                // Our Vision
                _buildSection(
                  context,
                  title: 'Our Vision',
                  content:
                      'To become the most trusted online learning platform globally, enabling millions of learners to achieve their educational and career goals through innovative and personalized learning experiences.',
                ),
                const SizedBox(height: 16),
        
                // Key Features
                Text(
                  'Why Choose Us',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 12),
                _buildFeatureCard(
                  context,
                  icon: Icons.star,
                  title: 'Expert Instructors',
                  description: 'Learn from industry professionals and experts',
                ),
                const SizedBox(height: 12),
                _buildFeatureCard(
                  context,
                  icon: Icons.videocam,
                  title: 'High-Quality Content',
                  description: 'Professionally produced video courses',
                ),
                const SizedBox(height: 12),
                _buildFeatureCard(
                  context,
                  icon: Icons.group,
                  title: 'Community Support',
                  description: 'Learn together with thousands of students',
                ),
                const SizedBox(height: 12),
                _buildFeatureCard(
                  context,
                  icon: Icons.verified,
                  title: 'Certifications',
                  description: 'Earn recognized certificates upon completion',
                ),
                const SizedBox(height: 24),
        
                Text(
                  'By The Numbers',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildStatCard(context, '1M+', 'Learners')),
                    const SizedBox(width: 12),
                    Expanded(child: _buildStatCard(context, '500+', 'Courses')),
                    const SizedBox(width: 12),
                    Expanded(child: _buildStatCard(context, '50+', 'Countries')),
                  ],
                ),
                const SizedBox(height: 24),
        
                // Contact CTA
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: dialogBgColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primaryBlue),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Have Questions?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Our support team is here to help you with any inquiries.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: textColor),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (Navigator.canPop(context)) Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            foregroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Contact Support'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
        
                // Version Info
                Center(
                  child: Text(
                    'Version 1.0.0',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.mediumGray,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    final textColor = Theme.of(context).textTheme.bodyMedium!.color!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.titleMedium!.color!,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(fontSize: 14, color: textColor, height: 1.6),
        ),
      ],
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBgColor = isDark ? AppColors.darkSurface : Colors.white;
    final textColor = Theme.of(context).textTheme.bodyMedium!.color!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dialogBgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.lightGray),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: textColor),
            ),
            child: Icon(icon, color: AppColors.primaryBlue, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBlue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: textColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String number, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBgColor = isDark ? AppColors.darkSurface : Colors.white;
    final textColor = Theme.of(context).textTheme.bodyMedium!.color!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dialogBgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primaryBlue),
      ),
      child: Column(
        children: [
          Text(
            number,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: textColor)),
        ],
      ),
    );
  }
}
