import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/activity_image.dart';
import '../models/app_error.dart';
import '../services/image_service.dart';
import '../services/image_storage_service.dart';
import 'auth_provider.dart';
import 'activity_provider.dart';

part 'activity_image_provider.g.dart';

/// Provider for the ImageService instance
@riverpod
ImageService imageService(Ref ref) {
  return createImageService();
}

/// Provider for the ImageStorageService instance
@riverpod
ImageStorageService imageStorageService(Ref ref) {
  return FirebaseImageStorageService();
}

/// Notifier for managing activity images
@riverpod
class ActivityImageNotifier extends _$ActivityImageNotifier {
  @override
  AsyncValue<List<ActivityImage>> build(String activityId) {
    // Watch the activity detail to get the current images
    final activityDetail =
        ref.watch(activityDetailNotifierProvider(activityId));
    return activityDetail.when(
      data: (activity) => AsyncValue.data(activity?.images ?? []),
      loading: () => const AsyncValue.loading(),
      error: (error, stack) => AsyncValue.error(error, stack),
    );
  }

  /// Force refresh the images by refreshing the activity detail
  Future<void> refreshImages() async {
    // Invalidate the activity detail provider to force a refresh
    ref.invalidate(activityDetailNotifierProvider(activityId));
    
    // Wait for the invalidation to propagate and then refresh this provider
    await Future.delayed(const Duration(milliseconds: 200));
    ref.invalidateSelf();
  }

  /// Add image to activity with compression and upload
  Future<void> addImage(ImageSource source, {int maxRetries = 3}) async {
    int retryCount = 0;

    while (retryCount <= maxRetries) {
      try {
        await _performImageUpload(source, retryCount);
        return; // Success - exit retry loop
      } catch (error) {
        retryCount++;

        if (retryCount > maxRetries) {
          // Max retries reached, throw the error
          rethrow;
        }

        // Wait before retrying (exponential backoff)
        await Future.delayed(Duration(seconds: retryCount * 2));

        // Update loading message to show retry attempt
        ref.read(loadingNotifierProvider.notifier).showLoading();
      }
    }
  }

  /// Perform the actual image upload process
  Future<void> _performImageUpload(
      ImageSource source, int attemptNumber) async {
    try {
      state = const AsyncValue.loading();

      final user = ref.read(authNotifierProvider).value;
      if (user == null) {
        throw Exception('User must be authenticated to add images');
      }

      final imageService = ref.read(imageServiceProvider);
      final storageService = ref.read(imageStorageServiceProvider);
      final activityRepository = ref.read(activityRepositoryProvider);

      // Pick image (only on first attempt)
      PlatformFile? imageFile;
      if (attemptNumber == 0) {
        if (source == ImageSource.gallery) {
          imageFile = await imageService.pickFromGallery();
        } else {
          imageFile = await imageService.pickFromCamera();
        }

        if (imageFile == null) {
          // User cancelled, restore previous state
          ref.invalidateSelf();
          return;
        }

        // Store the picked file for potential retries
        _lastPickedFile = imageFile;
      } else {
        // Use the previously picked file for retries
        imageFile = _lastPickedFile;
        if (imageFile == null) {
          throw Exception('No image file available for retry');
        }
      }

      // Show compression progress (only on first attempt)
      if (attemptNumber == 0) {
        ref.read(loadingNotifierProvider.notifier).showLoading();
      }

      // Compress image if needed (only on first attempt)
      PlatformFile compressedFile;
      if (attemptNumber == 0) {
        compressedFile = await imageService.compressImage(imageFile);
        _lastCompressedFile = compressedFile;
      } else {
        compressedFile = _lastCompressedFile ?? imageFile;
      }

      final fileSize = await imageService.getFileSize(compressedFile);

      // Generate storage path (only on first attempt)
      String storagePath;
      if (attemptNumber == 0) {
        final fileName = '${const Uuid().v4()}.jpg';
        storagePath = 'activities/$activityId/images/$fileName';
        _lastStoragePath = storagePath;
      } else {
        storagePath = _lastStoragePath ??
            'activities/$activityId/images/${const Uuid().v4()}.jpg';
      }

      // Update loading message for upload
      ref.read(loadingNotifierProvider.notifier).showLoading();

      // Upload to Firebase Storage with progress tracking
      final downloadUrl = await storageService.uploadImage(
        compressedFile,
        storagePath,
        onProgress: (progress) {
          // Progress tracking (loading state is already shown)
        },
      );

      // Create ActivityImage object
      final activityImage = ActivityImage(
        id: '', // Will be set by repository
        url: downloadUrl,
        storagePath: storagePath,
        uploadedBy: user.id,
        uploadedAt: DateTime.now(),
        originalFileName: imageFile.name,
        fileSizeBytes: fileSize,
      );

      // Add to activity
      await activityRepository.addImageToActivity(activityId, activityImage);

      ref.read(loadingNotifierProvider.notifier).hideLoading();
      ref
          .read(successNotifierProvider.notifier)
          .showSuccessWithAutoClear('Image added successfully!');

      // Clear cached files after successful upload
      _clearCachedFiles();

      // Clear cached network image for the new URL to ensure fresh display
      await CachedNetworkImage.evictFromCache(downloadUrl);

      // Refresh the images
      await refreshImages();
    } catch (error) {
      ref.read(loadingNotifierProvider.notifier).hideLoading();

      // Don't show error immediately if we're going to retry
      if (attemptNumber < 3) {
        // Just rethrow to trigger retry
        rethrow;
      }

      // Final attempt failed, show error
      final appError = _handleImageError(error);
      ref.read(errorNotifierProvider.notifier).showError(appError);
      state = AsyncValue.error(error, StackTrace.current);

      // Clear cached files after final failure
      _clearCachedFiles();

      rethrow;
    }
  }

