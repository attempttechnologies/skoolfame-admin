import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:skoolfame/Bloc/Friends/friends_bloc.dart';
import 'package:skoolfame/Data/API/api_manager.dart';
import 'package:skoolfame/Data/Models/login_success_respo_model.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Utils/app_strings.dart';
import 'package:skoolfame/Widgets/custom_widget.dart';
import 'package:skoolfame/Widgets/my_button.dart';
import 'package:skoolfame/Widgets/my_text_field_widget.dart';
import 'package:skoolfame/Widgets/wrapper.dart';
import 'package:skoolfame/generated/assets.dart';

import '../../Utils/constants.dart';

class MyRelationship extends StatefulWidget {
  const MyRelationship({Key? key}) : super(key: key);

  @override
  State<MyRelationship> createState() => _MyRelationshipState();
}

class _MyRelationshipState extends State<MyRelationship> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var friendsBloc = FriendsBloc();
  var reasonController = TextEditingController();
  double rate = 0.0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    friendsBloc.add(GetMyRelationshipApiEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrapper(
        title: "My Relationships",
        centerTitle: true,
        isBackIcon: true,
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.textWhiteColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: BlocListener<FriendsBloc, FriendsState>(
              bloc: friendsBloc,
              listener: (context, state) {
                if (state is EndRelationshipRequestSuccessState) {
                  Navigator.pop(context);
                  friendsBloc.add(GetMyRelationshipApiEvent());
                }
              },
              child: BlocBuilder<FriendsBloc, FriendsState>(
                bloc: friendsBloc,
                builder: (context, state) {
                  if (state is GetMyRelationshipSuccessState) {
                    var myRelationshipData =
                        state.myRelationshipResponse.relationshipData;

                    return RefreshIndicator(
                      onRefresh: _pullRefresh,
                      child: ListView.separated(
                        itemCount: myRelationshipData!.length,
                        padding: EdgeInsets.only(bottom: 1.0.h),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    myRelationshipData[index]
                                                    .receiver!
                                                    .userProfileImage! ==
                                                null ||
                                            myRelationshipData[index]
                                                    .receiver!
                                                    .userProfileImage! ==
                                                ""
                                        ? CircleAvatar(
                                            radius: 22,
                                            backgroundColor:
                                                AppColors.colorPrimary,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Image.asset(
                                                Assets.imagesUser,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        : CircleAvatar(
                                            radius: 22,
                                            backgroundImage: NetworkImage(myRelationshipData[
                                                            index]
                                                        .receiver!
                                                        .firstName ==
                                                    LoginSuccessResponse.fromJson(
                                                            GetStorage().read(
                                                                AppPreferenceString
                                                                    .pUserData))
                                                        .data!
                                                        .firstName!
                                                ? APIManager.baseUrl +
                                                    myRelationshipData[index]
                                                        .sender!
                                                        .userProfileImage!
                                                : APIManager.baseUrl +
                                                    myRelationshipData[index]
                                                        .receiver!
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
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    CustomWidgets.text(
                                                        myRelationshipData[
                                                                        index]
                                                                    .receiver!
                                                                    .firstName ==
                                                                LoginSuccessResponse.fromJson(GetStorage().read(AppPreferenceString.pUserData))
                                                                    .data!
                                                                    .firstName!
                                                            ? myRelationshipData[
                                                                        index]
                                                                    .sender!
                                                                    .firstName! +
                                                                " " +
                                                                myRelationshipData[
                                                                        index]
                                                                    .sender!
                                                                    .lastName!
                                                            : myRelationshipData[
                                                                        index]
                                                                    .receiver!
                                                                    .firstName! +
                                                                " " +
                                                                myRelationshipData[
                                                                        index]
                                                                    .receiver!
                                                                    .lastName!,
                                                        color: AppColors
                                                            .textBlackColor,
                                                        fontSize: 11.5,
                                                        maxLine: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    SizedBox(
                                                      height: 0.5.h,
                                                    ),
                                                    CustomWidgets.text(
                                                        "Began: ${DateFormat("MM/dd/yyyy").format(DateTime.parse(myRelationshipData[index].startDate.toString()))} ",
                                                        color: AppColors
                                                            .textTagGreyColor,
                                                        fontSize: 9.5,
                                                        textAlign:
                                                            TextAlign.start),
                                                  ],
                                                ),
                                              ),
                                              myRelationshipData[index].rate ==
                                                      null
                                                  ? MyButton(
                                                      onPressed: () {
                                                        showModalbottomSheet(
                                                            context, onTap: () {
                                                          // if (rate != 0.0) {
                                                          friendsBloc.add(
                                                              EndRelationshipRequestApiEvent({
                                                            "receiver_id":
                                                                myRelationshipData[
                                                                        index]
                                                                    .receiver!
                                                                    .sId,
                                                            "sender_id":
                                                                myRelationshipData[
                                                                        index]
                                                                    .sender!
                                                                    .sId,
                                                            "end_reason":
                                                                reasonController
                                                                    .text,
                                                            "rate": rate
                                                          }));
                                                          // } else {
                                                          //   const SnackBar snackBar = SnackBar(
                                                          //       content: Text(
                                                          //           "Please give the rate of the relationship"),
                                                          //       backgroundColor:
                                                          //           Colors.red,
                                                          //       behavior:
                                                          //           SnackBarBehavior
                                                          //               .floating);
                                                          //   snackbarKey
                                                          //       .currentState
                                                          //       ?.showSnackBar(
                                                          //           snackBar);
                                                          // }
                                                        });
                                                      },
                                                      color: AppColors
                                                          .textRedColor,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 2),
                                                      label: "End",
                                                      borderRadius: 5,
                                                      textStyle: TextStyle(
                                                          color: AppColors
                                                              .textWhiteColor,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  : Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            myRelationshipData[
                                                                            index]
                                                                        .rate ==
                                                                    null
                                                                ? Container()
                                                                : RatingBar(
                                                                    ignoreGestures:
                                                                        true,
                                                                    initialRating:
                                                                        double.parse(myRelationshipData[index]
                                                                            .rate
                                                                            .toString()),
                                                                    minRating:
                                                                        1,
                                                                    direction: Axis
                                                                        .horizontal,
                                                                    itemCount:
                                                                        5,
                                                                    itemSize:
                                                                        18.0,
                                                                    ratingWidget:
                                                                        RatingWidget(
                                                                      full:
                                                                          const Icon(
                                                                        Icons
                                                                            .star_rate,
                                                                        color: AppColors
                                                                            .colorPrimary,
                                                                      ),
                                                                      half:
                                                                          Container(),
                                                                      empty:
                                                                          const Icon(
                                                                        Icons
                                                                            .star_border,
                                                                        color: AppColors
                                                                            .colorPrimary,
                                                                      ),
                                                                    ),
                                                                    allowHalfRating:
                                                                        false,
                                                                    unratedColor:
                                                                        Colors
                                                                            .transparent,
                                                                    onRatingUpdate:
                                                                        (rating) {
                                                                      print(
                                                                          rating);
                                                                    },
                                                                  ),
                                                            SizedBox(
                                                              width: 0.3.w,
                                                            ),
                                                            CustomWidgets.text(
                                                              myRelationshipData[
                                                                          index]
                                                                      .rate
                                                                      .toString() +
                                                                  ".0",
                                                              color: AppColors
                                                                  .colorPrimary,
                                                              fontSize: 9.0,
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 0.3.h,
                                                        ),
                                                        Row(
                                                          children: [
                                                            CustomWidgets.text(
                                                              "Ended: ${DateFormat("MM/dd/yyyy").format(DateTime.parse(myRelationshipData[index].endDate.toString()))}  ",
                                                              color: AppColors
                                                                  .textTagGreyColor,
                                                              fontSize: 9.0,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 0.5.h,
                                          ),
                                          myRelationshipData[index].endReason ==
                                                  null
                                              ? Container()
                                              : CustomWidgets.text(
                                                  "Ended because:",
                                                  color: AppColors
                                                      .textStatusGreyColor,
                                                  fontSize: 10,
                                                  textAlign: TextAlign.start),
                                          SizedBox(
                                            height: 0.5.h,
                                          ),
                                          myRelationshipData[index].endReason ==
                                                  null
                                              ? Container()
                                              : CustomWidgets.text(
                                                  myRelationshipData[index]
                                                      .endReason!,
                                                  color: AppColors
                                                      .textTagGreyColor,
                                                  fontSize: 10,
                                                  maxLine: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.start),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            height: 1.h,
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
        ));
  }

  Future<void> _pullRefresh() async {
    friendsBloc.add(GetMyRelationshipApiEvent());
  }

  showModalbottomSheet(BuildContext context, {Function()? onTap}) {
    return showModalBottomSheet<void>(
      // isDismissible: false,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              height: 40.h,
              decoration: const BoxDecoration(
                  color: AppColors.colorPrimary,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 28.0),
                        child: Column(
                          children: [
                            MyTextField(
                              controller: reasonController,
                              hint: "Ended reason",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter ended reason';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Center(
                              child: RatingBar(
                                initialRating: 0,
                                minRating: 0,
                                direction: Axis.horizontal,
                                itemCount: 5,
                                itemSize: 35,
                                ratingWidget: RatingWidget(
                                  full: const Icon(
                                    Icons.star_rate,
                                    color: AppColors.textWhiteColor,
                                  ),
                                  half: Container(),
                                  empty: const Icon(
                                    Icons.star_border,
                                    color: AppColors.colorPrimaryLight,
                                  ),
                                ),
                                allowHalfRating: false,
                                unratedColor: Colors.transparent,
                                onRatingUpdate: (rating) {
                                  rate = rating;
                                  print(rate);
                                  setState(() {});
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Center(
                        child: MyButton(
                          height: 7.h,
                          width: 50.w,
                          label: 'End Relationship',
                          labelTextColor: AppColors.colorPrimary,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              onTap!();
                              reasonController.clear();
                            }
                          },
                          textStyle: TextStyle(
                              fontSize: 15,
                              color: AppColors.colorPrimary,
                              fontWeight: FontWeight.bold),
                          color: AppColors.textWhiteColor,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
