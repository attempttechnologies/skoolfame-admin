import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:skoolfame/Bloc/Signup/signup_bloc.dart';
import 'package:skoolfame/Data/Models/school_model.dart';
import 'package:skoolfame/Routes/routes.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Widgets/custom_widget.dart';
import 'package:skoolfame/Widgets/my_button.dart';
import 'package:skoolfame/Widgets/my_text_field_widget.dart';
import 'package:skoolfame/generated/assets.dart';
import 'package:skoolfame/main.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var fcm_token;
  FirebaseMessaging _messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.max,
  );
  var fNameController = TextEditingController();
  var lNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var reEnterPasswordController = TextEditingController();
  var dobController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var signupBloc = SignupBloc();
  String? genderValue;
  var genderItems = [
    'Male',
    'Female',
  ];
  var schoolValue = "";
  var schoolItems = [""];
  SchoolModel schooList = SchoolModel(schoolData: [
    SchoolData(
        address: "",
        createdAt: "",
        iV: 1,
        name: "hello",
        sId: "asd",
        updatedAt: "")
  ]);
  DateTime selectedDate = DateTime(2001, 11, 30);

  @override
  void initState() {
    print(genderValue);
    print(schoolValue);
    signupBloc.add(GetSchoolApiEvent());
    registerNotification();
    super.initState();
  }

  //
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
                    if (state is SignupSuccessState) {
                      Navigator.of(context)
                          .pushReplacementNamed(Routes.DASHBOARD_ROUTE);
                    }
                    if (state is SignupBlocFailure) {
                      print('Error occurred !');
                    }
                    if (state is GetSchoolSuccessState) {
                      schooList = state.schoolResponse;
                      setState(() {});
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
                          Row(
                            children: [
                              Expanded(
                                child: MyTextField(
                                  controller: fNameController,
                                  hint: "First Name",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter first name';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: MyTextField(
                                  controller: lNameController,
                                  hint: "Last Name",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter last name';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
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
                                  hint: "Date of Birth",
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
                                        hint: const Text(
                                          "Gender",
                                          style: TextStyle(
                                              color: AppColors.textWhiteColor),
                                        ),
                                        isDense: true,
                                        underline: Container(),
                                        dropdownColor:
                                            AppColors.colorPrimaryLight,
                                        value: genderValue,
                                        icon: const Icon(
                                          Icons.keyboard_arrow_down,
                                          color: AppColors.colorPrimaryLight,
                                          // size: 40,
                                        ),
                                        iconSize: 32,
                                        items: genderItems.map((String items) {
                                          return DropdownMenuItem(
                                            value: items,
                                            child: Text(items),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            genderValue = newValue!;
                                          });
                                        },
                                      ),
                                    ),
                                    const Divider(
                                      color: AppColors.colorPrimaryLight,
                                      thickness: 2,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Container(
                            width: 100.0.w,
                            padding: const EdgeInsets.only(top: 18.0),
                            child: DropdownButton<SchoolData>(
                              style: GoogleFonts.lato(
                                color: AppColors.textWhiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              underline: Container(),

                              isDense: true,
                              hint: const Text(
                                "School",
                                style:
                                    TextStyle(color: AppColors.textWhiteColor),
                              ),
                              dropdownColor: AppColors.colorPrimaryLight,
                              value: schoolValue.isEmpty
                                  ? null
                                  : schooList.schoolData!.firstWhere(
                                      (element) => element.name == schoolValue),

                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColors.colorPrimaryLight,
                                // size: 40,
                              ),
                              iconSize: 32,
                              items: schooList.schoolData!
                                  .map<DropdownMenuItem<SchoolData>>((e) =>
                                      DropdownMenuItem(
                                          value: e, child: Text(e.name!)))
                                  .toList(),
                              // items: genderItems.map((String items) {
                              //   return DropdownMenuItem(
                              //     value: items,
                              //     child: Text(items),
                              //   );
                              // }).toList(),
                              onChanged: (SchoolData? newValue) {
                                setState(() {
                                  schoolValue = newValue!.name!;
                                });
                              },
                            ),
                          ),
                          const Divider(
                            color: AppColors.colorPrimaryLight,
                            thickness: 2,
                          ),

                          SizedBox(
                            height: 3.h,
                          ),
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
                          SizedBox(
                            height: 3.h,
                          ),
                          MyTextField(
                            controller: passwordController,
                            hint: "Password",
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter password';
                              } else if (value.length < 6) {
                                return 'Please enter min 6 character';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          MyTextField(
                            controller: reEnterPasswordController,
                            hint: "Password Again",
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter password again';
                              } else if (value != passwordController.text) {
                                return 'Password doesn\'t match';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, Routes.REQUEST_SCHOOL_SCREEN);
                                },
                                child: CustomWidgets.text(
                                  "Request for school?",
                                  color: AppColors.textWhiteColor,
                                ),
                              ),
                            ],
                          ),
                          // SizedBox(height: 1.0.h),

                          SizedBox(height: 7.0.h),
                          MyButton(
                            height: 7.h,
                            width: 100.w,
                            label: 'SIGN UP',
                            labelTextColor: AppColors.colorPrimary,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (genderValue == null ||
                                    genderValue!.isEmpty) {
                                  const SnackBar snackBar = SnackBar(
                                      content: Text('Please select gender'));
                                  snackbarKey.currentState
                                      ?.showSnackBar(snackBar);
                                  return;
                                }
                                if (schoolValue.isEmpty) {
                                  const SnackBar snackBar = SnackBar(
                                      content: Text('Please select school'));
                                  snackbarKey.currentState
                                      ?.showSnackBar(snackBar);
                                  return;
                                }

                                signupBloc.add(SignUpApiEvent({
                                  "first_name": fNameController.text.trim(),
                                  "last_name": lNameController.text.trim(),
                                  "dob": DateFormat("yyyy-MM-dd")
                                      .format(selectedDate),
                                  "gender": genderValue,
                                  "school": schoolValue,
                                  "email": emailController.text.trim(),
                                  "password": passwordController.text.trim(),
                                  "social_media": "email",
                                  "about": "",
                                  "fcm_token": fcm_token,
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

  registerNotification() async {
    await flutterLocalNotificationsPlugin!
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    fcm_token = await _messaging.getToken();
    //foreground notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      print(notification!.title! +
          " message " +
          notification.body! +
          " id" +
          notification.hashCode.toString());
      print(android);

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin!.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                channelDescription: channel.description,
                icon: '@mipmap/ic_launcher',
                importance: Importance.high
                // other properties...
                ),
          ),
        );
      }
    });
    // background notification
    FirebaseMessaging.onBackgroundMessage((message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      print(notification!.title! +
          " message " +
          notification.body! +
          " id" +
          notification.hashCode.toString());
      print(android);

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        await flutterLocalNotificationsPlugin!.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id, channel.name, channelDescription: channel.description,
              icon: '@mipmap/ic_launcher', importance: Importance.high,

              // other properties...
            ),
          ),
        );
      }
    });
  }
}
