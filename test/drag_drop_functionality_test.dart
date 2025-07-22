import 'package:flutter_test/flutter_test.dart';
import 'package:trip_planner/models/activity.dart';
import 'package:trip_planner/repositories/mock_activity_repository.dart';

void main() {
  group('Drag and Drop Functionality Tests', () {
    late MockActivityRepository repository;

    setUp(() {
      repository = MockActivityRepository();
    });

    tearDown(() {
      repository.dispose();
    });

    test('should move activity to pool (unassign from day)', () async {
      // Get initial activities
      final activities = repository.getActivitiesByTripId('trip_1');
      final assignedActivity = activities.firstWhere((a) => a.assignedDay != null);
      
      // Move activity to pool by updating it with null assignedDay
      final updatedActivity = assignedActivity.copyWith(
        assignedDay: null,
        dayOrder: null,
      );
      
      await repository.updateActivity(updatedActivity);
      
      // Verify activity is now in pool
      final movedActivity = await repository.getActivityById(assignedActivity.id);
      
      expect(movedActivity!.assignedDay, isNull);
      expect(movedActivity.dayOrder, isNull);
    });

    test('should assign activity to day', () async {
      // Get initial activities
      final activities = repository.getActivitiesByTripId('trip_1');
      final poolActivity = activities.firstWhere((a) => a.assignedDay == null);
      
      // Assign activity to day
      final updatedActivity = poolActivity.copyWith(
        assignedDay: 'day-3',
        dayOrder: 0,
      );
      
      await repository.updateActivity(updatedActivity);
      
      // Verify activity is now assigned
      final assignedActivity = await repository.getActivityById(poolActivity.id);
      
      expect(assignedActivity!.assignedDay, equals('day-3'));
      expect(assignedActivity.dayOrder, equals(0));
    });

    test('should reorder activities within a day', () async {
      // Get activities for day-1
      final activities = repository.getActivitiesByTripId('trip_1');
      final dayActivities = activities
          .where((a) => a.assignedDay == 'day-1')
          .toList()
        ..sort((a, b) => (a.dayOrder ?? 0).compareTo(b.dayOrder ?? 0));
      
      if (dayActivities.length >= 2) {
        // Update activities with new order (reverse)
        for (int i = 0; i < dayActivities.length; i++) {
          final activity = dayActivities[i];
          final newOrder = dayActivities.length - 1 - i; // Reverse order
          final updatedActivity = activity.copyWith(dayOrder: newOrder);
          await repository.updateActivity(updatedActivity);
        }
        
        // Verify new order
        final updatedActivities = repository.getActivitiesByTripId('trip_1');
        final updatedDayActivities = updatedActivities
            .where((a) => a.assignedDay == 'day-1')
            .toList()
          ..sort((a, b) => (a.dayOrder ?? 0).compareTo(b.dayOrder ?? 0));
        
        expect(updatedDayActivities.first.id, equals(dayActivities.last.id));
        expect(updatedDayActivities.last.id, equals(dayActivities.first.id));
      }
    });

    test('should move activity between days', () async {
      // Get activities
      final activities = repository.getActivitiesByTripId('trip_1');
      final sourceActivity = activities.firstWhere((a) => a.assignedDay == 'day-1');
      
      // Move activity from day-1 to day-2
      final updatedActivity = sourceActivity.copyWith(
        assignedDay: 'day-2',
        dayOrder: 0,
      );
      
      await repository.updateActivity(updatedActivity);
      
      // Verify activity moved
      final movedActivity = await repository.getActivityById(sourceActivity.id);
      
      expect(movedActivity!.assignedDay, equals('day-2'));
      expect(movedActivity.dayOrder, equals(0));
    });

    test('should handle drag and drop UI components', () async {
      // Test that activities can be grouped by assignment status
      final activities = repository.getActivitiesByTripId('trip_1');
      
      final poolActivities = activities.where((a) => a.assignedDay == null).toList();
      final assignedActivities = <String, List<Activity>>{};
      
      for (final activity in activities) {
        if (activity.assignedDay != null) {
          final day = activity.assignedDay!;
          if (!assignedActivities.containsKey(day)) {
            assignedActivities[day] = [];
          }
          assignedActivities[day]!.add(activity);
        }
      }
      
      // Sort activities within each day by dayOrder
      for (final dayActivities in assignedActivities.values) {
        dayActivities.sort((a, b) => (a.dayOrder ?? 0).compareTo(b.dayOrder ?? 0));
      }
      
      // Verify grouping works
      expect(poolActivities.isNotEmpty, true);
      expect(assignedActivities.isNotEmpty, true);
      expect(assignedActivities.containsKey('day-1'), true);
      expect(assignedActivities.containsKey('day-2'), true);
    });

    test('should support activity card display with drag handles', () async {
      final activities = repository.getActivitiesByTripId('trip_1');
      final activity = activities.first;
      
      // Verify activity has all required fields for display
      expect(activity.place, isNotEmpty);
      expect(activity.activityType, isNotEmpty);
      expect(activity.createdBy, isNotEmpty);
      expect(activity.createdAt, isA<DateTime>());
      expect(activity.brainstormIdeas, isA<List>());
      
      // Verify activity can be dragged (has required properties)
      expect(activity.id, isNotEmpty);
      expect(activity.tripId, isNotEmpty);
    });
  });
}