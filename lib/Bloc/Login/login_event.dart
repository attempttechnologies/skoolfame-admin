part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoginApiEvent extends LoginEvent {
  final Map<String, dynamic> params;

  LoginApiEvent(this.params);
}

class LogoutApiEvent extends LoginEvent {}

class FacebookApiEvent extends LoginEvent {}

class ForgotPasswordApiEvent extends LoginEvent {
  final Map<String, dynamic> params;

  ForgotPasswordApiEvent(this.params);
}
