import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sizer/sizer.dart';
import 'package:skoolfame/Bloc/Friends/friends_bloc.dart';
import 'package:skoolfame/Bloc/Message/message_bloc.dart';
import 'package:skoolfame/Data/API/api_manager.dart';
import 'package:skoolfame/Data/Models/login_success_respo_model.dart';
import 'package:skoolfame/Routes/routes.dart';
import 'package:skoolfame/Screens/Friends/friends_profile_screen.dart';
import 'package:skoolfame/Screens/Messages/chat_screen.dart';
import 'package:skoolfame/Screens/Messages/message_screen.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Utils/app_strings.dart';
import 'package:skoolfame/Utils/appbar_manager.dart';
import 'package:skoolfame/Utils/constants.dart';
import 'package:skoolfame/Widgets/custom_widget.dart';
import 'package:skoolfame/Widgets/my_button.dart';
import 'package:skoolfame/Widgets/my_text_field_widget.dart';
import 'package:skoolfame/Widgets/wrapper.dart';
import 'package:skoolfame/generated/assets.dart';
import 'package:skoolfame/main.dart';

class FriendsScreen extends StatefulWidget {
  FriendsScreen({Key? key, this.isFromMessage = false}) : super(key: key);
  bool? isFromMessage;
  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  var friendsBloc = FriendsBloc();
  var messageBloc = MessageBloc();
  bool isTapOnGroup = false;
  var groupNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var userIdList = [];
  final ImagePicker _picker = ImagePicker();
  File? profileImage;

