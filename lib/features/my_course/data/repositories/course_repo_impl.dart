import 'package:dio/dio.dart';
import 'package:online_course/core/service/api%20service/activity.dart';
import 'package:online_course/core/service/api%20service/dio_service.dart';
import 'package:online_course/core/service/logger/logger.dart';
import 'package:online_course/features/my_course/data/model/course_list_modeld.dart';
import 'package:online_course/features/my_course/data/model/course_type_model.dart';
import 'package:online_course/features/my_course/domain/repositories/course_repo.dart';

class CourseRepoImpl implements CourseRepository {
  @override
  Future<CourseListModel> getCourseList() async {
    CourseListModel model = CourseListModel();
    try {
      final response = await DioService.dioPostApiCall(
        data: FormData.fromMap({'activity': Activity.courseList}),
      );
      if (response.statusCode == 200) {
        model = CourseListModel.fromJson(response.data);
        logger.d('Course List JsonData : ${response.data}');
      } else {
        logger.i('failed to get course list');
      }
    } catch (e) {
      logger.e('Course List Error : $e');
    }
    return model;
  }

  @override
  Future<CourseTypeModel> getCourseType() async {
    CourseTypeModel model = CourseTypeModel();
    try {
      final response = await DioService.dioPostApiCall(
        data: FormData.fromMap({'activity': Activity.courseType}),
      );
      if (response.statusCode == 200) {
        model = CourseTypeModel.fromJson(response.data);
        logger.d('Course Type JsonData : ${response.data}');
      } else {
        logger.i('failed to get course type');
      }
    } catch (e) {
      logger.e('Course Type Error : $e');
    }
    return model;
  }
}