  // Cache variables for retry functionality
  PlatformFile? _lastPickedFile;
  PlatformFile? _lastCompressedFile;
  String? _lastStoragePath;

  /// Clear cached files used for retries
  void _clearCachedFiles() {
    _lastPickedFile = null;
    _lastCompressedFile = null;
    _lastStoragePath = null;
  }

  /// Retry the last failed upload with the same image
  Future<void> retryLastUpload(ImageSource source) async {
    if (_lastPickedFile == null) {
      throw Exception('No previous upload to retry');
    }

    try {
      await _performImageUpload(source, 1); // Start from attempt 1 (retry)
    } catch (error) {
      // Error handling is done in _performImageUpload
      rethrow;
    }
  }

  /// Remove image from activity and storage
  Future<void> removeImage(String imageId) async {
    try {
      final currentImages = state.value ?? [];
      final imageToRemove = currentImages.firstWhere(
        (img) => img.id == imageId,
        orElse: () => throw Exception('Image not found'),
      );

      final storageService = ref.read(imageStorageServiceProvider);
      final activityRepository = ref.read(activityRepositoryProvider);

      // Remove from Firebase Storage
      await storageService.deleteImage(imageToRemove.storagePath);

      // Clear cached network image
      await CachedNetworkImage.evictFromCache(imageToRemove.url);

      // Remove from activity
      await activityRepository.removeImageFromActivity(activityId, imageId);

      ref
          .read(successNotifierProvider.notifier)
          .showSuccessWithAutoClear('Image removed successfully!');

      // Refresh the images
      await refreshImages();
    } catch (error) {
      final appError = _handleImageError(error);
      ref.read(errorNotifierProvider.notifier).showError(appError);
      rethrow;
    }
  }

  /// Reorder images in activity
  Future<void> reorderImages(List<String> imageIds) async {
    try {
      final activityRepository = ref.read(activityRepositoryProvider);
      await activityRepository.reorderActivityImages(activityId, imageIds);

      ref
          .read(successNotifierProvider.notifier)
          .showSuccessWithAutoClear('Images reordered successfully!');

      // Refresh the images
      await refreshImages();
    } catch (error) {
      final appError = _handleImageError(error);
      ref.read(errorNotifierProvider.notifier).showError(appError);
      rethrow;
    }
  }

  /// Update image caption
  Future<void> updateCaption(String imageId, String caption) async {
    try {
      final activityRepository = ref.read(activityRepositoryProvider);
      await activityRepository.updateImageCaption(activityId, imageId, caption);

      ref
          .read(successNotifierProvider.notifier)
          .showSuccessWithAutoClear('Caption updated successfully!');

      // Refresh the images
      await refreshImages();
    } catch (error) {
      final appError = _handleImageError(error);
      ref.read(errorNotifierProvider.notifier).showError(appError);
      rethrow;
    }
  }

  /// Helper method to convert exceptions to AppError
  AppError _handleImageError(Object error) {
    final errorMessage = error.toString();

    if (errorMessage.contains('Maximum of 5 images')) {
      return const AppError.validation(
          'Maximum of 5 images allowed per activity.');
    } else if (errorMessage.contains('network') ||
        errorMessage.contains('Network error') ||
        errorMessage.contains('SocketException') ||
        errorMessage.contains('TimeoutException')) {
      return AppError.network(
          'Upload failed due to network issues. The upload was automatically retried but still failed. Please check your connection and try again.');
    } else if (errorMessage.contains('storage') ||
        errorMessage.contains('Storage error') ||
        errorMessage.contains('firebase_storage')) {
      return const AppError.unknown(
          'Storage error occurred during upload. The upload was automatically retried but still failed. Please try again.');
    } else if (errorMessage.contains('permission') ||
        errorMessage.contains('Unauthorized')) {
      return const AppError.permission(
          'Permission denied. Please allow access to photos.');
    } else if (errorMessage.contains('file too large') ||
        errorMessage.contains('size limit')) {
      return const AppError.validation(
          'Image file is too large. Please select a smaller image.');
    } else if (errorMessage.contains('unsupported format')) {
      return const AppError.validation(
          'Unsupported image format. Please select a JPEG or PNG image.');
    } else if (errorMessage.contains('compression failed')) {
      return const AppError.unknown(
          'Failed to optimize image. Please try a different image.');
    } else if (errorMessage.contains('upload failed')) {
      return AppError.network(
          'Upload failed after multiple attempts. Please check your connection and try again.');
    } else {
      return AppError.unknown(
          'Upload failed after multiple attempts. Please try again.');
    }
  }
}
