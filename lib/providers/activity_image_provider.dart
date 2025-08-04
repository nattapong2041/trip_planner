import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;
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
  return ImageServiceImpl();
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
    final activityDetail =
        ref.watch(activityDetailNotifierProvider(activityId));
    return activityDetail.when(
      data: (activity) => AsyncValue.data(activity?.images ?? []),
      loading: () => const AsyncValue.loading(),
      error: (error, stack) => AsyncValue.error(error, stack),
    );
  }

  /// Add image to activity with compression and upload
  Future<void> addImage(ImageSource source) async {
    try {
      state = const AsyncValue.loading();

      final user = ref.read(authNotifierProvider).value;
      if (user == null) {
        throw Exception('User must be authenticated to add images');
      }

      final imageService = ref.read(imageServiceProvider);
      final storageService = ref.read(imageStorageServiceProvider);
      final activityRepository = ref.read(activityRepositoryProvider);

      // Pick image
      File? imageFile;
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

      // Show compression progress
      ref.read(loadingNotifierProvider.notifier).showLoading();

      // Compress image if needed
      final compressedFile = await imageService.compressImage(imageFile);
      final fileSize = await imageService.getFileSize(compressedFile);

      // Generate storage path
      final fileName = '${const Uuid().v4()}.jpg';
      final storagePath = 'activities/$activityId/images/$fileName';

      // Upload to Firebase Storage with progress tracking
      final downloadUrl = await storageService.uploadImage(
        compressedFile,
        storagePath,
        onProgress: (progress) {
          // Progress is handled by the storage service
        },
      );

      // Create ActivityImage object
      final activityImage = ActivityImage(
        id: '', // Will be set by repository
        url: downloadUrl,
        storagePath: storagePath,
        uploadedBy: user.id,
        uploadedAt: DateTime.now(),
        originalFileName: path.basename(imageFile.path),
        fileSizeBytes: fileSize,
      );

      // Add to activity
      await activityRepository.addImageToActivity(activityId, activityImage);

      ref.read(loadingNotifierProvider.notifier).hideLoading();
      ref
          .read(successNotifierProvider.notifier)
          .showSuccessWithAutoClear('Image added successfully!');

      // Clean up temporary files
      try {
        if (compressedFile.path != imageFile.path) {
          await compressedFile.delete();
        }
      } catch (e) {
        // Ignore cleanup errors
      }

      // Refresh the state
      ref.invalidateSelf();
    } catch (error) {
      ref.read(loadingNotifierProvider.notifier).hideLoading();
      final appError = _handleImageError(error);
      ref.read(errorNotifierProvider.notifier).showError(appError);
      state = AsyncValue.error(error, StackTrace.current);
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

      // Remove from activity
      await activityRepository.removeImageFromActivity(activityId, imageId);

      ref
          .read(successNotifierProvider.notifier)
          .showSuccessWithAutoClear('Image removed successfully!');

      // Refresh the state
      ref.invalidateSelf();
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

      // Refresh the state
      ref.invalidateSelf();
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

      // Refresh the state
      ref.invalidateSelf();
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
        errorMessage.contains('Network error')) {
      return const AppError.network(
          'Network error while managing images. Please check your connection.');
    } else if (errorMessage.contains('storage') ||
        errorMessage.contains('Storage error')) {
      return const AppError.unknown('Storage error. Please try again.');
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
      return const AppError.network(
          'Failed to upload image. Please check your connection and try again.');
    } else {
      return const AppError.unknown(
          'An error occurred while managing images. Please try again.');
    }
  }
}
