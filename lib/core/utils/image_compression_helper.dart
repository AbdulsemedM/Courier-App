import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class ImageCompressionHelper {
  static const int maxUploadBytes = 1024 * 1024;
  static const int maxLongestSide = 1600;
  static const int minQuality = 40;

  static Future<File> compressForUpload(File source) async {
    final bytes = await source.readAsBytes();
    final decoded = img.decodeImage(bytes);

    if (decoded == null) {
      throw Exception(
        'Could not process the photo. Please retake or choose a different image.',
      );
    }

    var image = _resizeToMaxLongestSide(decoded, maxLongestSide);
    var jpegBytes = _encodeUnderLimit(image);

    if (jpegBytes == null) {
      throw Exception(
        'The photo is still too large after compression. Please retake using a closer shot.',
      );
    }

    final tempDir = await getTemporaryDirectory();
    final outputPath =
        '${tempDir.path}/customer_id_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final outputFile = File(outputPath);
    await outputFile.writeAsBytes(jpegBytes, flush: true);
    return outputFile;
  }

  static img.Image _resizeToMaxLongestSide(img.Image image, int maxSide) {
    final longestSide = image.width > image.height ? image.width : image.height;
    if (longestSide <= maxSide) {
      return image;
    }

    if (image.width >= image.height) {
      return img.copyResize(image, width: maxSide);
    }

    return img.copyResize(image, height: maxSide);
  }

  static List<int>? _encodeUnderLimit(img.Image image) {
    var workingImage = image;

    for (var scaleAttempt = 0; scaleAttempt < 4; scaleAttempt++) {
      for (var quality = 85; quality >= minQuality; quality -= 10) {
        final encoded = img.encodeJpg(workingImage, quality: quality);
        if (encoded.length <= maxUploadBytes) {
          return encoded;
        }
      }

      final nextWidth = (workingImage.width * 0.75).round();
      final nextHeight = (workingImage.height * 0.75).round();
      if (nextWidth < 320 || nextHeight < 320) {
        break;
      }

      workingImage = img.copyResize(
        workingImage,
        width: nextWidth,
        height: nextHeight,
      );
    }

    return null;
  }

  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    }
    if (bytes < maxUploadBytes) {
      return '${(bytes / 1024).toStringAsFixed(0)} KB';
    }
    return '${(bytes / maxUploadBytes).toStringAsFixed(1)} MB';
  }
}
