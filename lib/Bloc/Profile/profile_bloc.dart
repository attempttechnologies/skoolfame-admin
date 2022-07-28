import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:skoolfame/Data/API/api_manager.dart';
import 'package:skoolfame/Data/API/dio_api_manager.dart';
import 'package:skoolfame/Data/Models/login_success_respo_model.dart';
import 'package:skoolfame/Utils/constants.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final APIManager apiManager = APIManager();
  final DioApiManager dioApiManager = DioApiManager();

  ProfileBloc() : super(ProfileInitial()) {
    on<EditProfileApiEvent>((event, emit) async {
      emit(ProfileInitial());
      var editProfileResponse = await _editProfileApiCall(event.params);
      emit(ProfileSuccessState(editProfileResponse));
    });
    on<UserAboutApiEvent>((event, emit) async {
      var userAboutResponse = await _userAboutApiCall(event.params);
      emit(UserAboutSuccessState(userAboutResponse));
    });
  }

  // Future<LoginSuccessResponse> _editProfileApiCall(
  //     Map<String, dynamic> param) async {
  //   var res = await apiManager.patchAPICall('users/update-user', param);
  //   LoginSuccessResponse loginSuccessResponse = LoginSuccessResponse();
  //   loginSuccessResponse = LoginSuccessResponse.fromJson(res);
  //   loginSuccessResponse.token = LoginSuccessResponse.fromJson(
  //           GetStorage().read(AppPreferenceString.pUserData))
  //       .token;
  //
  //   GetStorage()
  //       .write(AppPreferenceString.pUserData, loginSuccessResponse.toJson());
  //   return LoginSuccessResponse.fromJson(res);
  // }

  Future<LoginSuccessResponse> _userAboutApiCall(
      Map<String, dynamic> param) async {
    var res = await apiManager.postAPICall('users/about-us', param);
    LoginSuccessResponse loginSuccessResponse = LoginSuccessResponse();
    loginSuccessResponse = LoginSuccessResponse.fromJson(
        GetStorage().read(AppPreferenceString.pUserData));
    loginSuccessResponse.data!.about =
        LoginSuccessResponse.fromJson(res).data!.about;

    GetStorage()
        .write(AppPreferenceString.pUserData, loginSuccessResponse.toJson());
    return LoginSuccessResponse.fromJson(res);
  }

  Future<LoginSuccessResponse> _editProfileApiCall(
      Map<String, dynamic> param) async {
    var res = await dioApiManager.dioPatchAPICall('users/update-user', param);
    LoginSuccessResponse loginSuccessResponse = LoginSuccessResponse();
    loginSuccessResponse = LoginSuccessResponse.fromJson(res);
    loginSuccessResponse.token = LoginSuccessResponse.fromJson(
            GetStorage().read(AppPreferenceString.pUserData))
        .token;

    GetStorage()
        .write(AppPreferenceString.pUserData, loginSuccessResponse.toJson());
    return loginSuccessResponse;
  }
}
