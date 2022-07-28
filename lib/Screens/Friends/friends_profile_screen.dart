import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sizer/sizer.dart';
import 'package:skoolfame/Bloc/Friends/friends_bloc.dart';
import 'package:skoolfame/Data/API/api_manager.dart';
import 'package:skoolfame/Data/Models/login_success_respo_model.dart';
import 'package:skoolfame/Routes/routes.dart';
import 'package:skoolfame/Screens/Friends/photos_page.dart';
import 'package:skoolfame/Screens/Friends/video_page.dart';
import 'package:skoolfame/Screens/Messages/chat_screen.dart';
import 'package:skoolfame/Screens/Profile/details_page.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Utils/app_strings.dart';
import 'package:skoolfame/Utils/constants.dart';
import 'package:skoolfame/Widgets/custom_widget.dart';
import 'package:skoolfame/Widgets/my_button.dart';
import 'package:skoolfame/Widgets/wrapper.dart';
import 'package:skoolfame/generated/assets.dart';

class FriendsProfileScreen extends StatefulWidget {
  FriendsProfileScreen({Key? key, this.isFromFriends = false})
      : super(key: key);

  bool isFromFriends;

  @override
  _FriendsProfileScreenState createState() => _FriendsProfileScreenState();
}

class _FriendsProfileScreenState extends State<FriendsProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var friendsBloc = FriendsBloc();
  var userData = UserData();
  bool isFromFriends = false;

  @override
  void didChangeDependencies() {
    userData = ModalRoute.of(context)!.settings.arguments as UserData;
    isFromFriends = widget.isFromFriends;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorPrimaryLight,
      key: _scaffoldKey,
      appBar: CustomWidgets.myAppBar(
        title: userData.firstName!,
        centerTitle: true,
        isBackIcon: true,
        context: context,
        scaffoldKey: _scaffoldKey,
      ),
      body: SubWrapper(
        child: SizedBox(
          height: 100.h,
          child: BlocListener<FriendsBloc, FriendsState>(
            bloc: friendsBloc,
            listener: (context, state) {
              if (state is FriendRequestSuccessState ||
                  state is RelationshipRequestSuccessState) {
                friendsBloc.add(GetUsersApiEvent());
              }

              if (state is UpdateRequestSuccessState ||
                  state is UpdateRelationshipRequestSuccessState) {
                friendsBloc.add(GetUsersApiEvent());
              }
              if (state is GetUsersSuccessState) {
                userData = state.userResponse.data!
                    .firstWhere((element) => element.sId == userData.sId);

                setState(() {});
              }
            },
            child: BlocBuilder<FriendsBloc, FriendsState>(
              bloc: friendsBloc,
              builder: (context, state) {
                print("isFriend ${userData.reqSend}");

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 25.w,
                            height: 25.w,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColors.topYellowColor,
                                  AppColors.btnTabOrangeColor,
                                  AppColors.bottomOrangeColor,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: AppColors.textBlackColor
                                        .withOpacity(0.1),
                                    offset: const Offset(0, 10),
                                    blurRadius: 20,
                                    spreadRadius: 5)
                              ],
                              shape: BoxShape.circle,
                            ),
                            child: userData.userProfileImage == null ||
                                    userData.userProfileImage!.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Image.asset(
                                      Assets.imagesUser,
                                      fit: BoxFit.cover,
                                      color: AppColors.textWhiteColor,
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.network(
                                      APIManager.baseUrl +
                                          userData.userProfileImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          SizedBox(
                            width: 3.w,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 60.0.w,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomWidgets.text(
                                        userData.firstName! +
                                            " " +
                                            userData.lastName!,
                                        color: AppColors.textBlackColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                    // Spacer(),
                                    userData.reqSend == "accept" ||
                                            userData.reqReceive == "accept"
                                        ? CustomWidgets().customIcon(
                                            icon:
                                                Assets.iconsContactFriendsDone,
                                            size: 3)
                                        : Container()
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 0.5.h,
                              ),
                              Container(
                                width: 60.w,
                                child: CustomWidgets.text(userData.about!,
                                    color: AppColors.textGreyColor,
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    maxLine: 2,
                                    fontSize: 11),
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: userData.reqReceive == "pending" ||
                              userData.reqRelationshipReceive == "pending"
                          ? Row(
                              children: [
                                Expanded(
                                  child: MyButton(
                                      borderRadius: 5,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 19, vertical: 12),
                                      borderColor: AppColors.textGreyColor,
                                      textStyle: const TextStyle(
                                          color: AppColors.textGreyColor),
                                      label: "Ignore",
                                      onPressed: userData.reqReceive ==
                                              "pending"
                                          ? () {
                                              friendsBloc
                                                  .add(UpdateRequestApiEvent({
                                                "receiver_id":
                                                    LoginSuccessResponse.fromJson(
                                                            GetStorage().read(
                                                                AppPreferenceString
                                                                    .pUserData))
                                                        .data!
                                                        .sId,
                                                "sender_id": userData.sId,
                                                "requestStatus": "reject"
                                              }));
                                            }
                                          : () {
                                              friendsBloc.add(
                                                  UpdateRelationshipRequestApiEvent({
                                                "receiver_id":
                                                    LoginSuccessResponse.fromJson(
                                                            GetStorage().read(
                                                                AppPreferenceString
                                                                    .pUserData))
                                                        .data!
                                                        .sId,
                                                "sender_id": userData.sId,
                                                "requestStatus": "reject"
                                              }));
                                            }),
                                ),
                                SizedBox(
                                  width: 1.5.w,
                                ),
                                Expanded(
                                  child: MyButton(
                                      borderRadius: 5,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 19, vertical: 12),
                                      borderColor: AppColors.colorPrimary,
                                      textStyle: const TextStyle(
                                          color: AppColors.colorPrimary),
                                      label: "Accept",
                                      onPressed: userData.reqReceive ==
                                              "pending"
                                          ? () {
                                              friendsBloc
                                                  .add(UpdateRequestApiEvent({
                                                "receiver_id":
                                                    LoginSuccessResponse.fromJson(
                                                            GetStorage().read(
                                                                AppPreferenceString
                                                                    .pUserData))
                                                        .data!
                                                        .sId,
                                                "sender_id": userData.sId,
                                                "requestStatus": "accept"
                                              }));
                                            }
                                          : () {
                                              friendsBloc.add(
                                                  UpdateRelationshipRequestApiEvent({
                                                "receiver_id":
                                                    LoginSuccessResponse.fromJson(
                                                            GetStorage().read(
                                                                AppPreferenceString
                                                                    .pUserData))
                                                        .data!
                                                        .sId,
                                                "sender_id": userData.sId,
                                                "requestStatus": "accept"
                                              }));
                                            }),
                                )
                              ],
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: userData.reqSend == "pending"
                                      ? MyButton(
                                          borderRadius: 5,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 19, vertical: 12),
                                          borderColor: AppColors.colorPrimary,
                                          textStyle: TextStyle(
                                              color: AppColors.colorPrimary),
                                          label: AppStrings.requested,
                                          onPressed: () {
                                            friendsBloc
                                                .add(UpdateRequestApiEvent({
                                              "receiver_id": userData.sId,
                                              "sender_id":
                                                  LoginSuccessResponse.fromJson(
                                                          GetStorage().read(
                                                              AppPreferenceString
                                                                  .pUserData))
                                                      .data!
                                                      .sId,
                                              "requestStatus": "withdraw"
                                            }));
                                          })
                                      : (userData.reqSend == "accept" ||
                                                  userData.reqReceive ==
                                                      "accept" ||
                                                  isFromFriends == true) &&
                                              (userData.reqRelationshipSend == "" &&
                                                  userData.reqRelationshipReceive ==
                                                      "")
                                          ? MyButton(
                                              borderRadius: 5,
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 19, vertical: 12),
                                              borderColor:
                                                  AppColors.colorPrimary,
                                              textStyle: TextStyle(
                                                  color:
                                                      AppColors.colorPrimary),
                                              label: AppStrings.relationship,
                                              onPressed: () {
                                                friendsBloc.add(
                                                    RelationshipRequestApiEvent(
                                                        {"id": userData.sId}));
                                              })
                                          : userData.reqRelationshipSend ==
                                                  "pending"
                                              ? MyButton(
                                                  borderRadius: 5,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                          horizontal: 19,
                                                          vertical: 12),
                                                  borderColor:
                                                      AppColors.textGreyColor,
                                                  textStyle: TextStyle(
                                                      color: AppColors
                                                          .textGreyColor),
                                                  label: "Relationship reque",
                                                  onPressed: () {
                                                    friendsBloc.add(
                                                        UpdateRelationshipRequestApiEvent({
                                                      "receiver_id":
                                                          userData.sId,
                                                      "sender_id": LoginSuccessResponse.fromJson(
                                                              GetStorage().read(
                                                                  AppPreferenceString
                                                                      .pUserData))
                                                          .data!
                                                          .sId,
                                                      "requestStatus":
                                                          "withdraw"
                                                    }));
                                                  })
                                              : userData.reqRelationshipReceive == "accept" ||
                                                      userData.reqRelationshipSend == "accept"
                                                  ? MyButton(
                                                      borderRadius: 5,
                                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                                                      borderColor: AppColors.colorPrimary,
                                                      color: AppColors.colorPrimary,
                                                      textStyle: TextStyle(color: AppColors.textWhiteColor, fontSize: 15),
                                                      label: " In Relationship",
                                                      onPressed: () {
                                                        friendsBloc.add(
                                                            UpdateRelationshipRequestApiEvent({
                                                          "receiver_id":
                                                              userData.sId,
                                                          "sender_id": LoginSuccessResponse.fromJson(
                                                                  GetStorage().read(
                                                                      AppPreferenceString
                                                                          .pUserData))
                                                              .data!
                                                              .sId,
                                                          "requestStatus":
                                                              "withdraw"
                                                        }));
                                                      })
                                                  : MyButton(
                                                      borderRadius: 5,
                                                      padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 12),
                                                      borderColor: AppColors.textGreyColor,
                                                      textStyle: TextStyle(color: AppColors.textGreyColor),
                                                      label: AppStrings.addfriend,
                                                      onPressed: () {
                                                        friendsBloc.add(
                                                            FriendRequestApiEvent({
                                                          "id": userData.sId
                                                        }));
                                                      }),
                                ),
                                SizedBox(
                                  width: 3.w,
                                ),
                                Expanded(
                                    child: MyButton(
                                  borderRadius: 5,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 19, vertical: 12),
                                  borderColor: userData.reqSend == "accept" ||
                                          userData.reqReceive == "accept" ||
                                          isFromFriends
                                      ? AppColors.colorPrimary
                                      : AppColors.textGreyColor,
                                  textStyle: TextStyle(
                                      color: userData.reqSend == "accept" ||
                                              userData.reqReceive == "accept" ||
                                              isFromFriends
                                          ? AppColors.colorPrimary
                                          : AppColors.textGreyColor),
                                  label: "Message",
                                  onPressed: userData.reqSend == "accept" ||
                                          userData.reqReceive == "accept" ||
                                          isFromFriends
                                      ? () async {
                                          await pushNewScreenWithRouteSettings(
                                            context,
                                            screen: ChatScreen(
                                                isGroup: false, groupName: ""),
                                            settings: RouteSettings(
                                              name: Routes.CHAT_SCREEN,
                                              arguments: userData,
                                            ),
                                            withNavBar: false,
                                            pageTransitionAnimation:
                                                PageTransitionAnimation
                                                    .cupertino,
                                          );
                                        }
                                      : () {},
                                )),
                              ],
                            ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Expanded(
                      child: Container(
                        color: AppColors.textGreyColor.withOpacity(0.1),
                        child: CustomTabBar(
                          tabStrings: const [
                            AppStrings.details,
                            AppStrings.photos,
                            'Videos'
                          ],
                          tabPage: [
                            DetailsPage(screen: 'friend', userData: userData),
                            PhotosPage(userData: userData),
                            VideoPage(userData: userData),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTabBar extends StatefulWidget {
  const CustomTabBar({
    Key? key,
    required this.tabPage,
    required this.tabStrings,
  }) : super(key: key);

  final List<String> tabStrings;
  final List<StatefulWidget> tabPage;

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar>
    with SingleTickerProviderStateMixin {
  TabController? _controller;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Create TabController for getting the index of current tab
    _controller = TabController(length: widget.tabStrings.length, vsync: this);

    _controller!.addListener(() {
      setState(() {
        _selectedIndex = _controller!.index;
      });

      print("Selected Index: " + _controller!.index.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 70,
          child: TabBar(
            physics: const NeverScrollableScrollPhysics(),

            controller: _controller,
            unselectedLabelColor: AppColors.textGreyTabColor,
            labelColor: AppColors.textWhiteColor,
            padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 2.0.h),

            tabs: widget.tabStrings
                .map((e) => Tab(
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            e,
                            style: const TextStyle(fontSize: 16),
                          ) /*CustomWidgets.text(AppStrings.publics)*/),
                    ))
                .toList(),
            // labelPadding: EdgeInsets.zero,
            indicatorPadding: const EdgeInsets.all(1.0),
            indicatorWeight: 0.08,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.topYellowColor,
                  AppColors.btnTabOrangeColor,
                  AppColors.bottomOrangeColor,
                ],
              ),
              boxShadow: [
                BoxShadow(
                    color: AppColors.topYellowColor,
                    offset: Offset(0, 5),
                    blurRadius: 8,
                    spreadRadius: 0.2)
              ],
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _controller,
            children: widget.tabPage,
          ),
        ),
      ],
    );
  }
}
