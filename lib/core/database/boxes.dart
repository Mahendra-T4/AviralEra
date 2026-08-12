import 'package:hive_flutter/adapters.dart';

class AppBoxes {
  AppBoxes._();
  static final AppBoxes _instance = AppBoxes._();
  factory AppBoxes() => _instance;

  static const String userBoxKey = 'userBox';
  static Box<dynamic>? userBox;
}
