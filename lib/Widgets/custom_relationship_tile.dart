import 'package:flutter/material.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Widgets/custom_widget.dart';

class CustomRelationshipTile extends StatelessWidget {
  CustomRelationshipTile(
      {Key? key,
      required this.title,
      required this.onTap,
      this.icon = const Icon(
        Icons.arrow_forward_ios,
        color: AppColors.colorPrimary,
        size: 20,
      )})
      : super(key: key);

  final String title;
  final Function() onTap;
  Widget icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("DOne");
        onTap();
      },
      child: Container(
        // height: 5.h,
        decoration: BoxDecoration(
          border: Border.all(
            width: 0,
            color: AppColors.textGreyColor,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomWidgets.text(title, color: AppColors.textBlackColor, fontSize: 12, fontWeight: FontWeight.w500),
              icon
            ],
          ),
        ),
      ),
    );
  }
}
