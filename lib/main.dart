import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:online_course/app.dart';
import 'package:online_course/core/database/user_db.dart';
import 'package:online_course/core/di/sl.dart';
import 'package:online_course/core/service/config/env_config.dart';
import 'package:online_course/core/service/connectivity/connectivity_checker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EnvConfig.load();

  InternetConnectivityChecker().startMonitoring();

  await SLServices.init();
  await UserDB.init();
  await Hive.initFlutter();
  await Hive.openBox('themeBox');
  runApp(const App());
}



// Text(
//   'Square of 12 = ${() {
//     int num = 12;
//     return num * num;
//   }()}',
// ),