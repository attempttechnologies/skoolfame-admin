import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart' as d;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:sizer/sizer.dart';
import 'package:skoolfame/Data/API/api_manager.dart';
import 'package:skoolfame/Data/Models/album_images_model.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Utils/app_strings.dart';
import 'package:skoolfame/Widgets/custom_widget.dart';
import 'package:skoolfame/Widgets/my_button.dart';
import 'package:skoolfame/generated/assets.dart';
import 'package:skoolfame/main.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../Bloc/Video/video_bloc.dart';

class AddVideoScreen extends StatefulWidget {
  const AddVideoScreen({Key? key}) : super(key: key);

  @override
  State<AddVideoScreen> createState() => _AddVideoScreenState();
}

class _AddVideoScreenState extends State<AddVideoScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<String> privacyList = ["Only me", "Friends", "Public"];
  String? privacyOptionSelect;
  final ImagePicker _picker = ImagePicker();
  Uint8List? video;
  final _formKey = GlobalKey<FormState>();
  var videoBloc = VideoBloc();
  String albumId = "";
  String videoPath = "";
  var videoData = ImagesData();

  @override
  void didChangeDependencies() {
    if (ModalRoute.of(context)!.settings.arguments is ImagesData) {
      videoData = ModalRoute.of(context)!.settings.arguments as ImagesData;
      albumId = videoData.albumId!;
    } else {
      albumId = ModalRoute.of(context)!.settings.arguments as String;
    }
    if (videoData.title != null) {
      titleController.text = videoData.title!;
      descriptionController.text = videoData.description!;
      privacyOptionSelect = videoData.privacy;
      videoPath = videoData.path!;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      backgroundColor: AppColors.colorPrimaryLight,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textWhiteColor,
          ),
        ),
        backgroundColor: AppColors.colorPrimaryLight,
        elevation: 0,
        centerTitle: true,
        title: CustomWidgets.text(
            videoData.title != null
                ? AppStrings.updateVideo
                : AppStrings.addAVideo,
            fontSize: 16,
            fontWeight: FontWeight.bold),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.textWhiteColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocListener<VideoBloc, VideoState>(
            bloc: videoBloc,
            listener: (context, state) {
              if (state is AddVideoSuccessState ||
                  state is EditVideoSuccessState) {
                Navigator.pop(context);
              }
            },
            child: BlocBuilder<VideoBloc, VideoState>(
              bloc: videoBloc,
              builder: (context, state) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 6.0),
                              child: TextFormField(
                                controller: titleController,
                                decoration: InputDecoration(
                                  hintStyle: const TextStyle(
                                      fontSize: 14.5,
                                      color:
                                          AppColors.textNotificationGreyColor),
                                  hintText: AppStrings.videoTitle,
                                ),
                                validator: (videoTitle) {
                                  if (videoTitle!.isEmpty) {
                                    return "Please enter title";
                                  } else if (videoTitle.startsWith(" ")) {
                                    return "Space not allow in title";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 6.0),
                              child: TextFormField(
                                controller: descriptionController,
                                decoration: const InputDecoration(
                                  hintStyle: TextStyle(
                                      fontSize: 14.5,
                                      color:
                                          AppColors.textNotificationGreyColor),
                                  hintText: AppStrings.videoDescription,
                                ),
                                validator: (videoDescription) {
                                  if (videoDescription!.isEmpty) {
                                    return "Please enter description";
                                  } else if (videoDescription.startsWith(" ")) {
                                    return "Space not allow in description";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            InkWell(
                              onTap: () async {
                                final XFile? image = await _picker.pickVideo(
                                    source: ImageSource.gallery);
                                videoPath = image!.path;
                                setState(() {});
                                video = await VideoThumbnail.thumbnailData(
                                  video: videoPath,
                                  imageFormat: ImageFormat.JPEG,
                                  quality: 100,
                                );
                                setState(() {});
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 6.0, right: 6.0, top: 18),
                                child: video != null
                                    ? Stack(
                                        alignment: Alignment.bottomRight,
                                        children: [
                                          Container(
                                            height: 30.h,
                                            width: 100.w,
                                            // color: Colors.amber,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: Image.memory(
                                                video!,
                                                fit: BoxFit.cover,
                                                alignment: Alignment.topCenter,
                                              ),
                                            ),
                                          ),
                                          Align(
                                              alignment: Alignment.bottomRight,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: CustomWidgets()
                                                    .customIcon(
                                                        icon: Assets.iconsEdit,
                                                        size: 2.5,
                                                        color: AppColors
                                                            .colorPrimaryLight),
                                              )),
                                        ],
                                      )
                                    : videoData.thumbnail != null
                                        ? Stack(
                                            alignment: Alignment.bottomRight,
                                            children: [
                                              Container(
                                                height: 30.h,
                                                width: 100.w,
                                                // color: Colors.amber,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  child: CachedNetworkImage(
                                                    imageUrl: APIManager
                                                            .baseUrl +
                                                        videoData.thumbnail!,
                                                    fit: BoxFit.cover,
                                                    alignment:
                                                        Alignment.topCenter,
                                                    placeholder: (context,
                                                            url) =>
                                                        const Center(
                                                            child:
                                                                CupertinoActivityIndicator()),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: CustomWidgets()
                                                        .customIcon(
                                                            icon: Assets
                                                                .iconsEdit,
                                                            size: 2.5,
                                                            color: AppColors
                                                                .colorPrimaryLight),
                                                  )),
                                            ],
                                          )
                                        : Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    width: 0.24.h,
                                                    color: AppColors
                                                        .textNotificationGreyColor
                                                        .withOpacity(0.7)),
                                              ),
                                              color: AppColors.textWhiteColor,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 12),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  CustomWidgets.text(
                                                      AppStrings.videoUrl,
                                                      color: AppColors
                                                          .textNotificationGreyColor),
                                                  CustomWidgets().customIcon(
                                                      icon:
                                                          Assets.iconsVideoAdd,
                                                      size: 3)
                                                ],
                                              ),
                                            ),
                                          ),
                              ),
                            ),
                            SizedBox(
                              height: 0.8.h,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 6.0, right: 6.0, top: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 0.24.h,
                                        color: AppColors
                                            .textNotificationGreyColor
                                            .withOpacity(0.7)),
                                  ),
                                  color: AppColors.textWhiteColor,
                                ),
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  underline: SizedBox(),
                                  icon: CustomWidgets().customIcon(
                                      icon: Assets.iconsDownArrow, size: 2.7),
                                  dropdownColor: AppColors.textWhiteColor,
                                  hint: CustomWidgets.text(AppStrings.privacy,
                                      color:
                                          AppColors.textNotificationGreyColor,
                                      fontSize: 12),
                                  value: privacyOptionSelect,
                                  items: privacyList.map((String value) {
                                    return DropdownMenuItem<String>(
                                        value: value,
                                        child: CustomWidgets.text(value,
                                            color: AppColors.textBlackColor));
                                  }).toList(),
                                  onChanged: (v) {
                                    privacyOptionSelect = v;
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    MyButton(
                      height: 6.9.h,
                      label: videoData.title != null
                          ? AppStrings.update.toUpperCase()
                          : AppStrings.save.toUpperCase(),
                      labelTextColor: AppColors.textWhiteColor,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.textWhiteColor,
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (videoData.sId == null && videoPath.isEmpty) {
                            const SnackBar snackBar = SnackBar(
                                content: Text("Please select video"),
                                backgroundColor: AppColors.textRedColor,
                                behavior: SnackBarBehavior.floating);
                            snackbarKey.currentState?.showSnackBar(snackBar);
                            return;
                          }
                          if (privacyOptionSelect == null) {
                            final SnackBar snackBar = SnackBar(
                                content: Text("Please select privacy"),
                                backgroundColor: AppColors.textRedColor,
                                behavior: SnackBarBehavior.floating);
                            snackbarKey.currentState?.showSnackBar(snackBar);
                            return;
                          }
                          Map<String, dynamic> params = {
                            "album_id": albumId,
                            "title": titleController.text,
                            "description": descriptionController.text,
                            "privacy": privacyOptionSelect
                          };
                          print("VideoPAth ${APIManager.baseUrl + videoPath}");
                          print("Video ${video}");

                          if (videoPath.isNotEmpty && video != null) {
                            params['file'] = await d.MultipartFile.fromFile(
                                videoPath,
                                filename: path.basename(videoPath),
                                contentType: MediaType("video", "mp4"));
                            params['thumbnail'] = d.MultipartFile.fromBytes(
                                video!,
                                contentType: MediaType('image', 'jpg'),
                                filename: titleController.text + "thumbnail");
                            await DefaultCacheManager().emptyCache();
                          }
                          print("params ${params}");
                          videoData.sId != null
                              ? videoBloc.add(
                                  EditVideoApiEvent(params, videoData.sId!))
                              : videoBloc.add(AddVideoApiEvent(params));
                        }
                      },
                      color: AppColors.colorPrimary,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
