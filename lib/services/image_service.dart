import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:logger/logger.dart';
import 'image_service_interface.dart';

// Export the interface
export 'image_service_interface.dart';

/// Universal platform file implementation using XFile (works on all platforms)
class UniversalPlatformFile implements PlatformFile {
  final XFile _xFile;
  final String _name;

  UniversalPlatformFile(this._xFile, [String? name]) : _name = name ?? _xFile.name;

  @override
  String get path => _xFile.path;

  @override
  String get name => _name;

  @override
  Future<List<int>> readAsBytes() async {
    final bytes = await _xFile.readAsBytes();
    return bytes.toList();
  }

  @override
  Future<int> length() async {
    final bytes = await _xFile.readAsBytes();
    return bytes.length;
  }

  XFile get xFile => _xFile;
}

/// Universal implementation of ImageService using XFile (works on all platforms)
class ImageServiceImpl implements ImageService {
  final ImagePicker _picker = ImagePicker();
  final Logger _logger = Logger();

  @override
  Future<PlatformFile?> pickFromGallery() async {
    try {
      _logger.d('Picking image from gallery');

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 85,
      );

      if (image != null) {
        _logger.i('Image picked from gallery: ${image.name}');
        return UniversalPlatformFile(image);
      }

      _logger.d('No image selected from gallery');
      return null;
    } catch (e) {
      _logger.e('Error picking image from gallery: $e');
      rethrow;
    }
  }

  @override
  Future<PlatformFile?> pickFromCamera() async {
    try {
      _logger.d('Picking image from camera');

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 85,
      );

      if (image != null) {
        _logger.i('Image captured from camera: ${image.name}');
        return UniversalPlatformFile(image);
      }

      _logger.d('No image captured from camera');
      return null;
    } catch (e) {
      _logger.e('Error picking image from camera: $e');
      rethrow;
    }
  }

  @override
  Future<PlatformFile> compressImage(PlatformFile imageFile,
      {int maxSizeBytes = 3 * 1024 * 1024}) async {
    try {
      final universalFile = imageFile as UniversalPlatformFile;
      final xFile = universalFile.xFile;

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
        quality = 60; // More aggressive compression for very large files
      } else if (fileSize > maxSizeBytes * 1.5) {
        quality = 70; // Moderate compression for large files
      }

      _logger.d('Using compression quality: $quality');

      // Use compressWithFile which works on all platforms
      final compressedBytes = await FlutterImageCompress.compressWithFile(
        xFile.path,
        quality: quality,
        minWidth: 800,
        minHeight: 600,
      );

      if (compressedBytes != null) {
        // Create a new XFile from the compressed bytes
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final compressedFile = XFile.fromData(
          Uint8List.fromList(compressedBytes),
          name: 'compressed_$timestamp.jpg',
          mimeType: 'image/jpeg',
        );
        
        final compressedPlatformFile = UniversalPlatformFile(compressedFile);
        final compressedSize = await getFileSize(compressedPlatformFile);
        
        // Verify compression was effective
        if (compressedSize >= fileSize) {
          _logger.w('Compression did not reduce file size significantly. Original: ${fileSize}B, Compressed: ${compressedSize}B');
        }
        
        _logger.i('Image compressed from ${fileSize}B to ${compressedSize}B (${((1 - compressedSize / fileSize) * 100).toStringAsFixed(1)}% reduction)');
        return compressedPlatformFile;
      } else {
        throw Exception('Image compression failed - compressed file is null');
      }
    } catch (e) {
      _logger.e('Error compressing image: $e');
      rethrow;
    }
  }

  @override
  Future<int> getFileSize(PlatformFile file) async {
    try {
      return await file.length();
    } catch (e) {
      _logger.e('Error getting file size: $e');
      rethrow;
    }
  }

  @override
  Future<PlatformFile> generateThumbnail(PlatformFile imageFile, {int maxWidth = 300}) async {
    try {
      final universalFile = imageFile as UniversalPlatformFile;
      final xFile = universalFile.xFile;

      _logger.d('Generating thumbnail for image: ${xFile.name}');

      // Use compressWithFile which works on all platforms
      final thumbnailBytes = await FlutterImageCompress.compressWithFile(
        xFile.path,
        quality: 70,
        minWidth: maxWidth,
        minHeight: (maxWidth * 0.75).round(),
      );

      if (thumbnailBytes != null) {
        // Create a new XFile from the thumbnail bytes
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final thumbnailFile = XFile.fromData(
          Uint8List.fromList(thumbnailBytes),
          name: 'thumb_$timestamp.jpg',
          mimeType: 'image/jpeg',
        );
        
        _logger.i('Thumbnail generated: ${thumbnailFile.name}');
        return UniversalPlatformFile(thumbnailFile);
      } else {
        throw Exception('Thumbnail generation failed - thumbnail file is null');
      }
    } catch (e) {
      _logger.e('Error generating thumbnail: $e');
      rethrow;
    }
  }
}

/// Factory function to create the ImageService implementation
ImageService createImageService() => ImageServiceImpl();
