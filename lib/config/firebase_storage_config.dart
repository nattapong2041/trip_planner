import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Configuration service for Firebase Storage
class FirebaseStorageConfig {
  static final Logger _logger = Logger();
  static bool _isConfigured = false;

  /// Configure Firebase Storage settings
  /// This should be called once during app initialization, after Firebase.initializeApp()
  static Future<void> configure() async {
    if (_isConfigured) {
      _logger.w('Firebase Storage already configured');
      return;
    }

    try {
      final storage = FirebaseStorage.instance;

      // Configure storage settings based on platform
      if (kIsWeb) {
        // Web platform configuration
        _logger.i('Firebase Storage configured for web platform');
      } else {
        // Mobile and desktop platforms
        // Set maximum upload timeout to 2 minutes
        storage.setMaxUploadRetryTime(const Duration(minutes: 2));
        storage.setMaxDownloadRetryTime(const Duration(minutes: 1));
        storage.setMaxOperationRetryTime(const Duration(minutes: 2));
        
        _logger.i('Firebase Storage configured for mobile/desktop platform');
      }

      _isConfigured = true;
      _logger.i('Firebase Storage configured successfully');
    } catch (e) {
      _logger.e('Failed to configure Firebase Storage: $e');
      // Don't throw - app should continue to work
    }
  }

  /// Check if Firebase Storage is configured
  static bool get isConfigured => _isConfigured;

  /// Get Firebase Storage instance
  static FirebaseStorage get instance {
    if (!_isConfigured) {
      _logger.w('Firebase Storage not configured. Call configure() first.');
    }
    return FirebaseStorage.instance;
  }

  /// Get storage reference for activity images
  static Reference getActivityImagesRef(String activityId) {
    return instance.ref().child('activities/$activityId/images');
  }

  /// Get storage reference for a specific image
  static Reference getImageRef(String activityId, String imageId) {
    return instance.ref().child('activities/$activityId/images/$imageId');
  }

  /// Get storage reference with custom path
  static Reference getRef(String path) {
    return instance.ref().child(path);
  }

  /// Configure storage emulator for development (if needed)
  static void useEmulator(String host, int port) {
    try {
      FirebaseStorage.instance.useStorageEmulator(host, port);
      _logger.i('Firebase Storage emulator configured at $host:$port');
    } catch (e) {
      _logger.e('Failed to configure Firebase Storage emulator: $e');
    }
  }
}