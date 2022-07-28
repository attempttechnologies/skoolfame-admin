import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as d;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:skoolfame/Data/API/api_manager.dart';
import 'package:skoolfame/Data/API/custom_exception.dart';
import 'package:skoolfame/Data/Models/error_model.dart';
import 'package:skoolfame/Data/Models/login_success_respo_model.dart';
import 'package:skoolfame/Utils/constants.dart';
import 'package:skoolfame/Widgets/custom_widget.dart';

class DioApiManager {
  Future<dynamic> dioPostAPICall(String url, Map<String, dynamic> param) async {
    var responseJson;

    try {
      CustomWidgets().showProgressIndicator();
      var data = d.FormData.fromMap(param);
      var headers = {
        "Authorization": "Bearer " +
            LoginSuccessResponse.fromJson(
                    GetStorage().read(AppPreferenceString.pUserData))
                .token!
      };

      d.Dio dio = d.Dio();

      d.Response response = await dio.post(
        APIManager.baseUrl + url,
        data: data,
        options: d.Options(headers: headers),
      );

      responseJson = _response(response);
    } on SocketException {
      Get.showSnackbar(CustomWidgets()
          .errorSnackBar(title: 'Error!', message: 'No internet connection'));
      throw FetchDataException('No internet connection');
    } on TimeoutException catch (_) {
      throw FetchDataException('Server Error');
    } on d.DioError catch (e) {
      Get.showSnackbar(CustomWidgets()
          .errorSnackBar(title: 'Error!', message: 'No internet connection'));
      throw FetchDataException('No internet connection');
    } finally {
      /// Hide progress loader
      EasyLoading.dismiss();
    }
    return responseJson;
  }

  Future<dynamic> dioPatchAPICall(
      String url, Map<String, dynamic> param) async {
    var responseJson;

    try {
      CustomWidgets().showProgressIndicator();

      var data = d.FormData.fromMap(param);
      var headers = {
        "Authorization": "Bearer " +
            LoginSuccessResponse.fromJson(
                    GetStorage().read(AppPreferenceString.pUserData))
                .token!
      };

      d.Dio dio = d.Dio();
      print(APIManager.baseUrl + url);
      print(data);
      print(param);
      print(headers);

      d.Response response = await dio.patch(
        APIManager.baseUrl + url,
        data: data,
        options: d.Options(headers: headers),
      );
      print(response);
      responseJson = _response(response);
    } on SocketException {
      Get.showSnackbar(CustomWidgets()
          .errorSnackBar(title: 'Error!', message: 'No internet connection'));
      throw FetchDataException('No internet connection');
    } on TimeoutException catch (_) {
      throw FetchDataException('Server Error');
    } on d.DioError catch (e) {
      print(e.response);
      Get.showSnackbar(CustomWidgets()
          .errorSnackBar(title: 'Error!', message: 'No internet connection'));
      throw FetchDataException('No internet connection');
    } finally {
      /// Hide progress loader
      EasyLoading.dismiss();
    }
    return responseJson;
  }

  /// Check response status and handle exception
  static _response(d.Response response) {
    print(response.data);
    switch (response.statusCode) {

      /// Successfully get api response
      case 200:
        if (response.data['status'] == 0) {
          throw BadRequestException(ErrorModel.fromJson(response.data).message);
        } else {
          var responseJson = response.data;
          return responseJson;
        }

      /// Successfully get api response
      case 201:
        if (response.data['status'] == 0) {
          throw BadRequestException(ErrorModel.fromJson(response.data).message);
        } else {
          var responseJson = response.data;
          return responseJson;
        }

      /// Bad request need to check url
      case 400:
        throw BadRequestException(
            ErrorModel.fromJson(json.decode(response.data.toString())).message);

      /// Bad request need to check url
      case 401:
        throw BadRequestException(
            ErrorModel.fromJson(json.decode(response.data.toString())).message);

      /// Authorisation token invalid
      case 403:
        throw UnauthorisedException(
            ErrorModel.fromJson(json.decode(response.data.toString())).message);

      /// Authorisation token invalid
      case 417:
        throw UnauthorisedException(
            ErrorModel.fromJson(json.decode(response.data.toString())).message);

      /// Error occured while Communication with Server
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode: ${response.statusCode}');
    }
  }
}
