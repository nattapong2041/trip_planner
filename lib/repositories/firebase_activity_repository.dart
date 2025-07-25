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
        _logger
            .d('Received ${snapshot.docs.length} activities for trip $tripId');

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

      final docRef =
          await _firestore.collection(_activitiesCollection).add(activityData);

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
  Future<Activity> addBrainstormIdea(
      String activityId, BrainstormIdea idea) async {
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

      // Create new brainstorm idea with generated ID, timestamp, and order
      final newIdea = idea.copyWith(
        id: _firestore.collection('temp').doc().id, // Generate unique ID
        createdAt: DateTime.now(),
        order: activity.brainstormIdeas.length, // Add at the end
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
  Future<Activity> removeBrainstormIdea(
      String activityId, String ideaId) async {
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
      final updatedIdeas =
          activity.brainstormIdeas.where((idea) => idea.id != ideaId).toList();

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
  Future<Activity> reorderBrainstormIdeas(
      String activityId, List<String> ideaIds) async {
    try {
      _logger.d('Reordering brainstorm ideas for activity: $activityId');

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

      // Create a map of existing ideas for quick lookup
      final ideaMap = {
        for (var idea in activity.brainstormIdeas) idea.id: idea
      };

      // Reorder ideas based on the provided order and update order field
      final reorderedIdeas = <BrainstormIdea>[];
      for (int i = 0; i < ideaIds.length; i++) {
        final ideaId = ideaIds[i];
        final idea = ideaMap[ideaId];
        if (idea != null) {
          reorderedIdeas.add(idea.copyWith(order: i));
        }
      }

      // Add any ideas that weren't in the reorder list (shouldn't happen normally)
      for (final idea in activity.brainstormIdeas) {
        if (!ideaIds.contains(idea.id)) {
          reorderedIdeas.add(idea.copyWith(order: reorderedIdeas.length));
        }
      }

      // Update the activity with reordered brainstorm ideas
      await _firestore
          .collection(_activitiesCollection)
          .doc(activityId)
          .update({
        'brainstormIdeas': reorderedIdeas.map((idea) => idea.toJson()).toList(),
      });

      _logger.i('Brainstorm ideas reordered for activity: $activityId');

      return activity.copyWith(brainstormIdeas: reorderedIdeas);
    } catch (e) {
      _logger.e('Error reordering brainstorm ideas: $e');
      rethrow;
    }
  }

  @override
  Future<Activity> assignActivityToDay(
      String activityId, String day, int dayOrder,
      {String? timeSlot}) async {
    try {
      _logger
          .d('Assigning activity $activityId to day $day with order $dayOrder');

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

      // Update the activity with day assignment
      final updatedActivity = activity.copyWith(
        assignedDay: day,
        dayOrder: dayOrder,
        timeSlot: timeSlot,
      );

      await _firestore
          .collection(_activitiesCollection)
          .doc(activityId)
          .update({
        'assignedDay': day,
        'dayOrder': dayOrder,
        'timeSlot': timeSlot,
      });

      _logger.i('Activity assigned to day: $activityId -> $day');

      return updatedActivity;
    } catch (e) {
      _logger.e('Error assigning activity to day: $e');
      rethrow;
    }
  }

  @override
  Future<Activity> moveActivityToPool(String activityId) async {
    try {
      _logger.d('Moving activity to pool: $activityId');

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

      // Update the activity to remove day assignment
      final updatedActivity = activity.copyWith(
        assignedDay: null,
        dayOrder: null,
        timeSlot: null,
      );

      await _firestore
          .collection(_activitiesCollection)
          .doc(activityId)
          .update({
        'assignedDay': FieldValue.delete(),
        'dayOrder': FieldValue.delete(),
        'timeSlot': FieldValue.delete(),
      });

      _logger.i('Activity moved to pool: $activityId');

      return updatedActivity;
    } catch (e) {
      _logger.e('Error moving activity to pool: $e');
      rethrow;
    }
  }

  @override
  Future<void> reorderActivitiesInDay(
      String tripId, String day, List<String> activityIds) async {
    try {
      _logger.d('Reordering activities in day $day for trip $tripId');

      if (tripId.isEmpty || day.isEmpty) {
        throw Exception('Trip ID and day cannot be empty');
      }

      // Use a batch to update all activities atomically
      final batch = _firestore.batch();

      for (int i = 0; i < activityIds.length; i++) {
        final activityId = activityIds[i];
        final activityRef =
            _firestore.collection(_activitiesCollection).doc(activityId);

        batch.update(activityRef, {
          'dayOrder': i,
          'assignedDay': day,
        });
      }

      await batch.commit();

      _logger.i('Activities reordered in day $day for trip $tripId');
    } catch (e) {
      _logger.e('Error reordering activities in day: $e');
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
