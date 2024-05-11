import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:social_ice/screens/bottom_navigation_screens/new_post_screen/selecting_post_screen/new_post_controller.dart';
import 'package:transparent_image/transparent_image.dart';

class AlbumPage extends StatefulWidget {
  /// Album object to show in the page
  final Album album;

  /// The constructor of AlbumPage
  AlbumPage(Album album) : album = album;

  @override
  State<StatefulWidget> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  List<Medium>? _media;
  final controller = Get.put(NewPostController());

  @override
  void initState() {
    super.initState();
    initAsync();
  }

  void initAsync() async {
    MediaPage mediaPage = await widget.album.listMedia();
    setState(() {
      _media = mediaPage.items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.album.name ?? "Unnamed Album"),
      ),
      body: GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 1.0,
        crossAxisSpacing: 1.0,
        children: <Widget>[
          ...?_media?.map(
            (medium) => GestureDetector(
              onTap: () async {
                if (medium.mediumType == MediumType.image) {
                  final file = await PhotoGallery.getFile(
                      mediumId: medium.id, mediumType: MediumType.image);
                  controller.selectedPostPath.value = file.path;
                  controller.mediumId.value = medium.id;
                  controller.mediumType.value = "image";
                  Get.back();
                } else {
                  final file = await PhotoGallery.getFile(
                      mediumId: medium.id, mediumType: MediumType.video);
                  controller.selectedPostPath.value = file.path;
                  controller.mediumId.value = medium.id;
                  controller.mediumType.value = "video";

                  Get.back();
                }
              },
              child: Container(
                color: Colors.grey[300],
                child: FadeInImage(
                  fit: BoxFit.cover,
                  placeholder: MemoryImage(kTransparentImage),
                  image: ThumbnailProvider(
                    mediumId: medium.id,
                    mediumType: medium.mediumType,
                    highQuality: true,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
