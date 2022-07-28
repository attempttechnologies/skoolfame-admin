import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:skoolfame/Bloc/Video/video_bloc.dart';
import 'package:skoolfame/Data/Models/album_model.dart';
import 'package:skoolfame/Routes/routes.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Utils/app_strings.dart';
import 'package:skoolfame/Widgets/album_item_listtile.dart';
import 'package:skoolfame/Widgets/custom_widget.dart';
import 'package:skoolfame/Widgets/my_button.dart';
import 'package:skoolfame/generated/assets.dart';
import 'package:skoolfame/main.dart';
import 'package:video_player/video_player.dart';

class VideoAlbumDetails extends StatefulWidget {
  const VideoAlbumDetails({Key? key}) : super(key: key);

  @override
  State<VideoAlbumDetails> createState() => _VideoAlbumDetailsState();
}

class _VideoAlbumDetailsState extends State<VideoAlbumDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var videoBloc = VideoBloc();
  AlbumData videoAlbumData = AlbumData();
  var albumId = "";
  late VideoPlayerController _controller;

  @override
  void didChangeDependencies() {
    videoAlbumData = ModalRoute.of(context)!.settings.arguments as AlbumData;
    albumId = videoAlbumData.sId!;
    videoBloc.add(GetVideoApiEvent(albumId));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VideoBloc, VideoState>(
      bloc: videoBloc,
      listener: (context, state) {
        if (state is DeleteVideoAlbumSuccessState) {
          const SnackBar snackBar =
              SnackBar(content: Text('Album Deleted Successfully!'));
          snackbarKey.currentState?.showSnackBar(snackBar);
          Navigator.pop(context);
        }

        if (state is DeleteVideoSuccessState) {
          const SnackBar snackBar =
              SnackBar(content: Text('Video Deleted Successfully!'));
          snackbarKey.currentState?.showSnackBar(snackBar);
          Navigator.pop(context);
          videoBloc.add(GetVideoApiEvent(videoAlbumData.sId!));
        }
        if (state is GetVideoAlbumSuccessState) {
          videoAlbumData = state.getVideoAlbumResponse.albumData!
              .firstWhere((element) => element.sId == albumId);
          setState(() {});
          videoBloc.add(GetVideoApiEvent(albumId));
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.colorPrimaryLight,
        appBar: CustomWidgets.myAppBar(
            scaffoldKey: _scaffoldKey,
            context: context,
            centerTitle: true,
            title: videoAlbumData.title!,
            actions: [
              InkWell(
                  onTap: () async {
                    await Navigator.pushNamed(
                        context, Routes.ADD_VIDEO_ALBUM_SCREEN,
                        arguments: videoAlbumData) as String;
                    setState(() {});
                    videoBloc.add(GetVideoAlbumApiEvent());
                  },
                  child: CustomWidgets()
                      .customIcon(icon: Assets.iconsEditAlbum, size: 2.5)),
              SizedBox(
                width: 2.5.w,
              ),
              InkWell(
                  onTap: () {
                    CustomWidgets().showConfirmationDialog(context,
                        title: "Are you sure want to delete this album?",
                        onTap: (currentContext) {
                      videoBloc.add(
                          DeleteVideoAlbumApiEvent({"id": videoAlbumData.sId}));
                      Navigator.pop(context);
                    });
                  },
                  child: CustomWidgets()
                      .customIcon(icon: Assets.iconsDeleteAlbum, size: 2.5)),
              SizedBox(
                width: 4.w,
              ),
            ],
            isBackIcon: true),
        body: Container(
          decoration: const BoxDecoration(
            color: AppColors.textWhiteColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: BlocBuilder<VideoBloc, VideoState>(
              bloc: videoBloc,
              builder: (context, state) {
                print("State is ${state}");
                if (state is GetVideoSuccessState) {
                  print("yes");
                  return Column(
                    children: [
                      state.getVideoResponse.imagesData!.isEmpty
                          ? Expanded(
                              child: Center(
                                child: CustomWidgets.text("No data found",
                                    color: AppColors.colorPrimary,
                                    fontSize: 20),
                              ),
                            )
                          : Expanded(
                              child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 10,
                                    childAspectRatio: 1 / 1.4,
                                    mainAxisSpacing: 10,
                                  ),
                                  itemCount:
                                      state.getVideoResponse.imagesData!.length,
                                  itemBuilder: (BuildContext ctx, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, Routes.PLAY_VIDEO_SCREEN,
                                            arguments: state.getVideoResponse
                                                .imagesData![index]);
                                      },
                                      child: AlbumItemListTile(
                                        imagesData: state.getVideoResponse
                                            .imagesData![index],
                                        onEditTap: () async {
                                          await Navigator.pushNamed(
                                              context, Routes.ADD_VIDEO_SCREEN,
                                              arguments: state.getVideoResponse
                                                  .imagesData![index]);
                                          videoBloc.add(GetVideoApiEvent(state
                                              .getVideoResponse
                                              .imagesData![index]
                                              .albumId!));
                                        },
                                        widget: CustomWidgets().customIcon(
                                            icon: Assets.iconsVideoAlbum,
                                            size: 2.5),
                                        onDeleteTap: () {
                                          CustomWidgets().showConfirmationDialog(
                                              context,
                                              title:
                                                  "Are you sure want to delete this video?",
                                              onTap: (currentContext) {
                                            videoBloc.add(DeleteVideoApiEvent({
                                              "id": state.getVideoResponse
                                                  .imagesData![index].sId
                                            }));
                                          });
                                        },
                                      ),
                                    );
                                  }),
                            ),
                      MyButton(
                        height: 6.9.h,
                        label: AppStrings.addAVideo,
                        labelTextColor: AppColors.textWhiteColor,
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.textWhiteColor,
                        ),
                        onPressed: () async {
                          await Navigator.of(context).pushNamed(
                              Routes.ADD_VIDEO_SCREEN,
                              arguments: albumId);
                          videoBloc.add(GetVideoApiEvent(albumId));
                        },
                        color: AppColors.colorPrimary,
                      ),
                    ],
                  );
                }
                return Center(
                  child: Text("No data found"),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
