import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:place_picker/entities/location_result.dart';
import 'package:place_picker/widgets/place_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:skoolfame/Bloc/Profile/profile_bloc.dart';
import 'package:skoolfame/Routes/routes.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Utils/app_strings.dart';
import 'package:skoolfame/Widgets/my_button.dart';
import 'package:skoolfame/Widgets/my_text_field_widget.dart';
import 'package:skoolfame/generated/assets.dart';

class RemainingDetailsScreen extends StatefulWidget {
  const RemainingDetailsScreen({Key? key}) : super(key: key);

  @override
  _RemainingDetailsScreenState createState() => _RemainingDetailsScreenState();
}

class _RemainingDetailsScreenState extends State<RemainingDetailsScreen> {
  var fNameController = TextEditingController();
  var lNameController = TextEditingController();
  var schoolController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var reEnterPasswordController = TextEditingController();
  var dobController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var profileBloc = ProfileBloc();
  String dropdownValue = 'Female';
  var items = [
    'Male',
    'Female',
  ];
  DateTime selectedDate = DateTime(2001, 11, 30);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            Image.asset(
              Assets.imagesBg,
              width: 100.w,
              height: 100.h,
              fit: BoxFit.cover,
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: BlocListener<ProfileBloc, ProfileState>(
                  bloc: profileBloc,
                  listener: (context, state) {
                    if (state is ProfileSuccessState) {
                      Navigator.of(context)
                          .pushReplacementNamed(Routes.DASHBOARD_ROUTE);
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
                          Align(
                              alignment: Alignment.topCenter,
                              child: Image.asset(
                                Assets.imagesSkoolfame,
                                height: 25.h,
                                width: 50.w,
                              )),
                          Row(
                            children: [
                              Expanded(
                                child: MyTextField(
                                  controller: dobController,
                                  readOnly: true,
                                  onTap: () async {
                                    await _selectDate(context);

                                    dobController.text =
                                        DateFormat("MM/dd/yyyy")
                                            .format(selectedDate);
                                  },
                                  hint: "Date of birth",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select date of birth';
                                    }

                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(width: 5.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 18.0),
                                      child: DropdownButton(
                                        style: GoogleFonts.lato(
                                          color: AppColors.textWhiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                        isDense: true,
                                        dropdownColor:
                                            AppColors.colorPrimaryLight,
                                        value: dropdownValue,
                                        underline: Container(
                                            // padding: EdgeInsets.only(bottom: 50),
                                            // height: 2,
                                            // color: AppColors.colorPrimaryLight,
                                            ),
                                        icon: const Icon(
                                          Icons.keyboard_arrow_down,
                                          color: AppColors.colorPrimaryLight,
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
                                    ),
                                    Divider(
                                      color: AppColors.colorPrimaryLight,
                                      thickness: 2,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          MyTextField(
                            controller: schoolController,
                            hint: "School",
                            readOnly: true,
                            onTap: () async {
                              LocationResult? result =
                                  await Navigator.of(context)
                                      .push(MaterialPageRoute(
                                builder: (context) => PlacePicker(
                                  "AIzaSyBpOO_jzYTT8IY-yp5psd1phdiFcG-g5a8",
                                ),
                              ));
                              print("Result:  ${result!.formattedAddress}");
                              schoolController.text =
                                  result.formattedAddress.toString();
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter school';
                              }
                              return null;
                            },
                          ),

                          // SizedBox(height: 1.0.h),

                          SizedBox(height: 10.0.h),
                          MyButton(
                            height: 7.h,
                            width: 100.w,
                            label: AppStrings.continues.toUpperCase(),
                            labelTextColor: AppColors.colorPrimary,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                profileBloc.add(EditProfileApiEvent({
                                  "dob": DateFormat("yyyy-MM-dd")
                                      .format(selectedDate),
                                  "gender": dropdownValue,
                                  "school": schoolController.text.trim(),
                                }));
                                // Navigator.of(context)
                                //     .pushNamed(Routes.SIGNUP_SCREEN_ROUTE);
                              }
                            },
                            color: AppColors.textWhiteColor,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
    }
  }
}
