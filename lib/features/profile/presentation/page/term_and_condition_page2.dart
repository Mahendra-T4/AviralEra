import 'package:flutter/material.dart';
import 'package:online_course/core/constants/app_colors.dart';
import 'package:online_course/core/service/connectivity/connectivity_checker.dart';
import 'package:online_course/core/service/connectivity/no_internat_page.dart';
import 'package:online_course/core/utils/custom_appbar.dart';

class TermsAndConditionsPage2 extends StatelessWidget {
  const TermsAndConditionsPage2({super.key});
  static const String routeName = '/profile/terms-and-conditions2';

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
          appBar: CustomAppBar(
            title: 'Terms & Conditions',
            showNotificationIcon: false,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Introduction
                  const SizedBox(height: 8),
                  Text(
                    'Last Updated: June 2026',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.mediumGray,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 24),
        
                  // Section 1
                  _buildSectionTitle('1. Acceptance of Terms', context),
                  const SizedBox(height: 12),
                  _buildSectionContent(
                    'By accessing and using this application, you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to abide by the above, please do not use this service.',
                  ),
                  const SizedBox(height: 24),
        
                  // Section 2
                  _buildSectionTitle('2. Use License', context),
                  const SizedBox(height: 12),
                  _buildSectionContent(
                    'Permission is granted to temporarily download one copy of the materials (information or software) on our application for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title, and under this license you may not:',
                  ),
                  const SizedBox(height: 12),
                  _buildBulletPoint('Modify or copying the materials'),
                  _buildBulletPoint(
                    'Using the materials for any commercial purpose or for any public display',
                  ),
                  _buildBulletPoint(
                    'Attempting to decompile or reverse engineer any software contained on the application',
                  ),
                  _buildBulletPoint(
                    'Removing any copyright or other proprietary notations from the materials',
                  ),
                  const SizedBox(height: 24),
        
                  // Section 3
                  _buildSectionTitle('3. Disclaimer', context),
                  const SizedBox(height: 12),
                  _buildSectionContent(
                    'The materials on our application are provided on an \'as is\' basis. We make no warranties, expressed or implied, and hereby disclaim and negate all other warranties including, without limitation, implied warranties or conditions of merchantability, fitness for a particular purpose, or non-infringement of intellectual property or other violation of rights.',
                  ),
                  const SizedBox(height: 24),
        
                  // Section 4
                  _buildSectionTitle('4. Limitations', context),
                  const SizedBox(height: 12),
                  _buildSectionContent(
                    'In no event shall our company or its suppliers be liable for any damages (including, without limitation, damages for loss of data or profit, or due to business interruption) arising out of the use or inability to use the materials on our application.',
                  ),
                  const SizedBox(height: 24),
        
                  // Section 5
                  _buildSectionTitle('5. Accuracy of Materials', context),
                  const SizedBox(height: 12),
                  _buildSectionContent(
                    'The materials appearing on our application could include technical, typographical, or photographic errors. Our company does not warrant that any of the materials on the application are accurate, complete, or current. We may make changes to the materials contained on the application at any time without notice.',
                  ),
                  const SizedBox(height: 24),
        
                  // Section 6
                  _buildSectionTitle('6. Links', context),
                  const SizedBox(height: 12),
                  _buildSectionContent(
                    'We have not reviewed all of the sites linked to our application and are not responsible for the contents of any such linked site. The inclusion of any link does not imply endorsement by us of the site. Use of any such linked website is at the user\'s own risk.',
                  ),
                  const SizedBox(height: 24),
        
                  // Section 7
                  _buildSectionTitle('7. Modifications', context),
                  const SizedBox(height: 12),
                  _buildSectionContent(
                    'Our company may revise these terms of service for the application at any time without notice. By using the application, you are agreeing to be bound by the then current version of these terms of service.',
                  ),
                  const SizedBox(height: 24),
        
                  // Section 8
                  _buildSectionTitle('8. Governing Law', context),
                  const SizedBox(height: 12),
                  _buildSectionContent(
                    'These terms and conditions are governed by and construed in accordance with the laws of the jurisdiction in which the company is located, and you irrevocably submit to the exclusive jurisdiction of the courts in that location.',
                  ),
                  const SizedBox(height: 32),
        
                  // Contact Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlueLighter,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.lightGray),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Questions?',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'If you have any questions about these Terms & Conditions, please contact us at support@aviralera.com',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.darkGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: AppColors.primaryBlue,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Text(
      content,
      style: const TextStyle(
        fontSize: 14,
        color: AppColors.darkGray,
        height: 1.6,
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.darkGray,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.darkGray,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
