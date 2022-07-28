import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:skoolfame/Data/Models/login_success_respo_model.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Utils/app_strings.dart';
import 'package:skoolfame/Utils/constants.dart';
import 'package:skoolfame/Widgets/custom_widget.dart';

class DetailsPage extends StatefulWidget {
  String screen;
  DetailsPage({
    Key? key,
    required this.screen,
    this.userData,
  }) : super(key: key);
  UserData? userData;
  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  UserData userData = UserData();
  @override
  void initState() {
    if (widget.screen == "friend") {
      userData = widget.userData as UserData;
      userData.privacy ?? "public";
    } else {
      userData = LoginSuccessResponse.fromJson(
              GetStorage().read(AppPreferenceString.pUserData))
          .data as UserData;
      userData.privacy ?? "public";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            customDetails(
                label: AppStrings.firstName, details: userData.firstName!),
            customDetails(
                label: AppStrings.lastName, details: userData.lastName!),
            customDetails(label: AppStrings.sex, details: userData.gender!),
            customDetails(
                label: AppStrings.birthday,
                details: DateFormat("MM/dd/yyyy")
                    .format(DateTime.parse(userData.dob!.toString()))),
            customDetails(label: AppStrings.email, details: userData.email!),
            widget.screen == 'friend'
                ? customDetails(label: AppStrings.privacy, details: "Public")
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomWidgets.text(AppStrings.youAre,
                              color: AppColors.textGreyColor),
                          CustomWidgets.text(
                              userData.privacy == "private"
                                  ? "Visible to none of friends"
                                  : "Visible to friends",
                              color: AppColors.textBlackColor),
                        ],
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      // const Divider(
                      //   thickness: 1,
                      // ),
                      // SizedBox(
                      //   height: 1.h,
                      // ),
                    ],
                  ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     CustomWidgets.text(AppStrings.connectTo,
            //         color: AppColors.textGreyColor),
            //     Row(
            //       children: [
            //         CustomWidgets()
            //             .customIcon(icon: Assets.iconsFacebookBlue, size: 3),
            //         SizedBox(
            //           width: 2.w,
            //         ),
            //         CustomWidgets()
            //             .customIcon(icon: Assets.iconsTwitter, size: 3),
            //         SizedBox(
            //           width: 2.w,
            //         ),
            //         CustomWidgets()
            //             .customIcon(icon: Assets.iconsGoogle, size: 3),
            //       ],
            //     )
            //   ],
            // ),
            SizedBox(
              height: 4.h,
            ),
          ],
        ),
      ),
    );
  }

  customDetails({required String label, required String details}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomWidgets.text(label, color: AppColors.textGreyColor),
            Container(
                width: 65.w,
                child: CustomWidgets.text(details,
                    maxLine: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    color: AppColors.textBlackColor)),
          ],
        ),
        SizedBox(
          height: 1.h,
        ),
        const Divider(
          thickness: 1,
        ),
        SizedBox(
          height: 1.h,
        ),
      ],
    );
  }
}
