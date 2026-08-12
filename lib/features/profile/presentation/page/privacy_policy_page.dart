import 'package:flutter/material.dart';
import 'package:online_course/core/constants/app_colors.dart';
import 'package:online_course/core/service/connectivity/connectivity_checker.dart';
import 'package:online_course/core/service/connectivity/no_internat_page.dart';
import 'package:online_course/core/utils/custom_appbar.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});
  static const String routeName = '/privacy-policy';

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
          appBar: CustomAppBar(title: 'Privacy Policy', showBackButton: true),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Last Updated
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.infoLight,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.info),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info, color: AppColors.info, size: 20),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Last Updated: January 1, 2024',
                          style: TextStyle(color: AppColors.infoDark, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
        
                _buildSection(
                  context,
                  title: '1. Introduction',
                  content:
                      'We are committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application.\n\nPlease read this privacy policy carefully. If you do not agree with our policies and practices, please do not use our services.',
                ),
                const SizedBox(height: 16),
        
                _buildSection(
                  context,
                  title: '2. Information We Collect',
                  content:
                      'We may collect information about you in a variety of ways. The information we may collect on the Site includes:\n\n• Personal Data: Your name, email address, phone number, and other contact information.\n• Device Information: Information about your device, including device type, operating system, and unique device identifiers.\n• Usage Data: Information about how you interact with our application, including pages visited, time spent, and features used.\n• Location Data: With your permission, we may collect location information to provide location-based services.',
                ),
                const SizedBox(height: 16),
        
                _buildSection(
                  context,
                  title: '3. How We Use Your Information',
                  content:
                      'Having accurate information about you permits us to provide you with a smooth, efficient, and customized experience. Specifically, we may use information collected about you via the app to:\n\n• Create and manage your account\n• Deliver the services you request\n• Email you regarding your account or order\n• Fulfill and send out your purchases, orders, and payments\n• Generate a personal profile about you\n• Improve the app and its services\n• Monitor and analyze app usage and trends',
                ),
                const SizedBox(height: 16),
        
                _buildSection(
                  context,
                  title: '4. Disclosure of Your Information',
                  content:
                      'We may share information we have collected about you in certain situations:\n\n• By Law or to Protect Rights: If we are required to disclose information by law or if you violate our Terms of Service.\n• Third-Party Service Providers: We may share your information with vendors, consultants, and other service providers who need access to such information to carry out work on our behalf.\n• Business Transfers: Your information may be transferred if we are involved in a merger, acquisition, or asset sale.',
                ),
                const SizedBox(height: 16),
        
                _buildSection(
                  context,
                  title: '5. Security of Your Information',
                  content:
                      'We use administrative, technical, and physical security measures to protect your personal information. However, no method of transmission over the Internet or method of electronic storage is 100% secure. Therefore, we cannot guarantee absolute security of your information.',
                ),
                const SizedBox(height: 16),
        
                _buildSection(
                  context,
                  title: '6. Contact Us',
                  content:
                      'If you have questions or comments about this Privacy Policy, please contact us at:\n\nEmail: privacy@example.com\nPhone: +1 (555) 123-4567\n\nOur support team is available 24/7 to assist you.',
                ),
                const SizedBox(height: 24),
        
                // Action Buttons
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Privacy policy accepted')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('I Accept'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      if (Navigator.canPop(context)) Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryBlue,
                      side: const BorderSide(color: AppColors.primaryBlue),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Go Back'),
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
}
