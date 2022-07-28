import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_storage/get_storage.dart';
import 'package:skoolfame/Data/API/api_manager.dart';
import 'package:skoolfame/Data/Models/GetMessageModel.dart';
import 'package:skoolfame/Data/Models/comman_success_model.dart';
import 'package:skoolfame/Data/Models/comment_response_model.dart';
import 'package:skoolfame/Data/Models/login_success_respo_model.dart';
import 'package:skoolfame/Utils/constants.dart';
import 'package:socket_io_client/socket_io_client.dart';

part 'home_event.dart';
part 'home_state.dart';

Socket? socket;

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  List<MessageData> addpost = <MessageData>[];
  final APIManager apiManager = APIManager();

  HomeBloc() : super(HomeInitial()) {
    on<InitializeHomeSocketEvent>((event, emit) async {
      emit(HomeInitial());
      _initializeSocket();
      emit(const InitializeSocketSuccessState());
    });

    on<SendPostEvent>((event, emit) async {
      emit(HomeInitial());
      sendPost(event.params);
      emit(const SendPostSuccessState());
    });
    on<ReceivePostEvent>((event, emit) async {
      await receivePost();
    });
    on<GetPostEvent>((event, emit) async {
      emit(HomeInitial());

      await getPost(event.params);
    });
    on<DeletePostApiEvent>((event, emit) async {
      emit(HomeInitial());

      var withdrawNomineeSuccessState = await _deletePostApiCall(event.params);
      emit(DeletePostSuccessState(withdrawNomineeSuccessState));
    });
    on<LikePostApiEvent>((event, emit) async {
      var likePostSuccessState = await _likePostApiCall(event.params);
      emit(LikePostSuccessState(likePostSuccessState));
    });
    on<AddCommentApiEvent>((event, emit) async {
      var addCommentSuccessState = await _addCommentApiCall(event.params);
      emit(AddCommentSuccessState(addCommentSuccessState));
    });
    on<GetCommentApiEvent>((event, emit) async {
      var getCommentSuccessState = await _getCommentApiCall(event.params);
      emit(GetCommentSuccessState(getCommentSuccessState));
    });
    on<DeleteCommentApiEvent>((event, emit) async {
      var deleteCommentSuccessState = await _deleteCommentApiCall(event.params);
      emit(DeleteCommentSuccessState(deleteCommentSuccessState));
    });
  }
  void _initializeSocket() {
    socket = io(
      APIManager.baseUrl,
      OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .disableReconnection()
          .build(),
    );

    socket!.on("connect", (data) {
      print("CONNECTED ${socket!.id}");

      socket!.emit("home", [
        {
          "token": LoginSuccessResponse.fromJson(
                  GetStorage().read(AppPreferenceString.pUserData))
              .token!,
        }
      ]);
    });
    socket!.onConnectError((data) {
      print('error -> $data');
    });
    socket!.on('disconnect', (reason) async {
      print("DISCONNECTED");
      try {} catch (ex, stacktrace) {
        print(stacktrace);
      }
    });

    socket!.onError((error) {
      try {
        if (error == "invalid_token") {
          print("Invalid Token");
          // _initializeSocket();
        }
      } catch (ex, stacktrace) {
        print(stacktrace);
      }
    });

    socket!.connect();
  }

  Future<void> sendPost(Map<String, dynamic> params) async {
    socket!.emit("send-post", [params]);
    receivePost();
  }

  receivePost() {
    socket!.on("receive-post", (data) {
      print("receive-post :: $data");

      addpost.add(MessageData.fromJson(data));

      emit(ReceivePostSuccessState(addpost));
    });
  }

  getPost(Map<String, dynamic> params) {
    print("SOKET ::: $socket");
    socket!.emit("get-post", [params]);
    socket!.on(
      "receive-get-post",
      (data) async {
        print('receive-get-post :: $data');

        emit(GetPostSuccessState(GetMessageModel.fromJson(data)));
      },
    );
  }

  Future<CommonSuccessResponse> _deletePostApiCall(
      Map<String, dynamic> params) async {
    var res = await apiManager.deleteAPICall('users/delete-post', params);
    return CommonSuccessResponse.fromJson(res);
  }

  Future<CommonSuccessResponse> _likePostApiCall(
      Map<String, dynamic> params) async {
    var res = await apiManager.patchAPICall('users/add-like', params);
    return CommonSuccessResponse.fromJson(res);
  }

  Future<CommonSuccessResponse> _addCommentApiCall(
      Map<String, dynamic> params) async {
    var res = await apiManager.postAPICall('users/add-comment', params);
    print("RESPONSE :: ::: ${res}");
    return CommonSuccessResponse.fromJson(res);
  }

  Future<CommentResponseModel> _getCommentApiCall(String params) async {
    var res = await apiManager.getAPICall(
      'users/get-comment?id=$params',
    );
    return CommentResponseModel.fromJson(res);
  }

  Future<CommonSuccessResponse> _deleteCommentApiCall(
      Map<String, dynamic> params) async {
    var res = await apiManager.deleteAPICall('users/delete-comment', params);
    return CommonSuccessResponse.fromJson(res);
  }
}
