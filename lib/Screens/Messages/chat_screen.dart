import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:skoolfame/Bloc/Message/message_bloc.dart';
import 'package:skoolfame/Data/API/api_manager.dart';
import 'package:skoolfame/Data/Models/GetMessageModel.dart';
import 'package:skoolfame/Data/Models/login_success_respo_model.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Utils/app_strings.dart';
import 'package:skoolfame/Utils/constants.dart';
import 'package:skoolfame/Utils/custom_date_formatter.dart';
import 'package:skoolfame/Widgets/custom_widget.dart';
import 'package:skoolfame/Widgets/wrapper.dart';
import 'package:skoolfame/generated/assets.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({
    Key? key,
    this.isGroup,
    this.groupName,
  }) : super(key: key);
  bool? isGroup;
  String? groupName;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  var messageBloc = MessageBloc();
  final ImagePicker _picker = ImagePicker();
  File? profileImage;

  var groupId = "";
  UserData userData = UserData();

  @override
  void didChangeDependencies() {
    if (ModalRoute.of(context)!.settings.arguments! is String) {
      groupId = ModalRoute.of(context)!.settings.arguments! as String;
    } else {
      userData = ModalRoute.of(context)!.settings.arguments! as UserData;
    }

    if (ModalRoute.of(context)!.settings.arguments! is String) {
      ///
      ///  Group Chat
      ///
      messageBloc.add(GetGroupMessageEvent({
        "group_id": groupId,
        "token": LoginSuccessResponse.fromJson(
                GetStorage().read(AppPreferenceString.pUserData))
            .token!,
      }));
      messageBloc.add(ReceiveGroupMessageEvent());
    } else {
      ///
      ///  One to one Chat
      ///
      messageBloc.add(GetMessageEvent({
        "user_id": userData.sId,
        "token": LoginSuccessResponse.fromJson(
                GetStorage().read(AppPreferenceString.pUserData))
            .token!,
      }));
      messageBloc.add(ReceiveMessageEvent());
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Wrapper(
        isResizeToAvoidBottomInset: true,
        isBackIcon: true,
        centerTitle: true,
        title: !widget.isGroup!
            ? userData.firstName! + " " + userData.lastName!
            : widget.groupName!,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
          child: BlocListener<MessageBloc, MessageState>(
            bloc: messageBloc,
            listener: (context, state) {
              print("State-- ${state}");

              ///
              /// One  to one chat
              ///
              if (state is SendMessageSuccessState ||
                  state is ReceiveMessageSuccessState ||
                  state is SendPhotosSuccessState) {
                print("Hey");
                messageBloc.add(GetMessageEvent({
                  "user_id": userData.sId,
                  "token": LoginSuccessResponse.fromJson(
                          GetStorage().read(AppPreferenceString.pUserData))
                      .token!,
                }));
              }

              ///
              /// Group chat
              ///
              if (state is SendGroupMessageSuccessState ||
                  state is ReceiveGroupMessageSuccessState ||
                  state is SendPhotosSuccessState) {
                messageBloc.add(GetGroupMessageEvent({
                  "group_id": groupId,
                  "token": LoginSuccessResponse.fromJson(
                          GetStorage().read(AppPreferenceString.pUserData))
                      .token!,
                }));
              }
            },
            child: BlocBuilder<MessageBloc, MessageState>(
              bloc: messageBloc,
              builder: (context, state) {
                print("State--> ${state}");

                if (state is GetMessageSuccessState) {
                  return Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      state.messageResponse.messageData!.isEmpty
                          ? Center(
                              child: CustomWidgets.text(AppStrings.nothingFound,
                                  color: AppColors.textGreyColor,
                                  fontWeight: FontWeight.w600))
                          : Padding(
                              padding: const EdgeInsets.only(bottom: 70),
                              child: ListView.builder(
                                  reverse: true,
                                  shrinkWrap: true,
                                  itemCount:
                                      state.messageResponse.messageData!.length,
                                  itemBuilder: (context, index) {
                                    return state
                                                .messageResponse
                                                .messageData![index]
                                                .receiverUser!
                                                .sId ==
                                            LoginSuccessResponse.fromJson(
                                                    GetStorage().read(
                                                        AppPreferenceString
                                                            .pUserData))
                                                .data!
                                                .sId!
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                                left: 4, right: 24.w),
                                            child: Column(
                                              children: [
                                                MessageChatListTile(
                                                    messageData: state
                                                        .messageResponse
                                                        .messageData![index],
                                                    isFromReceiver: true),
                                              ],
                                            ),
                                          )
                                        : Padding(
                                            padding: EdgeInsets.only(
                                                left: 24.w, right: 4),
                                            child: MessageChatListTile(
                                              messageData: state.messageResponse
                                                  .messageData![index],
                                            ),
                                          );
                                  }),
                            ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: TextFormField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: AppColors.textGreyColor, width: 0.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: AppColors.textGreyColor, width: 0.0),
                            ),
                            contentPadding: EdgeInsets.all(8),
                            isDense: true,
                            hintStyle: const TextStyle(
                                color: AppColors.textGreyColor, fontSize: 15),
                            hintText: "Type a message..",
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                  onTap: () async {
                                    final XFile? image = await _picker
                                        .pickImage(source: ImageSource.gallery);
                                    profileImage = File(image!.path);

                                    messageBloc.add(SendPhotosEvent({
                                      "user_id": userData.sId,
                                      "token": LoginSuccessResponse.fromJson(
                                              GetStorage().read(
                                                  AppPreferenceString
                                                      .pUserData))
                                          .token!,
                                      "image": base64Encode(
                                          File(profileImage!.path)
                                              .readAsBytesSync())
                                    }));
                                    setState(() {});
                                  },
                                  child: CustomWidgets().customIcon(
                                      icon: Assets.iconsIconsGallery,
                                      size: 2,
                                      color: AppColors.textBlackColor)),
                            ),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(12),
                              child: InkWell(
                                onTap: () {
                                  if (_messageController.text.isNotEmpty) {
                                    messageBloc.add(SendMessageEvent({
                                      "message": _messageController.text,
                                      "user_id": userData.sId,
                                      "token": LoginSuccessResponse.fromJson(
                                              GetStorage().read(
                                                  AppPreferenceString
                                                      .pUserData))
                                          .token!,
                                    }));

                                    _messageController.clear();
                                  }
                                },
                                child: CustomWidgets().customIcon(
                                    icon: Assets.iconsSendMessage, size: 2.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                if (state is GetGroupMessageSuccessState) {
                  return Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 70),
                        child: ListView.builder(
                            reverse: true,
                            shrinkWrap: true,
                            itemCount:
                                state.messageResponse.messageData!.length,
                            itemBuilder: (context, index) {
                              return state.messageResponse.messageData![index]
                                          .senderUser!.sId !=
                                      LoginSuccessResponse.fromJson(GetStorage()
                                              .read(AppPreferenceString
                                                  .pUserData))
                                          .data!
                                          .sId!
                                  ? Padding(
                                      padding:
                                          EdgeInsets.only(left: 4, right: 24.w),
                                      child: MessageChatListTile(
                                          messageData: state.messageResponse
                                              .messageData![index],
                                          isFromReceiver: true),
                                    )
                                  : Padding(
                                      padding:
                                          EdgeInsets.only(left: 24.w, right: 4),
                                      child: MessageChatListTile(
                                        messageData: state.messageResponse
                                            .messageData![index],
                                      ),
                                    );
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: TextFormField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: AppColors.textGreyColor, width: 0.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: AppColors.textGreyColor, width: 0.0),
                            ),
                            contentPadding: EdgeInsets.all(8),
                            isDense: true,
                            hintStyle: const TextStyle(
                                color: AppColors.textGreyColor, fontSize: 15),
                            hintText: "Type a message..",
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () async {
                                  final XFile? image = await _picker.pickImage(
                                      source: ImageSource.gallery);
                                  profileImage = File(image!.path);

                                  messageBloc.add(SendPhotosEvent({
                                    "group_id": groupId,
                                    "isGroup": true,
                                    "token": LoginSuccessResponse.fromJson(
                                            GetStorage().read(
                                                AppPreferenceString.pUserData))
                                        .token!,
                                    "image": base64Encode(
                                        File(profileImage!.path)
                                            .readAsBytesSync())
                                  }));
                                  setState(() {});
                                },
                                child: CustomWidgets().customIcon(
                                    icon: Assets.iconsIconsGallery,
                                    size: 2,
                                    color: AppColors.textBlackColor),
                              ),
                            ),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(12),
                              child: InkWell(
                                onTap: () {
                                  if (_messageController.text.isNotEmpty) {
                                    messageBloc.add(SendGroupMessageEvent({
                                      "message": _messageController.text,
                                      "group_id": groupId,
                                      "token": LoginSuccessResponse.fromJson(
                                              GetStorage().read(
                                                  AppPreferenceString
                                                      .pUserData))
                                          .token!,
                                    }));

                                    _messageController.clear();
                                  }
                                },
                                child: CustomWidgets().customIcon(
                                    icon: Assets.iconsSendMessage, size: 2.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return Center(
                    child: CustomWidgets.text(AppStrings.nothingFound,
                        color: AppColors.textGreyColor,
                        fontWeight: FontWeight.w600));
              },
            ),
          ),
        ));
  }
}

