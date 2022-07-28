import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sizer/sizer.dart';
import 'package:skoolfame/Bloc/Friends/friends_bloc.dart';
import 'package:skoolfame/Data/API/api_manager.dart';
import 'package:skoolfame/Data/Models/login_success_respo_model.dart';
import 'package:skoolfame/Routes/routes.dart';
import 'package:skoolfame/Screens/Friends/friends_profile_screen.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Utils/app_strings.dart';
import 'package:skoolfame/Utils/appbar_manager.dart';
import 'package:skoolfame/Widgets/custom_widget.dart';
import 'package:skoolfame/Widgets/wrapper.dart';
import 'package:skoolfame/generated/assets.dart';

class SearchFriendScreen extends StatefulWidget {
  const SearchFriendScreen({Key? key}) : super(key: key);

  @override
  _SearchFriendScreenState createState() => _SearchFriendScreenState();
}

class _SearchFriendScreenState extends State<SearchFriendScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var friendsBloc = FriendsBloc();
  List<UserData>? templist = [];
  List<UserData>? searchlist = [];
  var searchController = TextEditingController();

  @override
  void dispose() {
    appBarManager.updateAppBarStatus(true);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    friendsBloc.add(GetUsersApiEvent());
    searchlist!.clear();
    searchlist!.addAll(templist!);
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorPrimaryLight,
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: CustomWidgets.myAppBar(
          title: AppStrings.friends,
          centerTitle: true,
          isBackIcon: true,
          context: context,
          actions: [Container()],
          scaffoldKey: _scaffoldKey),
      body: SubWrapper(
        child: Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: BlocListener<FriendsBloc, FriendsState>(
            bloc: friendsBloc,
            listener: (context, state) {
              if (state is GetUsersSuccessState) {
                templist!.clear();
                templist!.addAll(state.userResponse.data!);
                setState(() {});
              }
              if (state is FriendRequestSuccessState) {
                friendsBloc.add(GetUsersApiEvent());
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
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
                          color: AppColors.textGreyColor, fontSize: 15),
                      hintText: "Search Friends",
                    ),
                    onChanged: (v) {
                      if (v.isEmpty) {
                        setState(() {});
                      } else {
                        _searchUser(v);
                      }
                    },
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: CustomWidgets.text(
                    "Suggestions for you",
                    color: AppColors.textGreyTabColor,
                    textAlign: TextAlign.start,
                    fontSize: 11,
                  ),
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                BlocBuilder<FriendsBloc, FriendsState>(
                  bloc: friendsBloc,
                  builder: (context, state) {
                    if (state is GetUsersSuccessState) {
                      List<UserData> userList = [];

                      if (searchController.text.isNotEmpty) {
                        userList = searchlist!;
                      } else {
                        userList = state.userResponse.data!;
                      }
                      return userList.isEmpty
                          ? Expanded(
                              child: Center(
                                child: CustomWidgets.text("No friends found",
                                    color: AppColors.colorPrimary,
                                    fontSize: 20),
                              ),
                            )
                          : Expanded(
                              child: RefreshIndicator(
                                  onRefresh: _pullRefresh,
                                  child: ListView.separated(
                                    itemCount: userList.length,
                                    padding: EdgeInsets.only(bottom: 2.0.h),
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () async {
                                          var res =
                                              await pushNewScreenWithRouteSettings(
                                            context,
                                            screen: FriendsProfileScreen(),
                                            settings: RouteSettings(
                                              name:
                                                  Routes.FRIENDS_PROFILE_SCREEN,
                                              arguments: userList[index],
                                            ),
                                            withNavBar: true,
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
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(14.0)),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                // crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  userList[index].userProfileImage ==
                                                              null ||
                                                          userList[index]
                                                              .userProfileImage!
                                                              .isEmpty
                                                      ? ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
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
                                                                  Colors
                                                                      .transparent,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        10.0),
                                                                child:
                                                                    Image.asset(
                                                                  Assets
                                                                      .imagesUser,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : CircleAvatar(
                                                          radius: 22,
                                                          backgroundImage:
                                                              CachedNetworkImageProvider(APIManager
                                                                      .baseUrl +
                                                                  userList[
                                                                          index]
                                                                      .userProfileImage!),
                                                        ),
                                                  SizedBox(
                                                    width: 2.8.w,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        CustomWidgets.text(
                                                            userList[index]
                                                                    .firstName! +
                                                                " " +
                                                                userList[index]
                                                                    .lastName!,
                                                            color: AppColors
                                                                .textBlackColor,
                                                            maxLine: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.start,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        userList[index].about ==
                                                                    null ||
                                                                userList[index]
                                                                    .about!
                                                                    .isEmpty
                                                            ? Container()
                                                            : CustomWidgets
                                                                .text(
                                                                userList[index]
                                                                    .about!,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLine: 1,
                                                                color: AppColors
                                                                    .textGreyTabColor,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                fontSize: 11,
                                                              ),
                                                      ],
                                                    ),
                                                  ),
                                                  userList[index].reqSend ==
                                                              "pending" ||
                                                          userList[index]
                                                                  .reqSend ==
                                                              "accept" ||
                                                          userList[index]
                                                                  .reqReceive ==
                                                              "accept"
                                                      ? Container()
                                                      : InkWell(
                                                          onTap: () {
                                                            friendsBloc.add(
                                                                FriendRequestApiEvent({
                                                              "id": userList[
                                                                      index]
                                                                  .sId
                                                            }));
                                                          },
                                                          child: CustomWidgets()
                                                              .customIcon(
                                                                  icon: Assets
                                                                      .iconsContactFriends,
                                                                  size: 3),
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
                                  )),
                            );
                    }
                    return Center(child: Text("No Data"));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _searchUser(String v) {
    searchlist!.clear();
    for (var user in templist!) {
      if ((user.firstName!.toLowerCase() + " " + user.lastName!.toLowerCase())
          .contains(v.toLowerCase())) {
        searchlist!.add(user);
      }
    }
    print(searchlist);

    setState(() {});
  }

  Future<void> _pullRefresh() async {
    friendsBloc.add(GetUsersApiEvent());
    searchlist!.clear();
    searchlist!.addAll(templist!);
    setState(() {});
  }
}
