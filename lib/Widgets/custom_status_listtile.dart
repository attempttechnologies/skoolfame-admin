import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import 'package:skoolfame/Bloc/Activity/activity_bloc.dart';
import 'package:skoolfame/Data/API/api_manager.dart';
import 'package:skoolfame/Data/Models/GetMessageModel.dart';
import 'package:skoolfame/Data/Models/login_success_respo_model.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Utils/app_strings.dart';
import 'package:skoolfame/Utils/constants.dart';
import 'package:skoolfame/Widgets/custom_widget.dart';
import 'package:skoolfame/generated/assets.dart';

class CustomStatusListTile extends StatelessWidget {
  CustomStatusListTile({
    Key? key,
    this.messageData,
  }) : super(key: key);
  MessageData? messageData;
  var activityBloc = ActivityBloc();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.textGreyColor,
            width: 0,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(14.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              messageData!.senderUser!.userProfileImage == ""
                  ? CircleAvatar(
                      radius: 22,
                      backgroundColor: AppColors.colorPrimary,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          Assets.imagesUser,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : CircleAvatar(
                      radius: 22,
                      backgroundColor: AppColors.colorPrimary,
                      backgroundImage: NetworkImage(APIManager.baseUrl +
                          messageData!.senderUser!.userProfileImage!),
                    ),
              SizedBox(
                width: 2.8.w,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CustomWidgets.text(
                                messageData!.senderUser!.firstName! +
                                    " " +
                                    messageData!.senderUser!.lastName!,
                                color: AppColors.textBlackColor,
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold),
                            SizedBox(
                              width: 1.w,
                            ),
                            CustomWidgets.text(
                              "Updated their status",
                              color: AppColors.textLightGreyColor,
                              fontSize: 11,
                            ),
                          ],
                        ),
                        messageData!.senderUser!.sId !=
                                LoginSuccessResponse.fromJson(GetStorage()
                                        .read(AppPreferenceString.pUserData))
                                    .data!
                                    .sId
                            ? Container()
                            : GestureDetector(
                                onTap: () {
                                  CustomWidgets().showConfirmationDialog(
                                      context,
                                      title:
                                          "Are you sure want to delete this activity?",
                                      onTap: (currentContext) {
                                    activityBloc.add(DeleteActivityApiEvent(
                                        {"id": messageData!.sId!}));
                                  });
                                },
                                child: CustomWidgets().customIcon(
                                    icon: Assets.iconsDelete, size: 2.2),
                              )
                      ],
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    messageData!.messageType == "image"
                        ? Image.network(
                            APIManager.baseUrl + messageData!.message!)
                        : CustomWidgets.text(messageData!.message!,
                            color: AppColors.textStatusGreyColor,
                            fontSize: 11,
                            textAlign: TextAlign.start),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomWidgets()
                            .customIcon(icon: Assets.iconsTime, size: 1.5),
                        SizedBox(
                          width: 1.w,
                        ),
                        CustomWidgets.text(
                          "10",
                          color: AppColors.textTagGreyColor,
                          fontSize: 8.8,
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        CustomWidgets.text(AppStrings.hoursAgo,
                            color: AppColors.textTagGreyColor, fontSize: 8.8),
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
  }
}
