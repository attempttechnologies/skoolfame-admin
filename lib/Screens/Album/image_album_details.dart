import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:skoolfame/Bloc/Album/album_bloc.dart';
import 'package:skoolfame/Data/Models/album_model.dart';
import 'package:skoolfame/Routes/routes.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Utils/app_strings.dart';
import 'package:skoolfame/Widgets/album_item_listtile.dart';
import 'package:skoolfame/Widgets/custom_widget.dart';
import 'package:skoolfame/Widgets/my_button.dart';
import 'package:skoolfame/generated/assets.dart';
import 'package:skoolfame/main.dart';

class ImageAlbumDetails extends StatefulWidget {
  const ImageAlbumDetails({Key? key}) : super(key: key);

  @override
  State<ImageAlbumDetails> createState() => _ImageAlbumDetailsState();
}

class _ImageAlbumDetailsState extends State<ImageAlbumDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var albumBloc = AlbumBloc();
  AlbumData albumData = AlbumData();
  var albumId = "";
  @override
  void didChangeDependencies() {
    albumData = ModalRoute.of(context)!.settings.arguments as AlbumData;
    albumId = albumData.sId!;
    print("ID ${albumData.sId}");
    albumBloc.add(GetImagesApiEvent(albumData.sId!));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AlbumBloc, AlbumState>(
        bloc: albumBloc,
        listener: (context, state) {
          if (state is DeleteAlbumSuccessState) {
            const SnackBar snackBar =
                SnackBar(content: Text('Album Deleted Successfully!'));
            snackbarKey.currentState?.showSnackBar(snackBar);
            Navigator.pop(context);
          }

          if (state is DeleteImagesSuccessState) {
            const SnackBar snackBar =
                SnackBar(content: Text('Image deleted successfully!'));
            snackbarKey.currentState?.showSnackBar(snackBar);
            Navigator.pop(context);
            albumBloc.add(GetImagesApiEvent(albumData.sId!));
          }
          if (state is GetAlbumSuccessState) {
            albumData = state.getAlbumResponse.albumData!
                .firstWhere((element) => element.sId == albumId);
            setState(() {});
            albumBloc.add(GetImagesApiEvent(albumData.sId!));
          }
        },
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppColors.colorPrimaryLight,
          appBar: CustomWidgets.myAppBar(
              scaffoldKey: _scaffoldKey,
              context: context,
              centerTitle: true,
              title: albumData.title!,
              actions: [
                InkWell(
                    onTap: () async {
                      await Navigator.pushNamed(
                          context, Routes.ADD_ALBUM_SCREEN,
                          arguments: albumData) as String;
                      setState(() {});
                      albumBloc.add(GetAlbumApiEvent());
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
                        albumBloc
                            .add(DeleteAlbumApiEvent({"id": albumData.sId}));
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
              child: BlocBuilder<AlbumBloc, AlbumState>(
                bloc: albumBloc,
                builder: (context, state) {
                  print("State ${state}");
                  if (state is GetImagesSuccessState) {
                    return Column(
                      children: [
                        state.getImagesResponse.imagesData!.isEmpty
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
                                    itemCount: state
                                        .getImagesResponse.imagesData!.length,
                                    itemBuilder: (BuildContext ctx, index) {
                                      return AlbumItemListTile(
                                          imagesData: state.getImagesResponse
                                              .imagesData![index],
                                          onEditTap: () async {
                                            await Navigator.pushNamed(context,
                                                Routes.ADD_PHOTO_SCREEN,
                                                arguments: state
                                                    .getImagesResponse
                                                    .imagesData![index]);
                                            albumBloc.add(GetImagesApiEvent(
                                                state
                                                    .getImagesResponse
                                                    .imagesData![index]
                                                    .albumId!));
                                          },
                                          onDeleteTap: () {
                                            CustomWidgets().showConfirmationDialog(
                                                context,
                                                title:
                                                    "Are you sure want to delete this photo?",
                                                onTap: (currentContext) {
                                              albumBloc.add(
                                                  DeleteImagesApiEvent({
                                                "id": state.getImagesResponse
                                                    .imagesData![index].sId
                                              }));
                                            });
                                          });
                                    }),
                              ),
                        // Spacer(),
                        MyButton(
                          height: 6.9.h,
                          // width: 90.w,
                          label: AppStrings.addAPhoto,
                          labelTextColor: AppColors.textWhiteColor,
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.textWhiteColor,
                          ),
                          onPressed: () async {
                            // Navigator.of(context).pushNamed(Routes.LIVE_USER_PROFILE_SCREEN);
                            await Navigator.of(context).pushNamed(
                                Routes.ADD_PHOTO_SCREEN,
                                arguments: albumData.sId);
                            albumBloc.add(GetImagesApiEvent(albumData.sId!));
                          },
                          color: AppColors.colorPrimary,
                        ),
                      ],
                    );
                  }
                  return Container();
                },
              ),
            ),
          ),
        ));
  }
}
