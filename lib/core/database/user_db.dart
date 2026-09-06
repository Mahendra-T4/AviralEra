import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:online_course/core/database/boxes.dart';
import 'package:online_course/core/database/keys.dart';
import 'package:online_course/core/service/logger/logger.dart';
import 'package:online_course/core/utils/custom_toast.dart';
import 'package:online_course/features/auth/presentation/pages/login/login_panel.dart';

abstract class UserDB {
  static Future<void> init() async {
    await Hive.initFlutter();

    AppBoxes.userBox = await Hive.openBox(AppBoxes.userBoxKey);
  }

  static Future<void> setter({
    required String key,
    required dynamic value,
  }) async {
    await AppBoxes.userBox?.put(key, value);
  }

  static dynamic getter({required String key}) {
    return AppBoxes.userBox?.get(key) ?? null;
  }
  //!------------------get data-------------------------

  static bool get token {
    return getter(key: Keys.token) ?? false;
  }

  static String get firstName {
    return getter(key: Keys.firstNameKey) ?? "";
  }

  static String get lastName {
    return getter(key: Keys.lastNameKey) ?? "";
  }

  static String get email {
    return getter(key: Keys.emailKey) ?? "";
  }

  static String get mobile {
    return getter(key: Keys.mobileKey) ?? "";
  }

  static String get alternateMobile {
    return getter(key: Keys.alternateMobileKey) ?? "";
  }

  static String get profileImage {
    return getter(key: Keys.profileImageKey) ?? "";
  }

  static String get userKey {
    return getter(key: Keys.userKey) ?? "";
  }

  static String get getBio {
    return getter(key: Keys.bioKey) ?? "";
  }

  /// Delete a value by key
  static Future<void> delete(String key) async {
    await AppBoxes.userBox?.delete(key);
  }

  static void logout(BuildContext context) async {
    await AppBoxes.userBox?.clear();

    await AppBoxes.userBox?.close();

    AppBoxes.userBox = await Hive.openBox(AppBoxes.userBoxKey);

    context.goNamed(LoginPanel.routeName);
    ToastUtils.showToast(
      context,
      ToastType.success,
      Colors.white,
      message: 'Logout successfully',
      icon: Icons.check,
    );

    logger.d('User LogOut successfully');
  }
}
