import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import '../models/activity.dart';
import '../models/brainstorm_idea.dart';
import 'activity_repository.dart';

/// Firebase implementation of ActivityRepository using Firestore
class FirebaseActivityRepository implements ActivityRepository {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final Logger _logger = Logger();
  
  // Collection references
  static const String _activitiesCollection = 'activities';
  
  @override
  Stream<List<Activity>> getTripActivities(String tripId) {
    try {
      _logger.d('Getting activities for trip: $tripId');
      
      return _firestore
          .collection(_activitiesCollection)
          .where('tripId', isEqualTo: tripId)
          .orderBy('createdAt', descending: false)
          .snapshots()
          .map((snapshot) {
        _logger.d('Received ${snapshot.docs.length} activities for trip $tripId');
        
        return snapshot.docs.map((doc) {
          try {
            final data = doc.data();
            data['id'] = doc.id; // Ensure ID is set from document ID
            return Activity.fromJson(data);
          } catch (e) {
            _logger.e('Error parsing activity document ${doc.id}: $e');
            rethrow;
          }
        }).toList();
      });
    } catch (e) {
      _logger.e('Error getting trip activities: $e');
      rethrow;
    }
  }
  
  @override
  Future<Activity> createActivity(Activity activity) async {
    try {
      _logger.d('Creating activity: ${activity.place}');
      
      final now = DateTime.now();
      final updatedActivity = activity.copyWith(createdAt: now);
      final activityData = updatedActivity.toFirestoreJson();
      
      // Remove the ID field as Firestore will generate it
      activityData.remove('id');
      
      final docRef = await _firestore
          .collection(_activitiesCollection)
          .add(activityData);
      
      _logger.i('Activity created with ID: ${docRef.id}');
      
      // Return the activity with the generated ID
      return updatedActivity.copyWith(id: docRef.id);
    } catch (e) {
      _logger.e('Error creating activity: $e');
      throw Exception('Failed to create activity: $e');
    }
  }
  
  @override
  Future<Activity> updateActivity(Activity activity) async {
    try {
      _logger.d('Updating activity: ${activity.id}');
      
      if (activity.id.isEmpty) {
        throw Exception('Activity ID cannot be empty for update');
      }
      
      final activityData = activity.toFirestoreJson();
      
      // Remove the ID field as it's not stored in the document
      activityData.remove('id');
      
      await _firestore
          .collection(_activitiesCollection)
          .doc(activity.id)
          .update(activityData);
      
      _logger.i('Activity updated: ${activity.id}');
      
      return activity;
    } catch (e) {
      _logger.e('Error updating activity: $e');
      if (e.toString().contains('not-found')) {
        throw Exception('Activity not found');
      }
      throw Exception('Failed to update activity: $e');
    }
  }
  
  @override
  Future<void> deleteActivity(String activityId) async {
    try {
      _logger.d('Deleting activity: $activityId');
      
      if (activityId.isEmpty) {
        throw Exception('Activity ID cannot be empty for deletion');
      }
      
      await _firestore
          .collection(_activitiesCollection)
          .doc(activityId)
          .delete();
      
      _logger.i('Activity deleted: $activityId');
    } catch (e) {
      _logger.e('Error deleting activity: $e');
      if (e.toString().contains('not-found')) {
        throw Exception('Activity not found');
      }
      throw Exception('Failed to delete activity: $e');
    }
  }
  
  @override
  Future<Activity> addBrainstormIdea(String activityId, BrainstormIdea idea) async {
    try {
      _logger.d('Adding brainstorm idea to activity: $activityId');
      
      if (activityId.isEmpty) {
        throw Exception('Activity ID cannot be empty');
      }
      
      // Get the current activity
      final activityDoc = await _firestore
          .collection(_activitiesCollection)
          .doc(activityId)
          .get();
      
      if (!activityDoc.exists) {
        throw Exception('Activity not found');
      }
      
      final activityData = activityDoc.data()!;
      activityData['id'] = activityDoc.id;
      final activity = Activity.fromJson(activityData);
      
      // Create new brainstorm idea with generated ID and timestamp
      final newIdea = idea.copyWith(
        id: _firestore.collection('temp').doc().id, // Generate unique ID
        createdAt: DateTime.now(),
      );
      
      // Add the new idea to the existing list
      final updatedIdeas = [...activity.brainstormIdeas, newIdea];
      
      // Update the activity with the new brainstorm ideas
      await _firestore
          .collection(_activitiesCollection)
          .doc(activityId)
          .update({
        'brainstormIdeas': updatedIdeas.map((idea) => idea.toJson()).toList(),
      });
      
      _logger.i('Brainstorm idea added to activity: $activityId');
      
      return activity.copyWith(brainstormIdeas: updatedIdeas);
    } catch (e) {
      _logger.e('Error adding brainstorm idea: $e');
      rethrow;
    }
  }
  
  @override
  Future<Activity> removeBrainstormIdea(String activityId, String ideaId) async {
    try {
      _logger.d('Removing brainstorm idea $ideaId from activity: $activityId');
      
      if (activityId.isEmpty) {
        throw Exception('Activity ID cannot be empty');
      }
      
      if (ideaId.isEmpty) {
        throw Exception('Idea ID cannot be empty');
      }
      
      // Get the current activity
      final activityDoc = await _firestore
          .collection(_activitiesCollection)
          .doc(activityId)
          .get();
      
      if (!activityDoc.exists) {
        throw Exception('Activity not found');
      }
      
      final activityData = activityDoc.data()!;
      activityData['id'] = activityDoc.id;
      final activity = Activity.fromJson(activityData);
      
      // Remove the idea from the list
      final updatedIdeas = activity.brainstormIdeas
          .where((idea) => idea.id != ideaId)
          .toList();
      
      if (updatedIdeas.length == activity.brainstormIdeas.length) {
        throw Exception('Brainstorm idea not found');
      }
      
      // Update the activity with the filtered brainstorm ideas
      await _firestore
          .collection(_activitiesCollection)
          .doc(activityId)
          .update({
        'brainstormIdeas': updatedIdeas.map((idea) => idea.toJson()).toList(),
      });
      
      _logger.i('Brainstorm idea removed from activity: $activityId');
      
      return activity.copyWith(brainstormIdeas: updatedIdeas);
    } catch (e) {
      _logger.e('Error removing brainstorm idea: $e');
      rethrow;
    }
  }
  
  @override
  Future<Activity?> getActivityById(String activityId) async {
    try {
      _logger.d('Getting activity by ID: $activityId');
      
      if (activityId.isEmpty) {
        throw Exception('Activity ID cannot be empty');
      }
      
      final doc = await _firestore
          .collection(_activitiesCollection)
          .doc(activityId)
          .get();
      
      if (!doc.exists) {
        _logger.w('Activity not found: $activityId');
        return null;
      }
      
      final data = doc.data()!;
      data['id'] = doc.id; // Ensure ID is set from document ID
      
      final activity = Activity.fromJson(data);
      _logger.d('Retrieved activity: ${activity.place}');
      
      return activity;
    } catch (e) {
      _logger.e('Error getting activity by ID: $e');
      throw Exception('Failed to get activity: $e');
    }
  }
}