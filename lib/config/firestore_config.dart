import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Configuration service for Firestore offline persistence and real-time sync
class FirestoreConfig {
  static final Logger _logger = Logger();
  static bool _isConfigured = false;

  /// Enable Firestore offline persistence and configure real-time sync
  /// This should be called once during app initialization, after Firebase.initializeApp()
  static Future<void> enableOfflinePersistence() async {
    if (_isConfigured) {
      _logger.w('Firestore offline persistence already configured');
      return;
    }

    try {
      final db = FirebaseFirestore.instance;

      if (kIsWeb) {
        // Web platform - enable persistence with tab synchronization
        db.settings = const Settings(
          persistenceEnabled: true,
          cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
        );
        _logger.i(
            'Firestore web offline persistence enabled with unlimited cache');
      } else {
        // Mobile platforms (iOS, Android) and Desktop
        db.settings = const Settings(
          persistenceEnabled: true,
          cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
        );
        _logger.i(
            'Firestore mobile offline persistence enabled with unlimited cache');
      }

      _isConfigured = true;
      _logger.i(
          'Firestore offline persistence and real-time sync configured successfully');
    } catch (e) {
      _logger.e('Failed to enable Firestore offline persistence: $e');
      // Don't throw - app should continue to work without offline persistence
    }
  }

  /// Check if offline persistence is configured
  static bool get isConfigured => _isConfigured;

  /// Get Firestore instance with offline persistence enabled
  static FirebaseFirestore get instance {
    if (!_isConfigured) {
      _logger.w(
          'Firestore offline persistence not configured. Call enableOfflinePersistence() first.');
    }
    return FirebaseFirestore.instance;
  }

  /// Configure Firestore for optimal real-time collaboration
  static void configureForCollaboration() {
    final db = FirebaseFirestore.instance;

    // Enable network for real-time updates
    db.enableNetwork();

    _logger.i('Firestore configured for real-time collaboration');
  }

  /// Disable network (for testing offline scenarios)
  static Future<void> disableNetwork() async {
    try {
      await FirebaseFirestore.instance.disableNetwork();
      _logger.i('Firestore network disabled for offline testing');
    } catch (e) {
      _logger.e('Failed to disable Firestore network: $e');
    }
  }

  /// Enable network (restore online functionality)
  static Future<void> enableNetwork() async {
    try {
      await FirebaseFirestore.instance.enableNetwork();
      _logger.i('Firestore network enabled - back online');
    } catch (e) {
      _logger.e('Failed to enable Firestore network: $e');
    }
  }

  /// Clear offline cache (useful for testing)
  static Future<void> clearPersistence() async {
    try {
      await FirebaseFirestore.instance.clearPersistence();
      _logger.i('Firestore offline cache cleared');
    } catch (e) {
      _logger.e('Failed to clear Firestore persistence: $e');
    }
  }
}
