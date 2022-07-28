part of 'login_bloc.dart';

@immutable
abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginBlocFailure extends LoginState {
  final String errorMessage;
  const LoginBlocFailure(this.errorMessage);
}

class LoginSuccessState extends LoginState {
  final LoginSuccessResponse loginResponse;
  const LoginSuccessState(this.loginResponse);
}

class LogoutSuccessState extends LoginState {
  final CommonSuccessResponse logoutResponse;
  const LogoutSuccessState(this.logoutResponse);
}

class FacebookSuccessState extends LoginState {
  final LoginSuccessResponse facebookResponse;
  const FacebookSuccessState(this.facebookResponse);
}

class ForgotPasswordSuccessState extends LoginState {
  final CommonSuccessResponse passwordResponse;
  const ForgotPasswordSuccessState(this.passwordResponse);
}
