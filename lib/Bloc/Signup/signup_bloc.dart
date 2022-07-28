import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_storage/get_storage.dart';
import 'package:meta/meta.dart';
import 'package:skoolfame/Data/API/api_manager.dart';
import 'package:skoolfame/Data/Models/comman_success_model.dart';
import 'package:skoolfame/Data/Models/login_success_respo_model.dart';
import 'package:skoolfame/Data/Models/school_model.dart';
import 'package:skoolfame/Utils/constants.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignUpEvent, SignupState> {
  final APIManager apiManager = APIManager();

  SignupBloc() : super(SignupInitial()) {
    on<SignUpApiEvent>((event, emit) async {
      var signupResponse = await _signupApiCall(event.params);
      emit(SignupSuccessState(signupResponse));
    });
    on<GetSchoolApiEvent>((event, emit) async {
      var schoolResponse = await _getSchoolApiCall();
      emit(GetSchoolSuccessState(schoolResponse));
    });
    on<SchoolRequestApiEvent>((event, emit) async {
      emit(SignupLoadingState());
      var commonResponse = await _schoolRequestApiCall(event.params);
      emit(SchoolRequestSuccessState(commonResponse));
    });
  }

  Future<LoginSuccessResponse> _signupApiCall(
      Map<String, dynamic> param) async {
    var res = await apiManager.postAPICall('users/sign-up', param);
    GetStorage().write(AppPreferenceString.pUserData,
        LoginSuccessResponse.fromJson(res).toJson());
    return LoginSuccessResponse.fromJson(res);
  }

  Future<SchoolModel> _getSchoolApiCall() async {
    var res = await apiManager.getAPICall('users/get-all-school');
    return SchoolModel.fromJson(res);
  }

  Future<CommonSuccessResponse> _schoolRequestApiCall(
      Map<String, dynamic> param) async {
    var res = await apiManager.postAPICall('users/add-school-request', param);
    return CommonSuccessResponse.fromJson(res);
  }
}
