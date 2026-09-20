import 'package:online_course/features/global/data/model/get_logo_model.dart';

abstract class GlobalRepository {
  Future<GetLogoModel> getLogo();
}
