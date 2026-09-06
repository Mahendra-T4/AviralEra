part of 'course_bloc.dart';

sealed class CourseEvent extends Equatable {
  const CourseEvent();

  @override
  List<Object> get props => [];
}

final class GetCourseListEvent extends CourseEvent {
  const GetCourseListEvent();
  @override
  List<Object> get props => [];
}

final class GetCourseTypeEvent extends CourseEvent {
  const GetCourseTypeEvent();
  @override
  List<Object> get props => [];
}
