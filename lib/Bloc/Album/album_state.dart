part of 'album_bloc.dart';

abstract class AlbumState extends Equatable {
  const AlbumState();
  @override
  List<Object> get props => [];
}

class AlbumInitial extends AlbumState {}

class AlbumLoadingState extends AlbumState {}

class AlbumBlocFailure extends AlbumState {
  final String errorMessage;
  const AlbumBlocFailure(this.errorMessage);
}

class AddAlbumSuccessState extends AlbumState {
  final CommonSuccessResponse addAlbumResponse;
  const AddAlbumSuccessState(this.addAlbumResponse);
}

class GetAlbumSuccessState extends AlbumState {
  final AlbumResponse getAlbumResponse;
  const GetAlbumSuccessState(this.getAlbumResponse);
}

class DeleteAlbumSuccessState extends AlbumState {
  final CommonSuccessResponse deleteAlbumResponse;
  const DeleteAlbumSuccessState(this.deleteAlbumResponse);
}

class EditAlbumSuccessState extends AlbumState {
  final CommonSuccessResponse editAlbumResponse;
  const EditAlbumSuccessState(this.editAlbumResponse);
}

class AddImagesSuccessState extends AlbumState {
  final CommonSuccessResponse addImagesResponse;
  const AddImagesSuccessState(this.addImagesResponse);
}

class GetImagesSuccessState extends AlbumState {
  final AlbumImagesModel getImagesResponse;
  const GetImagesSuccessState(this.getImagesResponse);
}

class EditImagesSuccessState extends AlbumState {
  final CommonSuccessResponse editImagesResponse;
  const EditImagesSuccessState(this.editImagesResponse);
}

class DeleteImagesSuccessState extends AlbumState {
  final CommonSuccessResponse deleteAlbumResponse;
  const DeleteImagesSuccessState(this.deleteAlbumResponse);
}
