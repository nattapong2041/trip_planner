import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import '../../lib/services/image_service.dart';

// Generate mocks
@GenerateMocks([])
void main() {
  group('ImageService Compression Tests', () {
    late ImageServiceImpl imageService;

    setUp(() {
      imageService = ImageServiceImpl();
    });

    group('compressImage', () {
      test('should compress images larger than 3MB', () async {
        // Create a mock large image file (5MB)
        final largeImageData = Uint8List(5 * 1024 * 1024); // 5MB of data
        final largeImageFile = _createMockPlatformFile(
          'large_image.jpg',
          largeImageData,
        );

        // Compress the image
        final compressedFile = await imageService.compressImage(largeImageFile);
        final compressedSize = await imageService.getFileSize(compressedFile);

        // Verify compression occurred
        expect(compressedSize, lessThan(3 * 1024 * 1024));
        expect(compressedFile, isNot(same(largeImageFile)));
      });

      test('should not compress images smaller than 3MB', () async {
        // Create a mock small image file (1MB)
        final smallImageData = Uint8List(1 * 1024 * 1024); // 1MB of data
        final smallImageFile = _createMockPlatformFile(
          'small_image.jpg',
          smallImageData,
        );

        // Attempt to compress the image
        final result = await imageService.compressImage(smallImageFile);
        final resultSize = await imageService.getFileSize(result);

        // Verify no compression occurred (same file returned)
        expect(result, same(smallImageFile));
        expect(resultSize, equals(1 * 1024 * 1024));
      });

      test('should maintain good quality after compression', () async {
        // Create a mock large image file (4MB)
        final largeImageData = Uint8List(4 * 1024 * 1024); // 4MB of data
        final largeImageFile = _createMockPlatformFile(
          'quality_test.jpg',
          largeImageData,
        );

        // Compress the image
        final compressedFile = await imageService.compressImage(largeImageFile);
        final compressedSize = await imageService.getFileSize(compressedFile);

        // Verify compression maintains reasonable quality
        // Compressed size should be less than original but not too small
        expect(compressedSize, lessThan(4 * 1024 * 1024));
        expect(compressedSize, greaterThan(500 * 1024)); // At least 500KB
      });

      test('should use different quality levels based on file size', () async {
        // Create mock files of different sizes
        final mediumFile = _createMockPlatformFile(
          'medium.jpg',
          Uint8List(4 * 1024 * 1024), // 4MB
        );
        
        final largeFile = _createMockPlatformFile(
          'large.jpg',
          Uint8List(8 * 1024 * 1024), // 8MB
        );

        // Compress both files
        final compressedMedium = await imageService.compressImage(mediumFile);
        final compressedLarge = await imageService.compressImage(largeFile);

        final mediumSize = await imageService.getFileSize(compressedMedium);
        final largeSize = await imageService.getFileSize(compressedLarge);

        // Both should be compressed to under 3MB
        expect(mediumSize, lessThan(3 * 1024 * 1024));
        expect(largeSize, lessThan(3 * 1024 * 1024));
      });

      test('should handle compression errors gracefully', () async {
        // Create a mock file that will cause compression to fail
        final invalidFile = _createMockPlatformFile(
          'invalid.txt', // Not an image file
          Uint8List.fromList([1, 2, 3, 4, 5]),
        );

        // Expect compression to throw an error
        expect(
          () => imageService.compressImage(invalidFile),
          throwsException,
        );
      });
    });

    group('getFileSize', () {
      test('should return correct file size', () async {
        final testData = Uint8List(1024); // 1KB
        final testFile = _createMockPlatformFile('test.jpg', testData);

        final size = await imageService.getFileSize(testFile);

        expect(size, equals(1024));
      });
    });
  });
}

/// Helper function to create a mock PlatformFile for testing
UniversalPlatformFile _createMockPlatformFile(String name, Uint8List data) {
  final xFile = XFile.fromData(
    data,
    name: name,
    mimeType: 'image/jpeg',
  );
  return UniversalPlatformFile(xFile, name);
}