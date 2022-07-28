part of 'setting_bloc.dart';

@immutable
abstract class SettingEvent {}

class FeedbackApiEvent extends SettingEvent {
  final Map<String, dynamic> params;

  FeedbackApiEvent(this.params);
}

class AboutUsApiEvent extends SettingEvent {
  AboutUsApiEvent();
}
