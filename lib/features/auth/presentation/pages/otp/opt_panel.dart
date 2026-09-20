import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'package:online_course/assets/assets.dart';
import 'package:online_course/core/constants/app_colors.dart';
import 'package:online_course/core/database/user_db.dart';
import 'package:online_course/core/di/sl.dart';
import 'package:online_course/core/service/connectivity/connectivity_checker.dart';
import 'package:online_course/core/service/connectivity/no_internat_page.dart';
import 'package:online_course/core/utils/custom_toast.dart';
import 'package:online_course/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:online_course/features/auth/presentation/pages/login/login_panel.dart';
import 'package:online_course/features/auth/presentation/pages/set-password/set_pass.dart';
import 'package:online_course/features/profile/presentation/page/contact_us_page2.dart';

class OTPPanel extends StatefulWidget {
  const OTPPanel({super.key, this.data});
  final OTPPanelParam? data;

  static const String routeName = '/auth/otp';

  @override
  State<OTPPanel> createState() => _OTPPanelState();
}

class OTPPanelParam {
  final int? panelID;
  final String? mobileNumber;

  OTPPanelParam({this.panelID, this.mobileNumber});
}

class _OTPPanelState extends State<OTPPanel> with TickerProviderStateMixin {
  late AuthBloc _authBloc;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // OTP Controllers
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  bool _isLoading = false;
  int _verificationTimer = 60;
  late AnimationController _timerController;
  Timer? _verificationTimerObject;

  @override
  void initState() {
    super.initState();
    _authBloc = sl<AuthBloc>();
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

    _animationController.forward();

    _timerController = AnimationController(
      duration: const Duration(seconds: 60),
      vsync: this,
    );

    // Start verification timer
    _startVerificationTimer();

    // Auto-focus first field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNodes[0]);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timerController.dispose();
    _verificationTimerObject?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  /// Handle OTP input
  void _handleOTPInput(String value, int index) {
    if (value.length == 1) {
      // Move to next field
      if (index < 5) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        // Last field - dismiss keyboard
        FocusScope.of(context).unfocus();
      }
    } else if (value.isEmpty) {
      // Move to previous field on backspace
      if (index > 0) {
        _otpControllers[index].clear();
        FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
      }
    }
  }

  /// Get full OTP
  String getFullOTP() {
    if (_otpControllers.any((controller) => controller.text.isEmpty)) {
      return '';
    }
    return _otpControllers.map((controller) => controller.text).join();
  }

