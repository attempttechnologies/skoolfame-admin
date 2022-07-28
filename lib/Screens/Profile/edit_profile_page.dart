import 'dart:io';

import 'package:dio/dio.dart' as d;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:skoolfame/Bloc/Profile/profile_bloc.dart';
import 'package:skoolfame/Data/Models/login_success_respo_model.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Utils/app_strings.dart';
import 'package:skoolfame/Utils/constants.dart';
import 'package:skoolfame/Widgets/custom_widget.dart';
import 'package:skoolfame/Widgets/my_button.dart';
import 'package:skoolfame/generated/assets.dart';
import 'package:skoolfame/main.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key, this.image, this.callBack})
      : super(key: key);
  final File? image;
  final Function(LoginSuccessResponse)? callBack;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _fNameController = TextEditingController();
  final _lNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _emailController = TextEditingController();
  String dropdownValue = 'Female';
  // bool
  LoginSuccessResponse userData = LoginSuccessResponse();
  var profileBloc = ProfileBloc();
  bool isPrivate = false;

  // List of items in our dropdown menu
  var items = [
    'Male',
    'Female',
  ];
  DateTime selectedDate = DateTime(2001, 11, 30);

  void initState() {
    // TODO: implement initState
    userData = LoginSuccessResponse.fromJson(
        GetStorage().read(AppPreferenceString.pUserData));
    _fNameController.text = userData.data!.firstName!;
    _lNameController.text = userData.data!.lastName!;
    _emailController.text = userData.data!.email!;
    _dobController.text = DateFormat("MM/dd/yyyy")
        .format(DateTime.parse(userData.data!.dob.toString()));
    selectedDate = userData.data!.dob != null
        ? DateTime.parse(userData.data!.dob.toString())
        : DateTime(2001, 11, 30);
    dropdownValue = userData.data!.gender!;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 10),
      child: SingleChildScrollView(
        child: BlocListener<ProfileBloc, ProfileState>(
          bloc: profileBloc,
          listener: (context, state) {
            if (state is ProfileSuccessState) {
              widget.callBack!(state.profileResponse);
              final SnackBar snackBar = SnackBar(
                  content: Text("Updated Successfully"),
                  backgroundColor: AppColors.colorPrimary,
                  behavior: SnackBarBehavior.floating);
              snackbarKey.currentState?.showSnackBar(snackBar);
            }
            if (state is ProfileBlocFailure) {
              print('Error occurred !');
            }
          },
          child: BlocBuilder<ProfileBloc, ProfileState>(
            bloc: profileBloc,
            builder: (context, state) {
              return Column(
                children: [
                  customDetails(
                      label: AppStrings.firstName,
                      controller: _fNameController),
                  customDetails(
                      label: AppStrings.lastName, controller: _lNameController),
                  Container(
                    // color: Appcolor.textprimaryColors,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomWidgets.text(AppStrings.sex,
                            color: AppColors.textGreyColor),
                        SizedBox(
                          width: 15,
                        ),
                        CustomWidgets().customIcon(
                            icon: Assets.iconsEditProfile, size: 2.2),
                        Spacer(),
                        DropdownButton(
                          isDense: true,
                          value: dropdownValue,
                          underline: const SizedBox(
                            height: 0,
                          ),
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.colorPrimary,
                            // size: 40,
                          ),
                          iconSize: 32,
                          items: items.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(
                  //   height: 1.h,
                  // ),
                  const Divider(
                    thickness: 1,
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  customDetails(
                      label: AppStrings.birthday,
                      enabled: false,
                      controller: _dobController),
                  customDetails(
                      label: AppStrings.email,
                      isEditIcon: false,
                      enabled: false,
                      isEmail: true,
                      controller: _emailController),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomWidgets.text(AppStrings.youAre,
                          color: AppColors.textGreyColor),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              isPrivate = !isPrivate;
                              setState(() {});
                            },
                            child: isPrivate
                                ? CustomWidgets().customIcon(
                                    icon: Assets.iconsCloseEye,
                                    size: 2.5,
                                    color: AppColors.textGreyColor)
                                : CustomWidgets().customIcon(
                                    icon: Assets.iconsOpenEye,
                                    size: 2.5,
                                  ),
                          ),
                          SizedBox(width: 2.w),
                          CustomWidgets.text(
                              !isPrivate
                                  ? "Visible to friends"
                                  : "Visible to none of friends",
                              color: AppColors.textBlackColor),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  // const Divider(
                  //   thickness: 1,
                  // ),
                  // SizedBox(
                  //   height: 1.h,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     CustomWidgets.text(AppStrings.connectTo,
                  //         color: AppColors.textGreyColor),
                  //     Row(
                  //       children: [
                  //         CustomWidgets().customIcon(
                  //             icon: Assets.iconsFacebookBlue, size: 3),
                  //         SizedBox(
                  //           width: 2.w,
                  //         ),
                  //         CustomWidgets()
                  //             .customIcon(icon: Assets.iconsTwitter, size: 3),
                  //         SizedBox(
                  //           width: 2.w,
                  //         ),
                  //         CustomWidgets()
                  //             .customIcon(icon: Assets.iconsGoogle, size: 3),
                  //       ],
                  //     ),
                  //   ],
                  // ),
                  SizedBox(
                    height: 2.h,
                  ),
                  MyButton(
                      borderRadius: 5,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 15),
                      color: AppColors.colorPrimary,
                      textStyle: const TextStyle(
                          color: AppColors.textWhiteColor, fontSize: 20),
                      label: AppStrings.save,
                      onPressed: () async {
                        Map<String, dynamic> params = {
                          "first_name": _fNameController.text.trim(),
                          "last_name": _lNameController.text.trim(),
                          "email": _emailController.text.trim(),
                          "gender": dropdownValue,
                          "privacy": !isPrivate ? "public" : "private",
                          "dob": DateFormat("yyyy-MM-dd").format(selectedDate),
                        };
                        if (widget.image != null) {
                          params['file'] = await d.MultipartFile.fromFile(
                            widget.image!.path,
                            filename: '${userData.data!.sId!}Profile_image',
                            contentType: MediaType("image", "jpg"),
                          );
                        }
                        await DefaultCacheManager().emptyCache();

                        profileBloc.add(EditProfileApiEvent(params));
                      }),
                  SizedBox(
                    height: 35,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  customDetails(
      {required String label,
      String? details,
      bool isEditIcon = true,
      bool enabled = true,
      bool isEmail = false,
      TextEditingController? controller}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CustomWidgets.text(label, color: AppColors.textGreyColor),
                SizedBox(
                  width: 3.w,
                ),
                isEditIcon == true
                    ? CustomWidgets()
                        .customIcon(icon: Assets.iconsEditProfile, size: 2.2)
                    : Container()
              ],
            ),
            Expanded(
              child: InkWell(
                onTap: enabled || isEmail
                    ? () {}
                    : () async {
                        await _selectDate(context);
                      },
                child: TextFormField(
                  controller: controller,
                  // autofocus: true,
                  cursorColor: AppColors.colorPrimary,
                  textAlign: TextAlign.right,
                  enabled: enabled,

                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                    border: InputBorder.none,
                  ),
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 1.h,
        ),
        const Divider(
          thickness: 1,
        ),
        SizedBox(
          height: 1.h,
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1950, 1),
        lastDate: DateTime(2001, 12));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      _dobController.text = DateFormat("MM/dd/yyyy").format(selectedDate);
    }
  }
}
