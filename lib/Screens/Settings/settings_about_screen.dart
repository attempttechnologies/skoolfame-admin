import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:skoolfame/Bloc/Setting/setting_bloc.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Utils/app_strings.dart';
import 'package:skoolfame/Widgets/custom_widget.dart';
import 'package:skoolfame/Widgets/wrapper.dart';
import 'package:skoolfame/generated/assets.dart';

class SettingsAboutScreen extends StatefulWidget {
  const SettingsAboutScreen({Key? key}) : super(key: key);

  @override
  State<SettingsAboutScreen> createState() => _SettingsAboutScreenState();
}

class _SettingsAboutScreenState extends State<SettingsAboutScreen> {
  var settingBloc = SettingBloc();
  @override
  void initState() {
    settingBloc.add(AboutUsApiEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrapper(
        isBackIcon: true,
        title: AppStrings.about,
        centerTitle: true,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 28),
          child: BlocBuilder<SettingBloc, SettingState>(
            bloc: settingBloc,
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 74),
                        child: Image.asset(Assets.imagesSkoolfameAbout),
                      )),
                  SizedBox(
                    height: 4.h,
                  ),
                  state is AboutUsSuccessState
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: CustomWidgets.text(
                              "Almost every iphone app has an about page accessible from the main menu, it basically serves as an informational post where you place the company/ author name, and other details like version numbers, websites, or really anything you want unrelated to actual gameplay",
                              color: AppColors.textGreyTabColor,
                              fontSize: 13),
                        )
                      : Container()
                ],
              );
            },
          ),
        ));
  }
}