  /// Start verification timer
  void _startVerificationTimer() {
    // Cancel any existing timer
    _verificationTimerObject?.cancel();

    if (!mounted) return;

    setState(() => _verificationTimer = 60);

    _verificationTimerObject = Timer.periodic(const Duration(seconds: 1), (
      timer,
    ) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        _verificationTimer--;
        if (_verificationTimer <= 0) {
          timer.cancel();
        }
      });
    });
  }

  /// Verify OTP
  void _handleVerifyOTP() {
    if (_verificationTimer <= 0) {
      ToastUtils.showToast(
        context,
        ToastType.error,
        Colors.white,
        message: 'OTP verification time expired',
        icon: Icons.error,
      );
      return;
    }

    // String otp = getFullOTP();

    // if (otp.length != 6 || otp == "") {
    //   ToastUtils.showToast(
    //     context,
    //     ToastType.warning,
    //     Colors.white,
    //     message: 'Please enter all 6 digits',
    //     icon: Icons.check,
    //   );
    //   return;
    // }

    _authBloc.add(
      OTPVerifyEvent(
        uMobile: widget.data?.mobileNumber ?? '',
        uOTP: getFullOTP(),
        vType: widget.data?.panelID != 1 ? '1' : '0',
      ),
    );
  }

  /// Resend OTP
  void _handleResendOTP() {
    // Only allow resend once the verification timer has finished
    if (_verificationTimer > 0) return;

    // Clear current OTP input
    for (var controller in _otpControllers) {
      controller.clear();
    }

    // Restart the main verification timer
    _startVerificationTimer();

    // Re-focus the first field
    FocusScope.of(context).requestFocus(_focusNodes[0]);

    ToastUtils.showToast(
      context,
      ToastType.success,
      Colors.white,
      message: 'OTP resent successfully!',
      icon: Icons.check,
    );
  }

  /// Build OTP input field
  Widget _buildOTPInput(int index, bool isDark) {
    return SizedBox(
      width: 50,
      height: 60,
      child: TextFormField(
        controller: _otpControllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: (value) => _handleOTPInput(value, index),
        decoration: InputDecoration(
          filled: true,
          fillColor: isDark
              ? const Color(0xFF111827)
              : AppColors.primaryBlueLighter,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDark ? Colors.grey[700]! : AppColors.lightGray,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDark ? Colors.grey[600]! : AppColors.lightGray,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDark ? Colors.blue[300]! : AppColors.primaryBlue,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding: EdgeInsets.zero,
        ),
        style: TextStyle(
          color: isDark ? Colors.white : AppColors.darkGray,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
    );
  }

  /// Build logo section
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
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
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
                          'Verify Your Identity',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Enter the 6-digit code we sent to your mobile number.',
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
                      vertical: 32,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // OTP Input Section
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1F2937)
                                : AppColors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark
                                  ? Colors.grey[700]!
                                  : AppColors.lightGray,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isDark
                                    ? Colors.black.withOpacity(0.3)
                                    : AppColors.primaryBlue.withValues(
                                        alpha: 0.06,
                                      ),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Enter OTP Code',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      color: isDark
                                          ? Colors.white
                                          : AppColors.primaryBlue,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 24),

                              // Timer Display
                              Center(
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: _verificationTimer <= 10
                                          ? [
                                              Colors.red.shade400,
                                              Colors.red.shade600,
                                            ]
                                          : [
                                              AppColors.primaryBlue,
                                              AppColors.primaryBlueDark,
                                            ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            (_verificationTimer <= 10
                                                    ? Colors.red
                                                    : AppColors.primaryBlue)
                                                .withValues(alpha: 0.3),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // Circular Progress
                                      SizedBox(
                                        width: 120,
                                        height: 120,
                                        child: CircularProgressIndicator(
                                          value: _verificationTimer / 60,
                                          strokeWidth: 8,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                _verificationTimer <= 10
                                                    ? Colors.red.shade300
                                                    : AppColors
                                                          .primaryBlueLighter,
                                              ),
                                          backgroundColor:
                                              (_verificationTimer <= 10
                                                      ? Colors.red
                                                      : AppColors.primaryBlue)
                                                  .withValues(alpha: 0.2),
                                        ),
                                      ),
                                      // Timer Text
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            _verificationTimer.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineLarge
                                                ?.copyWith(
                                                  color: AppColors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 48,
                                                ),
                                          ),
                                          Text(
                                            'seconds',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: AppColors.white
                                                      .withValues(alpha: 0.8),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),

                              // OTP Input Fields
                              Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: List.generate(
                                    6,
                                    (index) => _buildOTPInput(index, isDark),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),

                              // Verify Button
                              //!------------
                              otpVerifyButtonWidget,
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Resend OTP Section - only visible once the verification timer ends
                        if (_verificationTimer <= 0) ...[
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.accentOrange.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.accentOrange.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Text(
                                  'Didn\'t receive the code?',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: AppColors.mediumGray,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: double.infinity,
                                  height: 44,
                                  child: OutlinedButton(
                                    onPressed: _handleResendOTP,
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                        color: AppColors.accentOrange,
                                        width: 1.5,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      'Resend OTP',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            color: AppColors.accentOrange,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        // Help text
                        Center(
                          child: InkWell(
                            onTap: () {
                              GoRouter.of(
                                context,
                              ).pushNamed(ContactUsPage2.routeName);
                            },
                            child: Text(
                              'Having trouble? Contact support',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: AppColors.mediumGray,
                                    decoration: TextDecoration.underline,
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget get otpVerifyButtonWidget => BlocConsumer(
    bloc: _authBloc,
    listener: (context, state) {
      if (state is AuthOTPVerificationLoadedSuccessState) {
        if (state.otpVerifyModel.status == 1) {
          final successMsg =
              (state.otpVerifyModel.message != null &&
                  state.otpVerifyModel.message.toString().isNotEmpty &&
                  state.otpVerifyModel.message.toString() != 'null')
              ? state.otpVerifyModel.message.toString()
              : 'OTP verified successfully!';
          ToastUtils.showToast(
            context,
            ToastType.success,
            Colors.white,
            message: successMsg,
            icon: Icons.check,
          );
          Future.delayed(const Duration(milliseconds: 600), () {
            if (!mounted) return;
            if (widget.data?.panelID == 1) {
              GoRouter.of(context).goNamed(LoginPanel.routeName);
              if (UserDB.token) {
                UserDB.logout(context);
              }
            } else {
              GoRouter.of(context).goNamed(
                SetPasswordPage.routeName,
                extra: state.otpVerifyModel.userKey,
              );
            }
          });
        } else {
          final errorMsg =
              (state.otpVerifyModel.message != null &&
                  state.otpVerifyModel.message.toString().isNotEmpty &&
                  state.otpVerifyModel.message.toString() != 'null')
              ? state.otpVerifyModel.message.toString()
              : 'OTP verification failed. Please try again.';
          ToastUtils.showToast(
            context,
            ToastType.error,
            Colors.white,
            message: errorMsg,
            icon: Icons.error_outline,
          );
        }
      }
      if (state is AuthOTPVerificationLoadedFailedState) {
        final errorMsg = state.message.isNotEmpty
            ? state.message.toString()
            : 'OTP verification failed. Please try again.';
        ToastUtils.showToast(
          context,
          ToastType.error,
          Colors.white,
          message: errorMsg,
          icon: Icons.error,
        );
      }
    },
    builder: (context, state) {
      if (state is AuthLoadingState) {
        return Center(child: CircularProgressIndicator());
      }
      return SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _handleVerifyOTP,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            // disabledBackgroundColor: AppColors.primaryBlue
            //     .withValues(alpha:0.6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 4,
            shadowColor: AppColors.primaryBlue.withValues(alpha: 0.3),
          ),
          child: Text(
            'Verify OTP',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    },
  );
}
