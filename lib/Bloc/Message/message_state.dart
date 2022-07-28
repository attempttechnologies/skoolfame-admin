part of 'message_bloc.dart';

abstract class MessageState extends Equatable {
  const MessageState();
  @override
  List<Object> get props => [];
}

class MessageInitial extends MessageState {}

class MessageLoadingState extends MessageState {}

class MessageBlocFailure extends MessageState {
  final String errorMessage;
  const MessageBlocFailure(this.errorMessage);
}

class InitializeSocketSuccessState extends MessageState {
  const InitializeSocketSuccessState();
}

class ReconnectSocketSuccessState extends MessageState {
  const ReconnectSocketSuccessState();
}

class DisposeSocketSuccessState extends MessageState {
  const DisposeSocketSuccessState();
}

class SendMessageSuccessState extends MessageState {
  const SendMessageSuccessState();
}

class GetMessageSuccessState extends MessageState {
  final GetMessageModel messageResponse;

  const GetMessageSuccessState(this.messageResponse);
}

class GetMessageListSuccessState extends MessageState {
  final MessageList messageListResponse;

  const GetMessageListSuccessState(this.messageListResponse);
}

class ReceiveMessageSuccessState extends MessageState {
  final List<MessageData> messageListResponse;

  const ReceiveMessageSuccessState(this.messageListResponse);
}

class CreateGroupSuccessState extends MessageState {
  const CreateGroupSuccessState();
}

class SendGroupMessageSuccessState extends MessageState {
  const SendGroupMessageSuccessState();
}

class ReceiveGroupMessageSuccessState extends MessageState {
  final List<MessageData> messageListResponse;

  const ReceiveGroupMessageSuccessState(this.messageListResponse);
}

class GetGroupMessageSuccessState extends MessageState {
  final GetMessageModel messageResponse;

  const GetGroupMessageSuccessState(this.messageResponse);
}

class SendPhotosSuccessState extends MessageState {
  const SendPhotosSuccessState();
}

class SearchMessageSuccessState extends MessageState {
  const SearchMessageSuccessState();
}
