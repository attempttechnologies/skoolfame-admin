part of 'notification_bloc.dart';

@immutable
abstract class NotificationEvent {}

class GetNotificationEvent extends NotificationEvent {}

class DeleteNotificationApiEvent extends NotificationEvent {
  final Map<String, dynamic> params;
  DeleteNotificationApiEvent(this.params);
}

class DeleteAllNotificationApiEvent extends NotificationEvent {
  final Map<String, dynamic> params;

  DeleteAllNotificationApiEvent(this.params);
}

class GetNotificationSettingApiEvent extends NotificationEvent {}

class UpdateNotificationSettingApiEvent extends NotificationEvent {
  final Map<String, dynamic> params;

  UpdateNotificationSettingApiEvent(this.params);
}
