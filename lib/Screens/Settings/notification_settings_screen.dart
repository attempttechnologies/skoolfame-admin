import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:skoolfame/Bloc/Notification/notification_bloc.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Utils/app_strings.dart';
import 'package:skoolfame/Utils/appbar_manager.dart';
import 'package:skoolfame/Widgets/custom_widget.dart';
import 'package:skoolfame/Widgets/wrapper.dart';
import 'package:skoolfame/generated/assets.dart';
import 'package:skoolfame/main.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> notificationsTypeList = [
    AppStrings.site,
    AppStrings.email,
    AppStrings.both
  ];
  String notificationsTypeOptionSelect = AppStrings.site;
  var _notificationBloc = NotificationBloc();
  var comment = AppStrings.site;
  var friend_request = AppStrings.site;
  var relationship_request = AppStrings.site;
  var message = AppStrings.site;
  @override
  void initState() {
    _notificationBloc.add(GetNotificationSettingApiEvent());

    super.initState();
  }

  @override
  void dispose() {
    appBarManager.updateAppBarStatus(true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationBloc, NotificationState>(
      bloc: _notificationBloc,
      listener: (context, state) {
        if (state is UpdateNotificationSettingSuccessState) {
          const SnackBar snackBar = SnackBar(
              content: Text('Notification Updated Successfully!'),
              backgroundColor: AppColors.colorPrimary,
              behavior: SnackBarBehavior.floating);
          snackbarKey.currentState?.showSnackBar(snackBar);
          _notificationBloc.add(GetNotificationSettingApiEvent());
        }
        if (state is GetNotificationSettingSuccessState) {
          comment =
              state.getNotificationSettingSuccessState.settingData!.comment!;
          friend_request = state
              .getNotificationSettingSuccessState.settingData!.friendRequest!;
          message =
              state.getNotificationSettingSuccessState.settingData!.message!;
          relationship_request = state.getNotificationSettingSuccessState
              .settingData!.relationshipRequest!;
        }
      },
      child: BlocBuilder<NotificationBloc, NotificationState>(
        bloc: _notificationBloc,
        builder: (context, state) {
          return Wrapper(
            isBackIcon: true,
            title: AppStrings.notifications,
            centerTitle: true,
            actions: InkWell(
              onTap: () {
                _notificationBloc.add(UpdateNotificationSettingApiEvent({
                  "comment": comment,
                  "friend_request": friend_request,
                  "relationship_request": relationship_request,
                  "message": message
                }));
              },
              child: CustomWidgets.text("Save",
                  fontSize: 13, fontWeight: FontWeight.w700),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 24, bottom: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: CustomWidgets.text(AppStrings.notifyByMe,
                          color: AppColors.textGreyColor,
                          textAlign: TextAlign.start),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1.3,
                            color: AppColors.textNotificationGreyColor
                                .withOpacity(0.7)),
                        color: AppColors.textWhiteColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: Container(),
                        icon: CustomWidgets()
                            .customIcon(icon: Assets.iconsDownArrow, size: 2.3),
                        dropdownColor: AppColors.textWhiteColor,
                        value: comment,
                        items: notificationsTypeList.map((String value) {
                          return DropdownMenuItem<String>(
                              value: value,
                              child: CustomWidgets.text(value,
                                  color: AppColors.textBlackColor));
                        }).toList(),
                        onChanged: (v) {
                          setState(() {
                            comment = v!;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 2.5.h,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: CustomWidgets.text(AppStrings.notifyFriendRequest,
                          color: AppColors.textGreyColor,
                          textAlign: TextAlign.start),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1.3,
                            color: AppColors.textNotificationGreyColor
                                .withOpacity(0.7)),
                        color: AppColors.textWhiteColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: Container(),
                        icon: CustomWidgets()
                            .customIcon(icon: Assets.iconsDownArrow, size: 2.3),
                        dropdownColor: AppColors.textWhiteColor,
                        value: friend_request,
                        items: notificationsTypeList.map((String value) {
                          return DropdownMenuItem<String>(
                              value: value,
                              child: CustomWidgets.text(value,
                                  color: AppColors.textBlackColor));
                        }).toList(),
                        onChanged: (v) {
                          setState(() {
                            friend_request = v!;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 2.5.h,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: CustomWidgets.text(AppStrings.sendMeAMessage,
                          color: AppColors.textGreyColor,
                          textAlign: TextAlign.start),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1.3,
                            color: AppColors.textNotificationGreyColor
                                .withOpacity(0.7)),
                        color: AppColors.textWhiteColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: Container(),
                        icon: CustomWidgets()
                            .customIcon(icon: Assets.iconsDownArrow, size: 2.3),
                        dropdownColor: AppColors.textWhiteColor,
                        value: message,
                        items: notificationsTypeList.map((String value) {
                          return DropdownMenuItem<String>(
                              value: value,
                              child: CustomWidgets.text(value,
                                  color: AppColors.textBlackColor));
                        }).toList(),
                        onChanged: (v) {
                          setState(() {
                            message = v!;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 2.5.h,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: CustomWidgets.text(
                          AppStrings.notifyRelationshipRequest,
                          color: AppColors.textGreyColor,
                          textAlign: TextAlign.start),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1.3,
                            color: AppColors.textNotificationGreyColor
                                .withOpacity(0.7)),
                        color: AppColors.textWhiteColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: Container(),
                        icon: CustomWidgets()
                            .customIcon(icon: Assets.iconsDownArrow, size: 2.3),
                        dropdownColor: AppColors.textWhiteColor,
                        value: relationship_request,
                        items: notificationsTypeList.map((String value) {
                          return DropdownMenuItem<String>(
                              value: value,
                              child: CustomWidgets.text(value,
                                  color: AppColors.textBlackColor));
                        }).toList(),
                        onChanged: (v) {
                          setState(() {
                            relationship_request = v!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
