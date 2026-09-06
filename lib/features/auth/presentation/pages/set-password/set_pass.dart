import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:online_course/core/constants/app_colors.dart';
import 'package:online_course/core/di/sl.dart';
import 'package:online_course/core/service/connectivity/connectivity_checker.dart';
import 'package:online_course/core/service/connectivity/no_internat_page.dart';
import 'package:online_course/core/utils/custom_toast.dart';
import 'package:online_course/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:online_course/features/auth/presentation/pages/login/login_panel.dart';

enum PasswordStrength { none, weak, medium, strong }

class SetPasswordPage extends StatefulWidget {
  const SetPasswordPage({super.key, this.userKey});
  final String? userKey;
  static const String routeName = '/set-password';

  @override
  State<SetPasswordPage> createState() => _SetPasswordPageState();
}

class _SetPasswordPageState extends State<SetPasswordPage>
    with TickerProviderStateMixin {
  late AuthBloc _authBloc;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  late AnimationController _entryController;
  late AnimationController _shieldController;
  late AnimationController _pulseController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _headerSlideAnimation;
  late Animation<Offset> _cardSlideAnimation;
  late Animation<double> _shieldScaleAnimation;
  late Animation<double> _pulseAnimation;

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  PasswordStrength _passwordStrength = PasswordStrength.none;

  // Requirement checks
  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasDigit = false;
  bool _hasSpecial = false;

  @override
  void initState() {
    super.initState();
    _authBloc = sl<AuthBloc>();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    _passwordController.addListener(_evaluatePassword);
    _confirmPasswordController.addListener(() => setState(() {}));

    // Entry animation
    _entryController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _entryController, curve: Curves.easeOut));

    _headerSlideAnimation =
        Tween<Offset>(begin: const Offset(0, -0.4), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _entryController,
            curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
          ),
        );

    _cardSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _entryController,
            curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    // Shield pop animation
    _shieldController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _shieldScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shieldController, curve: Curves.elasticOut),
    );

    // Pulse animation for the shield
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1600),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _entryController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _shieldController.forward();
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _entryController.dispose();
    _shieldController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _evaluatePassword() {
    final p = _passwordController.text;
    setState(() {
      _hasMinLength = p.length >= 8;
      _hasUppercase = p.contains(RegExp(r'[A-Z]'));
      _hasLowercase = p.contains(RegExp(r'[a-z]'));
      _hasDigit = p.contains(RegExp(r'[0-9]'));
      _hasSpecial = p.contains(RegExp(r'[!@#$%^&*()_+\-=\[\]{};:,.<>?]'));

      if (p.isEmpty) {
        _passwordStrength = PasswordStrength.none;
        return;
      }
      int score = 0;
      if (_hasMinLength) score++;
      if (_hasUppercase && _hasLowercase) score++;
      if (_hasDigit) score++;
      if (_hasSpecial) score++;

      if (score <= 1) {
        _passwordStrength = PasswordStrength.weak;
      } else if (score <= 2) {
        _passwordStrength = PasswordStrength.medium;
      } else {
        _passwordStrength = PasswordStrength.strong;
      }
    });
  }

  void _handleSetPassword() {
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;

    if (password != confirm) {
      ToastUtils.showToast(
        context,
        ToastType.warning,
        Colors.white,
        message: 'Passwords do not match',
        icon: Icons.warning_outlined,
      );
      return;
    }

    if (password.length < 8) {
      ToastUtils.showToast(
        context,
        ToastType.warning,
        Colors.white,
        message: 'Password must be at least 8 characters',
        icon: Icons.warning_outlined,
      );
      return;
    }

    if (_passwordStrength == PasswordStrength.weak) {
      ToastUtils.showToast(
        context,
        ToastType.warning,
        Colors.white,
        message: 'Please use a stronger password',
        icon: Icons.warning_outlined,
      );
      return;
    }

    if (formKey.currentState!.validate()) {
      _authBloc.add(
        AuthResetPasswordEvent(
          uPassword: password,
          uConfirmPassword: confirm,
          userKey: widget.userKey,
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
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1a3a6b),
                  AppColors.primaryBlueDark,
                  Color(0xFF0f2444),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
            child: Stack(
              children: [
                // Decorative circles
                _buildBackgroundDecor(size),

                SafeArea(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              SizedBox(height: size.height * 0.05),

                              // Header section
                              SlideTransition(
                                position: _headerSlideAnimation,
                                child: _buildHeaderSection(),
                              ),

                              SizedBox(height: size.height * 0.04),

                              // Form card
                              SlideTransition(
                                position: _cardSlideAnimation,
                                child: _buildFormCard(isDark),
                              ),

                              SizedBox(height: size.height * 0.04),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Background decorative circles ────────────────────────────────────────────
  Widget _buildBackgroundDecor(Size size) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            Positioned(
              top: -80,
              right: -60,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.04),
                ),
              ),
            ),
            Positioned(
              bottom: size.height * 0.25,
              left: -80,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accentOrange.withValues(alpha: 0.06),
                ),
              ),
            ),
            Positioned(
              bottom: -40,
              right: -40,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.03),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header section ────────────────────────────────────────────────────────────
  Widget _buildHeaderSection() {
    return Column(
      children: [
        // Shield icon with pulse
        ScaleTransition(
          scale: _shieldScaleAnimation,
          child: ScaleTransition(
            scale: _pulseAnimation,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer glow ring
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.accentOrange.withValues(alpha: 0.2),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                // Inner circle
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF2a5298), Color(0xFF1e3c72)],
                    ),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryBlue.withValues(alpha: 0.4),
                        blurRadius: 20,
                        spreadRadius: 2,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.lock_reset_rounded,
                    color: Colors.white,
                    size: 42,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        const Text(
          'Set New Password',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Create a strong password to keep\nyour account safe and secure',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.75),
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // ── Form card ─────────────────────────────────────────────────────────────────
  Widget _buildFormCard(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 40,
            spreadRadius: 0,
            offset: const Offset(0, 16),
          ),
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: 0.08),
            blurRadius: 24,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // New Password
          _buildLabel('New Password'),
          const SizedBox(height: 8),
          _buildPasswordField(
            controller: _passwordController,
            hint: 'Enter your new password',
            obscure: _obscurePassword,
            onToggle: () =>
                setState(() => _obscurePassword = !_obscurePassword),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }

              return null;
            },
          ),

          // Strength indicator
          if (_passwordStrength != PasswordStrength.none) ...[
            const SizedBox(height: 14),
            _buildStrengthIndicator(),
          ],

          const SizedBox(height: 20),

          // Confirm Password
          _buildLabel('Confirm Password'),
          const SizedBox(height: 8),
          _buildPasswordField(
            controller: _confirmPasswordController,
            hint: 'Re-enter your password',
            obscure: _obscureConfirm,
            onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
            showMatchIndicator:
                _confirmPasswordController.text.isNotEmpty &&
                _passwordController.text.isNotEmpty,
            isMatch:
                _passwordController.text == _confirmPasswordController.text,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (_passwordController.text != _confirmPasswordController.text) {
                return 'Passwords do not match';
              }

              return null;
            },
          ),

          // Match indicator below confirm field
          if (_confirmPasswordController.text.isNotEmpty &&
              _passwordController.text.isNotEmpty) ...[
            const SizedBox(height: 10),
            _buildMatchRow(),
          ],

          const SizedBox(height: 20),

          // Requirements checklist
          _buildRequirementsCard(),

          const SizedBox(height: 28),

          // Set Password button
          _buildSetPasswordButton(),

          const SizedBox(height: 16),

          // Back link
          GestureDetector(
            onTap: () => GoRouter.of(context).pop(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 14,
                  color: AppColors.mediumGray,
                ),
                const SizedBox(width: 6),
                Text(
                  'Go Back',
                  style: TextStyle(
                    color: AppColors.mediumGray,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Label ─────────────────────────────────────────────────────────────────────
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 14,
        color: Theme.of(context).textTheme.bodyMedium!.color,
      ),
    );
  }

  // ── Password text field ───────────────────────────────────────────────────────
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required VoidCallback onToggle,
    bool showMatchIndicator = false,
    bool isMatch = false,
    String? Function(String?)? validator,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Color borderColor = isDark ? Colors.grey[700]! : Colors.grey.shade200;
    if (showMatchIndicator) {
      borderColor = isMatch ? AppColors.success : AppColors.error;
    }
    final fillColor = isDark ? const Color(0xFF111827) : Colors.grey[50];
    final textColor = isDark ? Colors.white : Colors.black87;
    final hintColor = isDark ? Colors.grey[400] : Colors.grey[400];
    final iconColor = isDark ? Colors.blue[200] : AppColors.primaryBlue;
    final suffixColor = isDark ? Colors.grey[300] : AppColors.mediumGray;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366f1).withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: validator,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: hintColor, fontSize: 14),
          prefixIcon: Icon(
            Icons.lock_outline_rounded,
            color: iconColor,
            size: 20,
          ),
          suffixIcon: GestureDetector(
            onTap: onToggle,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                key: ValueKey(obscure),
                color: suffixColor,
                size: 20,
              ),
            ),
          ),
          filled: true,
          fillColor: fillColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: borderColor, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: isDark ? Colors.blue[300]! : AppColors.primaryBlue,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  // ── Password strength indicator ───────────────────────────────────────────────
  Widget _buildStrengthIndicator() {
    final strength = _passwordStrength;

    final Color color;
    final String label;
    final int filledBars;

    switch (strength) {
      case PasswordStrength.weak:
        color = AppColors.error;
        label = 'Weak';
        filledBars = 1;
        break;
      case PasswordStrength.medium:
        color = AppColors.warning;
        label = 'Medium';
        filledBars = 2;
        break;
      case PasswordStrength.strong:
        color = AppColors.success;
        label = 'Strong';
        filledBars = 3;
        break;
      default:
        color = Colors.grey;
        label = '';
        filledBars = 0;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Password Strength',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                label,
                key: ValueKey(label),
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(3, (index) {
            final isFilled = index < filledBars;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: index < 2 ? 6 : 0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: isFilled ? color : Colors.grey[200],
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  // ── Match row ─────────────────────────────────────────────────────────────────
  Widget _buildMatchRow() {
    final isMatch = _passwordController.text == _confirmPasswordController.text;
    final color = isMatch ? AppColors.success : AppColors.error;
    final label = isMatch ? 'Passwords match' : 'Passwords do not match';

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: Row(
        key: ValueKey(isMatch),
        children: [
          Icon(
            isMatch ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: color,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ── Requirements checklist ───────────────────────────────────────────────────
  Widget _buildRequirementsCard() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : AppColors.primaryBlueLighter,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? Colors.grey[700]!
              : AppColors.primaryBlue.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.checklist_rounded,
                size: 16,
                color: AppColors.primaryBlue,
              ),
              const SizedBox(width: 6),
              Text(
                'Password Requirements',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : AppColors.primaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildRequirementRow('At least 8 characters', _hasMinLength),
          const SizedBox(height: 6),
          _buildRequirementRow(
            'Uppercase & lowercase letters',
            _hasUppercase && _hasLowercase,
          ),
          const SizedBox(height: 6),
          _buildRequirementRow('At least one number', _hasDigit),
          const SizedBox(height: 6),
          _buildRequirementRow('At least one special character', _hasSpecial),
        ],
      ),
    );
  }

  Widget _buildRequirementRow(String text, bool met) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            met
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            key: ValueKey(met),
            size: 15,
            color: met ? AppColors.success : Colors.grey[400],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: met
                ? Colors.grey[900]
                : isDark
                ? Colors.grey[400]
                : Colors.grey[900],
            fontWeight: met ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  // ── Submit button ─────────────────────────────────────────────────────────────
  Widget _buildSetPasswordButton() {
    return BlocConsumer(
      bloc: _authBloc,
      listener: (context, state) {
        if (state is AuthResetPasswordLoadedSuccessState) {
          if (state.successModel.status == 1) {
            ToastUtils.showToast(
              context,
              ToastType.success,
              Colors.white,
              message: state.successModel.message.toString(),
              icon: Icons.check_circle_outline,
            );
            GoRouter.of(context).goNamed(LoginPanel.routeName);
          } else {
            ToastUtils.showToast(
              context,
              ToastType.error,
              Colors.white,
              message: state.successModel.message.toString(),
              icon: Icons.check_circle_outline,
            );
          }
        } else if (state is AuthResetPasswordLoadedFailedState) {
          ToastUtils.showToast(
            context,
            ToastType.error,
            Colors.white,
            message: state.message.toString(),
            icon: Icons.check_circle_outline,
          );
        }
      },
      builder: (context, state) {
        if (state is AuthLoadingState)
          return Center(child: CircularProgressIndicator());

        return GestureDetector(
          onTap: _handleSetPassword,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 56,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBlue.withValues(alpha: 0.35),
                  blurRadius: 16,
                  spreadRadius: 0,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_rounded, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Set Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
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
}
