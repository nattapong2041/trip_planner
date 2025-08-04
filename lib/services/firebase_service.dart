import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';

/// Service class to test Firebase connection and basic operations
class FirebaseService {
  static final _logger = Logger();
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Test Firebase Authentication connection
  static Future<bool> testAuthConnection() async {
    try {
      // Check if Firebase Auth is properly initialized
      final currentUser = _auth.currentUser;
      _logger.i('Firebase Auth connection test successful. Current user: ${currentUser?.uid ?? 'None'}');
      return true;
    } catch (e) {
      _logger.e('Firebase Auth connection test failed: $e');
      return false;
    }
  }

  /// Test Firestore connection by attempting to read from a test collection
  static Future<bool> testFirestoreConnection() async {
    try {
      // Try to access Firestore and perform a simple operation
      final testDoc = _firestore.collection('test').doc('connection_test');
      
      // Write a test document with timeout
      await testDoc.set({
        'timestamp': FieldValue.serverTimestamp(),
        'test': true,
        'message': 'Firebase connection test'
      }).timeout(const Duration(seconds: 10));
      
      // Read the test document back with timeout
      final docSnapshot = await testDoc.get().timeout(const Duration(seconds: 10));
      
      if (docSnapshot.exists) {
        _logger.i('Firestore connection test successful. Document data: ${docSnapshot.data()}');
        
        // Clean up test document
        try {
          await testDoc.delete().timeout(const Duration(seconds: 5));
          _logger.i('Test document cleaned up successfully');
        } catch (cleanupError) {
          _logger.w('Failed to clean up test document: $cleanupError');
          // Don't fail the test if cleanup fails
        }
        
        return true;
      } else {
        _logger.w('Firestore connection test: Document was not found after creation');
        return false;
      }
    } catch (e) {
      _logger.e('Firestore connection test failed: $e');
      return false;
    }
  }

  /// Test Firebase Storage connection
  static Future<bool> testStorageConnection() async {
    try {
      // Try to access Firebase Storage and perform a simple operation
      final testRef = _storage.ref().child('test/connection_test.txt');
      
      // Upload a test file with timeout
      const testData = 'Firebase Storage connection test';
      await testRef.putString(testData).timeout(const Duration(seconds: 30));
      
      // Download the test file back with timeout
      final downloadedData = await testRef.getData().timeout(const Duration(seconds: 30));
      
      if (downloadedData != null) {
        final downloadedString = String.fromCharCodes(downloadedData);
        _logger.i('Firebase Storage connection test successful. Downloaded: $downloadedString');
        
        // Clean up test file
        try {
          await testRef.delete().timeout(const Duration(seconds: 10));
          _logger.i('Test file cleaned up successfully');
        } catch (cleanupError) {
          _logger.w('Failed to clean up test file: $cleanupError');
          // Don't fail the test if cleanup fails
        }
        
        return true;
      } else {
        _logger.w('Firebase Storage connection test: No data downloaded');
        return false;
      }
    } catch (e) {
      _logger.e('Firebase Storage connection test failed: $e');
      return false;
    }
  }

  /// Test all Firebase services
  static Future<Map<String, bool>> testAllConnections() async {
    _logger.i('Testing all Firebase connections...');
    
    final results = <String, bool>{};
    
    results['auth'] = await testAuthConnection();
    results['firestore'] = await testFirestoreConnection();
    results['storage'] = await testStorageConnection();
    
    final allPassed = results.values.every((result) => result);
    _logger.i('Firebase connection tests completed. All passed: $allPassed');
    
    return results;
  }
}