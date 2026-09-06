part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoadingState extends AuthState {}

//!------------------------login state--------------------------------

final class AuthUserLoginLoadedSuccessState extends AuthState {
  final LoginModel loginModel;

  AuthUserLoginLoadedSuccessState({required this.loginModel});

  @override
  List<Object> get props => [loginModel];
}

final class AuthUserLoginLoadedFailedState extends AuthState {
  final String message;

  AuthUserLoginLoadedFailedState({required this.message});
  @override
  List<Object> get props => [message];
}

//!------------------------register state--------------------------------

final class AuthRegisterUserLoadedSuccessState extends AuthState {
  final RegisterUserModel registerUserModel;

  AuthRegisterUserLoadedSuccessState({required this.registerUserModel});

  @override
  List<Object> get props => [registerUserModel];
}

final class AuthRegisterUserLoadedFailedState extends AuthState {
  final String message;

  AuthRegisterUserLoadedFailedState({required this.message});
  @override
  List<Object> get props => [message];
}

//! -----------------------OTP Verification State--------------------------

final class AuthOTPVerificationLoadedSuccessState extends AuthState {
  final OTPVerifyModel otpVerifyModel;

  AuthOTPVerificationLoadedSuccessState({required this.otpVerifyModel});

  @override
  List<Object> get props => [otpVerifyModel];
}

final class AuthOTPVerificationLoadedFailedState extends AuthState {
  final String message;

  AuthOTPVerificationLoadedFailedState({required this.message});
  @override
  List<Object> get props => [message];
}

//!-----------------------forgot password--------------------------

final class AuthForgotPasswordLoadedSuccessState extends AuthState {
  final ForgotPasswordModel forgotPasswordModel;

  AuthForgotPasswordLoadedSuccessState({required this.forgotPasswordModel});

  @override
  List<Object> get props => [forgotPasswordModel];
}

final class AuthForgotPasswordLoadedFailedState extends AuthState {
  final String message;

  AuthForgotPasswordLoadedFailedState({required this.message});
  @override
  List<Object> get props => [message];
}

//!-----------------------set password--------------------------

final class AuthResetPasswordLoadedSuccessState extends AuthState {
  final SuccessModel successModel;

  AuthResetPasswordLoadedSuccessState({required this.successModel});

  @override
  List<Object> get props => [successModel];
}

final class AuthResetPasswordLoadedFailedState extends AuthState {
  final String message;

  AuthResetPasswordLoadedFailedState({required this.message});
  @override
  List<Object> get props => [message];
}

//!-----------------------account settings--------------------------

final class AuthUpdateAccountSettingLoadedSuccessState extends AuthState {
  final ForgotPasswordModel model;

  AuthUpdateAccountSettingLoadedSuccessState({required this.model});

  @override
  List<Object> get props => [model];
}

final class AuthUpdateAccountSettingFailedState extends AuthState {
  final String message;

  AuthUpdateAccountSettingFailedState({required this.message});
  @override
  List<Object> get props => [message];
}

//!-----------------------change password--------------------------

final class AuthChangePasswordLoadedSuccessState extends AuthState {
  final SuccessModel model;

  AuthChangePasswordLoadedSuccessState({required this.model});

  @override
  List<Object> get props => [model];
}

final class AuthChangePasswordFailedState extends AuthState {
  final String message;

  AuthChangePasswordFailedState({required this.message});
  @override
  List<Object> get props => [message];
}
