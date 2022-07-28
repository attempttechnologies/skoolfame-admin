part of 'notification_bloc.dart';

@immutable
abstract class NotificationState extends Equatable {
  const NotificationState();
  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoadingState extends NotificationState {}

class NotificationBlocFailure extends NotificationState {
  final String errorMessage;
  const NotificationBlocFailure(this.errorMessage);
}

class GetNotificationSuccessState extends NotificationState {
  final NotificationModel notificationResponse;
  const GetNotificationSuccessState(this.notificationResponse);
}

class DeleteNotificationSuccessState extends NotificationState {
  final CommonSuccessResponse deleteNotificationResponse;
  const DeleteNotificationSuccessState(this.deleteNotificationResponse);
}

class DeleteAllNotificationSuccessState extends NotificationState {
  final CommonSuccessResponse deleteAllNotificationResponse;
  const DeleteAllNotificationSuccessState(this.deleteAllNotificationResponse);
}

class UpdateNotificationSettingSuccessState extends NotificationState {
  final CommonSuccessResponse updateNotificationSettingSuccessState;
  const UpdateNotificationSettingSuccessState(
      this.updateNotificationSettingSuccessState);
}

class GetNotificationSettingSuccessState extends NotificationState {
  final NotificationSettingModel getNotificationSettingSuccessState;
  const GetNotificationSettingSuccessState(
      this.getNotificationSettingSuccessState);
}
