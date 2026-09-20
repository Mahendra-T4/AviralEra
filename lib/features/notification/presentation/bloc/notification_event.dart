part of 'notification_bloc.dart';

sealed class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

final class GetNotificationEvent extends NotificationEvent {
  const GetNotificationEvent();

  @override
  List<Object> get props => [];
}