class MessageChatListTile extends StatefulWidget {
  MessageChatListTile(
      {Key? key, required this.messageData, this.isFromReceiver})
      : super(key: key);
  MessageData messageData = MessageData();
  bool? isFromReceiver = false;

  @override
  State<MessageChatListTile> createState() => _MessageChatListTileState();
}

class _MessageChatListTileState extends State<MessageChatListTile> {
  @override
  Widget build(BuildContext context) {
    print("Type:" + widget.messageData.messageType!);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.textGreyColor,
            width: 0,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(14.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: widget.messageData.messageType == "image"
              ? Image.network(APIManager.baseUrl + widget.messageData.message!)
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.messageData.senderUser!.userProfileImage == ""
                        ? CircleAvatar(
                            radius: 22,
                            backgroundColor: AppColors.colorPrimary,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                Assets.imagesUser,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : CircleAvatar(
                            radius: 22,
                            backgroundColor: AppColors.colorPrimary,
                            backgroundImage: widget.isFromReceiver == false
                                ? NetworkImage(APIManager.baseUrl +
                                    widget.messageData.receiverUser!
                                        .userProfileImage!)
                                : NetworkImage(APIManager.baseUrl +
                                    widget.messageData.senderUser!
                                        .userProfileImage!),
                          ),
                    SizedBox(
                      width: 2.8.w,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomWidgets.text(
                              widget.isFromReceiver == false
                                  ? widget.messageData.receiverUser!
                                          .firstName! +
                                      " " +
                                      widget.messageData.receiverUser!.lastName!
                                  : widget.messageData.senderUser!.firstName! +
                                      " " +
                                      widget.messageData.senderUser!.lastName!,
                              color: AppColors.textBlackColor,
                              fontSize: 13,
                              maxLine: 1,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold),
                          SizedBox(
                            height: 0.3.h,
                          ),
                          CustomWidgets.text(
                            widget.messageData.message!,
                            color: AppColors.textGreyTabColor,
                            textAlign: TextAlign.start,
                            fontSize: 11.5,
                          ),
                          SizedBox(
                            height: 0.8.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CustomWidgets().customIcon(
                                  icon: Assets.iconsTime, size: 1.5),
                              SizedBox(
                                width: 1.w,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: CustomWidgets.text(
                                  DateFormatter()
                                      .getVerboseDateTimeRepresentation(
                                    DateTime.parse(
                                        widget.messageData.createdAt!),
                                  ),
                                  color: AppColors.textTagGreyColor,
                                  fontSize: 8.8,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
