part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

final class GetAboutUsDataEvent extends ProfileEvent {
  const GetAboutUsDataEvent();

  @override
  List<Object> get props => [];
}

final class GetContactUsDataEvent extends ProfileEvent {
  const GetContactUsDataEvent();

  @override
  List<Object> get props => [];
}

final class GetPoliciesDataEvent extends ProfileEvent {
  final int policyType;
  const GetPoliciesDataEvent({required this.policyType});

  @override
  List<Object> get props => [policyType];
}
