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

class SentPage extends StatefulWidget {
  const SentPage({Key? key}) : super(key: key);

  @override
  State<SentPage> createState() => _SentPageState();
}

class _SentPageState extends State<SentPage> {
  var friendsBloc = FriendsBloc();

  @override
  void initState() {
    imageCache!.clear();

    friendsBloc.add(GetRelationshipRequestApiEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FriendsBloc, FriendsState>(
      bloc: friendsBloc,
      listener: (context, state) {
        if (state is UpdateRelationshipRequestSuccessState) {
          Navigator.pop(context);
          friendsBloc.add(GetRelationshipRequestApiEvent());
        }
      },
      child: BlocBuilder<FriendsBloc, FriendsState>(
        bloc: friendsBloc,
        builder: (context, state) {
          if (state is GetRelationshipRequestSuccessState) {
            var sentRequestData =
                state.requestResponse.friendRequestList!.sendList!;
            return sentRequestData.isEmpty
                ? Center(
                    child: CustomWidgets.text(AppStrings.nothingFound,
                        color: AppColors.textGreyColor,
                        fontWeight: FontWeight.w600))
                : RefreshIndicator(
                    onRefresh: _pullRefresh,
                    child: ListView.separated(
                      itemCount: sentRequestData.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            print("DOne");
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18.0),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    sentRequestData[index]
                                                    .receiver!
                                                    .userProfileImage! ==
                                                null ||
                                            sentRequestData[index]
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
                                            backgroundImage: NetworkImage(
                                                APIManager.baseUrl +
                                                    sentRequestData[index]
                                                        .receiver!
                                                        .userProfileImage!),
                                          ),
                                    SizedBox(
                                      width: 3.w,
                                    ),
                                    Container(
                                      width: 40.w,
                                      child: CustomWidgets.text(
                                          sentRequestData[index]
                                                  .receiver!
                                                  .firstName! +
                                              " " +
                                              sentRequestData[index]
                                                  .receiver!
                                                  .lastName!,
                                          color: AppColors.textBlackColor,
                                          maxLine: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.start,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Spacer(),
                                    MyButton(
                                      // height: 5.0,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 5),
                                      // width: 15.0,
                                      textStyle: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15,
                                          color: AppColors.textRedColor),
                                      label: "Withdraw",
                                      onPressed: () {
                                        CustomWidgets().showConfirmationDialog(
                                            context,
                                            title:
                                                "Are you sure you want to do withdraw?",
                                            onTap: (currentContext) {
                                          friendsBloc.add(
                                              UpdateRelationshipRequestApiEvent({
                                            "receiver_id":
                                                sentRequestData[index]
                                                    .receiver!
                                                    .sId,
                                            "sender_id": sentRequestData[index]
                                                .sender!
                                                .sId,
                                            "requestStatus": "withdraw"
                                          }));
                                        });
                                      },
                                      borderRadius: 5,
                                      borderColor: AppColors.textRedColor,
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
                    ));
          }
          return Center(
              child: CustomWidgets.text(AppStrings.nothingFound,
                  color: AppColors.textGreyColor, fontWeight: FontWeight.w600));
        },
      ),
    );
  }

  Future<void> _pullRefresh() async {
    friendsBloc.add(GetRelationshipRequestApiEvent());
  }
}
