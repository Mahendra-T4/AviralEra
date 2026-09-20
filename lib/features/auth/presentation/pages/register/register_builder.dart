import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:online_course/assets/assets.dart';
import 'package:online_course/core/constants/app_colors.dart';
import 'package:online_course/core/utils/custom_snackbar.dart';
import 'package:online_course/core/utils/custom_toast.dart';
import 'package:online_course/features/auth/domain/entities/register_user_entities.dart';
import 'package:online_course/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:online_course/features/auth/presentation/pages/otp/opt_panel.dart';
import 'package:online_course/features/auth/presentation/pages/register/register.dart';

abstract class RegisterBuilder extends State<StudentRegisterPanel> {
  late AuthBloc authBloc;
  // Form key for validation
  final formKey = GlobalKey<FormState>();
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;
  late Animation<double> scaleAnimation;
  bool isChecked = false;
  bool isPasswordVisible = true;
  bool isConfirmPasswordVisible = true;

  // Text controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final alternateMobileController = TextEditingController();
  final fatherNameController = TextEditingController();
  final motherNameController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;
  String? selectedCourseName;
  String? selectedCourseType;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    alternateMobileController.dispose();
    fatherNameController.dispose();
    motherNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    cityController.dispose();
    stateController.dispose();
    super.dispose();
  }

  clearControllers() {
    // Clear form
    formKey.currentState?.reset();
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    mobileController.clear();
    alternateMobileController.clear();
    fatherNameController.clear();
    motherNameController.clear();
    cityController.clear();
    stateController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    setState(() {
      selectedCourseName = null;
      selectedCourseType = null;
    });
  }

  /// Validate form and handle registration
  void handleRegister() {
    if (formKey.currentState!.validate()) {
      if (selectedCourseName == null) {
        CustomSnackBar.error(context, message: 'Please select a course name');
        return;
      }
      if (selectedCourseType == null) {
        CustomSnackBar.error(context, message: 'Please select a course type');
        return;
      }

      // Proceed with registration

      authBloc.add(
        RegisterUserEvent(
          registerEntity: RegisterEntity(
            uFirstName: firstNameController.text,
            uLastName: lastNameController.text,
            uEmail: emailController.text,
            uMobile: mobileController.text,
            selectedCourse: selectedCourseName.toString(),
            selectedCourseType: selectedCourseType.toString(),
            uPassword: passwordController.text,
            uConfirmPassword: confirmPasswordController.text,
            termsAgree: isChecked ? '1' : '0',
          ),
        ),
      );
    }
  }

  Widget buildLogoSection() {
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

  Widget buildModernSectionCard({
    required BuildContext context,
    required String title,
    required int stepNumber,
    required List<Widget> children,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : AppColors.lightGray,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.2)
                : AppColors.primaryBlue.withValues(alpha: 0.06),
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
  Widget buildModernTextField({
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
    List<TextInputFormatter>? inputFormatters,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ??
        (isDark ? Colors.white : AppColors.darkGray);

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      validator: validator,
      obscureText: isPassword ? obscureText : false,
      inputFormatters: inputFormatters,
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
                  color: isDark ? Colors.blue[200] : Colors.indigoAccent,
                  size: 20,
                ),
              )
            : null,
        prefixIcon: Icon(
          icon,
          color: isDark ? Colors.blue[200] : AppColors.primaryBlue,
          size: 20,
        ),
        counterText: '',
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
            color: isDark ? Colors.grey[700]! : AppColors.lightGray,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.blue[300]! : AppColors.primaryBlue,
            width: 2,
          ),
        ),
        labelStyle: TextStyle(
          color: isDark ? Colors.white70 : AppColors.primaryBlue,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: TextStyle(
          color: isDark
              ? Colors.grey[400]
              : AppColors.mediumGray.withValues(alpha: 0.7),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
    );
  }

  /// Build modern register button
  Widget buildModernRegisterButton(BuildContext context) {
    return BlocConsumer(
      bloc: authBloc,
      listener: (context, state) {
        if (state is AuthRegisterUserLoadedSuccessState) {
          if (state.registerUserModel.status == 1) {
            GoRouter.of(context).goNamed(
              OTPPanel.routeName,
              extra: OTPPanelParam(
                mobileNumber: mobileController.text,
                panelID: 1,
              ),
            );
            ToastUtils.showToast(
              context,
              ToastType.success,
              Colors.white,
              message:
                  '${state.registerUserModel.message} OTP: ${state.registerUserModel.uOTP}',
              maxLines: 3,
            );
            clearControllers();
          } else {
            ToastUtils.showToast(
              context,
              ToastType.error,
              Colors.white,
              message: state.registerUserModel.message.toString(),
            );
          }
        }
        if (state is AuthRegisterUserLoadedFailedState) {
          ToastUtils.showToast(
            context,
            ToastType.error,
            Colors.white,
            message: state.message,
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
            onPressed: handleRegister,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              disabledBackgroundColor: AppColors.primaryBlue.withValues(
                alpha: 0.6,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 4,
              shadowColor: AppColors.primaryBlue.withValues(alpha: 0.3),
            ),
            child: Text(
              'Create Account',
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
}
