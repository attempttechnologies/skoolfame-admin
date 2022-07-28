part of 'signup_bloc.dart';

@immutable
abstract class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object> get props => [];
}

class SignupInitial extends SignupState {}

class SignupLoadingState extends SignupState {}

class SignupBlocFailure extends SignupState {
  final String errorMessage;
  const SignupBlocFailure(this.errorMessage);
}

class SignupSuccessState extends SignupState {
  final LoginSuccessResponse signupResponse;
  const SignupSuccessState(this.signupResponse);
}

class GetSchoolSuccessState extends SignupState {
  final SchoolModel schoolResponse;
  const GetSchoolSuccessState(this.schoolResponse);
}

class SchoolRequestSuccessState extends SignupState {
  final CommonSuccessResponse commonSuccessResponse;
  const SchoolRequestSuccessState(this.commonSuccessResponse);
}

class NotificationSuccessState extends SignupState {
  const NotificationSuccessState();
}
