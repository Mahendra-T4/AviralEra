part of 'course_bloc.dart';

sealed class CourseEvent extends Equatable {
  const CourseEvent();

  @override
  List<Object> get props => [];
}

final class GetCourseListEvent extends CourseEvent {
  final CourseFilterEntity entity;
  const GetCourseListEvent({required this.entity});
  @override
  List<Object> get props => [entity];
}

final class GetCourseTypeEvent extends CourseEvent {
  const GetCourseTypeEvent();
  @override
  List<Object> get props => [];
}

final class GetCourseCategoryEvent extends CourseEvent {
  const GetCourseCategoryEvent();
  @override
  List<Object> get props => [];
}
  
