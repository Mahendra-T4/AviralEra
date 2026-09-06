import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:online_course/features/my_course/data/model/course_list_modeld.dart';
import 'package:online_course/features/my_course/data/model/course_type_model.dart';
import 'package:online_course/features/my_course/domain/repositories/course_repo.dart';

part 'course_event.dart';
part 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final CourseRepository repository;
  CourseBloc(this.repository) : super(CourseInitial()) {
    on<GetCourseListEvent>(_getCourseListEvent);
    on<GetCourseTypeEvent>(_getCourseTypeEvent);
  }

  FutureOr<void> _getCourseListEvent(
    GetCourseListEvent event,
    Emitter<CourseState> emit,
  ) async {
    emit(CourseLoadingState());
    try {
      final result = await repository.getCourseList();
      emit(CourseListLoadedSuccessState(model: result));
    } catch (e) {
      emit(CourseListFailedErrorState(error: e.toString()));
    }
  }

  FutureOr<void> _getCourseTypeEvent(
    GetCourseTypeEvent event,
    Emitter<CourseState> emit,
  ) async {
    emit(CourseLoadingState1());
    try {
      final result = await repository.getCourseType();
      emit(CourseTypeLoadedSuccessState(model: result));
    } catch (e) {
      emit(CourseTypeFailedErrorState(error: e.toString()));
    }
  }
}
