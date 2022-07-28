import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:skoolfame/Bloc/Signup/signup_bloc.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Widgets/my_button.dart';
import 'package:skoolfame/Widgets/my_text_field_widget.dart';
import 'package:skoolfame/generated/assets.dart';
import 'package:skoolfame/main.dart';

class RequestSchoolScreen extends StatefulWidget {
  const RequestSchoolScreen({Key? key}) : super(key: key);

  @override
  _RequestSchoolScreenState createState() => _RequestSchoolScreenState();
}

class _RequestSchoolScreenState extends State<RequestSchoolScreen> {
  final _formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var addressController = TextEditingController();
  var signupBloc = SignupBloc();
  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    super.dispose();
  }

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
                child: BlocListener<SignupBloc, SignupState>(
                  bloc: signupBloc,
                  listener: (context, state) {
                    if (state is SchoolRequestSuccessState) {
                      final SnackBar snackBar = SnackBar(
                          content: Text("School request successfully sent"),
                          backgroundColor: AppColors.colorPrimary,
                          behavior: SnackBarBehavior.floating);
                      snackbarKey.currentState?.showSnackBar(snackBar);
                      // Navigator.pop(context);
                    }
                  },
                  child: BlocBuilder<SignupBloc, SignupState>(
                    bloc: signupBloc,
                    builder: (context, state) {
                      return Column(
                        children: [
                          Align(
                              alignment: Alignment.topCenter,
                              child: Image.asset(
                                Assets.imagesSkoolfame,
                                height: 20.h,
                                width: 50.w,
                              )),
                          MyTextField(
                            controller: nameController,
                            hint: "School Name",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter school name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 2.h),
                          MyTextField(
                            controller: addressController,
                            hint: "Address",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter school address';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          MyButton(
                            height: 7.h,
                            width: 100.w,
                            label: 'REQUEST FOR SCHOOL',
                            labelTextColor: AppColors.colorPrimary,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                signupBloc.add(SchoolRequestApiEvent({
                                  "name": nameController.text,
                                  "address": addressController.text
                                }));
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
}
