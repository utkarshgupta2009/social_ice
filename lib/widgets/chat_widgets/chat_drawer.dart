import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class ChatDrawer extends StatefulWidget {
  const ChatDrawer({Key? key}) : super(key: key);

  @override
  _ChatDrawerState createState() => _ChatDrawerState();
}

class _ChatDrawerState extends State<ChatDrawer> {
  Future<void> _selectDocument() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx'],
    );

    if (result != null) {
      final filePath = result.files.single.path;
      // Handle the selected document file
      print('Selected document: $filePath');
    }
  }

  Future<void> _selectImage() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );

    if (result != null) {
      final filePath = result.files.single.path;
      // Handle the selected image file
      print('Selected image: $filePath');
    }
  }

  Future<void> _selectVideo() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.video,
    );

    if (result != null) {
      final filePath = result.files.single.path;
      // Handle the selected video file
      print('Selected video: $filePath');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Attachments',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.insert_drive_file),
            title: const Text('Document'),
            onTap: _selectDocument,
          ),
          ListTile(
            leading: const Icon(Icons.image),
            title: const Text('Image'),
            onTap: _selectImage,
          ),
          ListTile(
            leading: const Icon(Icons.video_library),
            title: const Text('Video'),
            onTap: _selectVideo,
          ),
        ],
      ),
    );
  }
}