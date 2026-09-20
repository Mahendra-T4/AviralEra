import 'package:dio/dio.dart';
import 'package:online_course/core/service/api%20service/activity.dart';
import 'package:online_course/core/service/api%20service/dio_service.dart';
import 'package:online_course/core/service/logger/logger.dart';
import 'package:online_course/features/profile/data/model/about_us_model.dart';
import 'package:online_course/features/profile/data/model/conacts_us_model.dart';
import 'package:online_course/features/profile/data/model/policy_model.dart';
import 'package:online_course/features/profile/domain/repositories/profile_repo.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  @override
  Future<AboutUSModel> getAboutUs() async {
    AboutUSModel model = AboutUSModel();
    try {
      final response = await DioService.dioPostApiCall(
        data: FormData.fromMap({'activity': Activity.getAboutUs}),
      );
      if (response.statusCode == 200) {
        model = AboutUSModel.fromJson(response.data);
        logger.i('Get About Us Response: ${model.message}');
      } else {
        logger.e('Failed to load About Us Data');
      }
    } catch (e) {
      logger.e('Error For Get About Us: $e');
    } finally {
      return model;
    }
  }

  @override
  Future<ContactUSModel> getContactUs() async {
    ContactUSModel model = ContactUSModel();
    try {
      final response = await DioService.dioPostApiCall(
        data: FormData.fromMap({'activity': Activity.getContactUs}),
      );
      if (response.statusCode == 200) {
        model = ContactUSModel.fromJson(response.data);
        logger.i('Get Contact Us Response: ${model.message}');
      } else {
        logger.e('Failed to load Contact Us Data');
      }
    } catch (e) {
      logger.e('Error For Get Contact Us: $e');
    } finally {
      return model;
    }
  }

  @override
  Future<PolicyModel> getPolicies({required int policyType}) async {
    PolicyModel model = PolicyModel();
    try {
      final response = await DioService.dioPostApiCall(
        data: FormData.fromMap({
          'activity': Activity.getPolicies,
          'policyType': policyType,
        }),
      );
      if (response.statusCode == 200) {
        model = PolicyModel.fromJson(response.data);
        logger.i('Get Policy Response: ${model.message}');
      } else {
        logger.e('Failed to load Policies Data');
      }
    } catch (e) {
      logger.e('Error For Get Policies: $e');
    } finally {
      return model;
    }
  }
}
