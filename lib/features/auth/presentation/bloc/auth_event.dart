part of 'auth_bloc.dart';

class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthUserLoginEvent extends AuthEvent {
  final String uMobile;
  final String uPassword;

  AuthUserLoginEvent({required this.uMobile, required this.uPassword});

  @override
  List<Object?> get props => [uMobile, uPassword];
}

class RegisterUserEvent extends AuthEvent {
  final RegisterEntity registerEntity;

  RegisterUserEvent({required this.registerEntity});

  @override
  List<Object?> get props => [registerEntity];
}

class OTPVerifyEvent extends AuthEvent {
  final String uMobile;
  final String uOTP;
  final String vType;

  OTPVerifyEvent({
    required this.uMobile,
    required this.uOTP,
    required this.vType,
  });

  @override
  List<Object?> get props => [uMobile, uOTP, vType];
}

class ForgotPasswordEvent extends AuthEvent {
  final String uMobile;

  ForgotPasswordEvent({required this.uMobile});

  @override
  List<Object?> get props => [uMobile];
}

class AuthResetPasswordEvent extends AuthEvent {
  final String uPassword;
  final String uConfirmPassword;
  final String? userKey;

  AuthResetPasswordEvent({
    required this.uPassword,
    required this.uConfirmPassword,
    this.userKey,
  });

  @override
  List<Object?> get props => [uPassword, uConfirmPassword, userKey];
}

class AuthUpdateAccountSettingEvent extends AuthEvent {
  final AccountEntity data;

  AuthUpdateAccountSettingEvent({required this.data});

  @override
  List<Object?> get props => [data];
}

class AuthChangePasswordEvent extends AuthEvent {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  AuthChangePasswordEvent({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword, confirmPassword];
}
