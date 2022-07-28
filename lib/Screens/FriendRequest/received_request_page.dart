import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:skoolfame/Bloc/Friends/friends_bloc.dart';
import 'package:skoolfame/Data/API/api_manager.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Utils/app_strings.dart';
import 'package:skoolfame/Widgets/custom_widget.dart';
import 'package:skoolfame/Widgets/my_button.dart';
import 'package:skoolfame/generated/assets.dart';

class ReceivedRequestPage extends StatefulWidget {
  const ReceivedRequestPage({Key? key}) : super(key: key);

  @override
  State<ReceivedRequestPage> createState() => _ReceivedRequestPageState();
}

class _ReceivedRequestPageState extends State<ReceivedRequestPage> {
  var friendsBloc = FriendsBloc();
  @override
  void initState() {
    friendsBloc.add(GetFriendRequestApiEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FriendsBloc, FriendsState>(
      bloc: friendsBloc,
      listener: (context, state) {
        if (state is UpdateRequestSuccessState) {
          friendsBloc.add(GetFriendRequestApiEvent());
        }
        // TODO: implement listener
      },
      child: BlocBuilder<FriendsBloc, FriendsState>(
        bloc: friendsBloc,
        builder: (context, state) {
          print(state);
          if (state is GetFriendRequestSuccessState) {
            var requestData =
                state.requestResponse.friendRequestList!.requestList!;
            return requestData.isEmpty
                ? Center(
                    child: CustomWidgets.text(AppStrings.nothingFound,
                        color: AppColors.textGreyColor,
                        fontWeight: FontWeight.w600))
                : RefreshIndicator(
                    onRefresh: _pullRefresh,
                    child: ListView.separated(
                      itemCount: requestData.length,
                      itemBuilder: (context, index) {
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
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    requestData[index]
                                                    .sender!
                                                    .userProfileImage! ==
                                                null ||
                                            requestData[index]
                                                    .sender!
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
                                            backgroundImage: NetworkImage(
                                                APIManager.baseUrl +
                                                    requestData[index]
                                                        .sender!
                                                        .userProfileImage!),
                                          ),
                                    SizedBox(
                                      width: 3.w,
                                    ),
                                    Container(
                                      width: 30.w,
                                      child: CustomWidgets.text(
                                          requestData[index]
                                                  .sender!
                                                  .firstName! +
                                              " " +
                                              requestData[index]
                                                  .sender!
                                                  .lastName!,
                                          color: AppColors.textBlackColor,
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          maxLine: 1,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                    Row(
                                      children: [
                                        MyButton(
                                            borderRadius: 5,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 8),
                                            borderColor:
                                                AppColors.textGreyColor,
                                            textStyle: const TextStyle(
                                                color: AppColors.textGreyColor),
                                            label: "Ignore",
                                            onPressed: () {
                                              friendsBloc
                                                  .add(UpdateRequestApiEvent({
                                                "receiver_id":
                                                    requestData[index]
                                                        .receiver!
                                                        .sId,
                                                "sender_id": requestData[index]
                                                    .sender!
                                                    .sId,
                                                "requestStatus": "reject"
                                              }));
                                            }),
                                        SizedBox(
                                          width: 1.5.w,
                                        ),
                                        MyButton(
                                            borderRadius: 5,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 8),
                                            borderColor: AppColors.colorPrimary,
                                            textStyle: const TextStyle(
                                                color: AppColors.colorPrimary),
                                            label: "Accept",
                                            onPressed: () {
                                              friendsBloc
                                                  .add(UpdateRequestApiEvent({
                                                "receiver_id":
                                                    requestData[index]
                                                        .receiver!
                                                        .sId,
                                                "sender_id": requestData[index]
                                                    .sender!
                                                    .sId,
                                                "requestStatus": "accept"
                                              }));
                                            })
                                      ],
                                    ),
                                  ],
                                )),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 2.h,
                        );
                      },
                    ));
          }
          return Center(
              child: CustomWidgets.text(AppStrings.nothingFound,
                  color: AppColors.textGreyColor, fontWeight: FontWeight.w600));
        },
      ),
    );
    // Center(
    //     child: CustomWidgets.text(AppStrings.nothingFount,
    //         color: AppColors.textGreyColor, fontWeight: FontWeight.w600));
  }

  Future<void> _pullRefresh() async {
    friendsBloc.add(GetFriendRequestApiEvent());
  }
}
