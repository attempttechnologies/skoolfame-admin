import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:skoolfame/Bloc/High%20School/high_school_bloc.dart';
import 'package:skoolfame/Routes/routes.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Utils/app_strings.dart';
import 'package:skoolfame/Widgets/custom_widget.dart';
import 'package:skoolfame/Widgets/my_button.dart';
import 'package:skoolfame/Widgets/wrapper.dart';
import 'package:skoolfame/generated/assets.dart';

class HighSchoolScreen extends StatefulWidget {
  const HighSchoolScreen({Key? key}) : super(key: key);

  @override
  State<HighSchoolScreen> createState() => _HighSchoolScreenState();
}

class _HighSchoolScreenState extends State<HighSchoolScreen> {
  var highSchoolBloc = HighSchoolBloc();
  @override
  void initState() {
    highSchoolBloc.add(GetSchoolApiEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      title: "High Schools",
      centerTitle: true,
      child: BlocBuilder<HighSchoolBloc, HighSchoolState>(
        bloc: highSchoolBloc,
        builder: (context, state) {
          if (state is GetSchoolSuccessState) {
            return Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: RefreshIndicator(
                  onRefresh: _pullRefresh,
                  child: ListView.separated(
                    itemCount: state.schoolResponse.schoolData!.length,
                    padding: EdgeInsets.only(bottom: 1.0.h),
                    itemBuilder: (context, index) {
                      var schoolData = state.schoolResponse.schoolData![index];

                      return GestureDetector(
                        onTap: () {
                          // Navigator.pushNamed(
                          //     context, Routes.LIVE_USER_PROFILE_SCREEN);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
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
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomWidgets().customIcon(
                                      icon: Assets.iconsIconsHighSchool,
                                      size: 7),
                                  SizedBox(
                                    width: 1.w,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 35.w,
                                        child: CustomWidgets.text(
                                            schoolData.name!,
                                            color: AppColors.textBlackColor,
                                            fontSize: 11,
                                            maxLine: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.start,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: 0.5.h,
                                      ),
                                      CustomWidgets.text(
                                        schoolData.address!,
                                        color: AppColors.textTagGreyColor,
                                        fontSize: 11,
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  MyButton(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 13, vertical: 8),
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12,
                                        color: AppColors.colorPrimary),
                                    label: "View Superlatives",
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, Routes.SUPERLATIVES_ROUTE,
                                          arguments: schoolData.sId);
                                    },
                                    borderRadius: 5,
                                    borderColor: AppColors.colorPrimary,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 2.h,
                      );
                    },
                  )),
            );
          }
          return Center(
              child: CustomWidgets.text(AppStrings.nothingFound,
                  color: AppColors.textGreyColor, fontWeight: FontWeight.w600));
        },
      ),
    );
  }

  Future<void> _pullRefresh() async {
    highSchoolBloc.add(GetSchoolApiEvent());
  }
}
