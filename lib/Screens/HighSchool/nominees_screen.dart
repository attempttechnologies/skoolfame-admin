import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:skoolfame/Bloc/High%20School/high_school_bloc.dart';
import 'package:skoolfame/Data/API/api_manager.dart';
import 'package:skoolfame/Routes/routes.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Utils/app_strings.dart';
import 'package:skoolfame/Widgets/custom_widget.dart';
import 'package:skoolfame/Widgets/my_button.dart';
import 'package:skoolfame/Widgets/wrapper.dart';
import 'package:skoolfame/generated/assets.dart';

class NomineesScreen extends StatefulWidget {
  const NomineesScreen({Key? key}) : super(key: key);

  @override
  State<NomineesScreen> createState() => _NomineesScreenState();
}

class _NomineesScreenState extends State<NomineesScreen> {
  var highSchoolBloc = HighSchoolBloc();
  String superlativeId = "";

  @override
  void didChangeDependencies() {
    superlativeId = ModalRoute.of(context)!.settings.arguments as String;

    highSchoolBloc.add(GetNomineesApiEvent({"superlative_id": superlativeId}));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      isBackIcon: true,
      title: "Nominees",
      centerTitle: true,
      child: BlocListener<HighSchoolBloc, HighSchoolState>(
        bloc: highSchoolBloc,
        listener: (context, state) async {
          if (state is AddVoteSuccessState) {
            highSchoolBloc
                .add(GetNomineesApiEvent({"superlative_id": superlativeId}));
          }
          if (state is SelfNominateSuccessState) {
            await Navigator.pushNamed(context, Routes.MY_SUPERLATIVES_ROUTE,
                arguments: state.schoolData);
            highSchoolBloc
                .add(GetNomineesApiEvent({"superlative_id": superlativeId}));
          }
        },
        child: BlocBuilder<HighSchoolBloc, HighSchoolState>(
          bloc: highSchoolBloc,
          builder: (context, state) {
            return state is GetNomineesSuccessState
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: CustomWidgets.text(
                            "${state.nomineesResponse.superlativeData!.school!.name} "
                            "${state.nomineesResponse.superlativeData!.categoryName}",
                            color: AppColors.textBlackColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 0.5.h,
                      ),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: _pullRefresh,
                          child: ListView.separated(
                            itemCount: state.nomineesResponse.superlativeData!
                                .users!.length,
                            padding: EdgeInsets.only(bottom: 1.0.h),
                            itemBuilder: (context, index) {
                              var nomineesData = state.nomineesResponse
                                  .superlativeData!.users![index];
                              print("isVoted ${nomineesData.isVoted}");
                              return GestureDetector(
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18.0),
                                  child: Container(
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
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          nomineesData.userProfileImage! ==
                                                      null ||
                                                  nomineesData
                                                          .userProfileImage! ==
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
                                                  backgroundImage: NetworkImage(
                                                      APIManager.baseUrl +
                                                          nomineesData
                                                              .userProfileImage!),
                                                ),
                                          SizedBox(
                                            width: 3.w,
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CustomWidgets.text(
                                                    nomineesData.firstName! +
                                                        " " +
                                                        nomineesData.lastName!,
                                                    color: AppColors
                                                        .textBlackColor,
                                                    fontSize: 11,
                                                    maxLine: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                SizedBox(height: 1.0.h),
                                                Row(
                                                  children: [
                                                    MyButton(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 8,
                                                          vertical: 6),
                                                      textStyle:
                                                          const TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 12,
                                                        color: AppColors
                                                            .ratingBarColor,
                                                      ),
                                                      label:
                                                          "${state.nomineesResponse.superlativeData!.users![index].votelength ?? 0} Vote(s)",
                                                      onPressed: () {
                                                        highSchoolBloc.add(
                                                            AddVoteApiEvent({
                                                          "superlative_id":
                                                              superlativeId,
                                                          "user_id": state
                                                              .nomineesResponse
                                                              .superlativeData!
                                                              .users![index]
                                                              .sId
                                                        }));
                                                      },
                                                      borderRadius: 5,
                                                      borderColor: AppColors
                                                          .ratingBarColor,
                                                    ),
                                                    SizedBox(width: 2.w),
                                                    state
                                                                    .nomineesResponse
                                                                    .superlativeData!
                                                                    .users![
                                                                        index]
                                                                    .isVoted ==
                                                                null ||
                                                            !state
                                                                .nomineesResponse
                                                                .superlativeData!
                                                                .users![index]
                                                                .isVoted!
                                                        ? Container()
                                                        : MyButton(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical:
                                                                        6),
                                                            textStyle: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontSize: 12,
                                                                color: AppColors
                                                                    .textRedColor),
                                                            label:
                                                                "Vote Recorded",
                                                            onPressed: () {},
                                                            borderRadius: 5,
                                                            borderColor: AppColors
                                                                .textRedColor,
                                                          )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(
                                height: 2.h,
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 18.0),
                        child: MyButton(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                              color: AppColors.textWhiteColor),
                          label: "Nominate Yourself",
                          onPressed: () {
                            // Navigator.pushNamed(
                            //     context, Routes.MY_SUPERLATIVES_ROUTE,
                            //     arguments: state
                            //         .nomineesResponse.superlativeData!.school);
                            highSchoolBloc.add(SelfNominateApiEvent(
                                {
                                  "superlative_id": state
                                      .nomineesResponse.superlativeData!.sId
                                },
                                state.nomineesResponse.superlativeData!
                                    .school!));
                          },
                          borderRadius: 15,
                          color: AppColors.colorPrimary,
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: CustomWidgets.text(AppStrings.nothingFound,
                        color: AppColors.textGreyColor,
                        fontWeight: FontWeight.w600));
          },
        ),
      ),
    );
  }

  Future<void> _pullRefresh() async {
    highSchoolBloc.add(GetNomineesApiEvent({"superlative_id": superlativeId}));
  }
}
