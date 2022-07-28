part of 'setting_bloc.dart';

@immutable
abstract class SettingState extends Equatable {
  const SettingState();
  @override
  List<Object> get props => [];
}

class SettingInitial extends SettingState {}

class SettingLoadingState extends SettingState {}

class SettingFailureState extends SettingState {
  final String errorMessage;
  const SettingFailureState(this.errorMessage);
}

class FeedbackSuccessState extends SettingState {
  final CommonSuccessResponse feedbackResponse;
  const FeedbackSuccessState(this.feedbackResponse);
}

class AboutUsSuccessState extends SettingState {
  final CommonSuccessResponse aboutResponse;

  const AboutUsSuccessState(this.aboutResponse);
}
