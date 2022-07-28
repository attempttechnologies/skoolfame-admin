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

class SuperlativesScreen extends StatefulWidget {
  const SuperlativesScreen({Key? key}) : super(key: key);

  @override
  State<SuperlativesScreen> createState() => _SuperlativesScreenState();
}

class _SuperlativesScreenState extends State<SuperlativesScreen> {
  var highSchoolBloc = HighSchoolBloc();
  String schoolId = "";

  @override
  void didChangeDependencies() {
    schoolId = ModalRoute.of(context)!.settings.arguments as String;

    highSchoolBloc.add(GetSuperlativeApiEvent({"school_id": schoolId}));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      title: "Superlatives",
      centerTitle: true,
      isBackIcon: true,
      child: Padding(
        padding: const EdgeInsets.only(top: 18.0),
        child: BlocListener<HighSchoolBloc, HighSchoolState>(
          listener: (context, state) {
            print("statee ${state}");
            // TODO: implement listener
          },
          child: BlocBuilder<HighSchoolBloc, HighSchoolState>(
            bloc: highSchoolBloc,
            builder: (context, state) {
              if (state is GetSuperlativeSuccessState) {
                return RefreshIndicator(
                  onRefresh: _pullRefresh,
                  child: ListView.separated(
                    itemCount:
                        state.superlativeResponse.superlativeData!.length,
                    padding: EdgeInsets.only(bottom: 1.0.h),
                    itemBuilder: (context, index) {
                      var superlativeData =
                          state.superlativeResponse.superlativeData![index];
                      return Padding(
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
                                    icon: Assets.iconsSuperlatives, size: 7),
                                SizedBox(
                                  width: 3.w,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomWidgets.text(
                                        superlativeData.categoryName!,
                                        color: AppColors.textBlackColor,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600),
                                    SizedBox(
                                      height: 0.5.h,
                                    ),
                                    CustomWidgets.text(
                                      "${superlativeData.users!.length} Nominees (s)",
                                      color: AppColors.textTagGreyColor,
                                      fontSize: 11,
                                    ),
                                  ],
                                ),
                                Spacer(),
                                MyButton(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 13, vertical: 8),
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12,
                                      color: AppColors.colorPrimary),
                                  label: "View Nominees",
                                  onPressed: () async {
                                    await Navigator.pushNamed(
                                      context,
                                      Routes.NOMINEES_ROUTE,
                                      arguments: superlativeData.sId,
                                    );
                                    highSchoolBloc.add(GetSuperlativeApiEvent(
                                        {"school_id": schoolId}));
                                  },
                                  borderRadius: 5,
                                  borderColor: AppColors.colorPrimary,
                                )
                              ],
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
      ),
    );
  }

  Future<void> _pullRefresh() async {
    highSchoolBloc.add(GetSuperlativeApiEvent({"school_id": schoolId}));
  }
}
