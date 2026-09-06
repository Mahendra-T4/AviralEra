import 'package:online_course/features/auth/data/models/forgot_password_model.dart';
import 'package:online_course/features/auth/data/models/login_model.dart';
import 'package:online_course/features/auth/data/models/otp_verification_model.dart';
import 'package:online_course/features/auth/data/models/register_user_model.dart';
import 'package:online_course/features/auth/domain/entities/account_setting_entitie.dart';
import 'package:online_course/features/auth/domain/entities/register_user_entities.dart';
import 'package:online_course/features/global/data/model/success_model.dart';

abstract class AuthRepositories {
  Future<LoginModel> login({
    required String mobileNumber,
    required String Password,
  });

  Future<RegisterUserModel> registerUser({required RegisterEntity param});

  Future<OTPVerifyModel> otpVerification({
    required String uMobile,
    required String uOTP,
    required String vType,
  });

  Future<ForgotPasswordModel> forgotPassword({required String uMobile});

  Future<SuccessModel> resetPasswordPassword({
    required String uPassword,
    required String uConfirmPassword,
    String? userKey,
  });

  Future<ForgotPasswordModel> accountSetting({required AccountEntity data});

  Future<SuccessModel> changePassword({
    required String currentPass,
    required String newPass,
    required String confirmPass,
  });
}
