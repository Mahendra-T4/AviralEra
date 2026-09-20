import 'package:online_course/features/profile/data/model/about_us_model.dart';
import 'package:online_course/features/profile/data/model/conacts_us_model.dart';

import 'package:online_course/features/profile/data/model/policy_model.dart';

abstract class ProfileRepository {
  Future<PolicyModel> getPolicies({required int policyType});
  Future<AboutUSModel> getAboutUs();
  Future<ContactUSModel> getContactUs();
}
