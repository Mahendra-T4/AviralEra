import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:online_course/core/constants/app_colors.dart';
import 'package:online_course/core/database/user_db.dart';
import 'package:online_course/core/di/sl.dart';
import 'package:online_course/core/service/connectivity/connectivity_checker.dart';
import 'package:online_course/core/service/connectivity/no_internat_page.dart';
import 'package:online_course/core/service/file/file_picker.dart';
import 'package:online_course/core/utils/custom_appbar.dart';
import 'package:online_course/core/utils/custom_toast.dart';
import 'package:online_course/core/utils/image_util.dart';
import 'package:online_course/features/auth/domain/entities/account_setting_entitie.dart';
import 'package:online_course/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:online_course/features/auth/presentation/pages/login/login_panel.dart';
import 'package:online_course/features/auth/presentation/pages/otp/opt_panel.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});
  static const String routeName = '/update-profile';

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  late AuthBloc _authBloc;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;
  late TextEditingController _alternateMobileController;

  File? pickedImage;

  @override
  void initState() {
    super.initState();
    _authBloc = sl<AuthBloc>();
    _nameController = TextEditingController(text: UserDB.firstName);
    _lastNameController = TextEditingController(text: UserDB.lastName);
    _emailController = TextEditingController(text: UserDB.email);
    _phoneController = TextEditingController(text: UserDB.mobile);
    _bioController = TextEditingController(text: UserDB.getBio);
    _alternateMobileController = TextEditingController(
      text: UserDB.alternateMobile,
    );
  }

  String getNameInitials() {
    String initials = '';
    final first = _nameController.text.trim();
    final last = _lastNameController.text.trim();
    if (first.isNotEmpty) {
      initials += first[0].toUpperCase();
    }
    if (last.isNotEmpty) {
      initials += last[0].toUpperCase();
    }
    return initials.isNotEmpty ? initials : 'MK';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
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
          appBar: CustomAppBar(title: 'Update Profile', showBackButton: true),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Picture Section
                  Center(
                    child: Column(
                      children: [
                        Builder(
                          builder: (context) {
                            final ImageProvider? imageProvider = pickedImage != null
                                ? FileImage(pickedImage!)
                                : ImageUtil.getProfileImageProvider();
                            return CircleAvatar(
                              radius: 60,
                              backgroundColor: AppColors.primaryBlue,
                              backgroundImage: imageProvider,
                              onBackgroundImageError: imageProvider != null
                                  ? (_, __) {}
                                  : null,
                              child: imageProvider == null
                                  ? Text(
                                      getNameInitials(),
                                      style: const TextStyle(
                                        fontSize: 32,
                                        color: AppColors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : null,
                            );
                          },
                        ),

                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () async {
                            final File? pickedFile =
                                await FilePickerService.showImagePickerOptions(
                                  context,
                                );

                            if (pickedFile == null) return;

                            setState(() {
                              pickedImage = pickedFile;
                            });
                          },
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Change Photo'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            foregroundColor: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Form Fields
                  _buildSectionTitle('Personal Information'),
                  const SizedBox(height: 16),

                  // Name Field
                  _buildTextField(
                    controller: _nameController,
                    label: 'First Name',
                    hint: 'Enter your first name',
                    icon: Icons.person,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _lastNameController,
                    label: 'Last Name',
                    hint: 'Enter your last name',
                    icon: Icons.person,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Email Field
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email Address',
                    hint: 'Enter your email',
                    icon: Icons.email,

                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value!)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    suffixIcon: Icons.check_circle_outline,
                  ),
                  const SizedBox(height: 16),

                  // Phone Field
                  _buildTextField(
                    controller: _phoneController,
                    label: 'Mobile Number',
                    hint: 'Enter your mobile number',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],

                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter mobile number';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _alternateMobileController,
                    label: 'Alternate Mobile Number',
                    hint: 'Enter your alternate Mobile number',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Bio Field
                  _buildTextField(
                    controller: _bioController,
                    label: 'Bio',
                    hint: 'Tell us about yourself',
                    icon: Icons.description,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 32),

                  // Save Button
                  updateSettingsButton,
                  const SizedBox(height: 12),

                  // Cancel Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        if (Navigator.canPop(context)) Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryBlue,
                        side: const BorderSide(color: AppColors.primaryBlue),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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

  Widget get updateSettingsButton => BlocConsumer(
    bloc: _authBloc,
    listener: (context, state) {
      if (state is AuthUpdateAccountSettingLoadedSuccessState) {
        final getString = state.model.status == 2
            ? 'and OTP: ${state.model.uOTP}'
            : '';
        if (state.model.status == 2) {
          ToastUtils.showToast(
            context,
            ToastType.success,
            Colors.white,
            message: '${state.model.message} $getString',
          );
          context.pushNamed(
            OTPPanel.routeName,
            extra: OTPPanelParam(
              mobileNumber: _phoneController.text,
              panelID: 1,
            ),
          );
        }

        if (state.model.status == 1) {
          ToastUtils.showToast(
            context,
            ToastType.success,
            Colors.white,
            message: '${state.model.message} $getString',
          );
          Future.delayed(Duration(seconds: 3), () {
            context.pushNamed(LoginPanel.routeName);
            UserDB.logout(context);
          });
        } else {
          ToastUtils.showToast(
            context,
            ToastType.error,
            Colors.white,
            message: state.model.message.toString(),
          );
        }
      } else if (state is AuthUpdateAccountSettingFailedState) {
        ToastUtils.showToast(
          context,
          ToastType.error,
          Colors.white,
          message: state.message.toString(),
        );
      }
    },
    builder: (context, state) {
      if (state is AuthLoadingState) {
        return Center(child: CircularProgressIndicator());
      }
      return Center(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _authBloc.add(
                  AuthUpdateAccountSettingEvent(
                    data: AccountEntity(
                      uFirstName: _nameController.text,
                      uLastName: _lastNameController.text,
                      uEmail: _emailController.text,
                      uMobile: _phoneController.text,
                      uAlternateNumber: _alternateMobileController.text,
                      uBio: _bioController.text,
                      image: pickedImage ?? null,
                    ),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Save Changes',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      );
    },
  );

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).textTheme.titleMedium!.color!,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
    IconData? suffixIcon,
    List<TextInputFormatter>? inputFormatters,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fillColor = isDark ? AppColors.darkSurface : AppColors.white;
    final borderColor = isDark
        ? AppColors.lightGray.withValues(alpha: 0.2)
        : AppColors.lightGray;
    final textColor = Theme.of(context).textTheme.bodyMedium!.color!;
    final hintColor = Theme.of(context).textTheme.bodySmall!.color!;

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: TextStyle(color: textColor),
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: hintColor),
        hintText: hint,
        hintStyle: TextStyle(color: hintColor.withValues(alpha: 0.6)),
        suffixIcon: IconButton(
          icon: Icon(suffixIcon, color: AppColors.successDark),
          onPressed: () {},
        ),
        prefixIcon: Icon(icon, color: AppColors.primaryBlue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
        ),
        filled: true,
        fillColor: fillColor,
      ),
    );
  }
}
