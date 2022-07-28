import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import 'package:skoolfame/Bloc/Profile/profile_bloc.dart';
import 'package:skoolfame/Data/Models/login_success_respo_model.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Utils/app_strings.dart';
import 'package:skoolfame/Utils/constants.dart';
import 'package:skoolfame/Widgets/my_button.dart';
import 'package:skoolfame/Widgets/wrapper.dart';

class ProfileAboutPage extends StatefulWidget {
  const ProfileAboutPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileAboutPage> createState() => _ProfileAboutPageState();
}

class _ProfileAboutPageState extends State<ProfileAboutPage> {
  var profileBloc = ProfileBloc();
  var aboutController = TextEditingController();
  @override
  void initState() {
    aboutController.text = LoginSuccessResponse.fromJson(
            GetStorage().read(AppPreferenceString.pUserData))
        .data!
        .about!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      title: AppStrings.about,
      isBackIcon: true,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: BlocListener<ProfileBloc, ProfileState>(
          bloc: profileBloc,
          listener: (context, state) {
            if (state is UserAboutSuccessState) {
              Navigator.pop(context, aboutController.text);
            }
            if (state is ProfileBlocFailure) {
              print('Error occurred !');
            }
          },
          child: BlocBuilder<ProfileBloc, ProfileState>(
            bloc: profileBloc,
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: AppColors.textGreyColor, width: 0.0),
                      ),
                      child: TextFormField(
                        controller: aboutController,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.all(8),
                          isDense: true,
                          hintStyle: TextStyle(
                              color: AppColors.textGreyColor, fontSize: 15),
                          hintText: "Write something to Allison",
                        ),
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: Container(
                  //     padding: EdgeInsets.all(18),
                  //     decoration: BoxDecoration(
                  //       border: Border.all(
                  //         width: 0,
                  //         color: AppColors.textGreyColor,
                  //       ),
                  //       borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  //     ),
                  //     child: CustomWidgets.text(
                  //         "Don’t forget to fill in your favorite locations so heartedcan help setup your text...",
                  //         color: AppColors.textTagGreyColor,
                  //         textAlign: TextAlign.start),
                  //   ),
                  // ),
                  SizedBox(
                    height: 3.h,
                  ),
                  MyButton(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 17),
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: AppColors.textWhiteColor),
                    label: AppStrings.set,
                    onPressed: () {
                      profileBloc.add(UserAboutApiEvent(
                          {"about": aboutController.text.trim()}));
                    },
                    borderRadius: 15,
                    color: AppColors.colorPrimary,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
