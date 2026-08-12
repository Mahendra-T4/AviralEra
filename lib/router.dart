import 'package:go_router/go_router.dart';
import 'package:online_course/features/auth/presentation/pages/set-password/set_pass.dart';
import 'package:online_course/features/pdf/pdf_panel.dart';
import 'package:online_course/features/player/video_player.dart';
import 'package:online_course/features/test/presentation/page/quiz.dart';
import 'package:online_course/features/test/presentation/widgets/quiz_introduction.dart';
import 'features.dart';

abstract class Routers {
  static const INITIAL_ROUTE = SplashScreen.routeName;
  static final GoRouter router = GoRouter(
    initialLocation: INITIAL_ROUTE,
    routes: [
      //! Splash Screen Route
      GoRoute(
        path: SplashScreen.routeName,
        name: SplashScreen.routeName,
        builder: (context, state) => const SplashScreen(),
      ),

      ShellRoute(
        builder: (context, state, child) => BottomNavBar(child: child),
        routes: [
          //! Home Route
          GoRoute(
            path: HomePage.routeName,
            name: HomePage.routeName,
            builder: (context, state) => const HomePage(),
          ),

          //! Home Route
          GoRoute(
            path: DownloadPanel.routeName,
            name: DownloadPanel.routeName,
            builder: (context, state) => const DownloadPanel(),
          ),

          //! Purchased Courses Route
          GoRoute(
            path: PurchasedCoursesPage.routeName,
            name: PurchasedCoursesPage.routeName,
            builder: (context, state) => const PurchasedCoursesPage(),
          ),

          //! Course Details Route
          GoRoute(
            path: CourseDetailsPage.routeName,
            name: CourseDetailsPage.routeName,
            builder: (context, state) => const CourseDetailsPage(),
          ),

          //! Course Search Route
          GoRoute(
            path: CourseSearchPage.routeName,
            name: CourseSearchPage.routeName,
            builder: (context, state) => const CourseSearchPage(),
          ),

          //! My Tests Route
          GoRoute(
            path: MyTestPage.routeName,
            name: MyTestPage.routeName,
            builder: (context, state) => const MyTestPage(),
          ),

          //! Profile Route
          GoRoute(
            path: ProfilePage.routeName,
            name: ProfilePage.routeName,
            builder: (context, state) => const ProfilePage(),
          ),

          //! Notifications Route
          GoRoute(
            path: NotificationsPage.routeName,
            name: NotificationsPage.routeName,
            builder: (context, state) => const NotificationsPage(),
          ),

          //! Update Profile Route
          GoRoute(
            path: UpdateProfilePage.routeName,
            name: UpdateProfilePage.routeName,
            builder: (context, state) => const UpdateProfilePage(),
          ),

          //! Settings Route
          GoRoute(
            path: SettingsPage.routeName,
            name: SettingsPage.routeName,
            builder: (context, state) => const SettingsPage(),
          ),

          //! Privacy Policy Route
          GoRoute(
            path: PrivacyPolicyPage.routeName,
            name: PrivacyPolicyPage.routeName,
            builder: (context, state) => const PrivacyPolicyPage(),
          ),

          //! Contact Us Route
          GoRoute(
            path: ContactUsPage.routeName,
            name: ContactUsPage.routeName,
            builder: (context, state) => const ContactUsPage(),
          ),

          //! About Us Route
          GoRoute(
            path: AboutUsPage.routeName,
            name: AboutUsPage.routeName,
            builder: (context, state) => const AboutUsPage(),
          ),
          //! Terms and conditions Route
          GoRoute(
            path: TermsAndConditionsPage.routeName,
            name: TermsAndConditionsPage.routeName,
            builder: (context, state) => const TermsAndConditionsPage(),
          ),

          //! Refund Policy Route
          GoRoute(
            path: RefundPolicyPage.routeName,
            name: RefundPolicyPage.routeName,
            builder: (context, state) => const RefundPolicyPage(),
          ),
          GoRoute(
            path: QuizPage.routeName,
            name: QuizPage.routeName,
            builder: (context, state) => const QuizPage(),
          ),
          GoRoute(
            path: VideoPlayerPanel.routeName,
            name: VideoPlayerPanel.routeName,
            builder: (context, state) => const VideoPlayerPanel(),
          ),
          GoRoute(
            path: QuizIntroduction.routeName,
            name: QuizIntroduction.routeName,
            builder: (context, state) => QuizIntroduction(),
          ),
          GoRoute(
            path: PDFPanel.routeName,
            name: PDFPanel.routeName,
            builder: (context, state) => const PDFPanel(),
          ),
          // GoRoute(
          //   path: DemoHome.routeName,
          //   name: DemoHome.routeName,
          //   builder: (context, state) => const DemoHome(),
          // ),
        ],
      ),

      // //! Notifications Route
      // GoRoute(
      //   path: BottomNavBar.routeName,
      //   name: BottomNavBar.routeName,
      //   builder: (context, state) => const BottomNavBar(),
      // ),

      //! Authentication Routes
      GoRoute(
        path: LoginPanel.routeName,
        name: LoginPanel.routeName,
        builder: (context, state) => const LoginPanel(),
      ),

      GoRoute(
        path: StudentRegisterPanel.routeName,
        name: StudentRegisterPanel.routeName,
        builder: (context, state) => const StudentRegisterPanel(),
      ),

      GoRoute(
        path: ForgotPasswordPanel.routeName,
        name: ForgotPasswordPanel.routeName,
        builder: (context, state) => const ForgotPasswordPanel(),
      ),

      GoRoute(
        path: ChangePasswordPanel.routeName,
        name: ChangePasswordPanel.routeName,
        builder: (context, state) => const ChangePasswordPanel(),
      ),
      GoRoute(
        path: OTPPanel.routeName,
        name: OTPPanel.routeName,
        builder: (context, state) => const OTPPanel(),
      ),

      GoRoute(
        path: SetPasswordPage.routeName,
        name: SetPasswordPage.routeName,
        builder: (context, state) => const SetPasswordPage(),
      ),

      //! Contact Us 2 Route
      GoRoute(
        path: ContactUsPage2.routeName,
        name: ContactUsPage2.routeName,
        builder: (context, state) => const ContactUsPage2(),
      ),
      GoRoute(
        path: TermsAndConditionsPage2.routeName,
        name: TermsAndConditionsPage2.routeName,
        builder: (context, state) => const TermsAndConditionsPage2(),
      ),
      GoRoute(
        path: NoInternetPage.routeName,
        name: NoInternetPage.routeName,
        builder: (context, state) => const NoInternetPage(),
      ),
    ],
  );
}
