import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:skoolfame/Data/API/custom_exception.dart';
import 'package:skoolfame/Data/Models/error_model.dart';
import 'package:skoolfame/Data/Models/login_success_respo_model.dart';
import 'package:skoolfame/Utils/constants.dart';
import 'package:skoolfame/Widgets/custom_widget.dart';

/// [ApiManager] containes the Post and get method of http with response and error handling
///
class APIManager {
  ///
  /// Dev base URL
  ///
  static const baseUrl = "http://192.168.40.160:3000/";

  ///
  /// Prod base URL
  ///
  // static const baseUrl = "http://165.232.187.214:9000";

  /// Used to call post API method, pass the url and param for api call
  ///
  /// `APIManager().postAPICall("https://.....",{});`
  Future<dynamic> postAPICall(String url, Map param) async {
    print("Calling API: $url");
    print("Calling parameters: $param");

    var responseJson;
    try {
      /// Show progress loader
      CustomWidgets().showProgressIndicator();

      /// Set header for send request
      var headers = GetStorage().read(AppPreferenceString.pUserData) == null
          ? {
              "Content-Type": "application/json",
            }
          : {
              "Content-Type": "application/json",
              "Authorization": "Bearer " +
                  LoginSuccessResponse.fromJson(
                          GetStorage().read(AppPreferenceString.pUserData))
                      .token!
            };

      /// call post api for given url and parameters
      final response = await http
          .post(Uri.parse(baseUrl + url),
              headers: headers, body: json.encode(param))
          .timeout(const Duration(seconds: 10));
      // .onError((error, stackTrace) =>
      //     throw FetchDataException('Something Went Wrong!'));
      if (kDebugMode) {
        print(response.body);
      }

      /// Check api response and handle exception
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No internet connection');
    } on TimeoutException catch (_) {
      throw FetchDataException('Server Error');
    } finally {
      /// Hide progress loader
      EasyLoading.dismiss();
    }
    return responseJson;
  }

  /// Used to call get API method, pass the url for api call
  ///
  /// `APIManager().getAPICall("https://.....");`
  Future<dynamic> getAPICall(String url, {bool isLoaderShow = true}) async {
    print("Calling API: $url");

    var responseJson;
    try {
      /// Show progress loader
      ///
      if (isLoaderShow) {
        CustomWidgets().showProgressIndicator();
      }

      // print(auth_token);
      Map<String, String>? headers =
          GetStorage().read(AppPreferenceString.pUserData) == null
              ? {}
              : {
                  "Authorization": "Bearer " +
                      LoginSuccessResponse.fromJson(
                              GetStorage().read(AppPreferenceString.pUserData))
                          .token!
                };

      /// call post api for given url and parameters
      final response = await http
          .get(Uri.parse(baseUrl + url), headers: headers)
          .timeout(Duration(seconds: 15));
      // .onError((error, stackTrace) =>
      //     throw FetchDataException('Something went wrong!'));

      if (kDebugMode) {
        print(response.body);
      }

      /// Check api response and handle exception
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No internet connection');
    } on TimeoutException catch (_) {
      throw FetchDataException('Server Error');
    } finally {
      /// Hide progress loader
      if (isLoaderShow) {
        EasyLoading.dismiss();
      }
    }
    return responseJson;
  }

  /// Used to call post API method, pass the url and param for api call
  ///
  /// `APIManager().patchAPICall("https://.....",{});`
  Future<dynamic> patchAPICall(String url, Map param) async {
    print("Calling API: $url");
    print("Calling parameters: $param");

    var responseJson;
    try {
      /// Show progress loader
      CustomWidgets().showProgressIndicator();

      /// Set header for send request
      var headers = GetStorage().read(AppPreferenceString.pUserData) == null
          ? {
              "Content-Type": "application/json",
            }
          : {
              "Content-Type": "application/json",
              "Authorization": "Bearer " +
                  LoginSuccessResponse.fromJson(
                          GetStorage().read(AppPreferenceString.pUserData))
                      .token!
            };
      print("Headers:${headers}");

      /// call post api for given url and parameters
      final response = await http
          .patch(Uri.parse(baseUrl + url),
              headers: headers, body: json.encode(param))
          .timeout(Duration(seconds: 15));
      // .onError((error, stackTrace) =>
      //     throw FetchDataException('Something went wrong!'));
      print("response: ${response.body}");

      /// Check api response and handle exception
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No internet connection');
    } on TimeoutException catch (_) {
      throw FetchDataException('Server Error');
    } finally {
      /// Hide progress loader
      EasyLoading.dismiss();
    }
    return responseJson;
  }

