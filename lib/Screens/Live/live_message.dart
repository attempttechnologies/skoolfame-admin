import 'dart:typed_data';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:skoolfame/Bloc/Live/live_bloc.dart';
import 'package:skoolfame/Data/API/api_manager.dart';
import 'package:skoolfame/Data/Models/login_success_respo_model.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Utils/app_strings.dart';
import 'package:skoolfame/Utils/constants.dart';
import 'package:skoolfame/Widgets/custom_widget.dart';
import 'package:skoolfame/Widgets/my_button.dart';
import 'package:skoolfame/generated/assets.dart';

class LiveMessage extends StatefulWidget {
  const LiveMessage({Key? key}) : super(key: key);

  @override
  _LiveMessageState createState() => _LiveMessageState();
}

class _LiveMessageState extends State<LiveMessage> {
  var liveBloc = LiveBloc();
  final _users = <int>[];
  RtcEngine? _engine;
  bool muted = false;
  int? streamId;
  bool? isBroadcaster = false;
  String id = "";
  final messageController = TextEditingController();

  @override
  Future<void> didChangeDependencies() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.camera,
      Permission.microphone,
      //add more permission to request here.
    ].request();
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map;

    isBroadcaster = routeArgs["isBroadcaster"];

    id = routeArgs["id"];
    if (isBroadcaster!) {
      print("LIVE USER :: :: ::");
      initializeAgora(LoginSuccessResponse.fromJson(
              GetStorage().read(AppPreferenceString.pUserData))
          .data!
          .sId!);
      liveBloc.add(GetLiveMessageEvent({
        "id": LoginSuccessResponse.fromJson(
                GetStorage().read(AppPreferenceString.pUserData))
            .data!
            .sId!,
        "token": LoginSuccessResponse.fromJson(
                GetStorage().read(AppPreferenceString.pUserData))
            .token!,
      }));
      liveBloc.add(ReceiveLiveMessageEvent());
    } else {
      print("LIVE NOT USER :: :: ::");

      initializeAgora(id);
      liveBloc.add(GetLiveMessageEvent({
        "id": id,
        "token": LoginSuccessResponse.fromJson(
                GetStorage().read(AppPreferenceString.pUserData))
            .token!,
      }));
    }
    liveBloc.add(ReceiveLiveMessageEvent());

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _engine!.leaveChannel();

    _users.clear();
    _engine!.destroy();
    super.dispose();
  }

  Future<void> initializeAgora(String param) async {
    await _initAgoraRtcEngine();

    if (isBroadcaster!) {
      streamId = await _engine?.createDataStream(false, false);
    }

    _engine!.setEventHandler(RtcEngineEventHandler(
      joinChannelSuccess: (channel, uid, elapsed) {
        setState(() {
          print('onJoinChannel: $channel, uid: $uid');
        });
      },
      leaveChannel: (stats) {
        setState(() {
          print('onLeaveChannel');
          _users.clear();
        });
      },
      userJoined: (uid, elapsed) {
        setState(() {
          print('userJoined: $uid');

          _users.add(uid);
        });
      },
      userOffline: (uid, elapsed) {
        setState(() {
          print('userOffline: $uid');
          _users.remove(uid);
        });
      },
      streamMessage: (_, __, message) {
        final String info = "here is the message $message";
        print(info);
      },
      streamMessageError: (_, __, error, ___, ____) {
        final String info = "here is the error $error";
        print(info);
      },
    ));

    await _engine!.joinChannel("null", param, null, 0);
  }

  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.createWithConfig(
        RtcEngineConfig(AppStrings.agoraApiKey));
    await _engine!.enableVideo();

    await _engine!.setChannelProfile(ChannelProfile.LiveBroadcasting);
    if (isBroadcaster!) {
      await _engine!.setClientRole(ClientRole.Broadcaster);
    } else {
      await _engine!.setClientRole(ClientRole.Audience);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LiveBloc, LiveState>(
        bloc: liveBloc,
        listener: (context, state) {
          if (state is SendLiveMessageSuccessState ||
              state is ReceiveLiveMessageSuccessState) {
            if (isBroadcaster!) {
              initializeAgora(LoginSuccessResponse.fromJson(
                      GetStorage().read(AppPreferenceString.pUserData))
                  .data!
                  .sId!);
              liveBloc.add(GetLiveMessageEvent({
                "id": LoginSuccessResponse.fromJson(
                        GetStorage().read(AppPreferenceString.pUserData))
                    .data!
                    .sId!,
                "token": LoginSuccessResponse.fromJson(
                        GetStorage().read(AppPreferenceString.pUserData))
                    .token!,
              }));
              liveBloc.add(ReceiveLiveMessageEvent());
            } else {
              initializeAgora(id);
              liveBloc.add(GetLiveMessageEvent({
                "id": id,
                "token": LoginSuccessResponse.fromJson(
                        GetStorage().read(AppPreferenceString.pUserData))
                    .token!,
              }));
              liveBloc.add(ReceiveLiveMessageEvent());
            }
          }
        },
        child: BlocBuilder<LiveBloc, LiveState>(
          bloc: liveBloc,
          builder: (context, state) {
            print("State-------> ${state}");
            if (state is GetLiveMessageSuccessState) {
              return Stack(
                children: [
                  _broadcastView(),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, top: 35.0, right: 8.0, bottom: 15.0),
                    child: CustomScrollView(
                      slivers: [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 3.h,
                                    width: 16.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                      gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            AppColors.topYellowColor,
                                            AppColors.btnTabOrangeColor,
                                            AppColors.bottomOrangeColor
                                          ]),
                                    ),
                                    child: Center(
                                        child: CustomWidgets.text(
                                            AppStrings.live.toUpperCase(),
                                            color: AppColors.textWhiteColor)),
                                  ),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  CustomWidgets().customIcon(
                                      icon: Assets.iconsEye, size: 2.5),
                                  SizedBox(
                                    width: 1.w,
                                  ),
                                  CustomWidgets.text("2.5k",
                                      color: AppColors.textWhiteColor),
                                  Spacer(),
                                  MyButton(
                                    onPressed: () {
                                      if (isBroadcaster!) {
                                        liveBloc.add(
                                            LiveUserEvent({"isLive": false}));
                                        // _users.clear();
                                        // _engine?.destroy();
                                        Navigator.pop(context);
                                      } else {
                                        liveBloc.add(AddLiveUserEvent({
                                          "live_id": id,
                                          "isStart": false,
                                        }));
                                        Navigator.pop(context);
                                      }
                                    },
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 4),
                                    color: AppColors.textWhiteColor,
                                    borderRadius: 5,
                                    label: "End",
                                    textStyle: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.colorPrimary),
                                  )
                                ],
                              ),
                              Spacer(),
                              ShaderMask(
                                shaderCallback: (bounds) {
                                  return const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.center,
                                    colors: [Colors.transparent, Colors.black],
                                  ).createShader(bounds);
                                },
                                blendMode: BlendMode.dstIn,
                                child: Container(
                                    height: 70.h,
                                    child: ListView.separated(
                                      reverse: true,
                                      itemCount: state.getLiveMessageResponse
                                          .liveMessageData!.senderUser!.length,
                                      itemBuilder: (context, index) {
                                        var liveMessageData = state
                                            .getLiveMessageResponse
                                            .liveMessageData!
                                            .senderUser![index];
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.textBlackColor
                                                .withOpacity(0.5),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(7.0)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Row(
                                              // crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                CircleAvatar(
                                                  radius: 25,
                                                  backgroundColor:
                                                      AppColors.colorPrimary,
                                                  backgroundImage: NetworkImage(
                                                      APIManager.baseUrl +
                                                          liveMessageData.user!
                                                              .userProfileImage!),
                                                ),
                                                SizedBox(
                                                  width: 2.8.w,
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    CustomWidgets.text(
                                                        liveMessageData.user!
                                                                .firstName! +
                                                            " " +
                                                            liveMessageData
                                                                .user!
                                                                .lastName!,
                                                        color: AppColors
                                                            .textWhiteColor,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    SizedBox(
                                                      height: 0.5.h,
                                                    ),
                                                    CustomWidgets.text(
                                                      liveMessageData.message!,
                                                      color: AppColors
                                                          .textWhiteColor,
                                                      textAlign:
                                                          TextAlign.start,
                                                      fontSize: 11,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return SizedBox(
                                          height: 1.h,
                                        );
                                      },
                                    )),
                              ),
                              SizedBox(height: 15.0),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.black.withOpacity(0.2),
                                ),
                                child: TextFormField(
                                  controller: messageController,
                                  style: TextStyle(
                                      color: AppColors.textWhiteColor),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                        color: AppColors.textWhiteColor,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                        color: AppColors.textWhiteColor,
                                        // width: \0.0,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.all(8),
                                    isDense: true,
                                    hintStyle: const TextStyle(
                                        color: AppColors.textWhiteColor,
                                        fontSize: 15),
                                    hintText: "Type a message..",
                                    prefixIconConstraints: BoxConstraints(
                                        maxHeight: 50, maxWidth: 50),
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () {},
                                        child: CustomWidgets().customIcon(
                                            icon: Assets.iconsTextfieldSmily,
                                            size: 3),
                                      ),
                                    ),
                                    suffixIconConstraints: BoxConstraints(
                                        maxHeight: 40, maxWidth: 100),
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          !isBroadcaster!
                                              ? Container()
                                              : InkWell(
                                                  onTap: () {
                                                    _onSwitchCamera();
                                                  },
                                                  child: CustomWidgets()
                                                      .customIcon(
                                                          icon: Assets
                                                              .iconsCamera,
                                                          size: 2.5,
                                                          color: AppColors
                                                              .textWhiteColor),
                                                ),
                                          SizedBox(
                                            width: 2.w,
                                          ),
                                          InkWell(
                                              onTap: () {
                                                if (messageController
                                                    .text.isNotEmpty) {
                                                  if (isBroadcaster!) {
                                                    liveBloc.add(
                                                        SendLiveMessageEvent({
                                                      "id": LoginSuccessResponse.fromJson(
                                                              GetStorage().read(
                                                                  AppPreferenceString
                                                                      .pUserData))
                                                          .data!
                                                          .sId!,
                                                      "message":
                                                          messageController
                                                              .text,
                                                      'token': LoginSuccessResponse.fromJson(
                                                              GetStorage().read(
                                                                  AppPreferenceString
                                                                      .pUserData))
                                                          .token!
                                                    }));
                                                    messageController.clear();
                                                  } else {
                                                    liveBloc.add(
                                                        SendLiveMessageEvent({
                                                      "id": id,
                                                      "message":
                                                          messageController
                                                              .text,
                                                      'token': LoginSuccessResponse.fromJson(
                                                              GetStorage().read(
                                                                  AppPreferenceString
                                                                      .pUserData))
                                                          .token!
                                                    }));
                                                    messageController.clear();
                                                  }
                                                }
                                              },
                                              child: Icon(
                                                Icons.send,
                                                color: AppColors.textWhiteColor,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            }

            return Stack(
              children: [
                _broadcastView(),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, top: 35.0, right: 8.0, bottom: 15.0),
                  child: CustomScrollView(
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 3.h,
                                  width: 16.w,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          AppColors.topYellowColor,
                                          AppColors.btnTabOrangeColor,
                                          AppColors.bottomOrangeColor
                                        ]),
                                  ),
                                  child: Center(
                                      child: CustomWidgets.text(
                                          AppStrings.live.toUpperCase(),
                                          color: AppColors.textWhiteColor)),
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                CustomWidgets().customIcon(
                                    icon: Assets.iconsEye, size: 2.5),
                                SizedBox(
                                  width: 1.w,
                                ),
                                CustomWidgets.text("2.5k",
                                    color: AppColors.textWhiteColor),
                                Spacer(),
                                MyButton(
                                  onPressed: () {
                                    if (isBroadcaster!) {
                                      liveBloc.add(
                                          LiveUserEvent({"isLive": false}));

                                      Navigator.pop(context);
                                    } else {
                                      liveBloc.add(AddLiveUserEvent({
                                        "live_id": id,
                                        "isStart": false,
                                      }));
                                      Navigator.pop(context);
                                    }
                                  },
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 4),
                                  color: AppColors.textWhiteColor,
                                  borderRadius: 5,
                                  label: "End",
                                  textStyle: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.colorPrimary),
                                )
                              ],
                            ),
                            Spacer(),
                            SizedBox(height: 15.0),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.black.withOpacity(0.2),
                              ),
                              child: TextFormField(
                                controller: messageController,
                                style:
                                    TextStyle(color: AppColors.textWhiteColor),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: AppColors.textWhiteColor,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: AppColors.textWhiteColor,
                                      // width: \0.0,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.all(8),
                                  isDense: true,
                                  hintStyle: const TextStyle(
                                      color: AppColors.textWhiteColor,
                                      fontSize: 15),
                                  hintText: "Type a message..",
                                  prefixIconConstraints: BoxConstraints(
                                      maxHeight: 50, maxWidth: 50),
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {},
                                      child: CustomWidgets().customIcon(
                                          icon: Assets.iconsTextfieldSmily,
                                          size: 3),
                                    ),
                                  ),
                                  suffixIconConstraints: BoxConstraints(
                                      maxHeight: 40, maxWidth: 100),
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        !isBroadcaster!
                                            ? Container()
                                            : InkWell(
                                                onTap: () {
                                                  _onSwitchCamera();
                                                },
                                                child: CustomWidgets()
                                                    .customIcon(
                                                        icon:
                                                            Assets.iconsCamera,
                                                        size: 2.5,
                                                        color: AppColors
                                                            .textWhiteColor),
                                              ),
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        InkWell(
                                            onTap: () {
                                              if (messageController
                                                  .text.isNotEmpty) {
                                                if (isBroadcaster!) {
                                                  liveBloc.add(
                                                      SendLiveMessageEvent({
                                                    "id": LoginSuccessResponse.fromJson(
                                                            GetStorage().read(
                                                                AppPreferenceString
                                                                    .pUserData))
                                                        .data!
                                                        .sId!,
                                                    "message":
                                                        messageController.text,
                                                    'token': LoginSuccessResponse
                                                            .fromJson(GetStorage().read(
                                                                AppPreferenceString
                                                                    .pUserData))
                                                        .token!
                                                  }));
                                                  messageController.clear();
                                                } else {
                                                  liveBloc.add(
                                                      SendLiveMessageEvent({
                                                    "id": id,
                                                    "message":
                                                        messageController.text,
                                                    'token': LoginSuccessResponse
                                                            .fromJson(GetStorage().read(
                                                                AppPreferenceString
                                                                    .pUserData))
                                                        .token!
                                                  }));
                                                  messageController.clear();
                                                }
                                              }
                                            },
                                            child: Icon(
                                              Icons.send,
                                              color: AppColors.textWhiteColor,
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
  // Widget _toolbar() {
  //   return widget.isBroadcaster
  //       ? Container(
  //     alignment: Alignment.bottomCenter,
  //     padding: const EdgeInsets.symmetric(vertical: 48),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: <Widget>[
  //         RawMaterialButton(
  //           onPressed: _onToggleMute,
  //           child: Icon(
  //             muted ? Icons.mic_off : Icons.mic,
  //             color: muted ? Colors.white : Colors.blueAccent,
  //             size: 20.0,
  //           ),
  //           shape: CircleBorder(),
  //           elevation: 2.0,
  //           fillColor: muted ? Colors.blueAccent : Colors.white,
  //           padding: const EdgeInsets.all(12.0),
  //         ),
  //         RawMaterialButton(
  //           onPressed: () => _onCallEnd(context),
  //           child: Icon(
  //             Icons.call_end,
  //             color: Colors.white,
  //             size: 35.0,
  //           ),
  //           shape: CircleBorder(),
  //           elevation: 2.0,
  //           fillColor: Colors.redAccent,
  //           padding: const EdgeInsets.all(15.0),
  //         ),
  //         RawMaterialButton(
  //           onPressed: _onSwitchCamera,
  //           child: Icon(
  //             Icons.switch_camera,
  //             color: Colors.blueAccent,
  //             size: 20.0,
  //           ),
  //           shape: CircleBorder(),
  //           elevation: 2.0,
  //           fillColor: Colors.white,
  //           padding: const EdgeInsets.all(12.0),
  //         ),
  //       ],
  //     ),
  //   )
  //       : Container();
  // }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    if (isBroadcaster!) {
      list.add(RtcLocalView.SurfaceView());
    }
    _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(
          uid: uid,
          channelId: '',
        )));
    return list;
  }

  /// Video view row wrapper
  Widget _expandedVideoView(List<Widget> views) {
    final wrappedViews = views
        .map<Widget>((view) => Expanded(child: Container(child: view)))
        .toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _broadcastView() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoView([views[0]])
          ],
        ));
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoView([views[0]]),
            _expandedVideoView([views[1]])
          ],
        ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoView(views.sublist(0, 2)),
            _expandedVideoView(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoView(views.sublist(0, 2)),
            _expandedVideoView(views.sublist(2, 4))
          ],
        ));
      default:
    }
    return Container();
  }

  void _onSwitchCamera() {
    if (streamId != null)
      _engine?.sendStreamMessage(
        streamId!,
        Uint8List(8),
      );
    _engine!.switchCamera();
  }
}
