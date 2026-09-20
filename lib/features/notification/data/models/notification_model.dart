class NotificationModel {
  int? status;
  List<Notification>? notification;
  String? message;

  NotificationModel({this.status, this.notification, this.message});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['notification'] != null) {
      notification = <Notification>[];
      json['notification'].forEach((v) {
        notification!.add(new Notification.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.notification != null) {
      data['notification'] = this.notification!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Notification {
  String? notificationDate;
  String? notificationSubject;

  Notification({this.notificationDate, this.notificationSubject});

  Notification.fromJson(Map<String, dynamic> json) {
    notificationDate = json['notificationDate'];
    notificationSubject = json['notificationSubject'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notificationDate'] = this.notificationDate;
    data['notificationSubject'] = this.notificationSubject;
    return data;
  }
}