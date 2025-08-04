import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:logger/logger.dart';

/// Abstract interface for image operations
abstract class ImageService {
  /// Pick image from gallery
  Future<File?> pickFromGallery();

  /// Pick image from camera
  Future<File?> pickFromCamera();

  /// Compress image if it exceeds size limit
  Future<File> compressImage(File imageFile,
      {int maxSizeBytes = 3 * 1024 * 1024});

  /// Get image file size
  Future<int> getFileSize(File file);

  /// Generate thumbnail for image
  Future<File> generateThumbnail(File imageFile, {int maxWidth = 300});
}

/// Implementation of ImageService using image_picker and flutter_image_compress
class ImageServiceImpl implements ImageService {
  final ImagePicker _picker = ImagePicker();
  final Logger _logger = Logger();

  @override
  Future<File?> pickFromGallery() async {
    try {
      _logger.d('Picking image from gallery');

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 85,
      );

      if (image != null) {
        _logger.i('Image picked from gallery: ${image.path}');
        return File(image.path);
      }

      _logger.d('No image selected from gallery');
      return null;
    } catch (e) {
      _logger.e('Error picking image from gallery: $e');
      rethrow;
    }
  }

  @override
  Future<File?> pickFromCamera() async {
    try {
      _logger.d('Picking image from camera');

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 85,
      );

      if (image != null) {
        _logger.i('Image captured from camera: ${image.path}');
        return File(image.path);
      }

      _logger.d('No image captured from camera');
      return null;
    } catch (e) {
      _logger.e('Error picking image from camera: $e');
      rethrow;
    }
  }

  @override
  Future<File> compressImage(File imageFile,
      {int maxSizeBytes = 3 * 1024 * 1024}) async {
    try {
      final fileSize = await getFileSize(imageFile);

      if (fileSize <= maxSizeBytes) {
        _logger.d(
            'Image size ${fileSize}B is within limit, no compression needed');
        return imageFile; // No compression needed
      }

      _logger.d('Compressing image from ${fileSize}B to max ${maxSizeBytes}B');

      // Calculate compression quality based on file size
      int quality = 85;
      if (fileSize > maxSizeBytes * 2) {
        quality = 60;
      } else if (fileSize > maxSizeBytes * 1.5) {
        quality = 70;
      }

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        imageFile.absolute.path,
        '${imageFile.parent.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
        quality: quality,
        minWidth: 800,
        minHeight: 600,
      );

      if (compressedFile != null) {
        final compressedSize = await getFileSize(File(compressedFile.path));
        _logger.i('Image compressed from ${fileSize}B to ${compressedSize}B');
        return File(compressedFile.path);
      } else {
        throw Exception('Image compression failed');
      }
    } catch (e) {
      _logger.e('Error compressing image: $e');
      rethrow;
    }
  }

  @override
  Future<int> getFileSize(File file) async {
    try {
      return await file.length();
    } catch (e) {
      _logger.e('Error getting file size: $e');
      rethrow;
    }
  }

  @override
  Future<File> generateThumbnail(File imageFile, {int maxWidth = 300}) async {
    try {
      _logger.d('Generating thumbnail for image: ${imageFile.path}');

      final thumbnailFile = await FlutterImageCompress.compressAndGetFile(
        imageFile.absolute.path,
        '${imageFile.parent.path}/thumb_${DateTime.now().millisecondsSinceEpoch}.jpg',
        quality: 70,
        minWidth: maxWidth,
        minHeight: (maxWidth * 0.75).round(),
      );

      if (thumbnailFile != null) {
        _logger.i('Thumbnail generated: ${thumbnailFile.path}');
        return File(thumbnailFile.path);
      } else {
        throw Exception('Thumbnail generation failed');
      }
    } catch (e) {
      _logger.e('Error generating thumbnail: $e');
      rethrow;
    }
  }
}
