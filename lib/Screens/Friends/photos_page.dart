import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skoolfame/Data/API/api_manager.dart';
import 'package:skoolfame/Data/Models/login_success_respo_model.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Widgets/custom_widget.dart';

class PhotosPage extends StatefulWidget {
  PhotosPage({Key? key, this.userData}) : super(key: key);
  UserData? userData;
  @override
  _PhotosPageState createState() => _PhotosPageState();
}

class _PhotosPageState extends State<PhotosPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: widget.userData!.imagesData!.isEmpty
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
              itemCount: widget.userData!.imagesData!.length,
              itemBuilder: (BuildContext ctx, index) {
                print(widget.userData!.imagesData![index].path);
                return Container(
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
                                Icon(Icons.error),
                            imageUrl: APIManager.baseUrl +
                                widget.userData!.imagesData![index].path!,
                          )),
                    ],
                  ),
                );
              }),
    );
  }
}
