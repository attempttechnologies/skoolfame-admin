import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:skoolfame/Bloc/High%20School/high_school_bloc.dart';
import 'package:skoolfame/Data/Models/school_model.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Utils/app_strings.dart';
import 'package:skoolfame/Widgets/custom_widget.dart';
import 'package:skoolfame/Widgets/my_button.dart';
import 'package:skoolfame/Widgets/wrapper.dart';
import 'package:skoolfame/generated/assets.dart';

class MySuperlativesScreen extends StatefulWidget {
  const MySuperlativesScreen({Key? key}) : super(key: key);

  @override
  State<MySuperlativesScreen> createState() => _MySuperlativesScreenState();
}

class _MySuperlativesScreenState extends State<MySuperlativesScreen> {
  var highSchoolBloc = HighSchoolBloc();
  SchoolData schoolData = SchoolData();

  @override
  void didChangeDependencies() {
    schoolData = ModalRoute.of(context)!.settings.arguments as SchoolData;
    highSchoolBloc.add(GetSelfNomineeApiEvent({"school_id": schoolData.sId}));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      isBackIcon: true,
      title: "My Superlatives",
      centerTitle: true,
      child: BlocListener<HighSchoolBloc, HighSchoolState>(
        bloc: highSchoolBloc,
        listener: (context, state) {
          if (state is WithdrawNomineeSuccessState) {
            print("HElllll");
            Navigator.pop(context);
            highSchoolBloc
                .add(GetSelfNomineeApiEvent({"school_id": schoolData.sId}));
          }
        },
        child: BlocBuilder<HighSchoolBloc, HighSchoolState>(
          bloc: highSchoolBloc,
          builder: (context, state) {
            if (state is GetSelfNomineeSuccessState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Container(
                      // height: 5.h,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 0,
                          color: AppColors.textGreyColor,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomWidgets().customIcon(
                                    icon: Assets.iconsIconsHighSchool, size: 7),
                                SizedBox(
                                  width: 3.w,
                                ),
                                Expanded(
                                  child: Column(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomWidgets.text(schoolData.name!,
                                          color: AppColors.textBlackColor,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      CustomWidgets.text(schoolData.address!,
                                          color: AppColors.textTagGreyColor,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            SizedBox(height: 0.5.h),
                            CustomWidgets.text("Superlatives",
                                color: AppColors.textBlackColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w700),
                            SizedBox(height: 2.h),
                            state.getSelfNomineeResponse.superlativeData!
                                        .length ==
                                    0
                                ? Center(
                                    child: CustomWidgets.text(
                                        AppStrings.nothingFound,
                                        color: AppColors.textGreyColor,
                                        fontWeight: FontWeight.w600))
                                : ListView.separated(
                                    shrinkWrap: true,
                                    itemCount: state.getSelfNomineeResponse
                                        .superlativeData!.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        // height: 10.h,
                                        width: 100.w,
                                        decoration: BoxDecoration(
                                          color: AppColors.textGreyColor
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0, vertical: 10),
                                          child: Row(
                                            children: [
                                              CustomWidgets.text(
                                                  state
                                                      .getSelfNomineeResponse
                                                      .superlativeData![index]
                                                      .categoryName!,
                                                  color: AppColors
                                                      .textStatusGreyColor,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w500),
                                              const Spacer(),
                                              MyButton(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 6),
                                                textStyle: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 12,
                                                    color: AppColors
                                                        .ratingBarColor),
                                                label: "Nominated",
                                                onPressed: () {},
                                                borderRadius: 5,
                                                borderColor:
                                                    AppColors.ratingBarColor,
                                              ),
                                              SizedBox(width: 2.w),
                                              MyButton(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 6),
                                                textStyle: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 12,
                                                    color:
                                                        AppColors.textRedColor),
                                                label: "Withdraw",
                                                onPressed: () {
                                                  showConfirmationDialog(
                                                      onTap: () {
                                                    print(state
                                                        .getSelfNomineeResponse
                                                        .superlativeData![index]
                                                        .sId);
                                                    highSchoolBloc.add(
                                                        WithdrawNomineeApiEvent({
                                                      "superlative_id": state
                                                          .getSelfNomineeResponse
                                                          .superlativeData![
                                                              index]
                                                          .sId
                                                    }));
                                                  });
                                                },
                                                borderRadius: 5,
                                                borderColor:
                                                    AppColors.textRedColor,
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
                          ],
                        ),
                      ),
                    ),
                  ),
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
    );
  }

  showConfirmationDialog({Function()? onTap}) {
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
                CustomWidgets.text("Are you sure you want to do withdraw?",
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
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          color: AppColors.textGreyColor.withOpacity(0.6),
                          textStyle: const TextStyle(
                              color: AppColors.textWhiteColor, fontSize: 20),
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
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          color: AppColors.colorPrimary,
                          textStyle: const TextStyle(
                              color: AppColors.textWhiteColor, fontSize: 20),
                          label: "OK",
                          onPressed: onTap),
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
