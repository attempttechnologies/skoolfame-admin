import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skoolfame/Data/API/api_manager.dart';
import 'package:skoolfame/Data/Models/login_success_respo_model.dart';
import 'package:skoolfame/Routes/routes.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Widgets/custom_widget.dart';

class VideoPage extends StatefulWidget {
  VideoPage({Key? key, this.userData}) : super(key: key);
  UserData? userData;

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: widget.userData!.videos!.isEmpty
          ? Center(
              child:
                  CustomWidgets.text("No Data", color: AppColors.colorPrimary),
            )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                childAspectRatio: 1 / 1.4,
                mainAxisSpacing: 10,
              ),
              itemCount: widget.userData!.videos!.length,
              itemBuilder: (BuildContext ctx, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.PLAY_VIDEO_SCREEN,
                        arguments: widget.userData!.videos![index]);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.center,
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(6.0),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      const Center(
                                child: CupertinoActivityIndicator(),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              imageUrl: APIManager.baseUrl +
                                  widget.userData!.videos![index].thumbnail!,
                            )),
                      ],
                    ),
                  ),
                );
              }),
    );
  }
}
