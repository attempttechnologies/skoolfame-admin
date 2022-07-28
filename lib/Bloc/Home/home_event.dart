part of 'home_bloc.dart';

abstract class HomeEvent {}

class InitializeHomeSocketEvent extends HomeEvent {
  InitializeHomeSocketEvent();
}

class SendPostEvent extends HomeEvent {
  final Map<String, dynamic> params;
  SendPostEvent(this.params);
}

class ReceivePostEvent extends HomeEvent {
  ReceivePostEvent();
}

class GetPostEvent extends HomeEvent {
  final Map<String, dynamic> params;

  GetPostEvent(this.params);
}

class DeletePostApiEvent extends HomeEvent {
  final Map<String, dynamic> params;
  DeletePostApiEvent(this.params);
}

class LikePostApiEvent extends HomeEvent {
  final Map<String, dynamic> params;
  LikePostApiEvent(this.params);
}

class AddCommentApiEvent extends HomeEvent {
  final Map<String, dynamic> params;
  AddCommentApiEvent(this.params);
}

class GetCommentApiEvent extends HomeEvent {
  final String params;

  GetCommentApiEvent(this.params);
}

class DeleteCommentApiEvent extends HomeEvent {
  final Map<String, dynamic> params;
  DeleteCommentApiEvent(this.params);
}
