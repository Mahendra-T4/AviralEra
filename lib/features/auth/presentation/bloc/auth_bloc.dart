import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:online_course/features/auth/data/models/forgot_password_model.dart';
import 'package:online_course/features/auth/data/models/login_model.dart';
import 'package:online_course/features/auth/data/models/otp_verification_model.dart';
import 'package:online_course/features/auth/data/models/register_user_model.dart';
import 'package:online_course/features/auth/domain/entities/account_setting_entitie.dart';
import 'package:online_course/features/auth/domain/entities/register_user_entities.dart';
import 'package:online_course/features/auth/domain/repositories/auth_repositories.dart';
import 'package:online_course/features/global/data/model/success_model.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepositories repositorie;
  AuthBloc(this.repositorie) : super(AuthInitial()) {
    on<AuthUserLoginEvent>(_authUserLoginEvent);
    on<RegisterUserEvent>(_registerUserEvent);
    on<OTPVerifyEvent>(_oTPVerifyEvent);
    on<ForgotPasswordEvent>(_forgotPasswordEvent);
    on<AuthResetPasswordEvent>(_authResetPasswordEvent);
    on<AuthUpdateAccountSettingEvent>(_authUpdateAccountSettingEvent);
    on<AuthChangePasswordEvent>(_authChangePasswordEvent);
  }

  FutureOr<void> _registerUserEvent(
    RegisterUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final result = await repositorie.registerUser(
        param: event.registerEntity,
      );

      emit(AuthRegisterUserLoadedSuccessState(registerUserModel: result));
    } catch (e) {
      emit(AuthRegisterUserLoadedFailedState(message: e.toString()));
    }
  }

  FutureOr<void> _forgotPasswordEvent(
    ForgotPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final result = await repositorie.forgotPassword(uMobile: event.uMobile);

      emit(AuthForgotPasswordLoadedSuccessState(forgotPasswordModel: result));
    } catch (e) {
      emit(AuthForgotPasswordLoadedFailedState(message: e.toString()));
    }
  }

  FutureOr<void> _oTPVerifyEvent(
    OTPVerifyEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final result = await repositorie.otpVerification(
        uMobile: event.uMobile,
        uOTP: event.uOTP,
        vType: event.vType,
      );

      emit(AuthOTPVerificationLoadedSuccessState(otpVerifyModel: result));
    } catch (e) {
      emit(AuthOTPVerificationLoadedFailedState(message: e.toString()));
    }
  }

  FutureOr<void> _authResetPasswordEvent(
    AuthResetPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final result = await repositorie.resetPasswordPassword(
        uPassword: event.uPassword,
        uConfirmPassword: event.uConfirmPassword,
        userKey: event.userKey,
      );

      emit(AuthResetPasswordLoadedSuccessState(successModel: result));
    } catch (e) {
      emit(AuthResetPasswordLoadedFailedState(message: e.toString()));
    }
  }

  FutureOr<void> _authUserLoginEvent(
    AuthUserLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final result = await repositorie.login(
        mobileNumber: event.uMobile,
        Password: event.uPassword,
      );
      emit(AuthUserLoginLoadedSuccessState(loginModel: result));
    } catch (e) {
      emit(AuthUserLoginLoadedFailedState(message: e.toString()));
    }
  }

  FutureOr<void> _authUpdateAccountSettingEvent(
    AuthUpdateAccountSettingEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final result = await repositorie.accountSetting(data: event.data);

      emit(AuthUpdateAccountSettingLoadedSuccessState(model: result));
    } catch (e) {
      emit(AuthUpdateAccountSettingFailedState(message: e.toString()));
    }
  }

  FutureOr<void> _authChangePasswordEvent(
    AuthChangePasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final result = await repositorie.changePassword(
        currentPass: event.currentPassword,
        newPass: event.newPassword,
        confirmPass: event.confirmPassword,
      );

      emit(AuthChangePasswordLoadedSuccessState(model: result));
    } catch (e) {
      emit(AuthChangePasswordFailedState(message: e.toString()));
    }
  }
}
