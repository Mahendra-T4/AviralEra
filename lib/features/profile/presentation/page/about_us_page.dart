import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_course/assets/assets.dart';
import 'package:online_course/core/constants/app_colors.dart';
import 'package:online_course/core/di/sl.dart';
import 'package:online_course/core/service/connectivity/connectivity_checker.dart';
import 'package:online_course/core/service/connectivity/no_internat_page.dart';
import 'package:online_course/core/utils/custom_appbar.dart';
import 'package:online_course/features/profile/domain/usecase.dart';
import 'package:online_course/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:online_course/features/profile/presentation/widgets/section_widget.dart';

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
          body: BlocProvider(
            create: (context) => sl<ProfileBloc>()..add(GetAboutUsDataEvent()),
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                switch (state.runtimeType) {
                  case ProfileLoading:
                    return Center(child: CircularProgressIndicator());
                  case GetAboutUsDataSuccessState:
                    final data =
                        (state as GetAboutUsDataSuccessState).aboutUSModel;
                    return data.status != 1
                        ? Center(child: Text(data.message.toString()))
                        : SingleChildScrollView(
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
                                      border: Border.all(
                                        color: AppColors.primaryBlue,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          Assets.aviralEraLogo,
                                          height: 100,
                                          width: 100,
                                        ),
                                        const SizedBox(height: 16),

                                        Text(
                                          'Your Path to Online Learning',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: textColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // About Section – parsed dynamically from API
                                ...ProfileUsecase.parseTitleandDescription(
                                  data.aboutDescription ?? '',
                                ).map(
                                  (section) => Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 16.0,
                                    ),
                                    child: buildSection(
                                      context,
                                      title: section['title']!,
                                      content: section['content']!,
                                    ),
                                  ),
                                ),

                                // Key Features
                                Text(
                                  data.whyChooseUsTitle.toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _buildFeatureCard(
                                  context,
                                  icon: data.whyIconOne.toString(),
                                  title: data.whyHeadingOne.toString(),
                                  description: data.whyTaglineOne.toString(),
                                ),
                                const SizedBox(height: 12),
                                _buildFeatureCard(
                                  context,
                                  icon: data.whyIconTwo.toString(),
                                  title: data.whyHeadingTwo.toString(),
                                  description: data.whyTaglineTwo.toString(),
                                ),
                                const SizedBox(height: 12),
                                _buildFeatureCard(
                                  context,
                                  icon: data.whyIconThree.toString(),
                                  title: data.whyHeadingThree.toString(),
                                  description: data.whyTaglineThree.toString(),
                                ),
                                const SizedBox(height: 12),
                                _buildFeatureCard(
                                  context,
                                  icon: data.whyIconFour.toString(),
                                  title: data.whyHeadingFour.toString(),
                                  description: data.whyTaglineFour.toString(),
                                ),
                                const SizedBox(height: 24),

                                Text(
                                  data.byTheNumberHeading.toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildStatCard(
                                        context,
                                        data.byValueOne.toString(),
                                        data.byLabelOne.toString(),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildStatCard(
                                        context,
                                        data.byValueTwo.toString(),
                                        data.byLabelTwo.toString(),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildStatCard(
                                        context,
                                        data.byValueThree.toString(),
                                        data.byLabelThree.toString(),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),

                                // Contact CTA
                                Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: dialogBgColor,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColors.primaryBlue,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        data.haveQuestionTitle.toString(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: textColor,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        data.haveQuestionTagline.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: textColor,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (Navigator.canPop(context))
                                              Navigator.pop(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColors.primaryBlue,
                                            foregroundColor: AppColors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
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
                          );

                  case ProfileErrorState:
                    return const Center(
                      child: Text('Opps Something went wrong!'),
                    );
                  default:
                    return const Center(child: Text('State not found'));
                }
              },
            ),
          ),
        );
      },
    );
  }

  
  Widget _buildFeatureCard(
    BuildContext context, {
    required String icon,
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
            child: Image.network(
              icon,
              width: 24,
              height: 24,
              color: AppColors.primaryBlue,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.info_outline,
                color: AppColors.primaryBlue,
                size: 24,
              ),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                );
              },
            ),
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
