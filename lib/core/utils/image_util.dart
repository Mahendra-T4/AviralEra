import 'dart:io';
import 'package:flutter/material.dart';
import 'package:online_course/core/database/user_db.dart';

class ImageUtil {
  static ImageProvider? getProfileImageProvider() {
    final storedImage = UserDB.profileImage.trim();
    if (storedImage.isEmpty ||
        storedImage.toLowerCase() == 'null' ||
        storedImage.toLowerCase() == 'undefined' ||
        storedImage.toLowerCase() == 'n/a') {
      return null;
    }

    // 1. Full URL with scheme (http:// or https://)
    if (storedImage.startsWith('http://') ||
        storedImage.startsWith('https://')) {
      return NetworkImage(storedImage);
    }

    // 4. Local File
    try {
      final file = File(storedImage);
      if (file.existsSync()) {
        return FileImage(file);
      }
    } catch (_) {}
    return null;
  }
}
