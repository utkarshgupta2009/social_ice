import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:social_ice/screens/bottom_navigation_screens/new_post_screen/selecting_post_screen/VideoProvider.dart';
import 'package:social_ice/screens/bottom_navigation_screens/new_post_screen/selecting_post_screen/albumPage.dart';
import 'package:social_ice/screens/bottom_navigation_screens/new_post_screen/selecting_post_screen/new_post_controller.dart';
import 'package:social_ice/screens/bottom_navigation_screens/new_post_screen/uploading_post_screen/upload_post_screen.dart';
import 'package:social_ice/widgets/app_button.dart';
import 'package:transparent_image/transparent_image.dart';

/// The main widget of example app
class NewPostScreen extends StatefulWidget {
  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  List<Album>? _albums;
  bool _loading = false;
  final controller = Get.put(NewPostController());

  @override
  void initState() {
    super.initState();
    _loading = true;
    initAsync();
  }

  Future<void> initAsync() async {
    if (await _promptPermissionSetting()) {
      List<Album> albums = await PhotoGallery.listAlbums();
      setState(() {
        _albums = albums;
        _loading = false;
      });
    }
    setState(() {
      _loading = false;
    });
  }

  Future<bool> _promptPermissionSetting() async {
    if (Platform.isIOS) {
      if (await Permission.photos.request().isGranted ||
          await Permission.storage.request().isGranted) {
        return true;
      }
    }
    if (Platform.isAndroid) {
      if (await Permission.storage.request().isGranted ||
          await Permission.photos.request().isGranted &&
              await Permission.videos.request().isGranted) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Choose a Post'),
          forceMaterialTransparency: true,
          actions: [
            Obx(() => controller.selectedPostPath.value != ''
                ? SizedBox(
                    height: Get.height * 0.2,
                    child: AppButton(
                        onPressed: () {
                          Get.to(UploadPostScreen());
                        },
                        buttonLabel: "next"))
                : const Text('')),
          ]),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Flexible(
                    flex: 1,
                    child: Obx(
                      () => Container(
                          child: controller.selectedPostPath.value == ''
                              ? Center(
                                  child: Text(
                                    "Select a media",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 133, 133, 133),
                                        fontSize: Get.textScaleFactor * 20),
                                  ),
                                )
                              : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    height: Get.height * 0.5,
                                    width: Get.width,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20)),
                                    child: controller.mediumType.value == 'image'
                                        ? Image.file(
                                            File(controller
                                                .selectedPostPath.value),
                                            fit: BoxFit.fill,
                                          )
                                        : VideoProvider(
                                            mediumId:
                                                controller.mediumId.value)),
                              )),
                    )),
                Flexible(
                  flex: 1,
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      const Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Choose from gallery",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: Get.width * 0.02),
                        child: SizedBox(
                          height: Get.height * 0.42,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              double gridWidth =
                                  (constraints.maxWidth - 20) / 3;
                              double gridHeight = gridWidth + 33;
                              double ratio = gridWidth / gridHeight;
                              return Container(
                                padding: const EdgeInsets.all(5),
                                child: GridView.count(
                                  childAspectRatio: ratio,
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 5.0,
                                  crossAxisSpacing: 5.0,
                                  children: <Widget>[
                                    ...?_albums?.map(
                                      (album) => GestureDetector(
                                        onTap: () => Get.to(AlbumPage(album)),
                                        child: Column(
                                          children: <Widget>[
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              child: Container(
                                                color: Colors.grey[300],
                                                height: gridWidth,
                                                width: gridWidth,
                                                child: FadeInImage(
                                                  fit: BoxFit.cover,
                                                  placeholder: MemoryImage(
                                                      kTransparentImage),
                                                  image: AlbumThumbnailProvider(
                                                    album: album,
                                                    highQuality: true,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.topLeft,
                                              padding: const EdgeInsets.only(
                                                  left: 2.0),
                                              child: Text(
                                                album.name ?? "Unnamed Album",
                                                maxLines: 1,
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(
                                                  height: 1.2,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.topLeft,
                                              padding: const EdgeInsets.only(
                                                  left: 2.0),
                                              child: Text(
                                                album.count.toString(),
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(
                                                  height: 1.2,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}


/// The video provider widget
