import 'dart:io';

import 'package:flutter/material.dart';
import 'package:online_course/core/constants/app_colors.dart';
import 'package:online_course/core/service/connectivity/connectivity_checker.dart';
import 'package:online_course/core/service/connectivity/no_internat_page.dart';
import 'package:online_course/core/service/file/file_picker.dart';
import 'package:online_course/core/utils/custom_appbar.dart';
import 'package:online_course/core/utils/custom_toast.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});
  static const String routeName = '/update-profile';

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final _formKey = GlobalKey<FormState>();
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
    _nameController = TextEditingController(text: 'Mahendra');
    _lastNameController = TextEditingController(text: 'Kuldeep');
    _emailController = TextEditingController(
      text: 'mahendrakuldeep@example.com',
    );
    _phoneController = TextEditingController(text: '+91 98712 34567');
    _bioController = TextEditingController(
      text: 'Passionate learner and tech enthusiast',
    );
    _alternateMobileController = TextEditingController(text: '+91 86598 76543');
  }

  String getNameInitials() {
    String initials = '';
    if (_nameController.text.isNotEmpty) {
      initials += _nameController.text[0].toUpperCase();
    }
    if (_lastNameController.text.isNotEmpty) {
      initials += _lastNameController.text[0].toUpperCase();
    }
    return initials;
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
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: AppColors.primaryBlue,
                          backgroundImage: pickedImage != null
                              ? FileImage(pickedImage!)
                              : null,
                          child: pickedImage == null
                              ? Text(
                                  getNameInitials(),
                                  style: const TextStyle(
                                    fontSize: 32,
                                    color: AppColors.white,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () async {
                            final File? pickedFile =
                                await FilePickerService.uploadUserFile(
                                  pickedImage,
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
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _alternateMobileController,
                    label: 'Alternate Mobile Number',
                    hint: 'Enter your alternate Mobile number',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
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
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          ToastUtils.showToast(
                            context,
                            ToastType.success,
                            Colors.green,
                            message: 'Profile updated successfully',
                          );

                          if (Navigator.canPop(context)) Navigator.pop(context);
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
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
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
