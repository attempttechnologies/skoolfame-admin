import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:skoolfame/Data/API/api_manager.dart';
import 'package:skoolfame/Data/API/dio_api_manager.dart';
import 'package:skoolfame/Data/Models/album_images_model.dart';
import 'package:skoolfame/Data/Models/album_model.dart';
import 'package:skoolfame/Data/Models/comman_success_model.dart';

part 'album_event.dart';
part 'album_state.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final APIManager apiManager = APIManager();
  final DioApiManager dioApiManager = DioApiManager();

  AlbumBloc() : super(AlbumInitial()) {
    on<AddAlbumApiEvent>((event, emit) async {
      var addAlbumResponse = await _addAlbumApiCall(event.params);
      emit(AddAlbumSuccessState(addAlbumResponse));
    });
    on<GetAlbumApiEvent>((event, emit) async {
      emit(AlbumLoadingState());
      var albumResponse = await _getAlbumApiCall();
      emit(GetAlbumSuccessState(albumResponse));
    });
    on<DeleteAlbumApiEvent>((event, emit) async {
      emit(AlbumLoadingState());

      var deleteAlbumResponse = await _deleteAlbumApiCall(event.params);
      emit(DeleteAlbumSuccessState(deleteAlbumResponse));
    });
    on<EditAlbumApiEvent>((event, emit) async {
      emit(AlbumLoadingState());

      var editAlbumResponse = await _editAlbumApiCall(event.params, event.sId);
      emit(EditAlbumSuccessState(editAlbumResponse));
    });
    on<AddImagesApiEvent>((event, emit) async {
      var addImagesResponse = await _addImagesApiCall(event.params);
      emit(AddImagesSuccessState(addImagesResponse));
    });
    on<GetImagesApiEvent>((event, emit) async {
      emit(AlbumLoadingState());

      var getImagesResponse = await _getImagesApiCall(event.sId);
      emit(GetImagesSuccessState(getImagesResponse));
    });
    on<EditImagesApiEvent>((event, emit) async {
      emit(AlbumLoadingState());

      var editImagesResponse =
          await _editImagesApiCall(event.params, event.sId);
      emit(EditImagesSuccessState(editImagesResponse));
    });
    on<DeleteImagesApiEvent>((event, emit) async {
      emit(AlbumLoadingState());

      var deleteImagesResponse = await _deleteImagesApiCall(event.params);
      emit(DeleteImagesSuccessState(deleteImagesResponse));
    });
  }

  Future<CommonSuccessResponse> _addAlbumApiCall(
      Map<String, dynamic> param) async {
    var res = await dioApiManager.dioPostAPICall('users/image-album', param);
    return CommonSuccessResponse.fromJson(res);
  }

  Future<AlbumResponse> _getAlbumApiCall() async {
    var res = await apiManager.getAPICall('users/get-image-album');
    return AlbumResponse.fromJson(res);
  }

  Future<CommonSuccessResponse> _deleteAlbumApiCall(
      Map<String, dynamic> param) async {
    var res = await apiManager.deleteAPICall('users/delete-image-album', param);
    return CommonSuccessResponse.fromJson(res);
  }

  Future<CommonSuccessResponse> _editAlbumApiCall(
      Map<String, dynamic> param, String sId) async {
    var res = await dioApiManager.dioPatchAPICall(
        'users/update-image-album?id=$sId', param);
    return CommonSuccessResponse.fromJson(res);
  }

  Future<CommonSuccessResponse> _addImagesApiCall(
      Map<String, dynamic> param) async {
    var res = await dioApiManager.dioPostAPICall('users/upload-images', param);
    return CommonSuccessResponse.fromJson(res);
  }

  Future<AlbumImagesModel> _getImagesApiCall(String sId) async {
    var res = await apiManager.getAPICall('users/get-image?album_id=$sId');
    return AlbumImagesModel.fromJson(res);
  }

  Future<CommonSuccessResponse> _editImagesApiCall(
      Map<String, dynamic> param, String sId) async {
    print(sId);
    var res = await dioApiManager.dioPatchAPICall(
        'users/update-images?id=$sId', param);
    print("response $res");

    return CommonSuccessResponse.fromJson(res);
  }

  Future<CommonSuccessResponse> _deleteImagesApiCall(
      Map<String, dynamic> param) async {
    var res = await apiManager.deleteAPICall('users/delete-image', param);
    return CommonSuccessResponse.fromJson(res);
  }
}
