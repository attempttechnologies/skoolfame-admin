part of 'video_bloc.dart';

abstract class VideoEvent {}

class AddVideoAlbumApiEvent extends VideoEvent {
  final Map<String, dynamic> params;

  AddVideoAlbumApiEvent(this.params);
}

class GetVideoAlbumApiEvent extends VideoEvent {
  GetVideoAlbumApiEvent();
}

class DeleteVideoAlbumApiEvent extends VideoEvent {
  final Map<String, dynamic> params;

  DeleteVideoAlbumApiEvent(this.params);
}

class EditVideoAlbumApiEvent extends VideoEvent {
  final Map<String, dynamic> params;
  final String sId;

  EditVideoAlbumApiEvent(this.params, this.sId);
}

class AddVideoApiEvent extends VideoEvent {
  final Map<String, dynamic> params;

  AddVideoApiEvent(this.params);
}

class GetVideoApiEvent extends VideoEvent {
  final String sId;

  GetVideoApiEvent(this.sId);
}

class DeleteVideoApiEvent extends VideoEvent {
  final Map<String, dynamic> params;

  DeleteVideoApiEvent(this.params);
}

class EditVideoApiEvent extends VideoEvent {
  final Map<String, dynamic> params;
  final String sId;

  EditVideoApiEvent(this.params, this.sId);
}
