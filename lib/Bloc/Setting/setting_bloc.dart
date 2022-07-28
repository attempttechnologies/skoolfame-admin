import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:skoolfame/Data/API/api_manager.dart';
import 'package:skoolfame/Data/Models/comman_success_model.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final APIManager apiManager = APIManager();

  SettingBloc() : super(SettingInitial()) {
    on<FeedbackApiEvent>((event, emit) async {
      var feedbackResponse = await _feedbackApiCall(event.params);
      emit(FeedbackSuccessState(feedbackResponse));
    });
    on<AboutUsApiEvent>((event, emit) async {
      var aboutResponse = await _aboutUsApiCall();
      emit(AboutUsSuccessState(aboutResponse));
    });
  }
  Future<CommonSuccessResponse> _feedbackApiCall(
      Map<String, dynamic> param) async {
    var res = await apiManager.postAPICall('users/feedback', param);
    return CommonSuccessResponse.fromJson(res);
  }

  Future<CommonSuccessResponse> _aboutUsApiCall() async {
    var res = await apiManager.getAPICall('users/app-about-us');
    return CommonSuccessResponse.fromJson(res);
  }
}
