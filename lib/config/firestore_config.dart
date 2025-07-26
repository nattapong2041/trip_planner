import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Configuration service for Firestore offline persistence
class FirestoreConfig {
  static final Logger _logger = Logger();
  static bool _isConfigured = false;

  /// Enable Firestore offline persistence
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
        await db.enablePersistence(
          const PersistenceSettings(synchronizeTabs: true),
        );
        _logger.i('Firestore web offline persistence enabled with tab synchronization');
      } else {
        // Mobile platforms (iOS, Android) and Desktop
        db.settings = const Settings(persistenceEnabled: true);
        _logger.i('Firestore mobile offline persistence enabled');
      }

      _isConfigured = true;
    } catch (e) {
      _logger.e('Failed to enable Firestore offline persistence: $e');
      // Don't throw - app should continue to work without offline persistence
    }
  }

  /// Check if offline persistence is configured
  static bool get isConfigured => _isConfigured;
}