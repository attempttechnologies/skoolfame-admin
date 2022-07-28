import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skoolfame/Data/API/api_manager.dart';
import 'package:skoolfame/Data/Models/album_images_model.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Widgets/wrapper.dart';
import 'package:video_player/video_player.dart';

class PlayVideoScreen extends StatefulWidget {
  const PlayVideoScreen({Key? key}) : super(key: key);

  @override
  _PlayVideoScreenState createState() => _PlayVideoScreenState();
}

class _PlayVideoScreenState extends State<PlayVideoScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late VideoPlayerController _controller;
  ImagesData video = ImagesData();

  @override
  void didChangeDependencies() {
    video = ModalRoute.of(context)!.settings.arguments as ImagesData;

    _controller =
        VideoPlayerController.network(APIManager.baseUrl + video.path!)
          ..initialize().then((_) {
            _controller.play();
            setState(() {});
          });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      title: video.title!,
      isBackIcon: true,
      child: _controller.value.isInitialized
          ? Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  } else {
                    _controller.play();
                  }
                  setState(() {});
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                      ),
                      _controller.value.isPlaying
                          ? Container()
                          : Icon(
                              Icons.play_arrow,
                              size: 30,
                              color: AppColors.textWhiteColor,
                            ),
                    ],
                  ),
                ),
              ),
            )
          : Center(
              child: CupertinoActivityIndicator(),
            ),
    );
  }
}
