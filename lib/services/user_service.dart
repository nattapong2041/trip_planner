import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import '../models/user.dart';

/// Service for managing user documents in Firestore
class UserService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final Logger _logger = Logger();
  
  static const String _usersCollection = 'users';
  
  /// Create or update user document in Firestore
  /// This should be called after successful authentication
  static Future<void> createOrUpdateUserDocument(User user) async {
    try {
      _logger.d('Creating/updating user document for: ${user.email}');
      
      final userDoc = _firestore.collection(_usersCollection).doc(user.id);
      
      // Check if user document already exists
      final docSnapshot = await userDoc.get();
      
      if (docSnapshot.exists) {
        // Update existing user document with latest info
        await userDoc.update({
          'email': user.email,
          'displayName': user.displayName,
          'photoUrl': user.photoUrl,
          'updatedAt': FieldValue.serverTimestamp(),
        });
        _logger.i('Updated existing user document: ${user.id}');
      } else {
        // Create new user document
        await userDoc.set({
          'id': user.id,
          'email': user.email,
          'displayName': user.displayName,
          'photoUrl': user.photoUrl,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
        _logger.i('Created new user document: ${user.id}');
      }
    } catch (e) {
      _logger.e('Error creating/updating user document: $e');
      throw Exception('Failed to create/update user document: $e');
    }
  }
  
  /// Get user by email (for collaboration features)
  static Future<User?> getUserByEmail(String email) async {
    try {
      _logger.d('Looking up user by email: $email');
      
      final querySnapshot = await _firestore
          .collection(_usersCollection)
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      
      if (querySnapshot.docs.isEmpty) {
        _logger.w('No user found with email: $email');
        return null;
      }
      
      final doc = querySnapshot.docs.first;
      final data = doc.data();
      data['id'] = doc.id;
      
      // Remove timestamp fields that aren't part of the User model
      data.remove('createdAt');
      data.remove('updatedAt');
      
      final user = User.fromJson(data);
      _logger.d('Found user: ${user.displayName}');
      
      return user;
    } catch (e) {
      _logger.e('Error getting user by email: $e');
      throw Exception('Failed to get user by email: $e');
    }
  }
  
  /// Get multiple users by IDs
  static Future<List<User>> getUsersByIds(List<String> userIds) async {
    try {
      _logger.d('Getting users by IDs: $userIds');
      
      if (userIds.isEmpty) {
        return [];
      }
      
      // Firestore 'in' queries are limited to 10 items
      final users = <User>[];
      
      // Process in chunks of 10
      for (int i = 0; i < userIds.length; i += 10) {
        final chunk = userIds.skip(i).take(10).toList();
        
        final querySnapshot = await _firestore
            .collection(_usersCollection)
            .where(FieldPath.documentId, whereIn: chunk)
            .get();
        
        for (final doc in querySnapshot.docs) {
          final data = doc.data();
          data['id'] = doc.id;
          
          // Remove timestamp fields that aren't part of the User model
          data.remove('createdAt');
          data.remove('updatedAt');
          
          users.add(User.fromJson(data));
        }
      }
      
      _logger.d('Retrieved ${users.length} users');
      return users;
    } catch (e) {
      _logger.e('Error getting users by IDs: $e');
      throw Exception('Failed to get users by IDs: $e');
    }
  }
}