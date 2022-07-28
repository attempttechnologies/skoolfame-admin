import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:skoolfame/Screens/FriendRequest/received_request_page.dart';
import 'package:skoolfame/Screens/FriendRequest/sent_request_page.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Widgets/wrapper.dart';

class FriendRequestScreen extends StatefulWidget {
  const FriendRequestScreen({Key? key}) : super(key: key);

  @override
  State<FriendRequestScreen> createState() => _FriendRequestScreenState();
}

class _FriendRequestScreenState extends State<FriendRequestScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      title: "Friend Requests",
      centerTitle: true,
      isBackIcon: true,
      child: DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.textWhiteColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0)),
          ),
          child: Column(
            children: [
              Container(
                height: 70,
                child: TabBar(
                  unselectedLabelStyle:
                      const TextStyle(fontWeight: FontWeight.normal),
                  unselectedLabelColor: AppColors.textGreyTabColor,
                  labelColor: AppColors.textWhiteColor,
                  padding:
                      EdgeInsets.symmetric(horizontal: 18.0.w, vertical: 2.0.h),
                  tabs: const [
                    Tab(
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Received",
                            style: TextStyle(fontSize: 16),
                          ) /*CustomWidgets.text(AppStrings.publics)*/),
                    ),
                    Tab(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Sent",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                  ],
                  // labelPadding: EdgeInsets.zero,
                  indicatorPadding: EdgeInsets.all(1.0),
                  indicatorWeight: 0.08,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicator: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.topYellowColor,
                          AppColors.btnTabOrangeColor,
                          AppColors.bottomOrangeColor
                        ]),
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.colorPrimary,
                          offset: Offset(0, 2.5),
                          blurRadius: 8,
                          spreadRadius: 0.2)
                    ],
                  ),
                ),
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    ReceivedRequestPage(),
                    SentRequestPage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
