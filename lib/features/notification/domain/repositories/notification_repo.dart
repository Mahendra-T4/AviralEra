import 'package:online_course/features/notification/data/models/notification_model.dart';

abstract class NotificationRepository {
  Future<NotificationModel> getNotifications();
}