  @override
  void initState() {
    friendsBloc.add(GetFriendsApiEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      backgroundColor: AppColors.colorPrimaryLight,
      floatingActionButton: widget.isFromMessage == false
          ? Container()
          : Padding(
              padding: const EdgeInsets.only(bottom: 18.0),
              child: BlocListener<MessageBloc, MessageState>(
                bloc: messageBloc,
                listener: (context, state) async {
                  if (state is CreateGroupEvent) {}
                },
                child: BlocBuilder<MessageBloc, MessageState>(
                  bloc: messageBloc,
                  builder: (context, state) {
                    return FloatingActionButton.extended(
                        onPressed: () {
                          setState(() {
                            if (!isTapOnGroup) {
                              isTapOnGroup = true;
                            } else {
                              if (userIdList.isEmpty) {
                                final SnackBar snackBar = SnackBar(
                                    content: Text("Please select group member"),
                                    backgroundColor: Colors.red,
                                    behavior: SnackBarBehavior.floating);
                                snackbarKey.currentState
                                    ?.showSnackBar(snackBar);
                              } else {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(
                                          builder: (context, setState) {
                                        return AlertDialog(
                                          backgroundColor:
                                              AppColors.colorPrimary,
                                          title: CustomWidgets.text(
                                              "Create group",
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                              textAlign: TextAlign.start),
                                          actions: [],
                                          content: Container(
                                            height: 35.h,
                                            width: 90.w,
                                            child: Form(
                                              key: _formKey,
                                              child: Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () async {
                                                      final XFile? image =
                                                          await _picker.pickImage(
                                                              source:
                                                                  ImageSource
                                                                      .gallery);

                                                      setState(() {
                                                        profileImage =
                                                            File(image!.path);
                                                      });
                                                    },
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                            width: 25.w,
                                                            height: 25.w,
                                                            // padding: EdgeInsets.all(18),
                                                            decoration:
                                                                BoxDecoration(
                                                                    color: AppColors
                                                                        .textWhiteColor,
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                          color: AppColors.textBlackColor.withOpacity(
                                                                              0.1),
                                                                          offset: const Offset(0,
                                                                              10),
                                                                          blurRadius:
                                                                              20,
                                                                          spreadRadius:
                                                                              5)
                                                                    ],
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: AppColors
                                                                          .textWhiteColor,
                                                                      width:
                                                                          2.0,
                                                                    )),
                                                            child:
                                                                profileImage !=
                                                                        null
                                                                    ? ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(100),
                                                                        child: Image
                                                                            .file(
                                                                          profileImage!,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      )
                                                                    : Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(18.0),
                                                                        child: Image
                                                                            .asset(
                                                                          Assets
                                                                              .imagesUser,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      )),
                                                        Positioned.fill(
                                                          child: Align(
                                                            alignment: Alignment
                                                                .bottomRight,
                                                            child: CustomWidgets()
                                                                .customIcon(
                                                                    icon: Assets
                                                                        .iconsCameraRound,
                                                                    size: 5),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  MyTextField(
                                                    controller:
                                                        groupNameController,
                                                    hint: "Group name",
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please enter group name';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                  Spacer(),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Center(
                                                        child: MyButton(
                                                          height: 5.h,
                                                          width: 30.w,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal: 2,
                                                                  vertical: 2),
                                                          label: 'Cancel',
                                                          labelTextColor:
                                                              AppColors
                                                                  .textWhiteColor,
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          borderColor: AppColors
                                                              .colorPrimaryLight,
                                                          textStyle: TextStyle(
                                                              fontSize: 15,
                                                              color: AppColors
                                                                  .textWhiteColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          color: AppColors
                                                              .colorPrimaryLight,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Center(
                                                        child: MyButton(
                                                          height: 5.h,
                                                          width: 30.w,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal: 2,
                                                                  vertical: 2),
                                                          label: 'Create group',
                                                          labelTextColor:
                                                              AppColors
                                                                  .colorPrimary,
                                                          onPressed: () async {
                                                            if (_formKey
                                                                .currentState!
                                                                .validate()) {
                                                              messageBloc.add(
                                                                  CreateGroupEvent({
                                                                "token": LoginSuccessResponse.fromJson(
                                                                        GetStorage()
                                                                            .read(AppPreferenceString.pUserData))
                                                                    .token!,
                                                                "image": profileImage !=
                                                                        null
                                                                    ? base64Encode(
                                                                        File(profileImage!.path)
                                                                            .readAsBytesSync())
                                                                    : "",
                                                                "group_name":
                                                                    groupNameController
                                                                        .text,
                                                                "group_member":
                                                                    userIdList
                                                              }));
                                                              var count = 0;
                                                              Navigator
                                                                  .popUntil(
                                                                      context,
                                                                      (route) {
                                                                return count++ ==
                                                                    2;
                                                              });
                                                            }

                                                            // pushNewScreenWithRouteSettings(
                                                            //   context,
                                                            //   screen:
                                                            //       MessageScreen(),
                                                            //   settings:
                                                            //       const RouteSettings(
                                                            //     name: Routes
                                                            //         .MESSAGE_SCREEN,
                                                            //   ),
                                                            //   withNavBar: true,
                                                            //   pageTransitionAnimation:
                                                            //       PageTransitionAnimation
                                                            //           .cupertino,
                                                            // );
                                                          },
                                                          textStyle: TextStyle(
                                                              fontSize: 15,
                                                              color: AppColors
                                                                  .colorPrimary,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          color: AppColors
                                                              .textWhiteColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                    });
                              }
                            }
                          });
                        },
                        label: isTapOnGroup
                            ? CustomWidgets.text('Group Name',
                                color: AppColors.textWhiteColor,
                                fontWeight: FontWeight.bold)
                            : CustomWidgets.text('Create Group',
                                color: AppColors.textWhiteColor,
                                fontWeight: FontWeight.bold),
                        icon: isTapOnGroup
                            ? const Icon(
                                Icons.task_alt,
                                color: AppColors.textWhiteColor,
                              )
                            : const Icon(
                                Icons.add,
                                color: AppColors.textWhiteColor,
                              )
                        // backgroundColor: Colors.pink,
                        );
                  },
                ),
              ),
            ),
      body: SubWrapper(
        child: BlocListener<FriendsBloc, FriendsState>(
          bloc: friendsBloc,
          listener: (context, state) {
            if (state is GetFriendsSuccessState) {}
          },
          child: BlocBuilder<FriendsBloc, FriendsState>(
              bloc: friendsBloc,
              builder: (context, state) {
                print(state);
                if (state is GetFriendsSuccessState) {
                  return state.friendsResponse.data!.length == 0
                      ? Center(
                          child: CustomWidgets.text(AppStrings.nothingFound,
                              color: AppColors.textGreyColor,
                              fontWeight: FontWeight.w600))
                      : Padding(
                          padding: const EdgeInsets.only(top: 18.0),
                          child: RefreshIndicator(
                            onRefresh: _pullRefresh,
                            child: ListView.separated(
                              itemCount: state.friendsResponse.data!.length,
                              padding: const EdgeInsets.only(bottom: 20.0),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: widget.isFromMessage != true &&
                                          !isTapOnGroup
                                      ? () async {
                                          appBarManager
                                              .updateAppBarStatus(false);

                                          await pushNewScreenWithRouteSettings(
                                              context,
                                              screen: FriendsProfileScreen(
                                                  isFromFriends: true),
                                              settings: RouteSettings(
                                                name: Routes
                                                    .FRIENDS_PROFILE_SCREEN,
                                                arguments: state.friendsResponse
                                                    .data![index],
                                              ),
                                              withNavBar: true,
                                              pageTransitionAnimation:
                                                  PageTransitionAnimation
                                                      .cupertino);
                                          appBarManager
                                              .updateAppBarStatus(true);
                                        }
                                      : isTapOnGroup
                                          ? () {
                                              if (state
                                                      .friendsResponse
                                                      .data![index]
                                                      .isSelected !=
                                                  true) {
                                                state
                                                    .friendsResponse
                                                    .data![index]
                                                    .isSelected = true;
                                                if (state
                                                    .friendsResponse
                                                    .data![index]
                                                    .isSelected = true) {
                                                  userIdList.add(state
                                                      .friendsResponse
                                                      .data![index]
                                                      .sId);
                                                  print(userIdList);
                                                } else {
                                                  userIdList.removeWhere(
                                                      (element) =>
                                                          element ==
                                                          state
                                                              .friendsResponse
                                                              .data![index]
                                                              .sId);
                                                }
                                                print(userIdList);

                                                setState(() {});
                                              } else {
                                                state
                                                    .friendsResponse
                                                    .data![index]
                                                    .isSelected = false;

                                                setState(() {});
                                              }
                                            }
                                          : () async {
                                              var res =
                                                  await pushNewScreenWithRouteSettings(
                                                context,
                                                screen: ChatScreen(
                                                  isGroup: false,
                                                ),
                                                settings: RouteSettings(
                                                    name: Routes.CHAT_SCREEN,
                                                    arguments: state
                                                        .friendsResponse
                                                        .data![index]),
                                                withNavBar: false,
                                                pageTransitionAnimation:
                                                    PageTransitionAnimation
                                                        .cupertino,
                                              );
                                            },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18),
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
                                        padding: EdgeInsets.all(8.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            state.friendsResponse.data![index]
                                                            .userProfileImage! ==
                                                        null ||
                                                    state
                                                        .friendsResponse
                                                        .data![index]
                                                        .userProfileImage!
                                                        .isEmpty
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    child: Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
                                                          begin: Alignment
                                                              .topCenter,
                                                          end: Alignment
                                                              .bottomCenter,
                                                          colors: [
                                                            AppColors
                                                                .topYellowColor,
                                                            AppColors
                                                                .btnTabOrangeColor,
                                                            AppColors
                                                                .bottomOrangeColor,
                                                          ],
                                                        ),
                                                      ),
                                                      child: CircleAvatar(
                                                        radius: 22,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        // backgroundImage:
                                                        //     AssetImage(Assets.imagesUser,),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: Image.asset(
                                                            Assets.imagesUser,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : CircleAvatar(
                                                    radius: 22,
                                                    backgroundImage:
                                                        NetworkImage(APIManager
                                                                .baseUrl +
                                                            state
                                                                .friendsResponse
                                                                .data![index]
                                                                .userProfileImage!),
                                                  ),
                                            SizedBox(
                                              width: 2.8.w,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        width: 60.w,
                                                        child: CustomWidgets.text(
                                                            state
                                                                    .friendsResponse
                                                                    .data![
                                                                        index]
                                                                    .firstName! +
                                                                " " +
                                                                state
                                                                    .friendsResponse
                                                                    .data![
                                                                        index]
                                                                    .lastName!,
                                                            color: AppColors
                                                                .textBlackColor,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLine: 1,
                                                            fontSize: 13,
                                                            textAlign:
                                                                TextAlign.start,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      !state
                                                              .friendsResponse
                                                              .data![index]
                                                              .isSelected!
                                                          ? Container()
                                                          : Icon(
                                                              Icons.task_alt,
                                                              color: AppColors
                                                                  .colorPrimary,
                                                            ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 1.h,
                                                  ),
                                                  state
                                                              .friendsResponse
                                                              .data![index]
                                                              .about ==
                                                          null
                                                      ? Container()
                                                      : CustomWidgets.text(
                                                          state
                                                              .friendsResponse
                                                              .data![index]
                                                              .about!,
                                                          color: AppColors
                                                              .textGreyTabColor,
                                                          textAlign:
                                                              TextAlign.start,
                                                          fontSize: 11.5,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLine: 2),
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
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(
                                  height: 1.h,
                                );
                              },
                            ),
                          ),
                        );
                }
                return Center(
                    child: CustomWidgets.text(AppStrings.nothingFound,
                        color: AppColors.textGreyColor,
                        fontWeight: FontWeight.w600));
                // }
                // return Center(child: Text("No Data"));
              }),
        ),
      ),
    );
  }

  customGroupDialog(StateSetter setState, BuildContext context) async {
    return AlertDialog(
      backgroundColor: AppColors.colorPrimary,
      title: CustomWidgets.text("Create group",
          fontWeight: FontWeight.bold,
          fontSize: 17,
          textAlign: TextAlign.start),
      actions: [],
      content: Container(
        height: 30.h,
        width: 90.w,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    final XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);

                    setState(() {
                      profileImage = File(image!.path);
                    });
                  },
                  child: Stack(
                    children: [
                      Container(
                          width: 25.w,
                          height: 25.w,
                          // padding: EdgeInsets.all(18),
                          decoration: BoxDecoration(
                              color: AppColors.textWhiteColor,
                              boxShadow: [
                                BoxShadow(
                                    color: AppColors.textBlackColor
                                        .withOpacity(0.1),
                                    offset: const Offset(0, 10),
                                    blurRadius: 20,
                                    spreadRadius: 5)
                              ],
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.textWhiteColor,
                                width: 2.0,
                              )),
                          child: profileImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.file(
                                    profileImage!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Image.asset(
                                    Assets.imagesUser,
                                    fit: BoxFit.cover,
                                  ),
                                )),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: CustomWidgets().customIcon(
                              icon: Assets.iconsCameraRound, size: 5),
                        ),
                      ),
                    ],
                  ),
                ),
                MyTextField(
                  controller: groupNameController,
                  hint: "Group name",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter group name';
                    }
                    return null;
                  },
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Center(
                      child: MyButton(
                        height: 5.h,
                        width: 30.w,
                        padding:
                            EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                        label: 'Cancel',
                        labelTextColor: AppColors.textWhiteColor,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        borderColor: AppColors.colorPrimaryLight,
                        textStyle: TextStyle(
                            fontSize: 15,
                            color: AppColors.textWhiteColor,
                            fontWeight: FontWeight.bold),
                        color: AppColors.colorPrimaryLight,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Center(
                      child: MyButton(
                        height: 5.h,
                        width: 30.w,
                        padding:
                            EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                        label: 'Create group',
                        labelTextColor: AppColors.colorPrimary,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            messageBloc.add(CreateGroupEvent({
                              "token": LoginSuccessResponse.fromJson(
                                      GetStorage()
                                          .read(AppPreferenceString.pUserData))
                                  .token!,
                              "image": base64Encode(
                                  File(profileImage!.path).readAsBytesSync()),
                              "group_name": groupNameController.text,
                              "group_member": userIdList
                            }));
                            await pushNewScreenWithRouteSettings(context,
                                screen: MessageScreen(),
                                settings: RouteSettings(
                                  name: Routes.MESSAGE_SCREEN,
                                ),
                                withNavBar: true,
                                pageTransitionAnimation:
                                    PageTransitionAnimation.cupertino);
                          }
                        },
                        textStyle: TextStyle(
                            fontSize: 15,
                            color: AppColors.colorPrimary,
                            fontWeight: FontWeight.bold),
                        color: AppColors.textWhiteColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pullRefresh() async {
    friendsBloc.add(GetFriendsApiEvent());
  }
}
