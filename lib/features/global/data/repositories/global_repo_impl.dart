import 'package:dio/dio.dart';
import 'package:online_course/core/service/api%20service/activity.dart';
import 'package:online_course/core/service/api%20service/dio_service.dart';
import 'package:online_course/core/service/logger/logger.dart';
import 'package:online_course/features/global/data/model/get_logo_model.dart';
import 'package:online_course/features/global/domain/repositories/global_repo.dart';

class GlobalRepositoryImpl implements GlobalRepository {
  @override
  Future<GetLogoModel> getLogo() async {
    GetLogoModel model = GetLogoModel();
    try {
      final response = await DioService.dioPostApiCall(
        data: FormData.fromMap({'activity': Activity.getLogo}),
      );

      if (response.statusCode == 200) {
        model = GetLogoModel.fromJson(response.data);
        logger.i('Get Logo Response : ${model.message}');
      } else {
        logger.e('Failed to load logo');
      }
    } catch (e) {
      logger.e('Exception in getLogo: $e');
    } finally {
      return model;
    }
  }
}
