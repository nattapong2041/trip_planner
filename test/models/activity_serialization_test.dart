import 'package:flutter_test/flutter_test.dart';
import 'package:trip_planner/models/activity.dart';
import 'package:trip_planner/models/brainstorm_idea.dart';

void main() {
  group('Activity Serialization', () {
    test('Activity with brainstormIdeas should serialize to JSON correctly',
        () {
      final brainstormIdea = BrainstormIdea(
        id: 'idea1',
        description: 'Test idea',
        createdBy: 'user1',
        createdAt: DateTime(2024, 1, 1, 12, 0),
      );

      final activity = Activity(
        id: 'activity1',
        tripId: 'trip1',
        place: 'Test Place',
        activityType: 'Test Type',
        createdBy: 'user1',
        createdAt: DateTime(2024, 1, 1, 10, 0),
        timeSlot: '14:30',
        brainstormIdeas: [brainstormIdea],
      );

      // Test serialization
      final json = activity.toFirestoreJson();

      // Verify the structure
      expect(json['id'], 'activity1');
      expect(json['tripId'], 'trip1');
      expect(json['place'], 'Test Place');
      expect(json['timeSlot'], '14:30');
      expect(json['brainstormIdeas'], isA<List>());
      expect(json['brainstormIdeas'].length, 1);

      // Verify brainstorm idea serialization
      final ideaJson = json['brainstormIdeas'][0];
      expect(ideaJson, isA<Map<String, dynamic>>());
      expect(ideaJson['id'], 'idea1');
      expect(ideaJson['description'], 'Test idea');
      expect(ideaJson['createdBy'], 'user1');

      // Test deserialization
      final deserializedActivity = Activity.fromJson(json);
      expect(deserializedActivity.id, activity.id);
      expect(deserializedActivity.timeSlot, activity.timeSlot);
      expect(deserializedActivity.brainstormIdeas.length, 1);
      expect(deserializedActivity.brainstormIdeas[0].id, brainstormIdea.id);
      expect(deserializedActivity.brainstormIdeas[0].description,
          brainstormIdea.description);
    });

    test('Activity with empty brainstormIdeas should serialize correctly', () {
      final activity = Activity(
        id: 'activity1',
        tripId: 'trip1',
        place: 'Test Place',
        activityType: 'Test Type',
        createdBy: 'user1',
        createdAt: DateTime(2024, 1, 1, 10, 0),
        timeSlot: '09:00',
        brainstormIdeas: [],
      );

      final json = activity.toFirestoreJson();
      expect(json['brainstormIdeas'], isA<List>());
      expect(json['brainstormIdeas'].length, 0);

      final deserializedActivity = Activity.fromJson(json);
      expect(deserializedActivity.brainstormIdeas.length, 0);
    });

    test('Activity without timeSlot should serialize correctly', () {
      final activity = Activity(
        id: 'activity1',
        tripId: 'trip1',
        place: 'Test Place',
        activityType: 'Test Type',
        createdBy: 'user1',
        createdAt: DateTime(2024, 1, 1, 10, 0),
        timeSlot: null,
      );

      final json = activity.toFirestoreJson();
      expect(json['timeSlot'], null);

      final deserializedActivity = Activity.fromJson(json);
      expect(deserializedActivity.timeSlot, null);
    });
  });
}
