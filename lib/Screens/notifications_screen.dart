import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:skoolfame/Bloc/Notification/notification_bloc.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Utils/app_strings.dart';
import 'package:skoolfame/Widgets/custom_widget.dart';
import 'package:skoolfame/Widgets/wrapper.dart';
import 'package:skoolfame/generated/assets.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsState();
}

class _NotificationsState extends State<NotificationsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var notificationBloc = NotificationBloc();

  @override
  void initState() {
    notificationBloc.add(GetNotificationEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      title: AppStrings.notifications,
      centerTitle: true,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: BlocListener<NotificationBloc, NotificationState>(
          bloc: notificationBloc,
          listener: (context, state) {
            if (state is DeleteNotificationSuccessState ||
                state is DeleteAllNotificationSuccessState) {
              notificationBloc.add(GetNotificationEvent());
            }
          },
          child: BlocBuilder<NotificationBloc, NotificationState>(
            bloc: notificationBloc,
            builder: (context, state) {
              if (state is GetNotificationSuccessState) {
                return state.notificationResponse.notificationData!.isEmpty
                    ? Center(
                        child: CustomWidgets.text(AppStrings.nothingFound,
                            color: AppColors.textGreyColor,
                            fontWeight: FontWeight.w600))
                    : Column(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () {
                                notificationBloc
                                    .add(DeleteAllNotificationApiEvent({}));
                              },
                              child: CustomWidgets.text(AppStrings.dismissAll,
                                  color: AppColors.textRedColor),
                            ),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Expanded(
                            child: RefreshIndicator(
                              onRefresh: _pullRefresh,
                              child: ListView.separated(
                                itemCount: state.notificationResponse
                                    .notificationData!.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    // height: 5.h,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 0,
                                        color: AppColors.textGreyColor,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8.0)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: 80.w,
                                            child: CustomWidgets.text(
                                                state
                                                    .notificationResponse
                                                    .notificationData![index]
                                                    .notificationText!,
                                                color: AppColors
                                                    .textNotificationGreyColor,
                                                fontSize: 11,
                                                maxLine: 1,
                                                textAlign: TextAlign.start,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              notificationBloc.add(
                                                  DeleteNotificationApiEvent({
                                                "id": state
                                                    .notificationResponse
                                                    .notificationData![index]
                                                    .sId
                                              }));
                                            },
                                            child: CustomWidgets().customIcon(
                                                icon: Assets.iconsDismissAll,
                                                size: 1.4),
                                          )
                                        ],
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
                          )
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
    notificationBloc.add(GetNotificationEvent());
  }
}
