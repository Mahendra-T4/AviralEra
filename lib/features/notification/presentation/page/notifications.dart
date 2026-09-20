import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_course/core/constants/app_colors.dart';
import 'package:online_course/core/di/sl.dart';
import 'package:online_course/core/service/connectivity/connectivity_checker.dart';
import 'package:online_course/core/service/connectivity/no_internat_page.dart';
import 'package:online_course/core/utils/custom_appbar.dart';
import 'package:online_course/features/notification/presentation/bloc/notification_bloc.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});
  static const String routeName = '/notifications';

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  late NotificationBloc notificationBloc;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    notificationBloc = sl<NotificationBloc>()..add(GetNotificationEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBackground : const Color(0xFFF4F6FB);
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
          backgroundColor: bg,
          appBar: CustomAppBar(
            title: 'Notifications',
            showNotificationIcon: false,
          ),
          body: _buildContentBody(isDark: isDark),
        );
      },
    );
  }

  Widget _buildContentBody({required bool isDark}) => BlocBuilder(
    bloc: notificationBloc,
    builder: (context, state) {
      switch (state.runtimeType) {
        case NotificationLoadingState:
          return Center(child: CircularProgressIndicator());
        case NotificationLoadedSuccessState:
          final notifications = (state as NotificationLoadedSuccessState).model;

          if (notifications.status != 1) {
            return Center(child: Text(notifications.message.toString()));
          }

          return ListView.builder(
            itemCount: notifications.notification?.length,

            padding: const EdgeInsets.only(top: 10, bottom: 10),
            itemBuilder: (context, index) {
              final cardBgColor = isDark
                  ? AppColors.darkSurface
                  : AppColors.white;
              final borderColor = isDark
                  ? AppColors.white.withValues(alpha: 0.1)
                  : AppColors.lightGray;

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: borderColor, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.35)
                          : AppColors.primaryBlue.withValues(alpha: 0.08),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(22),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(22),
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isDark
                                    ? [
                                        AppColors.primaryBlue,
                                        AppColors.primaryBlueDark,
                                      ]
                                    : [
                                        AppColors.primaryBlueLight,
                                        AppColors.primaryBlueLighter,
                                      ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.notifications_rounded,
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.primaryBlueDark,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  notifications
                                      .notification![index]
                                      .notificationSubject
                                      .toString(),

                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.getTextColor(context),
                                    height: 1.35,
                                  ),
                                ),
                                Text(
                                  notifications
                                      .notification![index]
                                      .notificationDate
                                      .toString(),

                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.getTextColor(context),
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        case NotificationErrorFailState:
          return Center(child: Text('Opps? Something went wrong.'));
        default:
          return const Center(child: Text('State not found'));
      }
    },
  );
}
