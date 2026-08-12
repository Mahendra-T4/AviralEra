import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import 'package:online_course/assets/assets.dart';
import 'package:online_course/core/constants/app_colors.dart';
import 'package:online_course/core/service/connectivity/connectivity_checker.dart';
import 'package:online_course/core/service/connectivity/no_internat_page.dart';
import 'package:online_course/core/utils/custom_snackbar.dart';
import 'package:online_course/features/auth/presentation/pages/otp/opt_panel.dart';
import 'package:online_course/features/profile/presentation/page/term_and_condition_page2.dart';
import 'package:online_course/features/profile/presentation/page/terms_and_conditions_page.dart';

class StudentRegisterPanel extends StatefulWidget {
  const StudentRegisterPanel({super.key});
  static const String routeName = '/register/register-student';

  @override
  State<StudentRegisterPanel> createState() => _StudentRegisterPanelState();
}

class _StudentRegisterPanelState extends State<StudentRegisterPanel>
    with SingleTickerProviderStateMixin {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  bool isChecked = false;
  bool _isPasswordVisible = true;
  bool _isConfirmPasswordVisible = true;

  // Text controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _alternateMobileController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Form state variables
  String? _selectedGender;
  DateTime? _selectedDOB;
  bool _isLoading = false;
  String? _selectedCourseName;
  String? _selectedCourseType;

  // Gender options
  final List<String> _genderOptions = ['Male', 'Female', 'Other'];

  // Course names
  final List<String> _courseNames = [
    'Web Development',
    'Mobile App Development',
    'Data Science',
    'Machine Learning',
    'Python Programming',
    'Java Programming',
    'UI/UX Design',
    'Digital Marketing',
    'Cloud Computing',
  ];

  // Course types
  final List<String> _courseTypes = [
    'Workshop',
    'Certification',
    'Diploma',
    'Short Course',
    'Bootcamp',
    'Mentorship',
  ];

  // State list (Indian states - expandable)
  final List<String> _states = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    // Slide animation for logo
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    // Scale animation for text
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _alternateMobileController.dispose();
    _fatherNameController.dispose();
    _motherNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  /// Validate form and handle registration
  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      // if (_selectedGender == null) {
      //   CustomSnackBar.error(context, message: 'Please select a gender');
      //   return;
      // }
      // if (_selectedDOB == null) {
      //   CustomSnackBar.error(context, message: 'Please select date of birth');
      //   return;
      // }
      if (_selectedCourseName == null) {
        CustomSnackBar.error(context, message: 'Please select a course name');
        return;
      }
      if (_selectedCourseType == null) {
        CustomSnackBar.error(context, message: 'Please select a course type');
        return;
      }

      // Proceed with registration
      _performRegistration();
    }
  }

  /// Perform registration (placeholder)
  void _performRegistration() {
    setState(() => _isLoading = true);

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isLoading = false);

      if (mounted) {
        CustomSnackBar.success(context, message: 'Registration successful!');
        GoRouter.of(context).goNamed(OTPPanel.routeName);

        // Clear form
        _formKey.currentState?.reset();
        _firstNameController.clear();
        _lastNameController.clear();
        _emailController.clear();
        _mobileController.clear();
        _alternateMobileController.clear();
        _fatherNameController.clear();
        _motherNameController.clear();
        _cityController.clear();
        _stateController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();
        setState(() {
          _selectedGender = null;
          _selectedDOB = null;
          _selectedCourseName = null;
          _selectedCourseType = null;
        });
      }
    });
  }

  Widget _buildLogoSection() {
    return Container(
      width: 80,
      height: 80,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryBlue, AppColors.primaryBlueDark],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Image.asset(
        Assets.aviralEraLogo,
        width: 60,
        height: 60,
        fit: BoxFit.contain,
      ),
    );
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
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
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
                            position: _slideAnimation,
                            child: FadeTransition(
                              opacity: _fadeAnimation,

                              child: _buildLogoSection(),
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
                          _buildModernSectionCard(
                            context: context,
                            title: 'Personal Information',
                            stepNumber: 1,
                            children: [
                              // First Name & Last Name (Row)
                              _buildModernTextField(
                                controller: _firstNameController,
                                label: 'First Name',
                                hint: 'Enter first name',
                                icon: Icons.person_outline,
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
                              _buildModernTextField(
                                controller: _lastNameController,
                                label: 'Last Name',
                                hint: 'Enter last name',
                                icon: Icons.person_outline,
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
                              _buildModernTextField(
                                controller: _emailController,
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
                          _buildModernSectionCard(
                            context: context,
                            title: 'Contact Information',
                            stepNumber: 2,
                            children: [
                              _buildModernTextField(
                                controller: _mobileController,
                                label: 'Mobile',
                                hint: '10-digit number',
                                icon: Icons.phone_outlined,
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
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
                              _buildModernTextField(
                                controller: _alternateMobileController,
                                label: 'Alternate Mobile',
                                hint: '10-digit number',
                                icon: Icons.phone_outlined,
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
                          _buildModernSectionCard(
                            context: context,
                            title: 'Course Selection',
                            stepNumber: 3,
                            children: [
                              _buildModernDropdownField(
                                label: 'Course Name',
                                value: _selectedCourseName,
                                items: _courseNames,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCourseName = value;
                                  });
                                },
                                icon: Icons.school_outlined,
                              ),
                              const SizedBox(height: 16),
                              _buildModernDropdownField(
                                label: 'Course Type',
                                value: _selectedCourseType,
                                items: _courseTypes,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCourseType = value;
                                  });
                                },
                                icon: Icons.category_outlined,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Section 4: Password Setup
                          _buildModernSectionCard(
                            context: context,
                            title: 'Password Setup',
                            stepNumber: 4,
                            children: [
                              _buildModernTextField(
                                controller: _passwordController,
                                label: 'Password',
                                hint: 'Enter your password',
                                icon: Icons.lock_outlined,
                                keyboardType: TextInputType.text,
                                obscureText: _isPasswordVisible,
                                isPassword: true,
                                onPasswordToggle: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
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
                              _buildModernTextField(
                                controller: _confirmPasswordController,
                                label: 'Confirm Password',
                                hint: 'Confirm your password',
                                icon: Icons.lock_outlined,
                                keyboardType: TextInputType.text,
                                obscureText: _isConfirmPasswordVisible,
                                isPassword: true,
                                onPasswordToggle: () {
                                  setState(() {
                                    _isConfirmPasswordVisible =
                                        !_isConfirmPasswordVisible;
                                  });
                                },
                                maxLength: 100,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter confirm your password';
                                  }
                                  if (value != _passwordController.text) {
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
                          _buildModernRegisterButton(context),
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
  Widget _buildModernSectionCard({
    required BuildContext context,
    required String title,
    required int stepNumber,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGray, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.accentOrange,
                      AppColors.accentOrangeDark,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '$stepNumber',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Fields
          ...children,
        ],
      ),
    );
  }

  /// Build modern text field
  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    bool isPassword = false,
    bool obscureText = false,
    String? Function(String?)? validator,
    VoidCallback? onPasswordToggle,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      validator: validator,
      obscureText: isPassword ? obscureText : false,
      obscuringCharacter: '*',
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixIcon: isPassword
            ? GestureDetector(
                onTap: onPasswordToggle,
                child: Icon(
                  obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.indigoAccent,
                  size: 20,
                ),
              )
            : null,
        prefixIcon: Icon(icon, color: AppColors.primaryBlue, size: 20),
        counterText: '',
        filled: true,
        fillColor: AppColors.primaryBlueLighter,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightGray, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
        ),
        labelStyle: const TextStyle(
          color: AppColors.primaryBlue,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: TextStyle(
          color: AppColors.mediumGray.withValues(alpha: 0.7),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      style: const TextStyle(
        color: AppColors.darkGray,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  /// Build modern dropdown field
  Widget _buildModernDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required IconData icon,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primaryBlue, size: 20),
        filled: true,
        fillColor: AppColors.primaryBlueLighter,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightGray, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
        ),
        labelStyle: const TextStyle(
          color: AppColors.primaryBlue,
          fontWeight: FontWeight.w500,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select $label';
        }
        return null;
      },
      style: const TextStyle(
        color: AppColors.darkGray,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  /// Build modern register button
  Widget _buildModernRegisterButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleRegister,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          disabledBackgroundColor: AppColors.primaryBlue.withValues(alpha: 0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 4,
          shadowColor: AppColors.primaryBlue.withValues(alpha: 0.3),
        ),
        child: _isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.white.withValues(alpha: 0.9),
                  ),
                  strokeWidth: 2.5,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isLoading
                        ? Icons.hourglass_empty
                        : Icons.check_circle_outline,
                    color: AppColors.white,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _isLoading ? 'Registering...' : 'Create Account',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
