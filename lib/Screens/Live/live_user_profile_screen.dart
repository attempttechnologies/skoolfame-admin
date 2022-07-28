import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:skoolfame/Screens/alumni_screen.dart';
import 'package:skoolfame/Screens/latest_photos_screen.dart';
import 'package:skoolfame/Screens/videos_screen.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Utils/app_strings.dart';
import 'package:skoolfame/Widgets/custom_status_listtile.dart';
import 'package:skoolfame/Widgets/custom_widget.dart';
import 'package:skoolfame/Widgets/wrapper.dart';
import 'package:skoolfame/generated/assets.dart';

class LiveUserProfileScreen extends StatefulWidget {
  const LiveUserProfileScreen({Key? key}) : super(key: key);

  @override
  State<LiveUserProfileScreen> createState() => _LiveUserProfileScreenState();
}

class _LiveUserProfileScreenState extends State<LiveUserProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      title: 'bcfy',
      isBackIcon: true,
      child: Column(
        children: [
          Container(
            color: AppColors.textWhiteColor,
            child: Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, top: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 29.5.w,
                    height: 29.5.w,
                    decoration: BoxDecoration(
                      color: const Color(0xff7c94b6),
                      image: DecorationImage(
                        image: AssetImage(
                          Assets.imagesProfileimage,
                        ),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.textBlackColor.withOpacity(0.1),
                            offset: Offset(0, 10),
                            blurRadius: 20,
                            spreadRadius: 5)
                      ],
                      shape: BoxShape.circle,
                      // borderRadius: BorderRadius.all( Radius.circular(50.0)),
                      border: Border.all(
                        color: AppColors.textWhiteColor,
                        width: 2.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 3.w,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomWidgets.text("Allison Perreira",
                            color: AppColors.textBlackColor,
                            fontWeight: FontWeight.bold),
                        SizedBox(
                          height: 0.5.h,
                        ),
                        CustomWidgets.text(
                            "How often found where i sholud be doing only by setting out for somewhere else. ",
                            color: AppColors.textGreyColor,
                            textAlign: TextAlign.start),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Expanded(
            child: Container(
                color: AppColors.textGreyColor.withOpacity(0.2),
                child: Column(
                  children: [
                    Expanded(
                      child: CustomTabBar(
                        tabPage: [
                          LiveUserDetails(),
                          AluminiScreen(),
                          LatestPhotosScreen(),
                          VideosScreen()
                        ],
                        tabStrings: [
                          AppStrings.details,
                          AppStrings.alumini,
                          AppStrings.latestPhotos,
                          AppStrings.videos
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}

GestureDetector labelIcon(
    {required String label, required String icon, required Function() onTap}) {
  return GestureDetector(
    onTap: onTap(),
    child: Row(
      children: [
        CustomWidgets()
            .customIcon(icon: icon, size: 2, color: AppColors.textBlackColor),
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 80,
          child: TabBar(
            physics: NeverScrollableScrollPhysics(),

            controller: _controller,
            unselectedLabelColor: AppColors.textGreyTabColor,
            labelColor: AppColors.textWhiteColor,
            padding: EdgeInsets.symmetric(vertical: 2.0.h),

            onTap: (index) async {
              /*if (index == 2) {
                var res = await pushNewScreenWithRouteSettings(
                  context,
                  screen: const ProfileAboutPage(),
                  settings: const RouteSettings(
                    name: Routes.PROFILE_ABOUT_SCREEN,
                  ),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );

                _controller!.index = 0;
              }*/
            },
            tabs: widget.tabStrings
                .map((e) => Tab(
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            e,
                            style: TextStyle(fontSize: 16),
                          ) /*CustomWidgets.text(AppStrings.publics)*/),
                    ))
                .toList(),
            // labelPadding: EdgeInsets.zero,
            indicatorPadding: EdgeInsets.all(1.0),
            indicatorWeight: 0.08,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              gradient: LinearGradient(colors: [
                AppColors.topYellowColor,
                AppColors.btnTabOrangeColor,
                AppColors.bottomOrangeColor
              ]),
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
            physics: NeverScrollableScrollPhysics(),
            controller: _controller,
            children: widget.tabPage,
          ),
        ),
      ],
    );
  }
}

class LiveUserDetails extends StatefulWidget {
  const LiveUserDetails({Key? key}) : super(key: key);

  @override
  State<LiveUserDetails> createState() => _LiveUserDetailsState();
}

class _LiveUserDetailsState extends State<LiveUserDetails> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 18, top: 14),
          child: Align(
            alignment: Alignment.centerLeft,
            child: CustomWidgets.text("Write a Post",
                color: AppColors.textBlackColor),
          ),
        ),
        SizedBox(
          height: 2.h,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                    color: AppColors.textGreyColor, width: 0.0),
              ),
              contentPadding: EdgeInsets.all(8),
              isDense: true,
              hintStyle:
                  const TextStyle(color: AppColors.textGreyColor, fontSize: 15),
              hintText: "Type a message..",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {},
                  child: CustomWidgets()
                      .customIcon(icon: Assets.iconsSmileyLive, size: 2),
                ),
              ),
              suffixIcon: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
                mainAxisSize: MainAxisSize.min, // added line
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: CustomWidgets().customIcon(
                              icon: Assets.iconsCameraLive, size: 2.5),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: () {},
                            child: CustomWidgets().customIcon(
                                icon: Assets.iconsMenuLive, size: 2.5),
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: CustomWidgets()
                              .customIcon(icon: Assets.iconsSendLiveMessage),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 2.h,
        ),
        Expanded(
            child: ListView.separated(
          itemCount: 7,
          itemBuilder: (context, index) {
            return CustomStatusListTile();
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 1.h,
            );
          },
        )),
      ],
    );
  }
}
