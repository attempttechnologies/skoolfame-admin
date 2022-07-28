part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeBlocFailure extends HomeState {
  final String errorMessage;
  const HomeBlocFailure(this.errorMessage);
}

class InitializeSocketSuccessState extends HomeState {
  const InitializeSocketSuccessState();
}

class SendPostSuccessState extends HomeState {
  const SendPostSuccessState();
}

class ReceivePostSuccessState extends HomeState {
  final List<MessageData> postResponse;

  const ReceivePostSuccessState(this.postResponse);
}

class GetPostSuccessState extends HomeState {
  final GetMessageModel getPostResponse;

  const GetPostSuccessState(this.getPostResponse);
}

class DeletePostSuccessState extends HomeState {
  final CommonSuccessResponse deletePostResponse;
  const DeletePostSuccessState(this.deletePostResponse);
}

class LikePostSuccessState extends HomeState {
  final CommonSuccessResponse likePostResponse;
  const LikePostSuccessState(this.likePostResponse);
}

class AddCommentSuccessState extends HomeState {
  final CommonSuccessResponse addCommentResponse;
  const AddCommentSuccessState(this.addCommentResponse);
}

class GetCommentSuccessState extends HomeState {
  final CommentResponseModel getCommentResponse;
  const GetCommentSuccessState(this.getCommentResponse);
}

class DeleteCommentSuccessState extends HomeState {
  final CommonSuccessResponse deleteCommentResponse;
  const DeleteCommentSuccessState(this.deleteCommentResponse);
}
