import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:meta/meta.dart';
import 'package:skoolfame/Data/API/api_manager.dart';
import 'package:skoolfame/Data/Models/comman_success_model.dart';
import 'package:skoolfame/Data/Models/login_success_respo_model.dart';
import 'package:skoolfame/Data/Models/user_cached_model.dart';
import 'package:skoolfame/Utils/app_strings.dart';
import 'package:skoolfame/Utils/constants.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final APIManager apiManager = APIManager();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  LoginBloc() : super(LoginInitial()) {
    on<LoginApiEvent>((event, emit) async {
      var loginResponse = await _loginApiCall(event.params);
      emit(LoginSuccessState(loginResponse));
    });
    on<LogoutApiEvent>((event, emit) async {
      var logoutResponse = await _logoutApiCall();
      emit(LogoutSuccessState(logoutResponse));
    });
    on<FacebookApiEvent>((event, emit) async {
      var facebookResponse = await _facebookApiCall();
      emit(FacebookSuccessState(facebookResponse));
    });
    on<ForgotPasswordApiEvent>((event, emit) async {
      var passwordResponse = await _forgotPasswordApiCall(event.params);
      emit(ForgotPasswordSuccessState(passwordResponse));
    });
  }

  Future<LoginSuccessResponse> _loginApiCall(Map<String, dynamic> param) async {
    var res = await apiManager.postAPICall('users/sign-in', param);
    GetStorage().write(AppPreferenceString.pUserData,
        LoginSuccessResponse.fromJson(res).toJson());
    return LoginSuccessResponse.fromJson(res);
  }

  Future<CommonSuccessResponse> _forgotPasswordApiCall(
      Map<String, dynamic> param) async {
    var res = await apiManager.postAPICall('users/forgot-password', param);
    return CommonSuccessResponse.fromJson(res);
  }

  Future<CommonSuccessResponse> _logoutApiCall() async {
    if (LoginSuccessResponse.fromJson(
                GetStorage().read(AppPreferenceString.pUserData))
            .data!
            .socialMedia ==
        "facebook") {
      await FacebookAuth.instance.logOut();
      await _auth.signOut();
    }
    UserCachedModel userCachedModel = UserCachedModel();

    if (UserCachedModel.fromJson(GetStorage().read(AppStrings.userCached) ?? {})
            .email !=
        null) {
      userCachedModel =
          UserCachedModel.fromJson(GetStorage().read(AppStrings.userCached));
      print(userCachedModel.toJson());
    }
    var res = await apiManager.getAPICall('users/sign-out');
    GetStorage().erase();
    GetStorage().write(AppStrings.userCached, userCachedModel.toJson());
    return CommonSuccessResponse.fromJson(res);

    // }
  }

  Future<LoginSuccessResponse> _facebookApiCall() async {
    try {
      UserCredential userCredential;

      final LoginResult loginResult = await FacebookAuth.instance.login();

      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      userCredential = await _auth.signInWithCredential(facebookAuthCredential);

      User? user = userCredential.user;
      LoginSuccessResponse loginSuccessResponse = LoginSuccessResponse();
      if (user != null) {
        var res = await apiManager.postAPICall('users/sign-up-socialmedia', {
          "first_name": user.displayName,
          "last_name": user.displayName,
          "email": user.email,
          "social_media": "facebook",
          "about": ""
        });
        GetStorage().write(AppPreferenceString.pUserData,
            LoginSuccessResponse.fromJson(res).toJson());
        loginSuccessResponse = LoginSuccessResponse.fromJson(res);
      }
      return loginSuccessResponse;
    } catch (error) {
      rethrow;
    } finally {}
  }
}
