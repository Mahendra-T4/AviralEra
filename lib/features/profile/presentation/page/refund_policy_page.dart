import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_course/core/constants/app_colors.dart';
import 'package:online_course/core/di/sl.dart';
import 'package:online_course/core/service/connectivity/connectivity_checker.dart';
import 'package:online_course/core/service/connectivity/no_internat_page.dart';
import 'package:online_course/core/utils/custom_appbar.dart';
import 'package:online_course/features/profile/domain/usecase.dart';
import 'package:online_course/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:online_course/features/profile/presentation/widgets/section_widget.dart';

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
          body: BlocProvider(
            create: (context) =>
                sl<ProfileBloc>()..add(GetPoliciesDataEvent(policyType: 3)),
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                switch (state.runtimeType) {
                  case ProfileLoading:
                    return Center(child: CircularProgressIndicator());
                  case GetPoliciesDataSuccessState:
                    final data =
                        (state as GetPoliciesDataSuccessState).policyModel;
                    return data.status != 1
                        ? Center(child: Text(data.message.toString()))
                        : SingleChildScrollView(
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
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.info,
                                        color: AppColors.info,
                                        size: 20,
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          data.policyHeading.toString(),
                                          style: TextStyle(
                                            color: AppColors.infoDark,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),

                                ...ProfileUsecase.parseTitleandDescription(
                                  data.policyDescription ?? '',
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
                                const SizedBox(height: 24),
                              ],
                            ),
                          );
                  case ProfileErrorState:
                    return Center(child: Text('Opps? Something went wrong!!!'));
                  default:
                    return Center(child: Text('State not fount'));
                }
              },
            ),
          ),
        );
      },
    );
  }
}
