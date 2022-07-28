import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sizer/sizer.dart';
import 'package:skoolfame/Bloc/Setting/setting_bloc.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Utils/app_strings.dart';
import 'package:skoolfame/Utils/appbar_manager.dart';
import 'package:skoolfame/Widgets/custom_widget.dart';
import 'package:skoolfame/Widgets/wrapper.dart';
import 'package:skoolfame/generated/assets.dart';
import 'package:skoolfame/main.dart';

class FeedBackScreen extends StatefulWidget {
  const FeedBackScreen({Key? key}) : super(key: key);

  @override
  State<FeedBackScreen> createState() => _FeedBackScreenState();
}

class _FeedBackScreenState extends State<FeedBackScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var settingBloc = SettingBloc();
  var rate;
  var commentController = TextEditingController();
  var emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    appBarManager.updateAppBarStatus(true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingBloc, SettingState>(
      bloc: settingBloc,
      listener: (context, state) {
        if (state is FeedbackSuccessState) {
          const SnackBar snackBar = SnackBar(
              content: Text("Feedback added successfully"),
              backgroundColor: AppColors.colorPrimary,
              behavior: SnackBarBehavior.floating);
          snackbarKey.currentState?.showSnackBar(snackBar);
        }
      },
      child: BlocBuilder<SettingBloc, SettingState>(
        bloc: settingBloc,
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Wrapper(
              isBackIcon: true,
              title: AppStrings.feedback,
              centerTitle: true,
              actions: InkWell(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    FocusManager.instance.primaryFocus?.unfocus();

                    settingBloc.add(FeedbackApiEvent({
                      "rate": rate ?? "0.0",
                      "comment": commentController.text,
                      "email": emailController.text
                    }));
                    _formKey.currentState!.reset();
                    rate = 0.0;
                    Navigator.pop(context);
                  }
                },
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomWidgets.text("Send",
                      fontSize: 13, fontWeight: FontWeight.w700),
                )),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: CustomWidgets.text(AppStrings.rateExperiance,
                          color: AppColors.textBlackColor,
                          textAlign: TextAlign.start),
                    ),
                    SizedBox(height: 3.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RatingBar(
                          initialRating: 0,
                          minRating: 0,
                          direction: Axis.horizontal,
                          itemCount: 5,
                          itemSize: 35.0,
                          itemPadding: EdgeInsets.only(right: 5),
                          ratingWidget: RatingWidget(
                              full: CustomWidgets().customIcon(
                                icon: Assets.iconsFillStar,
                              ),
                              half: Container(),
                              empty: CustomWidgets()
                                  .customIcon(icon: Assets.iconsBorderStar)),
                          allowHalfRating: false,
                          unratedColor: Colors.transparent,
                          onRatingUpdate: (rating) {
                            rate = rating;
                            setState(() {});
                          },
                        ),
                        SizedBox(
                          width: 2.0.w,
                        ),
                        CustomWidgets.text(
                          rate == null ? "0.0" : "${rate}",
                          color: AppColors.ratingBarColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: CustomWidgets.text(AppStrings.comment,
                          color: AppColors.textBlackColor,
                          textAlign: TextAlign.start),
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    TextFormField(
                      controller: commentController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                              color: AppColors.textGreyColor, width: 0.0),
                        ),
                        contentPadding: EdgeInsets.all(8),
                        isDense: true,
                        hintStyle: const TextStyle(
                            color: AppColors.textGreyColor, fontSize: 15),
                        hintText:
                            "Love the app but it crashes when i try to upload a photo from the library",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter comment";
                        }
                      },
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 2.5.h,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: CustomWidgets.text(AppStrings.enterEmail,
                          color: AppColors.textBlackColor,
                          textAlign: TextAlign.start),
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                                color: AppColors.textGreyColor, width: 0.0),
                          ),
                          contentPadding: EdgeInsets.all(8),
                          // isDense: true,
                          hintStyle: const TextStyle(
                              color: AppColors.textGreyColor, fontSize: 15),
                          hintText: "larensammy@gmail.com",
                        ),
                        style: TextStyle(fontSize: 15),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter email";
                          } else if (!RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                            return 'Please enter valid email';
                          }
                        }),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomWidgets.text(AppStrings.poweredBy,
                                color: AppColors.textBlackColor),
                            SizedBox(
                              width: 4,
                            ),
                            CustomWidgets.text(AppStrings.terms,
                                color: AppColors.ratingBarColor),
                          ],
                        ),
                      ),
                    )
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
