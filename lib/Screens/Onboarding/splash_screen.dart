import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import 'package:skoolfame/Routes/routes.dart';
import 'package:skoolfame/Utils/constants.dart';
import 'package:skoolfame/generated/assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      GetStorage().read(AppPreferenceString.pUserData) != null
          ? Navigator.of(context).pushReplacementNamed(Routes.DASHBOARD_ROUTE)
          : Navigator.of(context)
              .pushReplacementNamed(Routes.LOGIN_SCREEN_ROUTE);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            Assets.imagesBg,
            width: 100.w,
            height: 100.h,
            fit: BoxFit.cover,
          ),
          Align(
              alignment: Alignment.center,
              child: Image.asset(
                Assets.imagesSkoolfame,
                height: 30.h,
                width: 60.w,
              )),
        ],
      ),
    );
  }
}
