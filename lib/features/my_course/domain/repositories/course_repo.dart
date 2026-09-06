import 'package:online_course/features/my_course/data/model/course_list_modeld.dart';
import 'package:online_course/features/my_course/data/model/course_type_model.dart';

abstract class CourseRepository {
  Future<CourseTypeModel> getCourseType();
  Future<CourseListModel> getCourseList();
}
