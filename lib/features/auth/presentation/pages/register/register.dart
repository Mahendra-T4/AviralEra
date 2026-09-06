import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:online_course/assets/assets.dart';
import 'package:online_course/core/constants/app_colors.dart';
import 'package:online_course/core/di/sl.dart';
import 'package:online_course/core/service/connectivity/connectivity_checker.dart';
import 'package:online_course/core/service/connectivity/no_internat_page.dart';
import 'package:online_course/core/utils/custom_snackbar.dart';
import 'package:online_course/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:online_course/features/auth/presentation/pages/otp/opt_panel.dart';
import 'package:online_course/features/auth/presentation/pages/register/register_builder.dart';
import 'package:online_course/features/my_course/presentation/widgets/course_list_dropdown.dart';
import 'package:online_course/features/my_course/presentation/widgets/course_type_dropdown.dart';
import 'package:online_course/features/profile/presentation/page/term_and_condition_page2.dart';

class StudentRegisterPanel extends StatefulWidget {
  const StudentRegisterPanel({super.key});
  static const String routeName = '/register/register-student';

  @override
  State<StudentRegisterPanel> createState() => _StudentRegisterPanelState();
}

class _StudentRegisterPanelState extends RegisterBuilder
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    authBloc = sl<AuthBloc>();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Fade animation
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeIn),
    );

    // Slide animation for logo
    slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        );

    // Scale animation for text
    scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    animationController.forward();
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
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          backgroundColor: isDark ? AppColors.darkBackground : Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Modern Gradient Header
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SlideTransition(
                            position: slideAnimation,
                            child: FadeTransition(
                              opacity: fadeAnimation,

                              child: buildLogoSection(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Create Your Account',
                            style: Theme.of(context).textTheme.headlineLarge!
                                .copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Join our learning community today',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: AppColors.white.withValues(alpha: 0.9),
                                ),
                          ),
                        ],
                      ),
                    ),

                    // Content with padding
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Section 1: Personal Information
                          buildModernSectionCard(
                            context: context,
                            title: 'Personal Information',
                            stepNumber: 1,
                            children: [
                              // First Name & Last Name (Row)
                              buildModernTextField(
                                controller: firstNameController,
                                label: 'First Name',
                                hint: 'Enter first name',
                                icon: Icons.person_outline,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z]'),
                                  ),
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'First name is required';
                                  }
                                  if (value.length < 2) {
                                    return 'Minimum 2 characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              buildModernTextField(
                                controller: lastNameController,
                                label: 'Last Name',
                                hint: 'Enter last name',
                                icon: Icons.person_outline,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z]'),
                                  ),
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Last name is required';
                                  }
                                  if (value.length < 2) {
                                    return 'Minimum 2 characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // Email
                              buildModernTextField(
                                controller: emailController,
                                label: 'Email ID',
                                hint: 'Enter your email address',
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Email is required';
                                  }
                                  if (!RegExp(
                                    r'^[^@]+@[^@]+\.[^@]+',
                                  ).hasMatch(value)) {
                                    return 'Enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Section 2: Contact Information
                          buildModernSectionCard(
                            context: context,
                            title: 'Contact Information',
                            stepNumber: 2,
                            children: [
                              buildModernTextField(
                                controller: mobileController,
                                label: 'Mobile',
                                hint: '10-digit number',
                                icon: Icons.phone_outlined,
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Mobile is required';
                                  }
                                  if (value.length != 10) {
                                    return 'Enter 10 digits';
                                  }
                                  if (!RegExp(r'^\d+$').hasMatch(value)) {
                                    return 'Only numbers allowed';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              buildModernTextField(
                                controller: alternateMobileController,
                                label: 'Alternate Mobile',
                                hint: '10-digit number',
                                icon: Icons.phone_outlined,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                validator: (value) {
                                  if (value != null && value.isNotEmpty) {
                                    if (value.length != 10) {
                                      return 'Enter 10 digits';
                                    }
                                    if (!RegExp(r'^\d+$').hasMatch(value)) {
                                      return 'Only numbers allowed';
                                    }
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Section 3: Course Selection
                          buildModernSectionCard(
                            context: context,
                            title: 'Course Selection',
                            stepNumber: 3,
                            children: [
                              CourseListDropdownWidget(
                                courseName: selectedCourseName,
                                onChanged: (value) {
                                  setState(() {
                                    selectedCourseName = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),
                              CourseTypeDropdownWidget(
                                courseName: selectedCourseType,
                                onChanged: (value) {
                                  setState(() {
                                    selectedCourseType = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Section 4: Password Setup
                          buildModernSectionCard(
                            context: context,
                            title: 'Password Setup',
                            stepNumber: 4,
                            children: [
                              buildModernTextField(
                                controller: passwordController,
                                label: 'Password',
                                hint: 'Enter your password',
                                icon: Icons.lock_outlined,
                                keyboardType: TextInputType.text,
                                obscureText: isPasswordVisible,
                                isPassword: true,
                                onPasswordToggle: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                                maxLength: 100,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a password';
                                  }

                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }

                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              buildModernTextField(
                                controller: confirmPasswordController,
                                label: 'Confirm Password',
                                hint: 'Confirm your password',
                                icon: Icons.lock_outlined,
                                keyboardType: TextInputType.text,
                                obscureText: isConfirmPasswordVisible,
                                isPassword: true,
                                onPasswordToggle: () {
                                  setState(() {
                                    isConfirmPasswordVisible =
                                        !isConfirmPasswordVisible;
                                  });
                                },
                                maxLength: 100,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter confirm your password';
                                  }
                                  if (value != passwordController.text) {
                                    return 'Confirm passwords do not match';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),
                          Row(
                            children: [
                              Checkbox(
                                value: isChecked,
                                onChanged: (value) {
                                  setState(() {
                                    isChecked = !isChecked;
                                  });
                                },
                                activeColor: AppColors.primaryBlue,
                                checkColor: AppColors.white,
                              ),
                              TextButton(
                                child: Text(
                                  'I agree to the Terms and Conditions',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: AppColors.tertiaryPurple,
                                        fontSize: 15,
                                      ),
                                ),
                                onPressed: () {
                                  GoRouter.of(context).pushNamed(
                                    TermsAndConditionsPage2.routeName,
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Register Button
                          buildModernRegisterButton(context),
                          const SizedBox(height: 16),

                          // Login Link
                          Center(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Already have an account? ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: AppColors.mediumGray),
                                  ),
                                  TextSpan(
                                    text: 'Login',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: AppColors.primaryBlue,
                                          fontWeight: FontWeight.w600,
                                        ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Navigator.pop(context),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
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
  }

  /// Build modern section card
}
