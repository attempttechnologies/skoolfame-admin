part of 'live_bloc.dart';

abstract class LiveEvent {}

class LiveUserEvent extends LiveEvent {
  final Map<String, dynamic> params;
  LiveUserEvent(this.params);
}

class GetLiveUserEvent extends LiveEvent {
  GetLiveUserEvent();
}

class SendLiveMessageEvent extends LiveEvent {
  final Map<String, dynamic> params;
  SendLiveMessageEvent(this.params);
}

class ReceiveLiveMessageEvent extends LiveEvent {
  ReceiveLiveMessageEvent();
}

class GetLiveMessageEvent extends LiveEvent {
  final Map<String, dynamic> params;

  GetLiveMessageEvent(this.params);
}

class AddLiveUserEvent extends LiveEvent {
  final Map<String, dynamic> params;
  AddLiveUserEvent(this.params);
}

class EndLiveEvent extends LiveEvent {
  EndLiveEvent();
}
