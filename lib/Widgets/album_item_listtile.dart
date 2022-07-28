import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:skoolfame/Bloc/Album/album_bloc.dart';
import 'package:skoolfame/Data/API/api_manager.dart';
import 'package:skoolfame/Data/Models/album_images_model.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Widgets/custom_widget.dart';
import 'package:skoolfame/generated/assets.dart';

class AlbumItemListTile extends StatefulWidget {
  AlbumItemListTile(
      {Key? key,
      this.widget,
      this.imagesData,
      required this.onEditTap,
      required this.onDeleteTap})
      : super(key: key);

  Function() onEditTap;
  Function() onDeleteTap;
  Widget? widget;
  ImagesData? imagesData;

  @override
  State<AlbumItemListTile> createState() => _AlbumItemListTileState();
}

class _AlbumItemListTileState extends State<AlbumItemListTile> {
  var albumBloc = AlbumBloc();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AlbumBloc, AlbumState>(
      bloc: albumBloc,
      listener: (context, state) {
        // TODO: implement listener
      },
      child: BlocBuilder<AlbumBloc, AlbumState>(
        bloc: albumBloc,
        builder: (context, state) {
          return Container(
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(6.0),
                    child: CachedNetworkImage(
                      imageUrl: widget.widget == null
                          ? APIManager.baseUrl + widget.imagesData!.path!
                          : APIManager.baseUrl + widget.imagesData!.thumbnail!,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => const Center(
                        child: CupertinoActivityIndicator(),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
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
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  width: 14.w,
                                  child: CustomWidgets.text(
                                      widget.imagesData!.title!,
                                      overflow: TextOverflow.ellipsis,
                                      maxLine: 1,
                                      color: AppColors.textBlackColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                width: 1.w,
                              ),
                              Row(
                                children: [
                                  InkWell(
                                      onTap: widget.onEditTap,
                                      child: CustomWidgets().customIcon(
                                          icon: Assets.iconsEdit, size: 1.8)),
                                  SizedBox(
                                    width: 1.5.w,
                                  ),
                                  InkWell(
                                      onTap: widget.onDeleteTap,
                                      child: CustomWidgets().customIcon(
                                          icon: Assets.iconsDelete, size: 1.8)),
                                ],
                              ),
                            ],
                          ),
                        ))),
                widget.widget != null
                    ? Positioned(right: 6, top: 6, child: widget.widget!)
                    : Container(),
              ],
            ),
          );
        },
      ),
    );
  }
}
