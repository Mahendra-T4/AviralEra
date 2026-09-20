import 'package:online_course/features/my_course/data/model/category.dart';
import 'package:online_course/features/my_course/data/model/course_list_modeld.dart';
import 'package:online_course/features/my_course/data/model/course_type_model.dart';
import 'package:online_course/features/my_course/domain/entities/category_entitie.dart';

abstract class CourseRepository {
  Future<CourseTypeModel> getCourseType();
  Future<CourseListModel> getCourseList(CourseFilterEntity? entity);
  Future<CategoryModel> getCourseCategory();
}
