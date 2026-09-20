import 'package:dio/dio.dart';
import 'package:online_course/core/database/keys.dart';
import 'package:online_course/core/database/user_db.dart';
import 'package:online_course/core/service/api%20service/activity.dart';
import 'package:online_course/core/service/api%20service/dio_service.dart';
import 'package:online_course/core/service/logger/logger.dart';
import 'package:online_course/features/auth/data/models/forgot_password_model.dart';
import 'package:online_course/features/auth/data/models/login_model.dart';
import 'package:online_course/features/auth/data/models/otp_verification_model.dart';
import 'package:online_course/features/auth/data/models/register_user_model.dart';
import 'package:online_course/features/auth/domain/entities/account_setting_entitie.dart';
import 'package:online_course/features/auth/domain/entities/register_user_entities.dart';
import 'package:online_course/features/auth/domain/repositories/auth_repositories.dart';
import 'package:online_course/features/global/data/model/success_model.dart';

class AuthRepositoriesImpl implements AuthRepositories {
  @override
  Future<LoginModel> login({
    required String mobileNumber,
    required String Password,
  }) async {
    LoginModel model = LoginModel();
    try {
      final formData = FormData.fromMap({
        'activity': Activity.login,
        'uMobile': mobileNumber,
        'uPassword': Password,
      });
      final response = await DioService.dioPostApiCall(data: formData);
      if (response.statusCode == 200) {
        model = LoginModel.fromJson(response.data);

        if (model.status == 1) {
          await UserDB.setter(key: Keys.token, value: true);
          await UserDB.setter(
            key: Keys.firstNameKey,
            value: model.studentProfile?.uFirstName,
          );
          await UserDB.setter(
            key: Keys.lastNameKey,
            value: model.studentProfile?.uLastName,
          );
          await UserDB.setter(
            key: Keys.emailKey,
            value: model.studentProfile?.uEmail,
          );
          await UserDB.setter(
            key: Keys.mobileKey,
            value: model.studentProfile?.uMobile,
          );
          await UserDB.setter(
            key: Keys.alternateMobileKey,
            value: model.studentProfile?.uAlternateNumber,
          );
          await UserDB.setter(
            key: Keys.profileImageKey,
            value: model.studentProfile?.uImage,
          );
          await UserDB.setter(
            key: Keys.bioKey,
            value: model.studentProfile?.uBio,
          );
          await UserDB.setter(
            key: Keys.userKey,
            value: model.studentProfile?.userKey,
          );
        }
        logger.i('Login FormData : ${formData.fields}');

        logger.d('Login JsonData : ${response.data}');
      } else {
        logger.i('failed to login');
      }
    } catch (e) {
      logger.e('Login Error : $e');
    }
    return model;
  }

  @override
  Future<RegisterUserModel> registerUser({
    required RegisterEntity param,
  }) async {
    RegisterUserModel model = RegisterUserModel();
    try {
      final formData = FormData.fromMap({
        'activity': Activity.registerUser,
        'uFirstName': param.uFirstName,
        'uLastName': param.uLastName,
        'uEmail': param.uEmail,
        'uMobile': param.uMobile,
        'uAlternateNumber': param.uAlternateNumber,
        'selectedCourse': param.selectedCourse,
        'selectedCourseType': param.selectedCourseType,
        'uPassword': param.uPassword,
        'uConfirmPassword': param.uConfirmPassword,
        'termsAgree': param.termsAgree,
      });
      final response = await DioService.dioPostApiCall(data: formData);

      if (response.statusCode == 200) {
        model = RegisterUserModel.fromJson(response.data);
        logger.i('RegisterUser FormData : ${formData.fields}');
        logger.d('Register User JsonData : ${response.data}');
      } else {
        logger.i('failed to register user');
      }
    } catch (e) {
      logger.e('Register User Error : $e');
    }
    return model;
  }

