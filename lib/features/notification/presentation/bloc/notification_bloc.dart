import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:online_course/features/notification/data/models/notification_model.dart';
import 'package:online_course/features/notification/domain/repositories/notification_repo.dart';
part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository repository;
  NotificationBloc(this.repository) : super(NotificationInitial()) {
    on<GetNotificationEvent>(_getNotificationEvent);
  }

  FutureOr<void> _getNotificationEvent(
    GetNotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoadingState());
    try {
      final model = await repository.getNotifications();
      emit(NotificationLoadedSuccessState(model));
    } catch (e) {
      emit(NotificationErrorFailState(e.toString()));
    }
  }
}
