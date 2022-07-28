import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sizer/sizer.dart';
import 'package:skoolfame/Bloc/Message/message_bloc.dart';
import 'package:skoolfame/Data/API/api_manager.dart';
import 'package:skoolfame/Routes/routes.dart';
import 'package:skoolfame/Screens/Friends/friends_screen.dart';
import 'package:skoolfame/Screens/Messages/chat_screen.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Utils/app_strings.dart';
import 'package:skoolfame/Utils/constants.dart';
import 'package:skoolfame/Widgets/custom_widget.dart';
import 'package:skoolfame/Widgets/wrapper.dart';
import 'package:skoolfame/generated/assets.dart';

import '../../Data/Models/login_success_respo_model.dart';
import '../../Utils/custom_date_formatter.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  var messageBloc = MessageBloc();
  bool isSearch = false;
  List<UserData>? templist = [];
  List<UserData>? searchlist = [];
  var searchController = TextEditingController();
  @override
  void initState() {
    // messageBloc.add(InitializeSocketEvent());
    messageBloc.add(GetMessageListEvent({
      "token": LoginSuccessResponse.fromJson(
              GetStorage().read(AppPreferenceString.pUserData))
          .token!
    }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorPrimaryLight,
      floatingActionButton: GestureDetector(
          onTap: () async {
            print("HEy");
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => FriendsScreen(isFromMessage: true),
                ));

            // await pushNewScreenWithRouteSettings(
            //   context,
            //   screen: FriendsScreen(isFromMessage: true),
            //   settings: const RouteSettings(
            //     name: Routes.FRIENDS_SCREEN,
            //   ),
            //   withNavBar: false,
            //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
            // ).then((value) => print("HEy"));
          },
          child: CustomWidgets().customIcon(icon: Assets.iconsAdd, size: 9)),
      body: SubWrapper(
        child: BlocListener<MessageBloc, MessageState>(
          bloc: messageBloc,
          listener: (context, state) {
            if (state is SearchMessageSuccessState) {
              print("ok");
            }
          },
          child: BlocBuilder<MessageBloc, MessageState>(
            bloc: messageBloc,
            builder: (context, state) {
              print("State------->${state}");
              if (state is GetMessageListSuccessState) {
                return Column(
                  children: [
                    isSearch
                        ? Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: TextFormField(
                              controller: searchController,
                              // autofocus: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                prefixIcon: Image.asset(
                                  Assets.iconsSearch,
                                  height: 10.0,
                                  width: 10.0,
                                  scale: 10,
                                  color: AppColors.textGreyColor,
                                ),
                                contentPadding: EdgeInsets.all(8),
                                hintStyle: const TextStyle(
                                    color: AppColors.textGreyColor,
                                    fontSize: 15),
                                hintText: "Search Friends",
                              ),
                              onChanged: (v) {
                                if (v.isEmpty) {
                                  setState(() {});
                                } else {}
                              },
                              style: TextStyle(fontSize: 15),
                            ),
                          )
                        : Container(),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: ListView.separated(
                          itemCount:
                              state.messageListResponse.messageListdata!.length,
                          padding: EdgeInsets.only(bottom: 20.0),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                await pushNewScreenWithRouteSettings(
                                  context,
                                  screen: ChatScreen(
                                      isGroup: state
                                                  .messageListResponse
                                                  .messageListdata![index]
                                                  .sId !=
                                              null
                                          ? true
                                          : false,
                                      groupName: state.messageListResponse
                                          .messageListdata![index].groupName),
                                  settings: RouteSettings(
                                    name: Routes.CHAT_SCREEN,
                                    arguments: state.messageListResponse
                                                .messageListdata![index].sId !=
                                            null
                                        ? state.messageListResponse
                                            .messageListdata![index].sId
                                        : state.messageListResponse
                                            .messageListdata![index].userData,
                                  ),
                                  withNavBar: false,
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.cupertino,
                                );
                                messageBloc.add(GetMessageListEvent({
                                  "token": LoginSuccessResponse.fromJson(
                                          GetStorage().read(
                                              AppPreferenceString.pUserData))
                                      .token!
                                }));
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColors.textGreyColor,
                                      width: 0,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(14.0)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        state
                                                    .messageListResponse
                                                    .messageListdata![index]
                                                    .userData !=
                                                null
                                            ? CircleAvatar(
                                                radius: 22,
                                                backgroundColor:
                                                    AppColors.colorPrimary,
                                                backgroundImage: NetworkImage(
                                                    APIManager.baseUrl +
                                                        state
                                                            .messageListResponse
                                                            .messageListdata![
                                                                index]
                                                            .userData!
                                                            .userProfileImage!),
                                              )
                                            : state
                                                        .messageListResponse
                                                        .messageListdata![index]
                                                        .groupImage !=
                                                    null
                                                ? CircleAvatar(
                                                    radius: 22,
                                                    backgroundColor:
                                                        AppColors.colorPrimary,
                                                    backgroundImage:
                                                        NetworkImage(APIManager
                                                                .baseUrl +
                                                            state
                                                                .messageListResponse
                                                                .messageListdata![
                                                                    index]
                                                                .groupImage!),
                                                  )
                                                : CircleAvatar(
                                                    radius: 22,
                                                    backgroundColor:
                                                        AppColors.colorPrimary,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Image.asset(
                                                        Assets.imagesUser,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                        SizedBox(
                                          width: 2.8.w,
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CustomWidgets.text(
                                                  state
                                                              .messageListResponse
                                                              .messageListdata![
                                                                  index]
                                                              .groupName !=
                                                          null
                                                      ? state
                                                          .messageListResponse
                                                          .messageListdata![
                                                              index]
                                                          .groupName!
                                                      : state
                                                              .messageListResponse
                                                              .messageListdata![
                                                                  index]
                                                              .userData!
                                                              .firstName! +
                                                          " " +
                                                          state
                                                              .messageListResponse
                                                              .messageListdata![
                                                                  index]
                                                              .userData!
                                                              .lastName!,
                                                  color:
                                                      AppColors.textBlackColor,
                                                  fontSize: 13,
                                                  maxLine: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontWeight: FontWeight.bold),
                                              SizedBox(
                                                height: 1.h,
                                              ),
                                              CustomWidgets.text(
                                                state
                                                            .messageListResponse
                                                            .messageListdata![
                                                                index]
                                                            .groupName !=
                                                        null
                                                    ? state
                                                        .messageListResponse
                                                        .messageListdata![index]
                                                        .groupName!
                                                    : state
                                                        .messageListResponse
                                                        .messageListdata![index]
                                                        .lastmessage!
                                                        .message!,
                                                color:
                                                    AppColors.textGreyTabColor,
                                                textAlign: TextAlign.start,
                                                fontSize: 11.5,
                                              ),
                                              state
                                                          .messageListResponse
                                                          .messageListdata![
                                                              index]
                                                          .lastmessage ==
                                                      null
                                                  ? Container()
                                                  : Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        CustomWidgets()
                                                            .customIcon(
                                                                icon: Assets
                                                                    .iconsTime,
                                                                size: 1.5),
                                                        SizedBox(
                                                          width: 1.w,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 2),
                                                          child: CustomWidgets
                                                              .text(
                                                            DateFormatter()
                                                                .getVerboseDateTimeRepresentation(
                                                              DateTime.parse(state
                                                                  .messageListResponse
                                                                  .messageListdata![
                                                                      index]
                                                                  .lastmessage!
                                                                  .createdAt!),
                                                            ),
                                                            color: AppColors
                                                                .textTagGreyColor,
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
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              height: 1.h,
                            );
                          },
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
      ),
    );
  }
}
