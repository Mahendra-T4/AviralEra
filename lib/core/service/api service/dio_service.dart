import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:online_course/core/service/config/env_config.dart';
import 'package:online_course/core/service/logger/logger.dart';

class DioService {
  static final Dio _dio = Dio();

  static void initialize() {
    _dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 10),
    );
    _dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.badCertificateCallback = (cert, host, port) => true;
        client.connectionTimeout = const Duration(seconds: 10);
        client.idleTimeout = const Duration(seconds: 30);
        return client;
      },
    );
  }

  static final String url = EnvConfig.aviralEraBaseUrl;
  // static final String url =
  //     'https://www.accountsure.in/development/app/inventory/the-tape-factory/software-APIs/index.php';

  static Future<Response> dioPostApiCall({data}) async {
    logger.i('Aviral Era Base URl => ${EnvConfig.aviralEraBaseUrl}');
    return await _dio.post(url, data: data);
  }
}
