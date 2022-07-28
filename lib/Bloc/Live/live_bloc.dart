import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:skoolfame/Bloc/Home/home_bloc.dart';
import 'package:skoolfame/Data/API/api_manager.dart';
import 'package:skoolfame/Data/Models/comman_success_model.dart';
import 'package:skoolfame/Data/Models/get_friends_success_model.dart';
import 'package:skoolfame/Data/Models/live_message_model.dart';

part 'live_event.dart';
part 'live_state.dart';

class LiveBloc extends Bloc<LiveEvent, LiveState> {
  final APIManager apiManager = APIManager();
  List<LiveMessageData> addLiveMessage = <LiveMessageData>[];

  final _users = <int>[];
  RtcEngine? _engine;
  bool muted = false;
  int? streamId;

  LiveBloc() : super(LiveInitial()) {
    on<LiveUserEvent>((event, emit) async {
      var liveUserResponse = await _liveUserApiCall(event.params);
      emit(LiveUserSuccessState(liveUserResponse));
    });
    on<GetLiveUserEvent>((event, emit) async {
      emit(LiveInitial());

      var getLiveUserResponse = await _getLiveUserApiCall();
      emit(GetLiveUserSuccessState(getLiveUserResponse));
    });

    on<SendLiveMessageEvent>((event, emit) async {
      emit(LiveInitial());
      sendLiveMessage(event.params);
      emit(const SendLiveMessageSuccessState());
    });
    on<ReceiveLiveMessageEvent>((event, emit) async {
      emit(LiveInitial());

      await receiveLiveMessage();
    });
    on<GetLiveMessageEvent>((event, emit) async {
      emit(LiveInitial());

      await getLiveMessage(event.params);
    });
    on<AddLiveUserEvent>((event, emit) async {
      var addLiveUserResponse = await addLiveUserApiCall(event.params);
      emit(AddLiveUserSuccessState(addLiveUserResponse));
    });
    on<EndLiveEvent>((event, emit) async {
      emit(LiveInitial());

      await endLive();
      emit(EndLiveSuccessState());
    });
  }

  Future<CommonSuccessResponse> _liveUserApiCall(
      Map<String, dynamic> params) async {
    var res = await apiManager.patchAPICall('users/update-live-user', params);
    print("RESPONSE:::: ${res}");
    return CommonSuccessResponse.fromJson(res);
  }

  Future<GetFriendsSuccessModel> _getLiveUserApiCall() async {
    var res = await apiManager.getAPICall('users/get-live-user');
    print(res);
    return GetFriendsSuccessModel.fromJson(res);
  }

  Future<void> sendLiveMessage(Map<String, dynamic> params) async {
    socket!.emit("live-chat", [params]);
    receiveLiveMessage();
  }

  receiveLiveMessage() {
    print("In Receive Live message");

    socket!.on("receive-live-chat", (data) {
      print("receive-post :: $data");

      addLiveMessage.add(LiveMessageData.fromJson(data));

      emit(ReceiveLiveMessageSuccessState(addLiveMessage));
    });
  }

  getLiveMessage(Map<String, dynamic> params) {
    socket!.emit("get-live-chat", [params]);
    socket!.on(
      "receive-get-live-chat",
      (data) async {
        print('receive-get-live-chat :: $data');

        emit(GetLiveMessageSuccessState(LiveMessageModel.fromJson(data)));
      },
    );
  }

  Future<CommonSuccessResponse> addLiveUserApiCall(
      Map<String, dynamic> params) async {
    print("PARAMS ::::: ${params}");
    var res = await apiManager.patchAPICall('users/add-live-user', params);
    return CommonSuccessResponse.fromJson(res);
  }

  endLive() {
    socket!.on("end-live", (data) {
      print("END_LIVE:: ::");
    });
  }
}
