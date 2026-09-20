import 'package:dio/dio.dart';
import 'package:online_course/core/database/user_db.dart';
import 'package:online_course/core/service/api%20service/activity.dart';
import 'package:online_course/core/service/api%20service/dio_service.dart';
import 'package:online_course/core/service/logger/logger.dart';
import 'package:online_course/features/notification/data/models/notification_model.dart';
import 'package:online_course/features/notification/domain/repositories/notification_repo.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  @override
  Future<NotificationModel> getNotifications() async {
    NotificationModel model = NotificationModel();
    try {
      final response = await DioService.dioPostApiCall(
        data: FormData.fromMap({
          'activity': Activity.notification,
          'userKey': UserDB.userKey,
        }),
      );

      if (response.statusCode == 200) {
        model = NotificationModel.fromJson(response.data);

        logger.i('Notification Response : ${model.message}');
      } else {
        logger.e('Failed to load notification');
      }
    } catch (e) {
      logger.e('Error loading notification :$e');
    } finally {
      return model;
    }
  }
}
