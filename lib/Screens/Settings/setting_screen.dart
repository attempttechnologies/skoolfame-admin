import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sizer/sizer.dart';
import 'package:skoolfame/Bloc/Login/login_bloc.dart';
import 'package:skoolfame/Routes/routes.dart';
import 'package:skoolfame/Screens/Onboarding/login_screen.dart';
import 'package:skoolfame/Screens/Settings/feedback_screen.dart';
import 'package:skoolfame/Screens/Settings/notification_settings_screen.dart';
import 'package:skoolfame/Screens/Settings/settings_about_screen.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Utils/app_strings.dart';
import 'package:skoolfame/Widgets/custom_drawer.dart';
import 'package:skoolfame/Widgets/custom_relationship_tile.dart';
import 'package:skoolfame/Widgets/custom_widget.dart';
import 'package:skoolfame/Widgets/wrapper.dart';
import 'package:skoolfame/generated/assets.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  var loginBloc = LoginBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorPrimaryLight,
      drawer: CustomDrawer(),
      body: SubWrapper(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: BlocListener<LoginBloc, LoginState>(
            bloc: loginBloc,
            listener: (context, state) {
              if (state is LogoutSuccessState) {
                pushNewScreen(
                  context,
                  screen: LoginScreen(),
                  withNavBar: false, // OPTIONAL VALUE. True by default.
                  pageTransitionAnimation:
                      PageTransitionAnimation.cupertino, // OPTIONAL
                );
                // Navigator.of(context).pushNamedAndRemoveUntil(
                //     Routes.LOGIN_SCREEN_ROUTE,
                //     (route) =>
                //         route.settings.name == Routes.LOGIN_SCREEN_ROUTE);
              }
            },
            child: Column(
              children: [
                CustomRelationshipTile(
                    title: AppStrings.notifications,
                    onTap: () async {
                      await pushNewScreenWithRouteSettings(
                        context,
                        screen: const NotificationSettingsScreen(),
                        settings: const RouteSettings(
                          name: Routes.NOTIFICATION_SETTINGS_SCREEN,
                        ),
                        withNavBar: false,
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      );
                    }),
                SizedBox(
                  height: 2.h,
                ),
                CustomRelationshipTile(
                    title: AppStrings.feedback,
                    onTap: () async {
                      await pushNewScreenWithRouteSettings(
                        context,
                        screen: const FeedBackScreen(),
                        settings: const RouteSettings(
                          name: Routes.FEEDBACK_SCREEN,
                        ),
                        withNavBar: false,
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      );
                    }),
                SizedBox(
                  height: 2.h,
                ),
                CustomRelationshipTile(
                    title: AppStrings.about,
                    onTap: () async {
                      await pushNewScreenWithRouteSettings(
                        context,
                        screen: const SettingsAboutScreen(),
                        settings: const RouteSettings(
                          name: Routes.SETTINGS_ABOUT_SCREEN,
                        ),
                        withNavBar: false,
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      );
                    }),
                SizedBox(
                  height: 2.h,
                ),
                BlocBuilder<LoginBloc, LoginState>(
                  bloc: loginBloc,
                  builder: (context, state) {
                    return CustomRelationshipTile(
                        icon: CustomWidgets().customIcon(
                          color: AppColors.colorPrimary,
                          size: 2.5,
                          icon: Assets.iconsLogout,
                        ),
                        title: AppStrings.logout,
                        onTap: () {
                          loginBloc.add(LogoutApiEvent());
                        });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
