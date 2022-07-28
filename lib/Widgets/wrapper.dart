import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Widgets/custom_widget.dart';

import 'custom_drawer.dart';

class Wrapper extends StatefulWidget {
  Wrapper(
      {Key? key,
      required this.title,
      required this.child,
      this.centerTitle = false,
      this.isBackIcon = false,
      this.actions,
      this.isResizeToAvoidBottomInset = false});

  final String title;
  final Widget child;
  final bool centerTitle;
  final bool isBackIcon;
  final Widget? actions;
  final bool? isResizeToAvoidBottomInset;

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: widget.isResizeToAvoidBottomInset,
      backgroundColor: AppColors.colorPrimaryLight,
      drawer: CustomDrawer(),
      appBar: CustomWidgets.myAppBar(
          title: widget.title,
          centerTitle: true,
          isBackIcon: widget.isBackIcon,
          context: context,
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: Center(child: widget.actions ?? Container()))
          ],
          scaffoldKey: _scaffoldKey),
      body: Container(
        height: 100.h,
        width: 100.w,
        decoration: const BoxDecoration(
          color: AppColors.textWhiteColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        child: widget.child,
      ),
    );
  }
}

class SubWrapper extends StatefulWidget {
  SubWrapper({Key? key, required this.child});

  final Widget child;
  @override
  State<SubWrapper> createState() => _SubWrapperState();
}

class _SubWrapperState extends State<SubWrapper> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      width: 100.w,
      decoration: const BoxDecoration(
        color: AppColors.textWhiteColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
      ),
      child: widget.child,
    );
  }
}
