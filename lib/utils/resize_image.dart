import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

Future<String> resizeImageToSquare(String imagePath) async {
  // Read the image file
  final File imageFile = File(imagePath);
  final Uint8List imageBytes = await imageFile.readAsBytes();
  final img.Image image = img.decodeImage(imageBytes)!;

  // Calculate dimensions for 1:1 aspect ratio
  final int minDimension = image.width < image.height ? image.width : image.height;
  final int targetWidth = minDimension;
  final int targetHeight = minDimension;

  // Resize the image
  final img.Image resizedImage = img.copyResize(image, width: targetWidth, height: targetHeight);

  // Get temporary directory path
  final Directory tempDir = await getTemporaryDirectory();
  final String tempPath = tempDir.path;

  // Save the resized image to a temporary file
  final String tempImagePath = '$tempPath/resized_image.jpg';
  File(tempImagePath).writeAsBytesSync(img.encodeJpg(resizedImage));

  return tempImagePath;
}
