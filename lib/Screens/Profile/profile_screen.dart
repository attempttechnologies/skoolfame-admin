import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sizer/sizer.dart';
import 'package:skoolfame/Bloc/Profile/profile_bloc.dart';
import 'package:skoolfame/Data/API/api_manager.dart';
import 'package:skoolfame/Data/Models/login_success_respo_model.dart';
import 'package:skoolfame/Routes/routes.dart';
import 'package:skoolfame/Screens/Profile/details_page.dart';
import 'package:skoolfame/Screens/Profile/edit_profile_page.dart';
import 'package:skoolfame/Screens/Profile/profile_about_page.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Utils/app_strings.dart';
import 'package:skoolfame/Utils/constants.dart';
import 'package:skoolfame/Widgets/custom_widget.dart';
import 'package:skoolfame/Widgets/wrapper.dart';
import 'package:skoolfame/generated/assets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, this.onTap}) : super(key: key);

  final Function(int)? onTap;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  CustomTabBarState customTabBarState = CustomTabBarState();
  var profileBloc = ProfileBloc();
  LoginSuccessResponse userData = LoginSuccessResponse();
  final ImagePicker _picker = ImagePicker();
  File? profileImage;
  bool isDetailScreen = true;

  @override
  void initState() {
    imageCache!.clear();
    PaintingBinding.instance!.imageCache!.clear();

    userData = LoginSuccessResponse.fromJson(
        GetStorage().read(AppPreferenceString.pUserData));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorPrimaryLight,
      body: SubWrapper(
        child: SizedBox(
          height: 100.0.h,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: isDetailScreen
                            ? () {}
                            : () async {
                                final XFile? image = await _picker.pickImage(
                                    source: ImageSource.gallery);
                                profileImage = File(image!.path);
                                setState(() {});
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
                                  : userData.data!.userProfileImage == null ||
                                          userData
                                              .data!.userProfileImage!.isEmpty
                                      ? Padding(
                                          padding: const EdgeInsets.all(18.0),
                                          child: Image.asset(
                                            Assets.imagesUser,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl: APIManager.baseUrl +
                                                userData
                                                    .data!.userProfileImage!,
                                          ),
                                        ),
                            ),
                            isDetailScreen
                                ? Container()
                                : Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: CustomWidgets().customIcon(
                                          icon: Assets.iconsCameraRound,
                                          size: 5),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 3.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 50.w,
                            child: CustomWidgets.text(
                                userData.data!.firstName! +
                                    " " +
                                    userData.data!.lastName!,
                                overflow: TextOverflow.ellipsis,
                                maxLine: 1,
                                textAlign: TextAlign.start,
                                color: AppColors.textBlackColor),
                          ),
                          SizedBox(height: 0.5.h),
                          Container(
                            width: 60.w,
                            child: CustomWidgets.text(userData.data!.about!,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                maxLine: 2,
                                color: AppColors.textGreyColor),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Container(
                    // height: 5.h,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 0,
                        color: AppColors.textGreyColor,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          labelIcon(
                              icon: Assets.iconsFriends,
                              label: AppStrings.friends,
                              onTap: () {
                                print("Print");
                                // SchedulerBinding.instance!
                                //     .addPostFrameCallback((_) {
                                //   pushNewScreenWithRouteSettings(context,
                                //       screen: FriendRequestScreen(),
                                //       settings: RouteSettings(
                                //           name: Routes.FRIEND_REQUEST_SCREEN));
                                // });
                              }),
                          labelIcon(
                              icon: Assets.iconsRelationship,
                              label: 'Relationships',
                              onTap: () {}),
                          labelIcon(
                              icon: Assets.iconsHighSchool,
                              size: 3,
                              label: AppStrings.highSchool,
                              onTap: () {}),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Container(
                  height: 55.h,
                  color: AppColors.textGreyColor.withOpacity(0.1),
                  child: CustomTabBar(
                    aboutCallBack: (String about) {
                      print("isDetailScreen");
                      userData.data!.about = about;
                      isDetailScreen = true;
                      setState(() {});
                    },
                    tabStrings: [
                      AppStrings.details,
                      AppStrings.edit,
                      AppStrings.about
                    ],
                    tabPage: [
                      DetailsPage(
                        screen: 'profile',
                      ),
                      EditProfilePage(
                          image: profileImage,
                          callBack:
                              (LoginSuccessResponse loginSuccessResponse) {
                            userData = loginSuccessResponse;
                            setState(() {});
                          }),
                      ProfileAboutPage(),
                    ],
                    onTap: (int index) {
                      if (index == 0) {
                        isDetailScreen = true;
                        setState(() {});
                      }

                      if (index == 1) {
                        setState(() {});
                        isDetailScreen = false;
                      }
                      widget.onTap!(index);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector labelIcon(
      {required String label,
      required String icon,
      required Function() onTap,
      size = 2}) {
    return GestureDetector(
      onTap: onTap(),
      child: Row(
        children: [
          CustomWidgets().customIcon(
              icon: icon,
              size: double.parse(size.toString()),
              color: AppColors.textBlackColor),
          SizedBox(
            width: 1.w,
          ),
          CustomWidgets.text(label,
              color: AppColors.textTagGreyColor,
              fontSize: 12,
              fontWeight: FontWeight.w500),
        ],
      ),
    );
  }
}

class CustomTabBar extends StatefulWidget {
  CustomTabBar(
      {Key? key,
      required this.tabPage,
      required this.tabStrings,
      required this.onTap,
      this.aboutCallBack})
      : super(key: key);

  final List<String> tabStrings;
  final List<StatefulWidget> tabPage;
  final Function(int)? onTap;
  final Function(String)? aboutCallBack;

  @override
  State<CustomTabBar> createState() => CustomTabBarState();
}

class CustomTabBarState extends State<CustomTabBar>
    with SingleTickerProviderStateMixin {
  TabController? controller;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Create TabController for getting the index of current tab
    controller = TabController(length: widget.tabStrings.length, vsync: this);

    controller!.addListener(() {
      setState(() {
        selectedIndex = controller!.index;
      });
      print("Selected Index: " + controller!.index.toString());
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
            controller: controller,
            unselectedLabelColor: AppColors.textGreyTabColor,
            labelColor: AppColors.textWhiteColor,
            padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 2.0.h),

            onTap: (index) async {
              widget.onTap!(index);
              if (index == 2) {
                var res = await pushNewScreenWithRouteSettings(
                  context,
                  screen: const ProfileAboutPage(),
                  settings: const RouteSettings(
                    name: Routes.PROFILE_ABOUT_SCREEN,
                  ),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
                if (res != null) widget.aboutCallBack!.call(res);

                controller!.index = 0;
              }
            },
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
            controller: controller,
            children: widget.tabPage,
          ),
        ),
      ],
    );
  }
}
