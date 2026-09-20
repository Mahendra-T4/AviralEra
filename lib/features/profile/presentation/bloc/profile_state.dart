part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class GetAboutUsDataSuccessState extends ProfileState {
  final AboutUSModel aboutUSModel;
  const GetAboutUsDataSuccessState({required this.aboutUSModel});

  @override
  List<Object> get props => [aboutUSModel];
}

final class GetContactUsDataSuccessState extends ProfileState {
  final ContactUSModel contactUSModel;
  const GetContactUsDataSuccessState({required this.contactUSModel});

  @override
  List<Object> get props => [contactUSModel];
}

final class GetPoliciesDataSuccessState extends ProfileState {
  final PolicyModel policyModel;
  const GetPoliciesDataSuccessState({required this.policyModel});

  @override
  List<Object> get props => [policyModel];
}

final class ProfileErrorState extends ProfileState {
  final String message;
  const ProfileErrorState({required this.message});

  @override
  List<Object> get props => [message];
}


