import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:online_course/core/service/logger/logger.dart';

class FilePickerService {
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
