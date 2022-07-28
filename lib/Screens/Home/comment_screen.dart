import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import 'package:skoolfame/Bloc/Home/home_bloc.dart';
import 'package:skoolfame/Data/API/api_manager.dart';
import 'package:skoolfame/Data/Models/login_success_respo_model.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Utils/app_strings.dart';
import 'package:skoolfame/Utils/constants.dart';
import 'package:skoolfame/Widgets/custom_widget.dart';
import 'package:skoolfame/Widgets/wrapper.dart';
import 'package:skoolfame/generated/assets.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({Key? key}) : super(key: key);

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final _commentController = TextEditingController();
  var homeBloc = HomeBloc();
  String messageId = "";
  @override
  void didChangeDependencies() {
    messageId = ModalRoute.of(context)!.settings.arguments as String;
    homeBloc.add(GetCommentApiEvent(messageId));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      isResizeToAvoidBottomInset: true,
      isBackIcon: true,
      title: "Comments",
      centerTitle: true,
      child: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: BlocListener<HomeBloc, HomeState>(
          bloc: homeBloc,
          listener: (context, state) {
            if (state is AddCommentSuccessState) {
              homeBloc.add(GetCommentApiEvent(messageId));
            }
            if (state is DeleteCommentSuccessState) {
              Navigator.pop(context);
              homeBloc.add(GetCommentApiEvent(messageId));
            }
          },
          child: BlocBuilder<HomeBloc, HomeState>(
            bloc: homeBloc,
            builder: (context, state) {
              if (state is GetCommentSuccessState) {
                return Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 18.0, bottom: 70, right: 18, left: 18),
                      child: state.getCommentResponse.commentData!.isEmpty
                          ? Center(
                              child: CustomWidgets.text(AppStrings.nothingFound,
                                  color: AppColors.textGreyColor,
                                  fontWeight: FontWeight.w600))
                          : ListView.separated(
                              itemCount:
                                  state.getCommentResponse.commentData!.length,
                              itemBuilder: (context, index) {
                                var comment = state
                                    .getCommentResponse.commentData![index];
                                return Container(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        comment.user!.userProfileImage! != ""
                                            ? CircleAvatar(
                                                radius: 22,
                                                backgroundImage: NetworkImage(
                                                  APIManager.baseUrl +
                                                      comment.user!
                                                          .userProfileImage!,
                                                ),
                                              )
                                            : CircleAvatar(
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      CustomWidgets.text(
                                                          comment.user!
                                                                  .firstName! +
                                                              " " +
                                                              comment.user!
                                                                  .lastName!,
                                                          color: AppColors
                                                              .textBlackColor,
                                                          fontSize: 11.5,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      SizedBox(
                                                        width: 1.w,
                                                      ),
                                                      CustomWidgets.text(
                                                        "Comment on post",
                                                        color: AppColors
                                                            .textLightGreyColor,
                                                        fontSize: 11,
                                                      ),
                                                    ],
                                                  ),
                                                  comment.user!.sId !=
                                                          LoginSuccessResponse.fromJson(
                                                                  GetStorage().read(
                                                                      AppPreferenceString
                                                                          .pUserData))
                                                              .data!
                                                              .sId
                                                      ? Container()
                                                      : GestureDetector(
                                                          onTap: () {
                                                            CustomWidgets()
                                                                .showConfirmationDialog(
                                                                    context,
                                                                    title:
                                                                        "Are you sure want to delete this comment?",
                                                                    onTap:
                                                                        (currentContext) {
                                                              homeBloc.add(
                                                                  DeleteCommentApiEvent({
                                                                "id":
                                                                    comment.sId
                                                              }));
                                                            });
                                                          },
                                                          child: CustomWidgets()
                                                              .customIcon(
                                                                  icon: Assets
                                                                      .iconsDelete,
                                                                  size: 2.2),
                                                        )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 1.h,
                                              ),
                                              CustomWidgets.text(
                                                  comment.comment!,
                                                  color: AppColors
                                                      .textStatusGreyColor,
                                                  fontSize: 11,
                                                  textAlign: TextAlign.start),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(
                                  height: 7,
                                );
                              },
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18),
                      child: TextFormField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                                color: AppColors.textGreyColor, width: 0.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                                color: AppColors.textGreyColor, width: 0.0),
                          ),
                          contentPadding: EdgeInsets.all(8),
                          isDense: true,
                          hintStyle: const TextStyle(
                              color: AppColors.textGreyColor, fontSize: 15),
                          hintText: "Type a comment",
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.comment,
                              size: 25,
                              color: AppColors.textBlackColor,
                            ),
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(12),
                            child: InkWell(
                              onTap: () {
                                if (_commentController.text.isNotEmpty) {
                                  homeBloc.add(AddCommentApiEvent({
                                    "id": messageId,
                                    "comment": _commentController.text
                                  }));
                                  _commentController.clear();
                                }
                              },
                              child: CustomWidgets().customIcon(
                                  icon: Assets.iconsSendMessage, size: 2.5),
                            ),
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
      ),
    );
  }

  Future<void> _pullRefresh() async {
    homeBloc.add(GetCommentApiEvent(messageId));
  }
}
