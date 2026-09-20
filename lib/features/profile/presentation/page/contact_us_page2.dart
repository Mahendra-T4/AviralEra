import 'package:flutter/material.dart';

import 'package:online_course/core/service/connectivity/connectivity_checker.dart';
import 'package:online_course/core/service/connectivity/no_internat_page.dart';
import 'package:online_course/core/utils/custom_appbar.dart';
import 'package:online_course/features/profile/presentation/widgets/contact_us_body.dart';

class ContactUsPage2 extends StatefulWidget {
  const ContactUsPage2({super.key});
  static const String routeName = '/contact-us2';

  @override
  State<ContactUsPage2> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage2> {
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
            title: 'Contact Us',
            showBackButton: false,
            showNotificationIcon: false,
          ),
          body: ContactUsBody(),
        );
      },
    );
  }
}
