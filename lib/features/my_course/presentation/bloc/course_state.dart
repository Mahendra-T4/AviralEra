part of 'course_bloc.dart';

sealed class CourseState extends Equatable {
  const CourseState();

  @override
  List<Object> get props => [];
}

final class CourseInitial extends CourseState {}

final class CourseLoadingState extends CourseState {}

final class CourseLoadingState1 extends CourseState {}

//!---------------------Course List-----------------------------------------

final class CourseListLoadedSuccessState extends CourseState {
  final CourseListModel model;
  CourseListLoadedSuccessState({required this.model});
  @override
  List<Object> get props => [model];
}

final class CourseListFailedErrorState extends CourseState {
  final String error;
  CourseListFailedErrorState({required this.error});
  @override
  List<Object> get props => [error];
}

//!---------------------Course Type-----------------------------------------

final class CourseTypeLoadedSuccessState extends CourseState {
  final CourseTypeModel model;
  CourseTypeLoadedSuccessState({required this.model});
  @override
  List<Object> get props => [model];
}

final class CourseTypeFailedErrorState extends CourseState {
  final String error;
  CourseTypeFailedErrorState({required this.error});
  @override
  List<Object> get props => [error];
}
