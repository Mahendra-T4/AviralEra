import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:online_course/features/profile/data/model/about_us_model.dart';
import 'package:online_course/features/profile/data/model/conacts_us_model.dart';
import 'package:online_course/features/profile/data/model/policy_model.dart';
import 'package:online_course/features/profile/domain/repositories/profile_repo.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;
  ProfileBloc({required this.repository}) : super(ProfileInitial()) {
    on<GetAboutUsDataEvent>(_getAboutUsDataEvent);
    on<GetContactUsDataEvent>(_getContactUsDataEvent);
    on<GetPoliciesDataEvent>(_getPoliciesDataEvent);
  }

  FutureOr<void> _getAboutUsDataEvent(
    GetAboutUsDataEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final model = await repository.getAboutUs();
      emit(GetAboutUsDataSuccessState(aboutUSModel: model));
    } catch (e) {
      emit(ProfileErrorState(message: e.toString()));
    }
  }

  FutureOr<void> _getContactUsDataEvent(
    GetContactUsDataEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final model = await repository.getContactUs();
      emit(GetContactUsDataSuccessState(contactUSModel: model));
    } catch (e) {
      emit(ProfileErrorState(message: e.toString()));
    }
  }

  FutureOr<void> _getPoliciesDataEvent(
    GetPoliciesDataEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final model = await repository.getPolicies(policyType: event.policyType);
      emit(GetPoliciesDataSuccessState(policyModel: model));
    } catch (e) {
      emit(ProfileErrorState(message: e.toString()));
    }
  }
}
