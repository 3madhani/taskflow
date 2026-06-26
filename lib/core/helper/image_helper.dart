import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ImageHelper {
  ImageHelper._();

  static Uint8List? decodeDataImage(String imageValue) {
    final markerIndex = imageValue.indexOf('base64,');
    if (markerIndex == -1) {
      return null;
    }

    try {
      return base64Decode(imageValue.substring(markerIndex + 7));
    } on FormatException {
      return null;
    }
  }

  static String imagePickerErrorMessage(Object error) {
    if (error is MissingPluginException) {
      return 'Image picker is not ready. Restart the app and try again.';
    }
    if (error is PlatformException) {
      return 'Could not choose image: ${error.message ?? error.code}';
    }
    return 'Could not choose image';
  }

  static bool isDataImage(String imageValue) {
    return imageValue.startsWith('data:image/');
  }

  static Future<String> storeProjectImage(XFile image) async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final imagesDirectory = Directory(
      path.join(documentsDirectory.path, 'project_images'),
    );
    if (!await imagesDirectory.exists()) {
      await imagesDirectory.create(recursive: true);
    }

    final fileName =
        'project_${DateTime.now().microsecondsSinceEpoch}${_extensionFor(image.name)}';
    final storedImage = File(path.join(imagesDirectory.path, fileName));
    final bytes = await image.readAsBytes();
    await storedImage.writeAsBytes(bytes, flush: true);
    return storedImage.path;
  }

  static String _extensionFor(String imageName) {
    final extension = path.extension(imageName).toLowerCase();
    if (extension == '.jpg' ||
        extension == '.jpeg' ||
        extension == '.png' ||
        extension == '.webp') {
      return extension;
    }
    return '.jpg';
  }
}
