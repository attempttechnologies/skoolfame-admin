import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:skoolfame/Data/API/api_manager.dart';
import 'package:skoolfame/Data/API/dio_api_manager.dart';
import 'package:skoolfame/Data/Models/album_images_model.dart';
import 'package:skoolfame/Data/Models/album_model.dart';
import 'package:skoolfame/Data/Models/comman_success_model.dart';

part 'video_event.dart';
part 'video_state.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  final APIManager apiManager = APIManager();
  final DioApiManager dioApiManager = DioApiManager();

  VideoBloc() : super(VideoInitial()) {
    on<AddVideoAlbumApiEvent>((event, emit) async {
      var addVideoAlbumResponse = await _addVideoAlbumApiCall(event.params);
      emit(AddVideoAlbumSuccessState(addVideoAlbumResponse));
    });

    on<GetVideoAlbumApiEvent>((event, emit) async {
      emit(VideoLoadingState());
      var albumResponse = await _getVideoAlbumApiCall();
      emit(GetVideoAlbumSuccessState(albumResponse));
    });

    on<DeleteVideoAlbumApiEvent>((event, emit) async {
      emit(VideoLoadingState());

      var deleteVideoAlbumResponse =
          await _deleteVideoAlbumApiCall(event.params);
      emit(DeleteVideoAlbumSuccessState(deleteVideoAlbumResponse));
    });
    on<EditVideoAlbumApiEvent>((event, emit) async {
      emit(VideoLoadingState());

      var editVideoAlbumResponse =
          await _editVideoAlbumApiCall(event.params, event.sId);
      emit(EditVideoAlbumSuccessState(editVideoAlbumResponse));
    });

    on<AddVideoApiEvent>((event, emit) async {
      var addVideoResponse = await _addVideoApiCall(event.params);
      emit(AddVideoSuccessState(addVideoResponse));
    });

    on<GetVideoApiEvent>((event, emit) async {
      emit(VideoLoadingState());
      var videoResponse = await _getVideoApiCall(event.sId);
      emit(GetVideoSuccessState(videoResponse));
    });

    on<DeleteVideoApiEvent>((event, emit) async {
      emit(VideoLoadingState());

      var deleteVideoResponse = await _deleteVideoApiCall(event.params);
      emit(DeleteVideoSuccessState(deleteVideoResponse));
    });
    on<EditVideoApiEvent>((event, emit) async {
      emit(VideoLoadingState());

      var editVideoResponse = await _editVideoApiCall(event.params, event.sId);
      emit(EditVideoSuccessState(editVideoResponse));
    });
  }
  Future<CommonSuccessResponse> _addVideoAlbumApiCall(
      Map<String, dynamic> param) async {
    var res = await dioApiManager.dioPostAPICall('users/video-album', param);
    return CommonSuccessResponse.fromJson(res);
  }

  Future<AlbumResponse> _getVideoAlbumApiCall() async {
    var res = await apiManager.getAPICall('users/get-video-album');
    return AlbumResponse.fromJson(res);
  }

  Future<CommonSuccessResponse> _deleteVideoAlbumApiCall(
      Map<String, dynamic> param) async {
    var res = await apiManager.deleteAPICall('users/delete-video-album', param);
    return CommonSuccessResponse.fromJson(res);
  }

  Future<CommonSuccessResponse> _editVideoAlbumApiCall(
      Map<String, dynamic> param, String sId) async {
    var res = await dioApiManager.dioPatchAPICall(
        'users/update-video-album?id=$sId', param);
    return CommonSuccessResponse.fromJson(res);
  }

  Future<CommonSuccessResponse> _addVideoApiCall(
      Map<String, dynamic> param) async {
    var res = await dioApiManager.dioPostAPICall('users/upload-video', param);
    return CommonSuccessResponse.fromJson(res);
  }

  Future<AlbumImagesModel> _getVideoApiCall(String sId) async {
    var res = await apiManager.getAPICall('users/get-video?album_id=$sId');
    return AlbumImagesModel.fromJson(res);
  }

  Future<CommonSuccessResponse> _deleteVideoApiCall(
      Map<String, dynamic> param) async {
    var res = await apiManager.deleteAPICall('users/delete-video', param);
    return CommonSuccessResponse.fromJson(res);
  }

  Future<CommonSuccessResponse> _editVideoApiCall(
      Map<String, dynamic> param, String sId) async {
    var res = await dioApiManager.dioPatchAPICall(
        'users/update-video?id=$sId', param);
    return CommonSuccessResponse.fromJson(res);
  }
}
