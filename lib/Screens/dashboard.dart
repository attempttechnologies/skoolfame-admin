import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:skoolfame/Bloc/Live/live_bloc.dart';
import 'package:skoolfame/Bloc/Message/message_bloc.dart';
import 'package:skoolfame/Routes/routes.dart';
import 'package:skoolfame/Screens/Friends/friends_screen.dart';
import 'package:skoolfame/Screens/Friends/search_friends_screen.dart';
import 'package:skoolfame/Screens/Home/home_screen.dart';
import 'package:skoolfame/Screens/Live/live_message.dart';
import 'package:skoolfame/Screens/Messages/message_screen.dart';
import 'package:skoolfame/Screens/Profile/profile_screen.dart';
import 'package:skoolfame/Screens/Settings/setting_screen.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Utils/appbar_manager.dart';
import 'package:skoolfame/Widgets/custom_drawer.dart';
import 'package:skoolfame/Widgets/custom_widget.dart';
import 'package:skoolfame/generated/assets.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedIndex = 0;
  int _profileTabsIndex = 0;
  var liveBloc = LiveBloc();
  var messageBloc = MessageBloc();

  bool _shouldShowAppBar = true;
  @override
  void initState() {
    // if (!appBarManager.isStreamListen) {
    //   appBarManager.init();
    //   appBarManager.stream.listen((status) {
    //     setState(() {
    //       _shouldShowAppBar = status;
    //     });
    //   });
    // }
    super.initState();
  }

  @override
  void dispose() {
    // appBarManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: appBarManager.valueNotifier,
      builder: (context, value, child) {
        return Scaffold(
            key: _scaffoldKey,
            appBar: value
                ? CustomWidgets.myAppBar(
                    scaffoldKey: _scaffoldKey,
                    title: getTitle(_selectedIndex),
                    actions: getActions(_selectedIndex),
                    centerTitle: true,
                    isBackIcon: false)
                : null,
            drawer: CustomDrawer(),
            body: Container(
              color: AppColors.textRedColor,
              child: PersistentTabView(
                context,
                controller: _controller,
                screens: _buildScreens(),
                items: _navBarsItems(),
                confineInSafeArea: true,
                backgroundColor: Colors.white,
                handleAndroidBackButtonPress: false,
                resizeToAvoidBottomInset: true,
                stateManagement: false,
                navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0
                    ? 0.0
                    : kBottomNavigationBarHeight + 12,
                hideNavigationBarWhenKeyboardShows: false,
                // margin: EdgeInsets.all(10.0),
                // bottomScreenMargin: kBottomNavigationBarHeight,
                decoration: const NavBarDecoration(
                  colorBehindNavBar: Colors.white,
                ),
                popActionScreens: PopActionScreensType.all,
                popAllScreensOnTapOfSelectedTab: false,
                itemAnimationProperties: const ItemAnimationProperties(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.ease,
                ),
                screenTransitionAnimation: const ScreenTransitionAnimation(
                  animateTabTransition: true,
                  curve: Curves.ease,
                  duration: Duration(milliseconds: 300),
                ),
                navBarStyle: NavBarStyle.simple,
                onItemSelected: (v) {
                  if (appBarManager.valueNotifier.value ||
                      _selectedIndex !=
                          _buildScreens().indexOf(FriendsScreen())) {
                    appBarManager.updateAppBarStatus(true);
                  }

                  setState(() {
                    _selectedIndex = v;
                  });
                },
              ),
            ));
      },
    );
  }

  getTitle(int selectedIndex) {
    print(_controller.index);
    switch (selectedIndex) {
      case 0:
        return "Home";
      case 1:
        return "Profile";
      case 2:
        return "Message";
      case 3:
        return "Friends";
      case 4:
        return "Settings";
    }
  }

  getActions(int selectedIndex) {
    print(_controller.index);
    switch (selectedIndex) {
      case 0:
        return [
          Container(),
          // Padding(
          //   padding: const EdgeInsets.all(18.0),
          //   child: Image.asset(
          //     Assets.iconsSearch,
          //   ),
          // ),
        ];
      case 1:
        return [
          BlocBuilder<LiveBloc, LiveState>(
            bloc: liveBloc,
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(18.0),
                child: _profileTabsIndex == 1
                    ? InkWell(
                        onTap: () {},
                        child: Center(
                          child: Image.asset(
                            Assets.iconsGoLiveBtn,
                          ),
                        ),
                      )
                    : GestureDetector(
                        child: Image.asset(
                          Assets.iconsGoLiveBtn,
                        ),
                        onTap: () async {
                          liveBloc.add(LiveUserEvent({"isLive": true}));
                          var res = await pushNewScreenWithRouteSettings(
                            context,
                            screen: const LiveMessage(),
                            settings: const RouteSettings(
                                name: Routes.LIVE_MESSAGE,
                                arguments: {"isBroadcaster": true, "id": ""}),
                            withNavBar: false,
                            pageTransitionAnimation:
                                PageTransitionAnimation.cupertino,
                          );
                        }),
              );
            },
          ),
        ];
      case 2:
        return [
          GestureDetector(
            onTap: () {
              messageBloc.add(SearchMessageEvent());
              print("Click");
            },
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Image.asset(
                Assets.iconsSearch,
              ),
            ),
          ),
        ];
      case 3:
        return [
          GestureDetector(
            onTap: () async {
              // if (appBarManager.valueNotifier.value) {
              //   appBarManager.updateAppBarStatus(true);
              // }

              await pushNewScreenWithRouteSettings(
                context,
                screen: const SearchFriendScreen(),
                settings:
                    const RouteSettings(name: Routes.SEARCH_FRIENDS_SCREEN),
                withNavBar: true,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Image.asset(
                Assets.iconsSearch,
              ),
            ),
          ),
        ];
      case 4:
        return [Container()];
    }
  }

  List<Widget> _buildScreens() {
    return [
      const HomeScreen(),
      ProfileScreen(onTap: (index) {
        setState(() {
          _profileTabsIndex = index;
        });
      }),
      const MessageScreen(),
      FriendsScreen(),
      const SettingScreen(),
    ];
  }

  ///
  /// This method is used to generate the navigation bar items.
  ///
  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: CustomWidgets().customIcon(icon: Assets.iconsNavHome),
        inactiveIcon:
            CustomWidgets().customIcon(icon: Assets.iconsHomeInactive),
        title: "Home",
        activeColorPrimary: AppColors.colorPrimary,
        inactiveColorPrimary: AppColors.textGreyColor,
        textStyle: const TextStyle(fontSize: 12),
      ),
      PersistentBottomNavBarItem(
        icon: CustomWidgets().customIcon(icon: Assets.iconsProfileActive),
        inactiveIcon: CustomWidgets().customIcon(icon: Assets.iconsProfile),
        title: "Profile",
        activeColorPrimary: AppColors.colorPrimary,
        inactiveColorPrimary: AppColors.textGreyColor,
        textStyle: const TextStyle(fontSize: 12),
        // routeAndNavigatorSettings: RouteAndNavigatorSettings(
        //   routes: {
        //     '/${Routes.MY_RELATIONSHIP_ROUTE}': (context) =>
        //         const MyRelationship(),
        //   },
        // ),
      ),
      PersistentBottomNavBarItem(
        icon: CustomWidgets().customIcon(icon: Assets.iconsActiveMsg),
        inactiveIcon: CustomWidgets().customIcon(icon: Assets.iconsMessage),
        title: "Message",
        activeColorPrimary: AppColors.colorPrimary,
        inactiveColorPrimary: AppColors.textGreyColor,
        textStyle: const TextStyle(fontSize: 12),
      ),
      PersistentBottomNavBarItem(
        icon: CustomWidgets().customIcon(icon: Assets.iconsFriendActive),
        inactiveIcon: CustomWidgets().customIcon(icon: Assets.iconsFriends),
        title: "Friends",
        activeColorPrimary: AppColors.colorPrimary,
        inactiveColorPrimary: AppColors.textGreyColor,
        textStyle: const TextStyle(fontSize: 12),
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          routes: {
            '/${Routes.SEARCH_FRIENDS_SCREEN}': (context) =>
                const SearchFriendScreen(),
          },
        ),
      ),
      PersistentBottomNavBarItem(
        icon: CustomWidgets().customIcon(icon: Assets.iconsSettingActive),
        inactiveIcon: CustomWidgets().customIcon(icon: Assets.iconsSetting),
        title: "Settings",
        // routeAndNavigatorSettings: RouteAndNavigatorSettings(
        //   routes: {
        //     '/${Routes.LOGIN_SCREEN_ROUTE}': (context) => const LoginScreen(),
        //   },
        // ),
        activeColorPrimary: AppColors.colorPrimary,
        inactiveColorPrimary: AppColors.textGreyColor,
        textStyle: const TextStyle(fontSize: 12),
      ),
    ];
  }
}
