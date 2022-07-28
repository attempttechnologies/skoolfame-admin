import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import 'package:skoolfame/Bloc/Activity/activity_bloc.dart';
import 'package:skoolfame/Data/API/api_manager.dart';
import 'package:skoolfame/Data/Models/login_success_respo_model.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Utils/app_strings.dart';
import 'package:skoolfame/Utils/constants.dart';
import 'package:skoolfame/Utils/custom_date_formatter.dart';
import 'package:skoolfame/Widgets/custom_widget.dart';
import 'package:skoolfame/Widgets/wrapper.dart';
import 'package:skoolfame/generated/assets.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({Key? key}) : super(key: key);

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var activityBloc = ActivityBloc();
  @override
  void initState() {
    activityBloc.add(GetActivityApiEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      title: AppStrings.activity,
      centerTitle: true,
      child: BlocListener<ActivityBloc, ActivityState>(
        bloc: activityBloc,
        listener: (context, state) {
          if (state is DeleteActivitySuccessState) {
            Navigator.pop(context);
            activityBloc.add(GetActivityApiEvent());
          }
        },
        child: BlocBuilder<ActivityBloc, ActivityState>(
          bloc: activityBloc,
          builder: (context, state) {
            if (state is GetActivitySuccessState) {
              return Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Column(
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _pullRefresh,
                        child: state.getActivityResponse.messageData!.isEmpty
                            ? Center(
                                child: CustomWidgets.text(
                                    AppStrings.nothingFound,
                                    color: AppColors.textGreyColor,
                                    fontWeight: FontWeight.w600))
                            : ListView.separated(
                                itemCount: state
                                    .getActivityResponse.messageData!.length,
                                padding: EdgeInsets.only(bottom: 1.0.h),
                                itemBuilder: (context, index) {
                                  var messageData = state
                                      .getActivityResponse.messageData![index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColors.textGreyColor,
                                          width: 0,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(14.0)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            messageData.senderUser!
                                                        .userProfileImage ==
                                                    ""
                                                ? CircleAvatar(
                                                    radius: 22,
                                                    backgroundColor:
                                                        AppColors.colorPrimary,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Image.asset(
                                                        Assets.imagesUser,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  )
                                                : CircleAvatar(
                                                    radius: 22,
                                                    backgroundColor:
                                                        AppColors.colorPrimary,
                                                    backgroundImage:
                                                        NetworkImage(APIManager
                                                                .baseUrl +
                                                            messageData
                                                                .senderUser!
                                                                .userProfileImage!),
                                                  ),
                                            SizedBox(
                                              width: 2.8.w,
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          CustomWidgets.text(
                                                              messageData
                                                                      .senderUser!
                                                                      .firstName! +
                                                                  " " +
                                                                  messageData
                                                                      .senderUser!
                                                                      .lastName!,
                                                              color: AppColors
                                                                  .textBlackColor,
                                                              fontSize: 11.5,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ],
                                                      ),
                                                      messageData.senderUser!
                                                                  .sId !=
                                                              LoginSuccessResponse.fromJson(
                                                                      GetStorage()
                                                                          .read(
                                                                              AppPreferenceString.pUserData))
                                                                  .data!
                                                                  .sId
                                                          ? Container()
                                                          : GestureDetector(
                                                              onTap: () {
                                                                CustomWidgets()
                                                                    .showConfirmationDialog(
                                                                        context,
                                                                        title:
                                                                            "Are you sure want to delete this activity?",
                                                                        onTap:
                                                                            (currentContext) {
                                                                  activityBloc.add(
                                                                      DeleteActivityApiEvent({
                                                                    "id":
                                                                        messageData
                                                                            .sId!
                                                                  }));
                                                                });
                                                              },
                                                              child: CustomWidgets()
                                                                  .customIcon(
                                                                      icon: Assets
                                                                          .iconsDelete,
                                                                      size:
                                                                          2.2),
                                                            )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 1.h,
                                                  ),
                                                  messageData.messageType ==
                                                          "image"
                                                      ? Image.network(APIManager
                                                              .baseUrl +
                                                          messageData.message!)
                                                      : CustomWidgets.text(
                                                          messageData.message!,
                                                          color: AppColors
                                                              .textStatusGreyColor,
                                                          fontSize: 11,
                                                          textAlign:
                                                              TextAlign.start),
                                                  SizedBox(
                                                    height: 1.5.h,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      CustomWidgets()
                                                          .customIcon(
                                                              icon: Assets
                                                                  .iconsTime,
                                                              size: 1.5),
                                                      SizedBox(
                                                        width: 1.w,
                                                      ),
                                                      CustomWidgets.text(
                                                        DateFormatter()
                                                            .getVerboseDateTimeRepresentation(
                                                          DateTime.parse(
                                                              messageData
                                                                  .createdAt!),
                                                        ),
                                                        color: AppColors
                                                            .textTagGreyColor,
                                                        fontSize: 8.8,
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
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
                              ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return Center(
                child: CustomWidgets.text(AppStrings.nothingFound,
                    color: AppColors.textGreyColor,
                    fontWeight: FontWeight.w600));
          },
        ),
      ),
    );
  }

  Future<void> _pullRefresh() async {
    activityBloc.add(GetActivityApiEvent());
  }
}
