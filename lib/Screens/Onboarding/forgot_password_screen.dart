import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:skoolfame/Bloc/Login/login_bloc.dart';
import 'package:skoolfame/Bloc/Signup/signup_bloc.dart';
import 'package:skoolfame/Routes/routes.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Utils/app_strings.dart';
import 'package:skoolfame/Widgets/my_button.dart';
import 'package:skoolfame/Widgets/my_text_field_widget.dart';
import 'package:skoolfame/generated/assets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  var loginBloc = LoginBloc();
  var emailController = TextEditingController();

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
                child: BlocListener<LoginBloc, LoginState>(
                  bloc: loginBloc,
                  listener: (context, state) {
                    if (state is SignupSuccessState) {
                      Navigator.of(context)
                          .pushReplacementNamed(Routes.DASHBOARD_ROUTE);
                    }
                    if (state is SignupBlocFailure) {
                      print('Error occurred !');
                    }
                  },
                  child: BlocBuilder<LoginBloc, LoginState>(
                    bloc: loginBloc,
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
                          MyTextField(
                            controller: emailController,
                            hint: "Email",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter email';
                              } else if (!RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value)) {
                                return 'Please enter valid email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 7.0.h),
                          MyButton(
                            height: 7.h,
                            width: 100.w,
                            label: AppStrings.send.toUpperCase(),
                            labelTextColor: AppColors.colorPrimary,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                loginBloc.add(ForgotPasswordApiEvent(
                                    {"email": emailController.text.trim()}));
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
