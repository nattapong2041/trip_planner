import 'dart:async';
import 'activity_repository.dart';
import '../models/activity.dart';
import '../models/brainstorm_idea.dart';
import 'mock_data_generator.dart';

/// Mock implementation of ActivityRepository for testing and development
class MockActivityRepository implements ActivityRepository {
  final Map<String, Activity> _activities = {};
  final Map<String, StreamController<List<Activity>>> _tripActivityControllers =
      {};

  MockActivityRepository() {
    _initializeMockData();
  }

  void _initializeMockData() {
    // Generate mock activities for the first trip
    final mockActivities =
        MockDataGenerator.generateMockActivities('trip_1', 'user_1');
    for (final activity in mockActivities) {
      _activities[activity.id] = activity;
    }

    // Generate some activities for the second trip
    final trip2Activities = [
      Activity(
        id: 'activity_5',
        tripId: 'trip_2',
        place: 'Eiffel Tower',
        activityType: 'Sightseeing',
        price: '€25',
        notes: 'Book skip-the-line tickets',
        assignedDay: 'day-1',
        dayOrder: 1,
        createdBy: 'user_1',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        brainstormIdeas: [
          BrainstormIdea(
            id: 'idea_7',
            description: 'Visit at night for light show',
            createdBy: 'user_2',
            createdAt: DateTime.now().subtract(const Duration(hours: 12)),
          ),
        ],
      ),
      Activity(
        id: 'activity_6',
        tripId: 'trip_2',
        place: 'Louvre Museum',
        activityType: 'Culture',
        price: '€17',
        notes: 'Allow full day for visit',
        assignedDay: null, // In activity pool
        dayOrder: null,
        createdBy: 'user_2',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        brainstormIdeas: [],
      ),
    ];

    for (final activity in trip2Activities) {
      _activities[activity.id] = activity;
    }
  }

  @override
  Stream<List<Activity>> getTripActivities(String tripId) {
    if (!_tripActivityControllers.containsKey(tripId)) {
      _tripActivityControllers[tripId] =
          StreamController<List<Activity>>.broadcast();
    }

    // Emit current activities for the trip
    final tripActivities = _activities.values
        .where((activity) => activity.tripId == tripId)
        .toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    Future.microtask(() {
      _tripActivityControllers[tripId]!.add(tripActivities);
    });

    return _tripActivityControllers[tripId]!.stream;
  }

  @override
  Future<Activity> createActivity(Activity activity) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    final newActivity = activity.copyWith(
      id: MockDataGenerator.generateId(),
      createdAt: DateTime.now(),
    );

    _activities[newActivity.id] = newActivity;
    _notifyTripActivityUpdates(newActivity.tripId);

