import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';
import 'image_service.dart';

/// Abstract interface for image storage operations
abstract class ImageStorageService {
  /// Upload image to storage
  Future<String> uploadImage(
    PlatformFile imageFile,
    String storagePath, {
    Function(double)? onProgress,
  });

  /// Delete image from storage
  Future<void> deleteImage(String storagePath);

  /// Get download URL for image
  Future<String> getDownloadUrl(String storagePath);
}

/// Firebase Storage implementation of ImageStorageService
class FirebaseImageStorageService implements ImageStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Logger _logger = Logger();

  @override
  Future<String> uploadImage(
    PlatformFile imageFile,
    String storagePath, {
    Function(double)? onProgress,
  }) async {
    try {
      _logger.d('Uploading image to: $storagePath');

      final ref = _storage.ref().child(storagePath);

      // Get image bytes
      final imageBytes = await imageFile.readAsBytes();
      final uploadTask = ref.putData(
        Uint8List.fromList(imageBytes),
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'originalName': imageFile.name,
          },
        ),
      );

      // Listen to upload progress
      if (onProgress != null) {
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          if (snapshot.totalBytes > 0) {
            final progress = snapshot.bytesTransferred / snapshot.totalBytes;
            onProgress(progress);
            _logger
                .d('Upload progress: ${(progress * 100).toStringAsFixed(1)}%');
          }
        });
      }

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      _logger.i('Image uploaded successfully: $downloadUrl');
      return downloadUrl;
    } on FirebaseException catch (e) {
      _logger.e('Firebase error uploading image: ${e.code} - ${e.message}');
      throw _handleFirebaseStorageError(e, 'upload');
    } catch (e) {
      _logger.e('Error uploading image: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteImage(String storagePath) async {
    try {
      _logger.d('Deleting image from: $storagePath');

      if (storagePath.isEmpty) {
        throw Exception('Storage path cannot be empty');
      }

      final ref = _storage.ref().child(storagePath);
      await ref.delete();

      _logger.i('Image deleted successfully: $storagePath');
    } on FirebaseException catch (e) {
      _logger.e('Firebase error deleting image: ${e.code} - ${e.message}');

      // If the file doesn't exist, consider it a successful deletion
      if (e.code == 'object-not-found') {
        _logger.w(
            'Image not found, considering deletion successful: $storagePath');
        return;
      }

      throw _handleFirebaseStorageError(e, 'delete');
    } catch (e) {
      _logger.e('Error deleting image: $e');
      rethrow;
    }
  }

  @override
  Future<String> getDownloadUrl(String storagePath) async {
    try {
      _logger.d('Getting download URL for: $storagePath');

      if (storagePath.isEmpty) {
        throw Exception('Storage path cannot be empty');
      }

      final ref = _storage.ref().child(storagePath);
      final downloadUrl = await ref.getDownloadURL();

      _logger.d('Download URL retrieved: $downloadUrl');
      return downloadUrl;
    } on FirebaseException catch (e) {
      _logger
          .e('Firebase error getting download URL: ${e.code} - ${e.message}');
      throw _handleFirebaseStorageError(e, 'get URL');
    } catch (e) {
      _logger.e('Error getting download URL: $e');
      rethrow;
    }
  }

  /// Handle Firebase Storage specific errors and provide user-friendly messages
  Exception _handleFirebaseStorageError(FirebaseException e, String operation) {
    switch (e.code) {
      case 'object-not-found':
        return Exception('Image not found in storage');
      case 'unauthorized':
        return Exception(
            'Unauthorized access to storage. Please check your permissions.');
      case 'canceled':
        return Exception('$operation operation was canceled');
      case 'unknown':
        return Exception('An unknown error occurred during $operation');
      case 'retry-limit-exceeded':
        return Exception(
            'Upload failed after multiple retries. Please check your connection.');
      case 'invalid-checksum':
        return Exception('File integrity check failed during $operation');
      case 'quota-exceeded':
        return Exception('Storage quota exceeded. Please contact support.');
      default:
        return Exception('Storage error during $operation: ${e.message}');
    }
  }
}
