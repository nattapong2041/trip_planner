import 'package:flutter_test/flutter_test.dart';
import 'package:trip_planner/models/activity.dart';
import 'package:trip_planner/models/brainstorm_idea.dart';
import 'package:trip_planner/utils/time_slot_utils.dart';

void main() {
  group('Time Slot Integration Tests', () {
    test('Activity with time slot should serialize correctly for Firestore', () {
      // Create an activity with brainstorm ideas and time slot
      final brainstormIdea = BrainstormIdea(
        id: 'idea1',
        description: 'Great restaurant idea',
        createdBy: 'user1',
        createdAt: DateTime(2024, 1, 1, 12, 0),
      );

      final activity = Activity(
        id: 'activity1',
        tripId: 'trip1',
        place: 'Amazing Restaurant',
        activityType: 'Dining',
        price: '\$50',
        notes: 'Make reservation',
        assignedDay: 'day-1',
        dayOrder: 0,
        timeSlot: '19:00',
        createdBy: 'user1',
        createdAt: DateTime(2024, 1, 1, 10, 0),
        brainstormIdeas: [brainstormIdea],
      );

      // Test Firestore serialization
      final firestoreJson = activity.toFirestoreJson();
      
      // Verify all fields are properly serialized
      expect(firestoreJson['id'], 'activity1');
      expect(firestoreJson['timeSlot'], '19:00');
      expect(firestoreJson['assignedDay'], 'day-1');
      expect(firestoreJson['dayOrder'], 0);
      expect(firestoreJson['brainstormIdeas'], isA<List>());
      expect(firestoreJson['brainstormIdeas'].length, 1);
      expect(firestoreJson['brainstormIdeas'][0], isA<Map<String, dynamic>>());
      expect(firestoreJson['brainstormIdeas'][0]['id'], 'idea1');

      // Test deserialization from Firestore JSON
      final deserializedActivity = Activity.fromJson(firestoreJson);
      expect(deserializedActivity.timeSlot, '19:00');
      expect(deserializedActivity.assignedDay, 'day-1');
      expect(deserializedActivity.dayOrder, 0);
      expect(deserializedActivity.brainstormIdeas.length, 1);
      expect(deserializedActivity.brainstormIdeas[0].id, 'idea1');
    });

    test('Time slot utilities work with serialized activities', () {
      final activities = [
        Activity(
          id: '1',
          tripId: 'trip1',
          place: 'Morning Coffee',
          activityType: 'Dining',
          timeSlot: '08:00',
          createdBy: 'user1',
          createdAt: DateTime.now(),
        ),
        Activity(
          id: '2',
          tripId: 'trip1',
          place: 'Lunch',
          activityType: 'Dining',
          timeSlot: '12:30',
          createdBy: 'user1',
          createdAt: DateTime.now(),
        ),
        Activity(
          id: '3',
          tripId: 'trip1',
          place: 'Museum Visit',
          activityType: 'Culture',
          timeSlot: null, // No time slot
          createdBy: 'user1',
          createdAt: DateTime.now(),
        ),
      ];

      // Test separation of timed and untimed activities
      final separated = TimeSlotUtils.separateActivitiesByTime(activities);
      expect(separated['timed']?.length, 2);
      expect(separated['untimed']?.length, 1);

      // Test chronological sorting
      final timedActivities = separated['timed']!;
      expect(timedActivities[0].timeSlot, '08:00');
      expect(timedActivities[1].timeSlot, '12:30');

      // Test time formatting
      expect(TimeSlotUtils.formatTimeSlot('08:00'), '8:00 AM');
      expect(TimeSlotUtils.formatTimeSlot('12:30'), '12:30 PM');

      // Test suggested time slots
      final suggestions = TimeSlotUtils.generateSuggestedTimeSlots(timedActivities);
      expect(suggestions.contains('08:00'), false); // Already used
      expect(suggestions.contains('12:30'), false); // Already used
      expect(suggestions.contains('09:00'), true);  // Available
      expect(suggestions.contains('14:00'), true);  // Available
    });

    test('Activity updates preserve all data including time slots', () {
      final originalActivity = Activity(
        id: 'activity1',
        tripId: 'trip1',
        place: 'Restaurant',
        activityType: 'Dining',
        price: '\$30',
        notes: 'Original notes',
        assignedDay: 'day-1',
        dayOrder: 1,
        timeSlot: '18:00',
        createdBy: 'user1',
        createdAt: DateTime(2024, 1, 1, 10, 0),
        brainstormIdeas: [
          BrainstormIdea(
            id: 'idea1',
            description: 'Try the pasta',
            createdBy: 'user1',
            createdAt: DateTime(2024, 1, 1, 11, 0),
          ),
        ],
      );

      // Update time slot
      final updatedActivity = originalActivity.copyWith(timeSlot: '19:30');

      // Verify update preserves all data
      expect(updatedActivity.id, originalActivity.id);
      expect(updatedActivity.place, originalActivity.place);
      expect(updatedActivity.price, originalActivity.price);
      expect(updatedActivity.assignedDay, originalActivity.assignedDay);
      expect(updatedActivity.dayOrder, originalActivity.dayOrder);
      expect(updatedActivity.brainstormIdeas.length, 1);
      expect(updatedActivity.brainstormIdeas[0].description, 'Try the pasta');
      expect(updatedActivity.timeSlot, '19:30'); // Updated field

      // Test Firestore serialization of updated activity
      final json = updatedActivity.toFirestoreJson();
      expect(json['timeSlot'], '19:30');
      expect(json['brainstormIdeas'].length, 1);
      expect(json['brainstormIdeas'][0]['description'], 'Try the pasta');
    });
  });
}