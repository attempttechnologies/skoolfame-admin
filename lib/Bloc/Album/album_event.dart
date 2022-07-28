part of 'album_bloc.dart';

abstract class AlbumEvent {}

class AddAlbumApiEvent extends AlbumEvent {
  final Map<String, dynamic> params;

  AddAlbumApiEvent(this.params);
}

class GetAlbumApiEvent extends AlbumEvent {
  GetAlbumApiEvent();
}

class DeleteAlbumApiEvent extends AlbumEvent {
  final Map<String, dynamic> params;

  DeleteAlbumApiEvent(this.params);
}

class EditAlbumApiEvent extends AlbumEvent {
  final Map<String, dynamic> params;
  final String sId;

  EditAlbumApiEvent(this.params, this.sId);
}

class AddImagesApiEvent extends AlbumEvent {
  final Map<String, dynamic> params;

  AddImagesApiEvent(this.params);
}

class GetImagesApiEvent extends AlbumEvent {
  final String sId;

  GetImagesApiEvent(this.sId);
}

class EditImagesApiEvent extends AlbumEvent {
  final Map<String, dynamic> params;
  final String sId;

  EditImagesApiEvent(this.params, this.sId);
}

class DeleteImagesApiEvent extends AlbumEvent {
  final Map<String, dynamic> params;

  DeleteImagesApiEvent(this.params);
}
