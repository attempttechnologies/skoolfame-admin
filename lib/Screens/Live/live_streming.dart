import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sizer/sizer.dart';
import 'package:skoolfame/Bloc/Live/live_bloc.dart';
import 'package:skoolfame/Data/API/api_manager.dart';
import 'package:skoolfame/Routes/routes.dart';
import 'package:skoolfame/Screens/Live/live_message.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Utils/app_strings.dart';
import 'package:skoolfame/Utils/appbar_manager.dart';
import 'package:skoolfame/Widgets/custom_drawer.dart';
import 'package:skoolfame/Widgets/custom_widget.dart';
import 'package:skoolfame/Widgets/wrapper.dart';
import 'package:skoolfame/generated/assets.dart';

class LiveStream extends StatefulWidget {
  const LiveStream({Key? key}) : super(key: key);

  @override
  _LiveStreamState createState() => _LiveStreamState();
}

class _LiveStreamState extends State<LiveStream> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var liveBloc = LiveBloc();

  @override
  void dispose() {
    appBarManager.updateAppBarStatus(true);
    super.dispose();
  }

  @override
  void initState() {
    liveBloc.add(GetLiveUserEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorPrimaryLight,
      key: _scaffoldKey,
      appBar: CustomWidgets.myAppBar(
          title: "Livestreaming",
          centerTitle: true,
          isBackIcon: false,
          context: context,
          actions: [
            BlocBuilder<LiveBloc, LiveState>(
              bloc: liveBloc,
              builder: (context, state) {
                return GestureDetector(
                  onTap: () async {
                    // print("Ok");
                    liveBloc.add(LiveUserEvent({"isLive": true}));
                    var res = await pushNewScreenWithRouteSettings(
                      context,
                      screen: const LiveMessage(),
                      settings: const RouteSettings(
                          name: Routes.LIVE_MESSAGE,
                          arguments: {"isBroadcaster": true, "id": ""}),
                      withNavBar: false,
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    );
                    liveBloc.add(GetLiveUserEvent());
                  },
                  child: Padding(
                    padding: EdgeInsets.all(17.0),
                    child: Image.asset(
                      Assets.iconsGoLiveBtn,
                    ),
                  ),
                );
              },
            ),
          ],
          scaffoldKey: _scaffoldKey),
      drawer: CustomDrawer(),
      body: BlocBuilder<LiveBloc, LiveState>(
        bloc: liveBloc,
        builder: (context, state) {
          print("STTA ${state}");
          if (state is GetLiveUserSuccessState) {
            return state.getLiveUserResponse.data!.isEmpty
                ? Center(
                    child: CustomWidgets.text(AppStrings.nothingFound,
                        color: AppColors.textWhiteColor,
                        fontWeight: FontWeight.w600))
                : RefreshIndicator(
                    onRefresh: _pullRefresh,
                    child: SubWrapper(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SingleChildScrollView(
                          child: StaggeredGrid.count(
                              crossAxisCount: 3,
                              mainAxisSpacing: 4,
                              crossAxisSpacing: 4,
                              children: List.generate(
                                state.getLiveUserResponse.data!.length,
                                (index) {
                                  var userData =
                                      state.getLiveUserResponse.data![index];
                                  return StaggeredGridTile.count(
                                    crossAxisCellCount: index % 4 == 0 ? 4 : 1,
                                    mainAxisCellCount: index % 4 == 0 ? 1 : 1,
                                    child: index % 4 == 0
                                        ? GestureDetector(
                                            onTap: () {
                                              liveBloc.add(AddLiveUserEvent({
                                                "live_id": state
                                                    .getLiveUserResponse
                                                    .data![index]
                                                    .sId,
                                                "isStart": true,
                                              }));
                                              Navigator.pushNamed(
                                                  context, Routes.LIVE_MESSAGE,
                                                  arguments: {
                                                    "isBroadcaster": false,
                                                    "id": state
                                                        .getLiveUserResponse
                                                        .data![index]
                                                        .sId
                                                  });
                                            },
                                            child: Stack(
                                              fit: StackFit.loose,
                                              children: [
                                                SizedBox(
                                                  width: 100.0.w,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Image.network(
                                                      APIManager.baseUrl +
                                                          userData
                                                              .userProfileImage!,
                                                      fit: BoxFit.cover,
                                                      alignment:
                                                          Alignment.topCenter,
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          CustomWidgets.text(
                                                              "Future live"),
                                                          CustomWidgets.text(
                                                              "Added by: ${userData.firstName} ${userData.lastName}",
                                                              fontSize: 10),
                                                          Row(
                                                            children: [
                                                              CustomWidgets()
                                                                  .customIcon(
                                                                      icon: Assets
                                                                          .iconsEye,
                                                                      size:
                                                                          2.5),
                                                              SizedBox(
                                                                  width: 1.w),
                                                              CustomWidgets.text(
                                                                  "2.5k",
                                                                  color: AppColors
                                                                      .textWhiteColor),
                                                              SizedBox(
                                                                  width: 3.w),
                                                              CustomWidgets().customIcon(
                                                                  icon: Assets
                                                                      .iconsLike,
                                                                  size: 2,
                                                                  color: AppColors
                                                                      .textWhiteColor),
                                                              SizedBox(
                                                                  width: 1.w),
                                                              CustomWidgets.text(
                                                                  "2.5k",
                                                                  color: AppColors
                                                                      .textWhiteColor),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 8.0,
                                                              right: 8),
                                                      child: Image.asset(
                                                        Assets.iconsLive,
                                                        width: 50,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              liveBloc.add(AddLiveUserEvent({
                                                "live_id": state
                                                    .getLiveUserResponse
                                                    .data![index]
                                                    .sId,
                                                "isStart": true,
                                              }));
                                              Navigator.pushNamed(
                                                  context, Routes.LIVE_MESSAGE,
                                                  arguments: {
                                                    "isBroadcaster": false,
                                                    "id": state
                                                        .getLiveUserResponse
                                                        .data![index]
                                                        .sId
                                                  });
                                            },
                                            child: Stack(
                                              alignment: Alignment.bottomRight,
                                              fit: StackFit.expand,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.network(
                                                    APIManager.baseUrl +
                                                        userData
                                                            .userProfileImage!,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                FittedBox(
                                                  fit: BoxFit.contain,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 0.0,
                                                            right: 2,
                                                            left: 25,
                                                            top: 25),
                                                    child: Image.asset(
                                                      Assets.iconsLive,
                                                      width: 12,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                  );
                                },
                              )),
                        ),
                        // child: GridView.custom(
                        //   gridDelegate: SliverQuiltedGridDelegate(
                        //     crossAxisSpacing: 100,
                        //     mainAxisSpacing: 12,
                        //     repeatPattern: QuiltedGridRepeatPattern.inverted,
                        //     pattern: [
                        //       QuiltedGridTile(1, 2),
                        //       QuiltedGridTile(1, 1),
                        //     ],
                        //     crossAxisCount: 2,
                        //   ),
                        //   childrenDelegate: SliverChildBuilderDelegate(
                        //     (context, index) => Container(
                        //       decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(10),
                        //         color: AppColors.colorPrimary,
                        //       ),
                        //       child: ClipRRect(
                        //         borderRadius: BorderRadius.circular(10),
                        //         child: Image.asset(
                        //           Assets.imagesLady,
                        //           fit: BoxFit.cover,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ),
                    ),
                  );
          }
          return Center(
              child: CustomWidgets.text(AppStrings.nothingFound,
                  color: AppColors.textWhiteColor,
                  fontWeight: FontWeight.w600));
        },
      ),
    );
  }

  Future<void> _pullRefresh() async {
    liveBloc.add(GetLiveUserEvent());
  }
}
