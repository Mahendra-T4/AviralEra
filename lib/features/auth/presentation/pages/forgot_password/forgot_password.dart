import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:online_course/core/constants/app_colors.dart';
import 'package:online_course/core/service/connectivity/connectivity_checker.dart';
import 'package:online_course/core/service/connectivity/no_internat_page.dart';

import 'package:online_course/core/utils/custom_snackbar.dart';
import 'package:online_course/core/utils/custom_toast.dart';
import 'package:online_course/features/auth/presentation/pages/otp/opt_panel.dart';

class ForgotPasswordPanel extends StatefulWidget {
  const ForgotPasswordPanel({super.key});
  static const String routeName = '/forgot-password';

  @override
  State<ForgotPasswordPanel> createState() => _ForgotPasswordPanelState();
}

class _ForgotPasswordPanelState extends State<ForgotPasswordPanel>
    with TickerProviderStateMixin {
  // late TextEditingController _emailController;
  late TextEditingController _mobileController;
  late TextEditingController _otpController;
  late AnimationController _fadeController;
  late AnimationController _slideController;

  String _selectedMethod = 'email'; // 'email' or 'mobile'
  bool _isLoading = false;
  bool _otpSent = false;

  @override
  void initState() {
    super.initState();
    // _emailController = TextEditingController();
    _mobileController = TextEditingController();
    _otpController = TextEditingController();

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
    // _emailController.dispose();
    _mobileController.dispose();
    _otpController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _handleSendCode() {
    String contactInfo = _mobileController.text;

    if (contactInfo.isEmpty) {
      ToastUtils.showToast(
        context,
        ToastType.warning,
        Colors.white,
        message: 'Please enter your mobile number',
        icon: Icons.error,
      );

      return;
    }

    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _otpSent = true;
        });
        ToastUtils.showToast(
          context,
          ToastType.warning,
          Colors.white,
          message: 'OTP sent to your mobile number',
          icon: Icons.error,
        );
        context.pushNamed(OTPPanel.routeName);
      }
    });
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
            decoration: BoxDecoration(color: AppColors.primaryBlueDark),
            child: SafeArea(
              child: FadeTransition(
                opacity: _fadeController,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                                  color: Colors.white.withValues(alpha: 0.2),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  _otpSent
                                      ? Icons.verified_user_rounded
                                      : Icons.lock_reset_rounded,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                _otpSent
                                    ? 'Verify Your Account'
                                    : 'Reset Password',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _otpSent
                                    ? 'Enter the OTP sent to your ${_selectedMethod == 'email' ? 'email' : 'mobile number'}'
                                    : 'We will send you a code to reset your password',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Colors.white.withValues(
                                        alpha: 0.8,
                                      ),
                                    ),
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
                                const SizedBox(height: 28),
                                _buildTextField(
                                  controller: _mobileController,
                                  label: 'Mobile Number',
                                  hint: 'Enter your mobile number',
                                  icon: Icons.phone_outlined,
                                  keyboardType: TextInputType.phone,
                                  prefix: '+91 ',
                                  maxLength: 10,
                                ),
                                const SizedBox(height: 24),
                                // Send Code Button
                                _buildSendButton(),
                                const SizedBox(height: 16),
                                // Back to Login Link
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
                                          color: AppColors.primaryBlueDark,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Back to Login',
                                          style: TextStyle(
                                            color: AppColors.primaryBlueDark,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // const SizedBox(height: 12),
                                // Text(
                                //   'Didn\'t receive the code?',
                                //   style: TextStyle(
                                //     fontSize: 12,
                                //     color: Colors.grey[600],
                                //   ),
                                // ),
                                // const SizedBox(height: 8),
                                // GestureDetector(
                                //   onTap: _isLoading ? null : _handleResendOTP,
                                //   child: Text(
                                //     'Resend OTP',
                                //     style: TextStyle(
                                //       color: AppColors.accentOrange,
                                //       fontWeight: FontWeight.w600,
                                //       fontSize: 14,
                                //     ),
                                //   ),
                                // ),
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
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? prefix,
    int? maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: AppColors.primaryBlueDark,
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
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLength: maxLength,

            decoration: InputDecoration(
              hintText: hint,

              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              prefixIcon: Icon(icon, color: Colors.indigoAccent, size: 20),
              prefix: prefix != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Text(
                        prefix,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : null,
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
              counterText: '',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSendButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _handleSendCode,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: AppColors.accentGradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentOrange.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: _isLoading
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                )
              : Text(
                  'Send Code',
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
  }
}
