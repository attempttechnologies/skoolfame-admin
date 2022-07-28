import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sizer/sizer.dart';
import 'package:skoolfame/Bloc/Home/home_bloc.dart';
import 'package:skoolfame/Bloc/Message/message_bloc.dart';
import 'package:skoolfame/Data/API/api_manager.dart';
import 'package:skoolfame/Routes/routes.dart';
import 'package:skoolfame/Screens/Home/comment_screen.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Utils/app_strings.dart';
import 'package:skoolfame/Utils/constants.dart';
import 'package:skoolfame/Utils/custom_date_formatter.dart';
import 'package:skoolfame/Widgets/custom_widget.dart';
import 'package:skoolfame/Widgets/wrapper.dart';
import 'package:skoolfame/generated/assets.dart';
import 'package:skoolfame/main.dart';

import '../../Data/Models/login_success_respo_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var messageBloc = MessageBloc();
  var homeBloc = HomeBloc();
  LoginSuccessResponse userData = LoginSuccessResponse();
  var postController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? profileImage;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var commentController = TextEditingController();

  @override
  void initState() {
    homeBloc.add(InitializeHomeSocketEvent());
    userData = LoginSuccessResponse.fromJson(
        GetStorage().read(AppPreferenceString.pUserData));
    homeBloc.add(GetPostEvent({
      "token": LoginSuccessResponse.fromJson(
              GetStorage().read(AppPreferenceString.pUserData))
          .token!
    }));
    // homeBloc.add(ReceivePostEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorPrimaryLight,
      body: SubWrapper(
        child: BlocListener<HomeBloc, HomeState>(
          bloc: homeBloc,
          listener: (context, state) {
            if (state is SendPostSuccessState ||
                state is ReceivePostSuccessState ||
                state is SendMessageSuccessState ||
                state is LikePostSuccessState) {
              homeBloc.add(GetPostEvent({
                "token": LoginSuccessResponse.fromJson(
                        GetStorage().read(AppPreferenceString.pUserData))
                    .token!
              }));
              setState(() {});
            }
            if (state is DeletePostSuccessState) {
              homeBloc.add(GetPostEvent({
                "token": LoginSuccessResponse.fromJson(
                        GetStorage().read(AppPreferenceString.pUserData))
                    .token!
              }));
            }
          },
          child: BlocBuilder<HomeBloc, HomeState>(
            bloc: homeBloc,
            builder: (context, state) {
              if (state is GetPostSuccessState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 1.5.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          userData.data!.userProfileImage == ""
                              ? CircleAvatar(
                                  radius: 22,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      Assets.imagesUser,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 22,
                                  backgroundImage: NetworkImage(
                                      APIManager.baseUrl +
                                          userData.data!.userProfileImage!),
                                ),
                          SizedBox(
                            width: 2.w,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: postController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                      color: AppColors.textGreyColor,
                                      width: 0.0),
                                ),
                                contentPadding: EdgeInsets.all(12),
                                isDense: true,
                                hintStyle: const TextStyle(
                                    color: AppColors.textGreyColor,
                                    fontSize: 17),
                                hintText: "What’s on your mind?",
                              ),
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                          // SizedBox(
                          //   width: 3.w,
                          // ),
                          // GestureDetector(
                          //     onTap: () {},
                          //     child: CustomWidgets()
                          //         .customIcon(icon: Assets.iconsCamera, size: 3)),
                          // SizedBox(
                          //   width: 3.w,
                          // ),
                          // GestureDetector(
                          //     onTap: () {},
                          //     child: CustomWidgets()
                          //         .customIcon(icon: Assets.iconsVideoShare, size: 3)),
                          SizedBox(
                            width: 3.w,
                          ),
                          GestureDetector(
                              onTap: () async {
                                final XFile? image = await _picker.pickImage(
                                    source: ImageSource.gallery);
                                profileImage = File(image!.path);

                                messageBloc.add(SendPhotosEvent({
                                  "token": LoginSuccessResponse.fromJson(
                                          GetStorage().read(
                                              AppPreferenceString.pUserData))
                                      .token!,
                                  "isHome": true,
                                  "image": base64Encode(File(profileImage!.path)
                                      .readAsBytesSync())
                                }));
                                setState(() {});
                              },
                              child: CustomWidgets().customIcon(
                                icon: Assets.iconsIconsGallery,
                                size: 4,
                              )),
                          SizedBox(
                            width: 3.w,
                          ),
                          GestureDetector(
                              onTap: () {
                                if (postController.text.startsWith(" ")) {
                                  final SnackBar snackBar = SnackBar(
                                      content: Text("Space not allow"),
                                      backgroundColor: AppColors.textRedColor,
                                      behavior: SnackBarBehavior.floating);
                                  snackbarKey.currentState
                                      ?.showSnackBar(snackBar);
                                } else if (postController.text.isNotEmpty) {
                                  homeBloc.add(SendPostEvent({
                                    "token": LoginSuccessResponse.fromJson(
                                            GetStorage().read(
                                                AppPreferenceString.pUserData))
                                        .token!,
                                    "message": postController.text
                                  }));
                                  postController.clear();
                                }
                              },
                              child: CustomWidgets().customIcon(
                                  icon: Assets.iconsShare, size: 4.2))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    state.getPostResponse.messageData!.isEmpty
                        ? Expanded(
                            child: Center(
                                child: CustomWidgets.text(
                                    AppStrings.nothingFound,
                                    color: AppColors.textGreyColor,
                                    fontWeight: FontWeight.w600)),
                          )
                        : Expanded(
                            child: RefreshIndicator(
                              onRefresh: _pullRefresh,
                              child: ListView.separated(
                                itemCount:
                                    state.getPostResponse.messageData!.length,
                                padding: EdgeInsets.only(bottom: 3.0.h),
                                itemBuilder: (context, index) {
                                  var messageData =
                                      state.getPostResponse.messageData![index];
                                  return Padding(
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
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            messageData.senderUser!
                                                        .userProfileImage ==
                                                    null
                                                ? CircleAvatar(
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
                                                  )
                                                : CircleAvatar(
                                                    radius: 22,
                                                    backgroundColor:
                                                        AppColors.colorPrimary,
                                                    backgroundImage:
                                                        NetworkImage(APIManager
                                                                .baseUrl +
                                                            messageData
                                                                .senderUser!
                                                                .userProfileImage!),
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
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          CustomWidgets.text(
                                                              messageData
                                                                      .senderUser!
                                                                      .firstName! +
                                                                  " " +
                                                                  messageData
                                                                      .senderUser!
                                                                      .lastName!,
                                                              color: AppColors
                                                                  .textBlackColor,
                                                              fontSize: 11.5,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ],
                                                      ),
                                                      messageData.senderUser!
                                                                  .sId !=
                                                              LoginSuccessResponse.fromJson(
                                                                      GetStorage()
                                                                          .read(
                                                                              AppPreferenceString.pUserData))
                                                                  .data!
                                                                  .sId
                                                          ? Container()
                                                          : GestureDetector(
                                                              onTap: () {
                                                                CustomWidgets()
                                                                    .showConfirmationDialog(
                                                                        context,
                                                                        title:
                                                                            "Are you sure want to delete this post?",
                                                                        onTap:
                                                                            (currentContext) {
                                                                  Navigator.pop(
                                                                      currentContext);

                                                                  homeBloc.add(
                                                                      DeletePostApiEvent({
                                                                    "id":
                                                                        messageData
                                                                            .sId!
                                                                  }));
                                                                });
                                                              },
                                                              child: CustomWidgets()
                                                                  .customIcon(
                                                                      icon: Assets
                                                                          .iconsDelete,
                                                                      size:
                                                                          2.2),
                                                            )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 1.h,
                                                  ),
                                                  messageData.messageType ==
                                                          "image"
                                                      ? Image.network(APIManager
                                                              .baseUrl +
                                                          messageData.message!)
                                                      : CustomWidgets.text(
                                                          messageData.message!,
                                                          color: AppColors
                                                              .textStatusGreyColor,
                                                          fontSize: 11,
                                                          textAlign:
                                                              TextAlign.start),
                                                  SizedBox(
                                                    height: 1.5.h,
                                                  ),
                                                  BlocConsumer<HomeBloc,
                                                      HomeState>(
                                                    bloc: homeBloc,
                                                    listener: (context, state) {
                                                      // TODO: implement listener
                                                    },
                                                    builder: (context, state) {
                                                      return Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          InkWell(
                                                            onTap: () async {
                                                              await pushNewScreenWithRouteSettings(
                                                                context,
                                                                screen:
                                                                    const CommentScreen(),
                                                                settings: RouteSettings(
                                                                    name: Routes
                                                                        .COMMENT_SCREEN,
                                                                    arguments:
                                                                        messageData
                                                                            .sId!),
                                                                withNavBar:
                                                                    false,
                                                                pageTransitionAnimation:
                                                                    PageTransitionAnimation
                                                                        .cupertino,
                                                              );
                                                            },
                                                            child: messageData
                                                                        .totalCount ==
                                                                    null
                                                                ? CustomWidgets()
                                                                    .customIcon(
                                                                    icon: Assets
                                                                        .iconsComment,
                                                                    size: 1.8,
                                                                  )
                                                                : CustomWidgets()
                                                                    .customIcon(
                                                                    icon: Assets
                                                                        .iconsComment,
                                                                    color: AppColors
                                                                        .greenColor,
                                                                    size: 1.8,
                                                                  ),
                                                          ),
                                                          SizedBox(
                                                            width: 1.w,
                                                          ),
                                                          CustomWidgets.text(
                                                            messageData.totalCount ==
                                                                    null
                                                                ? "0 " +
                                                                    AppStrings
                                                                        .comment
                                                                : messageData
                                                                        .totalCount
                                                                        .toString() +
                                                                    " " +
                                                                    AppStrings
                                                                        .comment,
                                                            color: AppColors
                                                                .textTagGreyColor,
                                                            fontSize: 9,
                                                          ),
                                                          SizedBox(
                                                            width: 3.w,
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              homeBloc.add(
                                                                  LikePostApiEvent({
                                                                "id":
                                                                    messageData
                                                                        .sId,
                                                              }));
                                                            },
                                                            child: messageData
                                                                    .isLike!
                                                                ? CustomWidgets().customIcon(
                                                                    icon: Assets
                                                                        .iconsLike,
                                                                    size: 1.8,
                                                                    color: AppColors
                                                                        .greenColor)
                                                                : CustomWidgets()
                                                                    .customIcon(
                                                                    icon: Assets
                                                                        .iconsLike,
                                                                    size: 1.8,
                                                                  ),
                                                          ),
                                                          SizedBox(
                                                            width: 1.w,
                                                          ),
                                                          CustomWidgets.text(
                                                            messageData
                                                                .totalLike!
                                                                .toString(),
                                                            color: AppColors
                                                                .textTagGreyColor,
                                                            fontSize: 9,
                                                          ),
                                                          SizedBox(
                                                            width: 1.w,
                                                          ),
                                                          CustomWidgets.text(
                                                            AppStrings.like,
                                                            color: AppColors
                                                                .textTagGreyColor,
                                                            fontSize: 9,
                                                          ),
                                                          Spacer(),
                                                          CustomWidgets()
                                                              .customIcon(
                                                                  icon: Assets
                                                                      .iconsTime,
                                                                  size: 1.5),
                                                          SizedBox(
                                                            width: 1.w,
                                                          ),
                                                          CustomWidgets.text(
                                                            DateFormatter()
                                                                .getVerboseDateTimeRepresentation(
                                                              DateTime.parse(
                                                                  messageData
                                                                      .createdAt!),
                                                            ),
                                                            color: AppColors
                                                                .textTagGreyColor,
                                                            fontSize: 8.8,
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
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

  Future<void> _pullRefresh() async {
    homeBloc.add(GetPostEvent({
      "token": LoginSuccessResponse.fromJson(
              GetStorage().read(AppPreferenceString.pUserData))
          .token!
    }));
  }
}
