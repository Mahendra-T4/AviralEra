import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:online_course/core/service/logger/logger.dart';

class EnvConfig {
  static String get aviralEraBaseUrl => dotenv.env['AVIRAL_ERA_BASE_URL'] ?? '';

  static Future<void> load() async {
    await dotenv.load(fileName: ".env");
    logger.i('Loading environment variables...');
    logger.i('Base URL: ${dotenv.env['AVIRAL_ERA_BASE_URL']}');
  }
}
