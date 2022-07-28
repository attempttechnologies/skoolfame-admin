import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:skoolfame/Data/API/api_manager.dart';
import 'package:skoolfame/Data/Models/GetMessageModel.dart';
import 'package:skoolfame/Data/Models/comman_success_model.dart';

part 'activity_event.dart';
part 'activity_state.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  final APIManager apiManager = APIManager();

  ActivityBloc() : super(ActivityInitial()) {
    on<GetActivityApiEvent>((event, emit) async {
      emit(ActivityLoadingState());
      var getActivityResponse = await _getActivityApiCall();
      emit(GetActivitySuccessState(getActivityResponse));
    });
    on<DeleteActivityApiEvent>((event, emit) async {
      emit(ActivityLoadingState());
      var deleteActivityResponse = await _deleteActivityApiCall(event.params);
      emit(DeleteActivitySuccessState(deleteActivityResponse));
    });
  }
  Future<GetMessageModel> _getActivityApiCall() async {
    var res = await apiManager.getAPICall('users/get-my-activity');
    return GetMessageModel.fromJson(res);
  }

  Future<CommonSuccessResponse> _deleteActivityApiCall(
      Map<String, dynamic> param) async {
    var res = await apiManager.deleteAPICall('users/delete-my-activity', param);
    return CommonSuccessResponse.fromJson(res);
  }
}
