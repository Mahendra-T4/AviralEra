import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_course/core/constants/app_colors.dart';
import 'package:online_course/core/service/logger/logger.dart';

class FilePickerService {
  static final ImagePicker _imagePicker = ImagePicker();

  /// Pick an image from camera
  static Future<File?> pickImageFromCamera() async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (photo == null) return null;
      return File(photo.path);
    } catch (e) {
      logger.e('Camera Picker Error :=> $e');
      return null;
    }
  }

  /// Pick an image from gallery
  static Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (image == null) return null;
      return File(image.path);
    } catch (e) {
      logger.e('Gallery Picker Error :=> $e');
      return null;
    }
  }

  /// Shows a modal bottom sheet allowing the user to choose between Camera and Gallery
  static Future<File?> showImagePickerOptions(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkSurface : AppColors.white;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.darkGray;

    return showModalBottomSheet<File?>(
      context: context,
      backgroundColor: bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppColors.mediumGray.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Text(
                  'Choose Profile Photo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildOption(
                      context: ctx,
                      icon: Icons.camera_alt_rounded,
                      label: 'Camera',
                      color: AppColors.primaryBlue,
                      onTap: () async {
                        final file = await pickImageFromCamera();
                        if (ctx.mounted) Navigator.pop(ctx, file);
                      },
                    ),
                    _buildOption(
                      context: ctx,
                      icon: Icons.photo_library_rounded,
                      label: 'Gallery',
                      color: AppColors.accentOrange,
                      onTap: () async {
                        final file = await pickImageFromGallery();
                        if (ctx.mounted) Navigator.pop(ctx, file);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _buildOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.darkGray;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// General document / file picker
  static Future<File?> uploadUserFile(File? file) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'csv', 'xlsx', 'xls'],
      );

      if (result == null || result.files.isEmpty) return null;

      final data = result.files.first;

      if (data.path == null) return null;

      return File(data.path!);
    } catch (e) {
      logger.e('File Picker Error :=> $e');
    }
    return null;
  }
}
