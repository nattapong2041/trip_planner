/// Platform-agnostic file representation
abstract class PlatformFile {
  String get path;
  String get name;
  Future<List<int>> readAsBytes();
  Future<int> length();
}

/// Abstract interface for image operations
abstract class ImageService {
  /// Pick image from gallery
  Future<PlatformFile?> pickFromGallery();

  /// Pick image from camera
  Future<PlatformFile?> pickFromCamera();

  /// Compress image if it exceeds size limit
  Future<PlatformFile> compressImage(PlatformFile imageFile,
      {int maxSizeBytes = 3 * 1024 * 1024});

  /// Get image file size
  Future<int> getFileSize(PlatformFile file);

  /// Generate thumbnail for image
  Future<PlatformFile> generateThumbnail(PlatformFile imageFile, {int maxWidth = 300});
}