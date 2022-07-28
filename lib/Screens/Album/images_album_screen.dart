import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:skoolfame/Bloc/Album/album_bloc.dart';
import 'package:skoolfame/Data/Models/album_model.dart';
import 'package:skoolfame/Routes/routes.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Utils/app_strings.dart';
import 'package:skoolfame/Widgets/albums_list_tile.dart';
import 'package:skoolfame/Widgets/custom_widget.dart';
import 'package:skoolfame/Widgets/my_button.dart';
import 'package:skoolfame/Widgets/wrapper.dart';
import 'package:skoolfame/generated/assets.dart';

class ImagesAlbumScreen extends StatefulWidget {
  const ImagesAlbumScreen({Key? key}) : super(key: key);

  @override
  State<ImagesAlbumScreen> createState() => _ImagesAlbumScreenState();
}

class _ImagesAlbumScreenState extends State<ImagesAlbumScreen> {
  var albumBloc = AlbumBloc();
  bool isSearch = false;

  List<AlbumData>? templist = [];
  List<AlbumData>? searchlist = [];

  @override
  void initState() {
    albumBloc.add(GetAlbumApiEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrapper(
        title: AppStrings.albums,
        centerTitle: true,
        actions: InkWell(
            onTap: () {
              isSearch = true;
              searchlist!.clear();
              searchlist!.addAll(templist!);
              setState(() {});
            },
            child: CustomWidgets()
                .customIcon(icon: Assets.iconsSearch, size: 2.5)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocListener<AlbumBloc, AlbumState>(
            bloc: albumBloc,
            listener: (context, state) {
              if (state is GetAlbumSuccessState) {
                templist!.clear();
                templist!.addAll(state.getAlbumResponse.albumData!);
                setState(() {});
              }
            },
            child: BlocBuilder<AlbumBloc, AlbumState>(
              bloc: albumBloc,
              builder: (context, state) {
                print("state ${state}");
                if (state is GetAlbumSuccessState) {
                  List<AlbumData> albumList = [];

                  if (isSearch) {
                    albumList = searchlist!;
                  } else {
                    albumList = state.getAlbumResponse.albumData!;
                  }
                  return Column(
                    children: [
                      isSearch
                          ? TextFormField(
                              // controller: imageDescriptionController,
                              autofocus: true,
                              decoration: const InputDecoration(
                                hintStyle: const TextStyle(
                                    fontSize: 14.5,
                                    color: AppColors.textNotificationGreyColor),
                                hintText: AppStrings.search,
                              ),
                              onChanged: (v) {
                                if (v.isEmpty) {
                                  isSearch = false;
                                  setState(() {});
                                } else {
                                  _searchAlbum(v);
                                }
                              },
                              validator: (photoDescription) {
                                if (photoDescription!.isEmpty) {
                                  return "Search album";
                                } else {
                                  return null;
                                }
                              },
                            )
                          : Container(),
                      SizedBox(
                        height: isSearch ? 2.h : 0.0,
                      ),
                      albumList.isEmpty
                          ? Expanded(
                              child: Center(
                                child: CustomWidgets.text("No data found",
                                    color: AppColors.colorPrimary,
                                    fontSize: 20),
                              ),
                            )
                          : Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10,
                                      childAspectRatio: 1,
                                      mainAxisSpacing: 10,
                                    ),
                                    itemCount: albumList.length,
                                    itemBuilder: (BuildContext context, index) {
                                      return AlbumsListTile(
                                          albumData: albumList[index],
                                          onTap: () async {
                                            await Navigator.of(context)
                                                .pushNamed(
                                                    Routes
                                                        .IMAGES_SCREEN_DETAILS,
                                                    arguments:
                                                        albumList[index]);
                                            albumBloc.add(GetAlbumApiEvent());
                                          });
                                    }),
                              ),
                            ),
                      MyButton(
                        height: 6.9.h,
                        // width: 90.w,
                        label: AppStrings.createAlbum,
                        labelTextColor: AppColors.textWhiteColor,
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.textWhiteColor,
                        ),
                        onPressed: () async {
                          await Navigator.of(context)
                              .pushNamed(Routes.ADD_ALBUM_SCREEN);
                          albumBloc.add(GetAlbumApiEvent());
                          setState(() {});
                        },
                        color: AppColors.colorPrimary,
                      ),
                    ],
                  );
                }
                return Center(
                  child: Text("No Data"),
                );
              },
            ),
          ),
        ));
  }

  _searchAlbum(String v) {
    searchlist!.clear();
    for (var album in templist!) {
      if (album.title!.toLowerCase().contains(v.toLowerCase())) {
        searchlist!.add(album);
      }
    }
    setState(() {});
  }
}