    return newActivity;
  }

  @override
  Future<Activity> updateActivity(Activity activity) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));

    if (!_activities.containsKey(activity.id)) {
      throw Exception('Activity not found');
    }

    _activities[activity.id] = activity;
    _notifyTripActivityUpdates(activity.tripId);

    return activity;
  }

  @override
  Future<void> deleteActivity(String activityId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));

    final activity = _activities[activityId];
    if (activity == null) {
      throw Exception('Activity not found');
    }

    _activities.remove(activityId);
    _notifyTripActivityUpdates(activity.tripId);
  }

  @override
  Future<Activity> addBrainstormIdea(
      String activityId, BrainstormIdea idea) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));

    final activity = _activities[activityId];
    if (activity == null) {
      throw Exception('Activity not found');
    }

    final newIdea = idea.copyWith(
      id: MockDataGenerator.generateId(),
      createdAt: DateTime.now(),
    );

    final updatedActivity = activity.copyWith(
      brainstormIdeas: [...activity.brainstormIdeas, newIdea],
    );

    _activities[activityId] = updatedActivity;
    _notifyTripActivityUpdates(updatedActivity.tripId);

    return updatedActivity;
  }

  @override
  Future<Activity> removeBrainstormIdea(
      String activityId, String ideaId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));

    final activity = _activities[activityId];
    if (activity == null) {
      throw Exception('Activity not found');
    }

    final updatedIdeas =
        activity.brainstormIdeas.where((idea) => idea.id != ideaId).toList();

    final updatedActivity = activity.copyWith(brainstormIdeas: updatedIdeas);

    _activities[activityId] = updatedActivity;
    _notifyTripActivityUpdates(updatedActivity.tripId);

    return updatedActivity;
  }

  @override
  Future<Activity?> getActivityById(String activityId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 100));

    return _activities[activityId];
  }

  @override
  Future<Activity> reorderBrainstormIdeas(
      String activityId, List<String> ideaIds) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));

    final activity = _activities[activityId];
    if (activity == null) {
      throw Exception('Activity not found');
    }

    // Create a map of existing ideas for quick lookup
    final ideaMap = {for (var idea in activity.brainstormIdeas) idea.id: idea};

    // Reorder ideas based on the provided order and update order field
    final reorderedIdeas = <BrainstormIdea>[];
    for (int i = 0; i < ideaIds.length; i++) {
      final ideaId = ideaIds[i];
      final idea = ideaMap[ideaId];
      if (idea != null) {
        reorderedIdeas.add(idea.copyWith(order: i));
      }
    }

    // Add any ideas that weren't in the reorder list
    for (final idea in activity.brainstormIdeas) {
      if (!ideaIds.contains(idea.id)) {
        reorderedIdeas.add(idea.copyWith(order: reorderedIdeas.length));
      }
    }

    final updatedActivity = activity.copyWith(brainstormIdeas: reorderedIdeas);
    _activities[activityId] = updatedActivity;
    _notifyTripActivityUpdates(updatedActivity.tripId);

    return updatedActivity;
  }

  @override
  Future<Activity> assignActivityToDay(
      String activityId, String day, int dayOrder,
      {String? timeSlot}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));

    final activity = _activities[activityId];
    if (activity == null) {
      throw Exception('Activity not found');
    }

    final updatedActivity = activity.copyWith(
      assignedDay: day,
      dayOrder: dayOrder,
      timeSlot: timeSlot,
    );

    _activities[activityId] = updatedActivity;
    _notifyTripActivityUpdates(updatedActivity.tripId);

    return updatedActivity;
  }

  @override
  Future<Activity> moveActivityToPool(String activityId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));

    final activity = _activities[activityId];
    if (activity == null) {
      throw Exception('Activity not found');
    }

    final updatedActivity = activity.copyWith(
      assignedDay: null,
      dayOrder: null,
      timeSlot: null,
    );

    _activities[activityId] = updatedActivity;
    _notifyTripActivityUpdates(updatedActivity.tripId);

    return updatedActivity;
  }

  @override
  Future<void> reorderActivitiesInDay(
      String tripId, String day, List<String> activityIds) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));

    for (int i = 0; i < activityIds.length; i++) {
      final activityId = activityIds[i];
      final activity = _activities[activityId];
      if (activity != null) {
        final updatedActivity = activity.copyWith(
          assignedDay: day,
          dayOrder: i,
        );
        _activities[activityId] = updatedActivity;
      }
    }

    _notifyTripActivityUpdates(tripId);
  }

  void _notifyTripActivityUpdates(String tripId) {
    if (_tripActivityControllers.containsKey(tripId)) {
      final tripActivities = _activities.values
          .where((activity) => activity.tripId == tripId)
          .toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

      _tripActivityControllers[tripId]!.add(tripActivities);
    }
  }

  /// Get all activities (for testing purposes)
  List<Activity> get allActivities => List.unmodifiable(_activities.values);

  /// Get activities by trip ID (for testing purposes)
  List<Activity> getActivitiesByTripId(String tripId) {
    return _activities.values
        .where((activity) => activity.tripId == tripId)
        .toList();
  }

  /// Dispose resources
  void dispose() {
    for (final controller in _tripActivityControllers.values) {
      controller.close();
    }
    _tripActivityControllers.clear();
  }
}