  /// Used to call post API method, pass the url and param for api call
  ///
  /// `APIManager().postAPICall("https://.....",{});`
  Future<dynamic> putAPICall(String url, Map param) async {
    print("Calling API: $url");
    print("Calling parameters: $param");

    var responseJson;
    try {
      /// Show progress loader
      CustomWidgets().showProgressIndicator();

      /// Set header for send request
      var headers = {
        "Content-Type": "application/json",
      };

      /// call post api for given url and parameters
      final response = await http
          .put(Uri.parse(baseUrl + url),
              headers: headers, body: json.encode(param))
          .timeout(Duration(seconds: 15));
      // .onError((error, stackTrace) =>
      //     throw FetchDataException('Something went wrong!'));

      /// Check api response and handle exception
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No internet connection');
    } on TimeoutException catch (_) {
      throw FetchDataException('Server Error');
    } finally {
      /// Hide progress loader
      EasyLoading.dismiss();
    }
    return responseJson;
  }

  /// Used to call delete API method, pass the url and param for api call
  ///
  /// `APIManager().deleteAPICall("https://.....",{});`
  Future<dynamic> deleteAPICall(String url, Map param) async {
    print("Calling API: $url");
    print("Calling parameters: $param");

    var responseJson;
    try {
      /// Show progress loader
      CustomWidgets().showProgressIndicator();

      /// Set header for send request
      var headers = GetStorage().read(AppPreferenceString.pUserData) == null
          ? {
              "Content-Type": "application/json",
            }
          : {
              "Content-Type": "application/json",
              "Authorization": "Bearer " +
                  LoginSuccessResponse.fromJson(
                          GetStorage().read(AppPreferenceString.pUserData))
                      .token!
            };

      /// call post api for given url and parameters
      final response = await http
          .delete(Uri.parse(baseUrl + url),
              headers: headers, body: json.encode(param))
          .timeout(Duration(seconds: 15));
      // .onError((error, stackTrace) =>
      //     throw FetchDataException('Something went wrong!'));

      /// Check api response and handle exception
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No internet connection');
    } on TimeoutException catch (_) {
      throw FetchDataException('Server Error');
    } finally {
      /// Hide progress loader
      EasyLoading.dismiss();
    }
    return responseJson;
  }

  /// Check response status and handle exception
  static _response(http.Response response) {
    print(response.statusCode);
    switch (response.statusCode) {

      /// Successfully get api response
      case 200:
        if (json.decode(response.body)['status'] == 0) {
          throw BadRequestException(
              ErrorModel.fromJson(json.decode(response.body.toString()))
                  .message);
        } else {
          var responseJson = json.decode(response.body.toString());
          return responseJson;
        }

      /// Successfully get api response
      case 201:
        if (json.decode(response.body)['status'] == 0) {
          throw BadRequestException(
              ErrorModel.fromJson(json.decode(response.body.toString()))
                  .message);
        } else {
          var responseJson = json.decode(response.body.toString());
          return responseJson;
        }

      /// Bad request need to check url
      case 400:
        throw BadRequestException(
            ErrorModel.fromJson(json.decode(response.body.toString())).message);

      /// Bad request need to check url
      case 401:
        throw BadRequestException(
            ErrorModel.fromJson(json.decode(response.body.toString())).message);

      /// Authorisation token invalid
      case 403:
        throw UnauthorisedException(
            ErrorModel.fromJson(json.decode(response.body.toString())).message);

      /// Authorisation token invalid
      case 417:
        throw UnauthorisedException(
            ErrorModel.fromJson(json.decode(response.body.toString())).message);

      /// Error occured while Communication with Server
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode: ${response.statusCode}');
    }
  }
}