  @override
  Future<ForgotPasswordModel> forgotPassword({required String uMobile}) async {
    ForgotPasswordModel model = ForgotPasswordModel();
    try {
      final response = await DioService.dioPostApiCall(
        data: FormData.fromMap({
          'activity': Activity.forgotPassword,
          'uMobile': uMobile,
        }),
      );
      if (response.statusCode == 200) {
        model = ForgotPasswordModel.fromJson(response.data);

        logger.d('Forgot Password JsonData : ${response.data}');
      } else {
        logger.i('failed to forgot password');
      }
    } catch (e) {
      logger.e('Forgot Password Error : $e');
    }
    return model;
  }

  @override
  Future<OTPVerifyModel> otpVerification({
    required String uMobile,
    required String uOTP,
    required String vType,
  }) async {
    OTPVerifyModel model = OTPVerifyModel();
    try {
      final formData = FormData.fromMap({
        'activity': Activity.otp,
        'uMobile': uMobile,
        'uOTP': uOTP,
        'verificationType': vType,
      });
      final response = await DioService.dioPostApiCall(data: formData);
      if (response.statusCode == 200) {
        model = OTPVerifyModel.fromJson(response.data);

        logger.d('OTP Verification FormData : ${formData.fields}');
        logger.d('OTP Verification JsonData : ${response.data}');
      } else {
        logger.i('failed to otp verification');
      }
    } catch (e) {
      logger.e('OTP Verification Error : $e');
    }
    return model;
  }

  @override
  Future<SuccessModel> resetPasswordPassword({
    required String uPassword,
    required String uConfirmPassword,
    String? userKey,
  }) async {
    SuccessModel model = SuccessModel();
    try {
      final response = await DioService.dioPostApiCall(
        data: FormData.fromMap({
          'activity': Activity.resetPassword,
          'uPassword': uPassword,
          'uConfirmPassword': uConfirmPassword,
          'userKey': userKey ?? UserDB.userKey,
        }),
      );
      if (response.statusCode == 200) {
        model = SuccessModel.fromJson(response.data);

        logger.d('Reset Password JsonData : ${response.data}');
      } else {
        logger.i('failed to reset password');
      }
    } catch (e) {
      logger.e('Reset Password Error : $e');
    }
    return model;
  }

  @override
  Future<ForgotPasswordModel> accountSetting({
    required AccountEntity data,
  }) async {
    ForgotPasswordModel model = ForgotPasswordModel();
    try {
      final formData = FormData.fromMap({
        'activity': Activity.accountSetting,
        'userKey': UserDB.userKey,
        'uFirstName': data.uFirstName,
        'uLastName': data.uLastName,
        'uEmail': data.uEmail,
        'uMobile': data.uMobile,
        'uAlternateNumber': data.uAlternateNumber,
        'uBio': data.uBio,
      });

      if (data.image != null) {
        formData.files.add(
          MapEntry(
            'uImage',
            await MultipartFile.fromFile(
              data.image!.path,
              filename: data.image!.path.split('/').last,
            ),
          ),
        );

        logger.i('User Selected Profile Image : ${data.image!.path}');
      }

      final response = await DioService.dioPostApiCall(data: formData);
      if (response.statusCode == 200) {
        model = ForgotPasswordModel.fromJson(response.data);

        logger.d('Account Setting FormData : ${formData.fields}');
        logger.d('Account Setting JsonData : ${response.data}');
      } else {
        logger.i('failed to account setting');
      }
    } catch (e) {
      logger.e('Account Setting Error : $e');
    }
    return model;
  }

  @override
  @override
  Future<SuccessModel> changePassword({
    required String currentPass,
    required String newPass,
    required String confirmPass,
  }) async {
    SuccessModel model = SuccessModel();
    try {
      final formData = FormData.fromMap({
        'activity': Activity.changePassword,
        'userKey': UserDB.userKey,
        'currentPassword': currentPass,
        'newPassword': newPass,
        'confirmPassword': confirmPass,
      });
      final response = await DioService.dioPostApiCall(data: formData);
      if (response.statusCode == 200) {
        model = SuccessModel.fromJson(response.data);

        logger.d('Change Password FormData : ${formData.fields}');
        logger.d('Change Password JsonData : ${response.data}');
      } else {
        logger.i('failed to change password');
      }
    } catch (e) {
      logger.e('Change Password Error : $e');
    }
    return model;
  }
}
