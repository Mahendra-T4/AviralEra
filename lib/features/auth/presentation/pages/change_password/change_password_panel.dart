import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:online_course/core/constants/app_colors.dart';
import 'package:online_course/core/database/user_db.dart';
import 'package:online_course/core/di/sl.dart';
import 'package:online_course/core/service/connectivity/connectivity_checker.dart';
import 'package:online_course/core/service/connectivity/no_internat_page.dart';
import 'package:online_course/core/utils/custom_toast.dart';
import 'package:online_course/features/auth/presentation/bloc/auth_bloc.dart';

class ChangePasswordPanel extends StatefulWidget {
  const ChangePasswordPanel({super.key});
  static const String routeName = '/change-password';

  @override
  State<ChangePasswordPanel> createState() => _ChangePasswordPanelState();
}

class _ChangePasswordPanelState extends State<ChangePasswordPanel>
    with TickerProviderStateMixin {
  late AuthBloc _authBloc;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;
  late AnimationController _fadeController;
  late AnimationController _slideController;

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  PasswordStrength _passwordStrength = PasswordStrength.weak;

  @override
  void initState() {
    super.initState();
    _authBloc = sl<AuthBloc>();
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    _newPasswordController.addListener(_evaluatePasswordStrength);

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _evaluatePasswordStrength() {
    final password = _newPasswordController.text;

    if (password.isEmpty) {
      setState(() => _passwordStrength = PasswordStrength.weak);
      return;
    }

    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasDigits = password.contains(RegExp(r'[0-9]'));
    bool hasSpecialChars = password.contains(
      RegExp(r'[!@#$%^&*()_+\-=\[\]{};:,.<>?]'),
    );
    // bool isLengthValid = password.length >= 8;

    int strengthScore = 0;
    if (password.length >= 6) strengthScore++;
    if (password.length >= 8) strengthScore++;
    if (hasUppercase && hasLowercase) strengthScore++;
    if (hasDigits) strengthScore++;
    if (hasSpecialChars) strengthScore++;

    setState(() {
      if (strengthScore <= 1) {
        _passwordStrength = PasswordStrength.weak;
      } else if (strengthScore <= 3) {
        _passwordStrength = PasswordStrength.medium;
      } else {
        _passwordStrength = PasswordStrength.strong;
      }
    });
  }

  void _handleChangePassword() {
    final currentPassword = _currentPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (_formKey.currentState!.validate()) {
      _authBloc.add(
        AuthChangePasswordEvent(
          currentPassword: currentPassword,
          newPassword: newPassword,
          confirmPassword: confirmPassword,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          body: Container(
            height: size.height,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.primaryBlueDark
                  : AppColors.primaryBlueLight,
            ),
            child: SafeArea(
              child: FadeTransition(
                opacity: _fadeController,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(height: size.height * 0.06),
                          // Header Section
                          SlideTransition(
                            position:
                                Tween<Offset>(
                                  begin: const Offset(0, -0.3),
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: _slideController,
                                    curve: Curves.easeOutCubic,
                                  ),
                                ),
                            child: Column(
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isDark
                                        ? AppColors.primaryBlueLight.withValues(
                                            alpha: 0.2,
                                          )
                                        : AppColors.primaryBlueDark.withValues(
                                            alpha: 0.2,
                                          ),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.3,
                                      ),
                                      width: 2,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.security_rounded,
                                    color: isDark
                                        ? AppColors.primaryBlueLight
                                        : AppColors.primaryBlueDark,
                                    size: 40,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'Change Password',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineMedium,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Update your password to keep your account secure',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: size.height * 0.08),
                          // Form Card
                          SlideTransition(
                            position:
                                Tween<Offset>(
                                  begin: const Offset(0, 0.3),
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: _slideController,
                                    curve: Curves.easeOutCubic,
                                  ),
                                ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: isDark ? Colors.grey[900] : Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 30,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(28),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Current Password Field
                                  _buildPasswordField(
                                    controller: _currentPasswordController,
                                    label: 'Current Password',
                                    hint: 'Enter your current password',
                                    icon: Icons.lock_outline,
                                    obscureText: _obscureCurrentPassword,
                                    onPasswordToggle: () {
                                      setState(
                                        () => _obscureCurrentPassword =
                                            !_obscureCurrentPassword,
                                      );
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your current password';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  // New Password Field
                                  _buildPasswordField(
                                    controller: _newPasswordController,
                                    label: 'New Password',
                                    hint: 'Enter your new password',
                                    icon: Icons.lock_outline,
                                    obscureText: _obscureNewPassword,
                                    onPasswordToggle: () {
                                      setState(
                                        () => _obscureNewPassword =
                                            !_obscureNewPassword,
                                      );
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your new password';
                                      }
                                      if (value.length < 6) {
                                        return 'Password must be at least 6 characters long';
                                      }
                                      if (value ==
                                          _currentPasswordController.text) {
                                        return 'New password cannot be same as current password';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                  // Password Strength Indicator
                                  if (_newPasswordController.text.isNotEmpty)
                                    _buildPasswordStrengthIndicator(),
                                  const SizedBox(height: 20),
                                  // Confirm Password Field
                                  _buildPasswordField(
                                    controller: _confirmPasswordController,
                                    label: 'Confirm New Password',
                                    hint: 'Re-enter your new password',
                                    icon: Icons.lock_outline,
                                    obscureText: _obscureConfirmPassword,
                                    onPasswordToggle: () {
                                      setState(
                                        () => _obscureConfirmPassword =
                                            !_obscureConfirmPassword,
                                      );
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your confirm password';
                                      }
                                      if (value !=
                                          _newPasswordController.text) {
                                        return 'Passwords do not match';
                                      }
                                      if (value ==
                                          _currentPasswordController.text) {
                                        return 'Confirm password cannot be same as current password';
                                      }
                                      if (value.length < 6) {
                                        return 'Confirm password must be at least 6 characters long';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                  // Password Match Indicator
                                  if (_newPasswordController.text.isNotEmpty &&
                                      _confirmPasswordController
                                          .text
                                          .isNotEmpty)
                                    _buildPasswordMatchIndicator(),
                                  const SizedBox(height: 28),
                                  // Change Password Button
                                  _buildChangePasswordButton(),
                                  const SizedBox(height: 16),
                                  // Back Button
                                  Align(
                                    alignment: Alignment.center,
                                    child: GestureDetector(
                                      onTap: () => context.pop(),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.arrow_back_rounded,
                                            color: Theme.of(
                                              context,
                                            ).textTheme.bodyMedium!.color,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Back',
                                            style: TextStyle(
                                              color: Theme.of(
                                                context,
                                              ).textTheme.bodyMedium!.color,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.06),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool obscureText,
    required VoidCallback onPasswordToggle,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Theme.of(context).textTheme.bodyMedium!.color,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6366f1).withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              prefixIcon: Icon(icon, color: Colors.indigoAccent, size: 20),
              suffixIcon: GestureDetector(
                onTap: onPasswordToggle,
                child: Icon(
                  obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.indigoAccent,
                  size: 20,
                ),
              ),
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF6366f1),
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    final strength = _passwordStrength;
    final strengthLabel = strength == PasswordStrength.weak
        ? 'Weak'
        : strength == PasswordStrength.medium
        ? 'Medium'
        : 'Strong';
    final strengthColor = strength == PasswordStrength.weak
        ? AppColors.error
        : strength == PasswordStrength.medium
        ? AppColors.warning
        : AppColors.success;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Password Strength: ',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              strengthLabel,
              style: TextStyle(
                fontSize: 12,
                color: strengthColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: strength == PasswordStrength.weak
                ? 0.33
                : strength == PasswordStrength.medium
                ? 0.66
                : 1.0,
            minHeight: 6,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(strengthColor),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordMatchIndicator() {
    final isMatch =
        _newPasswordController.text == _confirmPasswordController.text;
    final matchColor = isMatch ? AppColors.success : AppColors.error;
    final matchLabel = isMatch ? 'Passwords match' : 'Passwords do not match';

    return Row(
      children: [
        Icon(
          isMatch ? Icons.check_circle_rounded : Icons.cancel_rounded,
          color: matchColor,
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          matchLabel,
          style: TextStyle(
            fontSize: 12,
            color: matchColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildChangePasswordButton() {
    return BlocConsumer(
      bloc: _authBloc,
      listener: (context, state) {
        if (state is AuthChangePasswordLoadedSuccessState) {
          if (state.model.status == 1) {
            ToastUtils.showToast(
              context,
              ToastType.success,
              Colors.white,
              message: state.model.message.toString(),
              icon: Icons.check_circle_outlined,
            );
            Future.delayed(Duration(seconds: 2), () {
              UserDB.logout(context);
            });
          } else {
            ToastUtils.showToast(
              context,
              ToastType.error,
              Colors.white,
              message: state.model.message.toString(),
              icon: Icons.error_outline,
            );
          }
        } else if (state is AuthChangePasswordFailedState) {
          ToastUtils.showToast(
            context,
            ToastType.error,
            Colors.white,
            message: state.message,
            icon: Icons.error_outline,
          );
        }
      },
      builder: (context, state) {
        if (state is AuthLoadingState)
          return Center(child: CircularProgressIndicator());
        return GestureDetector(
          onTap: _handleChangePassword,
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBlue.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'Change Password',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

enum PasswordStrength { weak, medium, strong }
