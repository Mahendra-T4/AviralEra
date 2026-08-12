import 'package:flutter/material.dart';
import 'package:online_course/core/constants/app_colors.dart';
import 'package:online_course/core/service/connectivity/connectivity_checker.dart';
import 'package:online_course/core/service/connectivity/no_internat_page.dart';
import 'package:online_course/core/utils/custom_appbar.dart';

class RefundPolicyPage extends StatelessWidget {
  const RefundPolicyPage({super.key});
  static const String routeName = '/profile/refund-policy';

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
          appBar: CustomAppBar(title: 'Refund Policy'),
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
        
                  // Overview
                  _buildSectionTitle('Refund Policy Overview', context),
                  const SizedBox(height: 12),
                  _buildSectionContent(
                    context,
                    'At Aviral Era, we want you to be completely satisfied with your purchase. If you\'re not happy with your course or learning experience, we offer a hassle-free refund policy.',
                  ),
                  const SizedBox(height: 24),
        
                  // Section 1
                  _buildSectionTitle('1. Refund Eligibility', context),
                  const SizedBox(height: 12),
                  _buildSectionContent(
                    context,
                    'You are eligible for a refund if:',
                  ),
                  const SizedBox(height: 12),
                  _buildBulletPoint(
                    context,
                    'You request a refund within 30 days of purchase',
                  ),
                  _buildBulletPoint(
                    context,
                    'You have completed less than 30% of the course content',
                  ),
                  _buildBulletPoint(
                    context,
                    'The course does not meet the description provided',
                  ),
                  _buildBulletPoint(
                    context,
                    'You have technical issues that prevent access to course materials',
                  ),
                  const SizedBox(height: 24),
        
                  // Section 2
                  _buildSectionTitle('2. Non-Refundable Items', context),
                  const SizedBox(height: 12),
                  _buildSectionContent(
                    context,
                    'The following items are non-refundable:',
                  ),
                  const SizedBox(height: 12),
                  _buildBulletPoint(
                    context,
                    'Courses purchased with promotional or discount codes',
                  ),
                  _buildBulletPoint(
                    context,
                    'Courses where you have completed more than 30% of the content',
                  ),
                  _buildBulletPoint(
                    context,
                    'Certification exams after submission',
                  ),
                  _buildBulletPoint(context, 'Administrative or service fees'),
                  const SizedBox(height: 24),
        
                  // Section 3
                  _buildSectionTitle('3. Refund Process', context),
                  const SizedBox(height: 12),
                  _buildSectionContent(context, 'To request a refund:'),
                  const SizedBox(height: 12),
                  _buildBulletPoint(
                    context,
                    'Log in to your account and navigate to "My Courses"',
                  ),
                  _buildBulletPoint(
                    context,
                    'Select the course for which you want a refund',
                  ),
                  _buildBulletPoint(
                    context,
                    'Click on "Request Refund" and provide a reason',
                  ),
                  _buildBulletPoint(
                    context,
                    'Submit your request and wait for our team to review',
                  ),
                  _buildBulletPoint(
                    context,
                    'We will respond to your request within 5-7 business days',
                  ),
                  const SizedBox(height: 24),
        
                  // Section 4
                  _buildSectionTitle('4. Refund Timeline', context),
                  const SizedBox(height: 12),
                  _buildSectionContent(
                    context,
                    'Once your refund request is approved:',
                  ),
                  const SizedBox(height: 12),
                  _buildBulletPoint(
                    context,
                    'Credit card refunds typically appear in 5-10 business days',
                  ),
                  _buildBulletPoint(
                    context,
                    'Net banking and UPI refunds appear within 3-5 business days',
                  ),
                  _buildBulletPoint(
                    context,
                    'Wallet refunds are credited immediately',
                  ),
                  const SizedBox(height: 24),
        
                  // Section 5
                  _buildSectionTitle('5. Partial Refunds', context),
                  const SizedBox(height: 12),
                  _buildSectionContent(
                    context,
                    'If you have partially completed a course (between 10-30% completion), we may offer a partial refund at our discretion. The refund amount will be calculated based on the percentage of content completed.',
                  ),
                  const SizedBox(height: 24),
        
                  // Section 6
                  _buildSectionTitle('6. Course Bundles', context),
                  const SizedBox(height: 12),
                  _buildSectionContent(
                    context,
                    'If you purchased a course bundle, refunds are only applicable to the entire bundle, not individual courses. The bundle must meet all refund eligibility criteria.',
                  ),
                  const SizedBox(height: 24),
        
                  // Section 7
                  _buildSectionTitle('7. Special Circumstances', context),
                  const SizedBox(height: 12),
                  _buildSectionContent(
                    context,
                    'In cases of technical issues, course unavailability, or other special circumstances, we may authorize refunds outside of the standard policy. Please contact our support team for assistance.',
                  ),
                  const SizedBox(height: 24),
        
                  // Section 8
                  _buildSectionTitle('8. Policy Changes', context),
                  const SizedBox(height: 12),
                  _buildSectionContent(
                    context,
                    'We reserve the right to modify this refund policy at any time. Changes will be effective immediately upon posting to the application. Your continued use of the application constitutes acceptance of the updated policy.',
                  ),
                  const SizedBox(height: 32),
        
                  // FAQ Section
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: dialogBgColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.lightGray),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Need Help?',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'For questions about our refund policy or to initiate a refund request, please contact our support team at support@aviralera.com or use the "Contact Us" option in the app.',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(color: textColor),
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
    final textColor = Theme.of(context).textTheme.bodyMedium!.color!;
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: textColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildSectionContent(BuildContext context, String content) {
    final textColor = Theme.of(context).textTheme.bodyMedium!.color!;
    return Text(
      content,
      style: TextStyle(fontSize: 14, color: textColor, height: 1.6),
    );
  }

  Widget _buildBulletPoint(BuildContext context, String text) {
    final textColor = Theme.of(context).textTheme.bodyMedium!.color!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              fontSize: 14,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: textColor, height: 1.6),
            ),
          ),
        ],
      ),
    );
  }
}
