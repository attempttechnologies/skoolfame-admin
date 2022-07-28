import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import 'package:skoolfame/Bloc/Login/login_bloc.dart';
import 'package:skoolfame/Data/API/api_manager.dart';
import 'package:skoolfame/Data/Models/login_success_respo_model.dart';
import 'package:skoolfame/Routes/routes.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Utils/app_strings.dart';
import 'package:skoolfame/Utils/constants.dart';
import 'package:skoolfame/Widgets/custom_widget.dart';
import 'package:skoolfame/generated/assets.dart';

class CustomDrawer extends StatefulWidget {
  CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  var loginBloc = LoginBloc();
  LoginSuccessResponse userData = LoginSuccessResponse();
  @override
  void initState() {
    userData = LoginSuccessResponse.fromJson(
        GetStorage().read(AppPreferenceString.pUserData));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topRight: Radius.circular(26), bottomRight: Radius.circular(26)),
      child: Drawer(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.topYellowColor,
                AppColors.bottomOrangeColor,
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 6.h),
                Center(
                  child: Container(
                    width: 25.w,
                    height: 25.w,
                    // padding: EdgeInsets.all(18),
                    decoration: BoxDecoration(
                        color: AppColors.textWhiteColor,
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.topYellowColor,
                            offset: Offset(0, 5),
                            blurRadius: 10,
                            spreadRadius: 5,
                          ),
                        ],
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.textWhiteColor,
                          width: 2.0,
                        )),
                    child: userData.data!.userProfileImage == null ||
                            userData.data!.userProfileImage!.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Image.asset(
                              Assets.imagesUser,
                              fit: BoxFit.cover,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CachedNetworkImage(
                              imageUrl: APIManager.baseUrl +
                                  userData.data!.userProfileImage!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  CupertinoActivityIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 1.5.h),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CustomWidgets.text(
                    LoginSuccessResponse.fromJson(
                            GetStorage().read(AppPreferenceString.pUserData))
                        .data!
                        .firstName!,
                    maxLine: 1,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                DrawerItem(
                  title: AppStrings.home,
                  icon: Assets.iconsHome,
                  callback: (index) {
                    if (ModalRoute.of(context)!.settings.name !=
                        Routes.DASHBOARD_ROUTE) {
                      Navigator.popUntil(
                          context,
                          (route) =>
                              route.settings.name == Routes.DASHBOARD_ROUTE);
                    }
                  },
                  callbackIndex: HOME_INDEX,
                ),
                commonDivider(),
                DrawerItem(
                  title: AppStrings.activity,
                  icon: Assets.iconsActivity,
                  callback: (index) {
                    if (ModalRoute.of(context)!.settings.name !=
                        Routes.ACTIVITY_SCREEN_ROUTE) {
                      Navigator.pushNamed(
                          context, Routes.ACTIVITY_SCREEN_ROUTE);
                    }
                  },
                  callbackIndex: ACTIVITY_INDEX,
                ),
                commonDivider(),
                DrawerItem(
                  title: AppStrings.notifications,
                  icon: Assets.iconsNotifications,
                  callback: (index) {
                    if (ModalRoute.of(context)!.settings.name !=
                        Routes.NOTIFICATIONS_SCREEN_ROUTE) {
                      Navigator.pushNamed(
                          context, Routes.NOTIFICATIONS_SCREEN_ROUTE);
                    }
                  },
                  callbackIndex: NOTIFICATIONS_INDEX,
                ),
                commonDivider(),
                DrawerItem(
                  title: AppStrings.friendRequest,
                  icon: Assets.iconsFriendRequest,
                  callback: (index) {
                    if (ModalRoute.of(context)!.settings.name !=
                        Routes.FRIEND_REQUEST_SCREEN) {
                      Navigator.pushNamed(
                          context, Routes.FRIEND_REQUEST_SCREEN);
                    }
                  },
                  callbackIndex: VIDEO_INDEX,
                ),
                commonDivider(),
                DrawerItem(
                  title: AppStrings.relationship,
                  icon: Assets.iconsRelationship,
                  callback: (index) {
                    if (ModalRoute.of(context)!.settings.name !=
                        Routes.RELATIONSHIP_SCREEN_ROUTE) {
                      Navigator.pushNamed(
                          context, Routes.RELATIONSHIP_SCREEN_ROUTE);
                    }
                  },
                  callbackIndex: RELATIONSHIP_INDEX,
                ),
                commonDivider(),
                DrawerItem(
                  title: AppStrings.album,
                  icon: Assets.iconsAlbum,
                  callback: (index) {
                    if (ModalRoute.of(context)!.settings.name !=
                        Routes.ALBUM_SCREEN_ROUTE) {
                      Navigator.pushNamed(context, Routes.ALBUM_SCREEN_ROUTE);
                    }
                  },
                  callbackIndex: ALBUM_INDEX,
                ),
                commonDivider(),
                DrawerItem(
                  title: AppStrings.video,
                  icon: Assets.iconsVideo,
                  callback: (index) {
                    if (ModalRoute.of(context)!.settings.name !=
                        Routes.VIDEO_SCREEN_ROUTE) {
                      Navigator.pushNamed(context, Routes.VIDEO_SCREEN_ROUTE);
                    }
                  },
                  callbackIndex: VIDEO_INDEX,
                ),
                commonDivider(),
                DrawerItem(
                  title: AppStrings.liveStreaming,
                  icon: Assets.iconsLiveStreaming,
                  callback: (index) {
                    if (ModalRoute.of(context)!.settings.name !=
                        Routes.LIVE_STREAMING) {
                      Navigator.pushNamed(context, Routes.LIVE_STREAMING);
                    }
                  },
                  callbackIndex: VIDEO_INDEX,
                ),
                commonDivider(),
                DrawerItem(
                  title: AppStrings.highSchool,
                  icon: Assets.iconsHighSchool,
                  // size: 3.3,
                  callback: (index) {
                    if (ModalRoute.of(context)!.settings.name !=
                        Routes.HIGH_SCHOOL_SCREEN_ROUTE) {
                      Navigator.pushNamed(
                          context, Routes.HIGH_SCHOOL_SCREEN_ROUTE);
                    }
                  },
                  callbackIndex: HIGH_SCHOOL_INDEX,
                ),
                commonDivider(),
                BlocListener<LoginBloc, LoginState>(
                  bloc: loginBloc,
                  listener: (context, state) {
                    if (state is LogoutSuccessState) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          Routes.LOGIN_SCREEN_ROUTE,
                          (route) =>
                              route.settings.name == Routes.LOGIN_SCREEN_ROUTE);
                    }
                    if (state is LoginBlocFailure) {
                      print('Error occurred !');
                    }
                  },
                  child: BlocBuilder<LoginBloc, LoginState>(
                    bloc: loginBloc,
                    builder: (context, state) {
                      return DrawerItem(
                        title: AppStrings.logout,
                        icon: Assets.iconsLogout,
                        callback: (index) {
                          FacebookAuth.instance.logOut().then((value) =>
                              FirebaseAuth.instance.signOut().then(
                                  (value) => loginBloc.add(LogoutApiEvent())));
                        },
                        callbackIndex: LOGOUT_INDEX,
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 6.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget commonDivider() {
  return Divider(
    color: Color(0xffFFBF53),
    indent: 5.0.w,
    endIndent: 13.0.w,
    thickness: 1.2,
    height: 3.0.h,
  );
}

class DrawerItem extends StatelessWidget {
  const DrawerItem(
      {Key? key,
      this.size = 2.8,
      this.title,
      this.callback,
      this.callbackIndex,
      this.icon})
      : super(key: key);

  final String? title;
  final String? icon;
  final Function(int?)? callback;
  final int? callbackIndex;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        return callback!(callbackIndex);
      },
      child: Container(
        margin: EdgeInsets.only(top: 2.2.h),
        padding: EdgeInsets.only(left: 5.5.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomWidgets().customIcon(
                icon: icon, size: size!, color: AppColors.textWhiteColor),
            SizedBox(width: 4.0.w),
            CustomWidgets.text(title!,
                color: AppColors.textWhiteColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.2),
          ],
        ),
      ),
    );
  }
}
