part of 'notification_bloc.dart';

sealed class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

final class NotificationInitial extends NotificationState {}

final class NotificationLoadingState extends NotificationState {}

final class NotificationLoadedSuccessState extends NotificationState {
  final NotificationModel model;
  const NotificationLoadedSuccessState(this.model);
  @override
  List<Object> get props => [model];
}

final class NotificationErrorFailState extends NotificationState {
  final String error;
  const NotificationErrorFailState(this.error);
  @override
  List<Object> get props => [error];
}
