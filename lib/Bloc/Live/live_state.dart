part of 'live_bloc.dart';

abstract class LiveState extends Equatable {
  const LiveState();
  @override
  List<Object> get props => [];
}

class LiveInitial extends LiveState {}

class LiveLoadingState extends LiveState {}

class LiveBlocFailure extends LiveState {
  final String errorMessage;
  const LiveBlocFailure(this.errorMessage);
}

class LiveUserSuccessState extends LiveState {
  CommonSuccessResponse liveUserResponse;
  LiveUserSuccessState(this.liveUserResponse);
}

class GetLiveUserSuccessState extends LiveState {
  GetFriendsSuccessModel getLiveUserResponse;
  GetLiveUserSuccessState(this.getLiveUserResponse);
}

class SendLiveMessageSuccessState extends LiveState {
  const SendLiveMessageSuccessState();
}

class ReceiveLiveMessageSuccessState extends LiveState {
  final List<LiveMessageData> receiveLiveMessageResponse;

  const ReceiveLiveMessageSuccessState(this.receiveLiveMessageResponse);
}

class GetLiveMessageSuccessState extends LiveState {
  final LiveMessageModel getLiveMessageResponse;

  const GetLiveMessageSuccessState(this.getLiveMessageResponse);
}

class AddLiveUserSuccessState extends LiveState {
  CommonSuccessResponse addLiveUserResponse;
  AddLiveUserSuccessState(this.addLiveUserResponse);
}

class EndLiveSuccessState extends LiveState {
  const EndLiveSuccessState();
}
