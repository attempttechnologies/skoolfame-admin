import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:skoolfame/Bloc/Home/home_bloc.dart';
import 'package:skoolfame/Data/Models/GetMessageModel.dart';
import 'package:skoolfame/Data/Models/MessageListModel.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  List<MessageData> addSendMessage = <MessageData>[];

  MessageBloc() : super(MessageInitial()) {
    on<SendMessageEvent>((event, emit) async {
      emit(MessageInitial());
      sendMessage(event.params);
      emit(const SendMessageSuccessState());
    });
    on<GetMessageEvent>((event, emit) async {
      await getMessage(event.params);
    });
    on<GetMessageListEvent>((event, emit) async {
      await getMessageList(event.params);
    });
    on<ReceiveMessageEvent>((event, emit) async {
      await receiveMessage();
    });
    on<CreateGroupEvent>((event, emit) async {
      await createGroup(event.params);
    });
    on<GetGroupMessageEvent>((event, emit) async {
      await getGroupMessage(event.params);
    });

    on<SendGroupMessageEvent>((event, emit) async {
      emit(MessageInitial());
      sendGroupMessage(event.params);
      emit(const SendGroupMessageSuccessState());
    });
    on<ReceiveGroupMessageEvent>((event, emit) async {
      await receiveGroupMessage();
    });
    on<SendPhotosEvent>((event, emit) async {
      emit(MessageInitial());
      sendPhotos(event.params);
      emit(const SendPhotosSuccessState());
    });
    on<SearchMessageEvent>((event, emit) async {
      emit(MessageInitial());

      searchMessage();
    });
  }

  Future<void> sendMessage(Map<String, dynamic> params) async {
    socket!.emit("message", [params]);
  }

  receiveMessage() {
    socket!.on("receive-message", (data) {
      print("receive-message :: $data");

      addSendMessage.add(MessageData.fromJson(data));

      emit(ReceiveMessageSuccessState(addSendMessage));
    });
  }

  getMessage(Map<String, dynamic> params) async {
    socket!.emit("user-chat", [params]);
    socket!.on(
      "receive-chat",
      (data) async {
        print('receive-chat :: $data');

        emit(GetMessageSuccessState(GetMessageModel.fromJson(data)));
      },
    );
  }

  getMessageList(Map<String, dynamic> params) {
    socket!.emit("user-list", [params]);
    socket!.on(
      "receive-user-list",
      (data) async {
        print('USER - LIST :: $data');
        emit(GetMessageListSuccessState(MessageList.fromJson(data)));
      },
    );
  }

  createGroup(Map<String, dynamic> params) {
    // _initializeSocket();
    socket!.emit("create-group", params);
    socket!.on("receive-create-group", (data) async => print(data));
  }

  getGroupMessage(Map<String, dynamic> params) async {
    socket!.emit("group-message-list", [params]);
    socket!.on(
      "receive-group-message-list",
      (data) async {
        print('receive-group-message-list:: $data');
        emit(GetGroupMessageSuccessState(GetMessageModel.fromJson(data)));
      },
    );
  }

  sendGroupMessage(Map<String, dynamic> params) {
    socket!.emit("group-message", params);
    receiveGroupMessage();
  }

  receiveGroupMessage() {
    socket!.on(
      "receive-group-message",
      (data) async {
        print('receive-group-message :: $data');
        addSendMessage.add(MessageData.fromJson(data));
        emit(ReceiveGroupMessageSuccessState(addSendMessage));
      },
    );
  }

  sendPhotos(Map<String, dynamic> params) {
    // _initializeSocket();
    print(params);
    socket!.emit("get-document", params);
    receiveMessage();
  }

  searchMessage() {
    emit(SearchMessageSuccessState());
  }
}
