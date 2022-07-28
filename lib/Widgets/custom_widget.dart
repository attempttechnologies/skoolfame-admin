import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Widgets/my_button.dart';
import 'package:skoolfame/generated/assets.dart';

class CustomWidgets {
  static Text text(
    String content, {
    Color? color = AppColors.textWhiteColor,
    double? fontSize = 12,
    FontWeight? fontWeight = FontWeight.normal,
    int? maxLine,
    double? letterSpacing = 0.0,
    TextAlign textAlign = TextAlign.center,
    double? height = 1.7,
    TextOverflow? overflow,
  }) {
    return Text(content,
        textAlign: textAlign,
        maxLines: maxLine,
        overflow: overflow,
        style: GoogleFonts.lato(
          letterSpacing: letterSpacing,
          color: color,
          fontSize: fontSize!.sp,
          fontWeight: fontWeight,
        ));
  }

  /// Container custom box decoration with some default style and also customizable
  ///
  static BoxDecoration customBoxDecoration(
      {Color color = AppColors.textWhiteColor,
      bool isBoxShadow = true,
      bool isBorderEnable = false,
      Color borderColor = AppColors.textBlackColor,
      double borderRadius = 20}) {
    return BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
        border:
            isBorderEnable ? Border.all(color: borderColor, width: 0.8) : null,
        boxShadow: isBoxShadow
            ? [
                BoxShadow(
                    spreadRadius: 5,
                    offset: const Offset(4, 4),
                    blurRadius: 13,
                    color: Colors.grey.withOpacity(0.2))
              ]
            : []);
  }

  /// Show progress indicator when API call Or any other async method call
  ///
  showProgressIndicator() {
    return EasyLoading.show(
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
        status: 'Loading');
  }

  /// Custom error ErrorSnackBar design for show error
  ///
  /// Call `Get.showSnackbar(ErrorSnackBar(title: 'Error!', message: response.body.toString()));` for show ErrorSnackBar
  GetSnackBar errorSnackBar({String title = 'Error', String? message}) {
    Get.log("[$title] $message", isError: true);
    return GetSnackBar(
      titleText: text(title.tr,
          textAlign: TextAlign.left,
          color: AppColors.textWhiteColor,
          fontSize: 12.0,
          height: 1.0,
          fontWeight: FontWeight.bold),
      messageText: text(
        message!,
        color: AppColors.textWhiteColor,
        fontSize: 10.0,
        height: 1.0,
        textAlign: TextAlign.left,
      ),
      snackPosition: SnackPosition.BOTTOM,
      shouldIconPulse: true,
      margin: const EdgeInsets.all(20),
      backgroundColor: Colors.redAccent,
      icon: const Icon(Icons.remove_circle_outline,
          size: 25.0, color: AppColors.textWhiteColor),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      borderRadius: 8,
      duration: const Duration(seconds: 3),
    );
  }

  GetSnackBar successSnackBar({String title = 'Success', String? message}) {
    Get.log("[$title] $message", isError: true);
    return GetSnackBar(
      titleText: text(title.tr,
          textAlign: TextAlign.left,
          color: AppColors.textBlackColor,
          fontSize: 12.0,
          height: 1.0,
          fontWeight: FontWeight.bold),
      messageText: text(
        message!,
        color: AppColors.textBlackColor,
        fontSize: 10.0,
        height: 1.0,
        textAlign: TextAlign.left,
      ),
      isDismissible: false,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(20),
      backgroundColor: Colors.greenAccent,
      icon:
          const Icon(Icons.check, size: 25.0, color: AppColors.textBlackColor),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      borderRadius: 8,
      duration: const Duration(seconds: 3),
    );
  }

  /// Create the 4.0.h * 4.0.h size icon you can adjust size according requirement, pass the asset image path as named parameter
  ///
  Container customIcon(
      {required String? icon, double size = 4.0, Color? color}) {
    return Container(
      height: size.h,
      width: size.h,
      child: Image.asset(
        icon!,
        color: color,
      ),
    );
  }

  static InputDecoration inputPrefixDecoration(
      {String? prefixIcon, String? hint}) {
    return InputDecoration(
      prefixIcon: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Image.asset(
          prefixIcon!,
          height: 18.0,
          width: 18.0,
          alignment: Alignment.centerLeft,
        ),
      ),
      isDense: false,
      hintText: "$hint",
      hintStyle: GoogleFonts.lato(
          color: AppColors.textWhiteColor,
          fontWeight: FontWeight.bold,
          fontSize: 18),
      counterText: '',
      // isDense: true,
      border: const UnderlineInputBorder(
          borderSide:
              const BorderSide(color: AppColors.colorPrimaryLight, width: 2)),
      focusedBorder: const UnderlineInputBorder(
          borderSide:
              const BorderSide(color: AppColors.colorPrimaryLight, width: 2)),
      enabledBorder: const UnderlineInputBorder(
          borderSide:
              const BorderSide(color: AppColors.colorPrimaryLight, width: 2)),
      // contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    );
  }

  static InputDecoration customInputDecoration({String? hint}) {
    return InputDecoration(
      hintText: "$hint",
      hintStyle: GoogleFonts.lato(
          color: AppColors.textWhiteColor,
          fontWeight: FontWeight.bold,
          fontSize: 18),
      counterText: '',
      // isDense: true,
      border: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.colorPrimaryLight, width: 2)),
      focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.colorPrimaryLight, width: 2)),
      enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.colorPrimaryLight, width: 2)),
      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
    );
  }

  ///Custom divider
  Divider customDivider(
      {Color color = AppColors.colorPrimaryLight, double size = 1.0}) {
    return Divider(
      color: color,
      height: size.h,
    );
  }

  static AppBar myAppBar(
      {required GlobalKey<ScaffoldState> scaffoldKey,
      required String title,
      bool centerTitle = false,
      bool isBackIcon = false,
      BuildContext? context,
      List<Widget>? actions}) {
    return AppBar(
      title:
          CustomWidgets.text(title, fontSize: 15, fontWeight: FontWeight.w700),
      centerTitle: centerTitle,
      leading: GestureDetector(
          onTap: () {
            scaffoldKey.currentState!.openDrawer();
          },
          child: Container(
            padding: const EdgeInsets.all(17),
            child: isBackIcon
                ? GestureDetector(
                    onTap: () {
                      Navigator.pop(context!);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.textWhiteColor,
                    ))
                : Image.asset(
                    Assets.iconsMenu,
                  ),
          )),
      actions: actions ??
          [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: isBackIcon
                  ? Container()
                  : Image.asset(
                      Assets.iconsSearch,
                    ),
            ),
          ],
      elevation: 0,
      backgroundColor: AppColors.colorPrimaryLight,
    );
  }

  showConfirmationDialog(BuildContext context,
      {required String title, required Function(dynamic) onTap}) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: CustomWidgets().customIcon(icon: Assets.iconsAlert),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                CustomWidgets.text("Are you Sure?",
                    color: AppColors.textBlackColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700),
                SizedBox(
                  height: 0.5.h,
                ),
                CustomWidgets.text(title,
                    color: AppColors.textGreyColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w400),
                SizedBox(
                  height: 4.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: MyButton(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          color: AppColors.textGreyColor.withOpacity(0.6),
                          textStyle: const TextStyle(
                              color: AppColors.textWhiteColor, fontSize: 18),
                          label: "Cancel",
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Expanded(
                      child: MyButton(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          color: AppColors.colorPrimary,
                          textStyle: const TextStyle(
                              color: AppColors.textWhiteColor, fontSize: 18),
                          label: "OK",
                          onPressed: () => onTap(context)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
