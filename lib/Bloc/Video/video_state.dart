part of 'video_bloc.dart';

abstract class VideoState extends Equatable {
  const VideoState();
  @override
  List<Object> get props => [];
}

class VideoInitial extends VideoState {}

class VideoLoadingState extends VideoState {}

class VideoBlocFailure extends VideoState {
  final String errorMessage;
  const VideoBlocFailure(this.errorMessage);
}

class AddVideoAlbumSuccessState extends VideoState {
  final CommonSuccessResponse addVideoAlbumResponse;
  const AddVideoAlbumSuccessState(this.addVideoAlbumResponse);
}

class GetVideoAlbumSuccessState extends VideoState {
  final AlbumResponse getVideoAlbumResponse;
  const GetVideoAlbumSuccessState(this.getVideoAlbumResponse);
}

class DeleteVideoAlbumSuccessState extends VideoState {
  final CommonSuccessResponse deleteVideoAlbumResponse;
  const DeleteVideoAlbumSuccessState(this.deleteVideoAlbumResponse);
}

class EditVideoAlbumSuccessState extends VideoState {
  final CommonSuccessResponse editVideoAlbumResponse;
  const EditVideoAlbumSuccessState(this.editVideoAlbumResponse);
}

class AddVideoSuccessState extends VideoState {
  final CommonSuccessResponse addVideoResponse;
  const AddVideoSuccessState(this.addVideoResponse);
}

class GetVideoSuccessState extends VideoState {
  final AlbumImagesModel getVideoResponse;
  const GetVideoSuccessState(this.getVideoResponse);
}

class DeleteVideoSuccessState extends VideoState {
  final CommonSuccessResponse deleteVideoResponse;
  const DeleteVideoSuccessState(this.deleteVideoResponse);
}

class EditVideoSuccessState extends VideoState {
  final CommonSuccessResponse editVideoResponse;
  const EditVideoSuccessState(this.editVideoResponse);
}
