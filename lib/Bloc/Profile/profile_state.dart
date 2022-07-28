part of 'profile_bloc.dart';

@immutable
abstract class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileBlocFailure extends ProfileState {
  final String errorMessage;
  const ProfileBlocFailure(this.errorMessage);
}

class ProfileSuccessState extends ProfileState {
  final LoginSuccessResponse profileResponse;
  const ProfileSuccessState(this.profileResponse);
}

class UserAboutSuccessState extends ProfileState {
  final LoginSuccessResponse userAboutResponse;
  const UserAboutSuccessState(this.userAboutResponse);
}
