part of 'message_bloc.dart';

abstract class MessageEvent {}

class SendMessageEvent extends MessageEvent {
  final Map<String, dynamic> params;
  SendMessageEvent(this.params);
}

class GetMessageEvent extends MessageEvent {
  final Map<String, dynamic> params;

  GetMessageEvent(this.params);
}

class GetMessageListEvent extends MessageEvent {
  final Map<String, dynamic> params;

  GetMessageListEvent(this.params);
}

class ReceiveMessageEvent extends MessageEvent {
  ReceiveMessageEvent();
}

class CreateGroupEvent extends MessageEvent {
  final Map<String, dynamic> params;

  CreateGroupEvent(this.params);
}

class SendGroupMessageEvent extends MessageEvent {
  final Map<String, dynamic> params;
  SendGroupMessageEvent(this.params);
}

class ReceiveGroupMessageEvent extends MessageEvent {
  ReceiveGroupMessageEvent();
}

class GetGroupMessageEvent extends MessageEvent {
  final Map<String, dynamic> params;

  GetGroupMessageEvent(this.params);
}

class SendPhotosEvent extends MessageEvent {
  final Map<String, dynamic> params;

  SendPhotosEvent(this.params);
}

class SearchMessageEvent extends MessageEvent {
  SearchMessageEvent();
}
