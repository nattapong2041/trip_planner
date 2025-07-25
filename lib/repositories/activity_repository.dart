import '../models/activity.dart';
import '../models/brainstorm_idea.dart';

/// Abstract repository interface for activity management operations
abstract class ActivityRepository {
  /// Stream of activities for a specific trip
  /// Returns real-time updates of all activities in the trip
  Stream<List<Activity>> getTripActivities(String tripId);
  
  /// Create a new activity
  /// Returns the created activity with generated ID and timestamps
  Future<Activity> createActivity(Activity activity);
  
  /// Update an existing activity
  /// Returns the updated activity
  Future<Activity> updateActivity(Activity activity);
  
  /// Delete an activity by ID
  /// Removes the activity and all associated brainstorm ideas
  Future<void> deleteActivity(String activityId);
  
  /// Add a brainstorm idea to an activity
  /// Returns the updated activity with the new brainstorm idea
  Future<Activity> addBrainstormIdea(String activityId, BrainstormIdea idea);
  
  /// Remove a brainstorm idea from an activity
  /// Returns the updated activity without the brainstorm idea
  Future<Activity> removeBrainstormIdea(String activityId, String ideaId);
  
  /// Reorder brainstorm ideas within an activity
  /// Updates the order field of brainstorm ideas for real-time synchronization
  Future<Activity> reorderBrainstormIdeas(String activityId, List<String> ideaIds);
  
  /// Assign activity to day with time slot
  /// Updates assignedDay, dayOrder, and timeSlot for real-time synchronization
  Future<Activity> assignActivityToDay(String activityId, String day, int dayOrder, {String? timeSlot});
  
  /// Move activity to pool (unassign from day)
  /// Clears assignedDay, dayOrder, and timeSlot for real-time synchronization
  Future<Activity> moveActivityToPool(String activityId);
  
  /// Reorder activities within a day
  /// Updates dayOrder for all activities in the day for real-time synchronization
  Future<void> reorderActivitiesInDay(String tripId, String day, List<String> activityIds);
  
  /// Get a single activity by ID
  /// Returns null if activity doesn't exist
  Future<Activity?> getActivityById(String activityId);
}