import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:skoolfame/Data/API/api_manager.dart';
import 'package:skoolfame/Data/Models/NotificationSettingModel.dart';
import 'package:skoolfame/Data/Models/comman_success_model.dart';
import 'package:skoolfame/Data/Models/notification_model.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final APIManager apiManager = APIManager();

  NotificationBloc() : super(NotificationInitial()) {
    on<GetNotificationEvent>((event, emit) async {
      emit(NotificationInitial());
      var notificationResponse = await _getNotificationApiCall();
      emit(GetNotificationSuccessState(notificationResponse));
    });
    on<DeleteNotificationApiEvent>((event, emit) async {
      emit(NotificationInitial());
      var deleteNotificationResponse =
          await _deleteNotificationApiCall(event.params);
      emit(DeleteNotificationSuccessState(deleteNotificationResponse));
    });
    on<DeleteAllNotificationApiEvent>((event, emit) async {
      emit(NotificationInitial());
      var deleteAllNotificationResponse =
          await _deleteAllNotificationApiCall(event.params);
      emit(DeleteAllNotificationSuccessState(deleteAllNotificationResponse));
    });

    on<GetNotificationSettingApiEvent>((event, emit) async {
      emit(NotificationInitial());
      var getNotificationSettingResponse =
          await _getNotificationSettingApiCall();
      emit(GetNotificationSettingSuccessState(getNotificationSettingResponse));
    });
    on<UpdateNotificationSettingApiEvent>((event, emit) async {
      emit(NotificationInitial());
      var updateNotificationSettingResponse =
          await _updateNotificationSettingApiCall(event.params);
      emit(UpdateNotificationSettingSuccessState(
          updateNotificationSettingResponse));
    });
  }
  Future<NotificationModel> _getNotificationApiCall() async {
    var res = await apiManager.getAPICall('users/get-notification');
    return NotificationModel.fromJson(res);
  }

  Future<CommonSuccessResponse> _deleteNotificationApiCall(
      Map<String, dynamic> params) async {
    var res =
        await apiManager.deleteAPICall('users/delete-notification', params);
    return CommonSuccessResponse.fromJson(res);
  }

  Future<CommonSuccessResponse> _deleteAllNotificationApiCall(
      Map<String, dynamic> params) async {
    var res =
        await apiManager.deleteAPICall('users/delete-all-notification', params);
    return CommonSuccessResponse.fromJson(res);
  }

  Future<NotificationSettingModel> _getNotificationSettingApiCall() async {
    var res = await apiManager.getAPICall('users/get-notification-setting');
    return NotificationSettingModel.fromJson(res);
  }

  Future<CommonSuccessResponse> _updateNotificationSettingApiCall(
      Map<String, dynamic> params) async {
    var res = await apiManager.patchAPICall(
        'users/update-notification-setting', params);
    return CommonSuccessResponse.fromJson(res);
  }
}
