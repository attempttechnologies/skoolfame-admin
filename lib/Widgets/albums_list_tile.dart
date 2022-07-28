import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skoolfame/Data/API/api_manager.dart';
import 'package:skoolfame/Data/Models/album_model.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Widgets/custom_widget.dart';

class AlbumsListTile extends StatefulWidget {
  AlbumsListTile({
    Key? key,
    required this.onTap,
    this.widget,
    this.albumData,
  }) : super(key: key);

  Function onTap;
  Widget? widget;
  final AlbumData? albumData;

  @override
  State<AlbumsListTile> createState() => _AlbumsListTileState();
}

class _AlbumsListTileState extends State<AlbumsListTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onTap(),
      child: Container(
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: CachedNetworkImage(
                  imageUrl: APIManager.baseUrl + widget.albumData!.path!,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      const Center(
                    child: CupertinoActivityIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                )),
            Positioned(
                left: 6,
                right: 6,
                bottom: 6,
                child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.textWhiteColor.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(4.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomWidgets.text(widget.albumData!.title!,
                          color: AppColors.textBlackColor,
                          overflow: TextOverflow.ellipsis,
                          maxLine: 1,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ))),
            widget.widget != null
                ? Positioned(right: 6, top: 6, child: widget.widget!)
                : Container(),
          ],
        ),
      ),
    );
  }
}
