import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:online_course/app.dart';
import 'package:online_course/core/service/connectivity/connectivity_checker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  InternetConnectivityChecker().startMonitoring();
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