import 'package:hive_flutter/adapters.dart';
import 'package:online_course/core/database/boxes.dart';
import 'package:online_course/core/service/logger/logger.dart';

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

  /// Delete a value by key
  static Future<void> delete(String key) async {
    await AppBoxes.userBox?.delete(key);
  }

  static dynamic getter({required String key}) {
    return AppBoxes.userBox?.get(key);
  }

  static void logout() async {
    await AppBoxes.userBox?.clear();

    await AppBoxes.userBox?.close();

    AppBoxes.userBox = await Hive.openBox(AppBoxes.userBoxKey);
    logger.d('User LogOut successfully');
  }
}
