part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

class EditProfileApiEvent extends ProfileEvent {
  final Map<String, dynamic> params;

  EditProfileApiEvent(this.params);
}

class UserAboutApiEvent extends ProfileEvent {
  final Map<String, dynamic> params;

  UserAboutApiEvent(this.params);
}
