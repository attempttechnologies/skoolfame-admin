part of 'signup_bloc.dart';

@immutable
abstract class SignUpEvent {}

class SignUpApiEvent extends SignUpEvent {
  final Map<String, dynamic> params;

  SignUpApiEvent(this.params);
}

class GetSchoolApiEvent extends SignUpEvent {}

class SchoolRequestApiEvent extends SignUpEvent {
  final Map<String, dynamic> params;

  SchoolRequestApiEvent(this.params);
}

class NotificationEvent extends SignUpEvent {}
