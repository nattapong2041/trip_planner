import 'package:flutter_test/flutter_test.dart';
import 'package:trip_planner/models/activity.dart';
import 'package:trip_planner/models/brainstorm_idea.dart';

void main() {
  group('Activity Model Tests', () {
    late DateTime testDate;
    late BrainstormIdea testIdea;
    late Activity testActivity;
    late Map<String, dynamic> validActivityJson;

    setUp(() {
      testDate = DateTime(2024, 1, 15, 10, 30);
      
      testIdea = BrainstormIdea(
        id: 'idea_123',
        description: 'Try the famous ramen',
        createdBy: 'user_789',
        createdAt: testDate,
      );

      testActivity = Activity(
        id: 'activity_123',
        tripId: 'trip_456',
        place: 'Tokyo Station',
        activityType: 'Food',
        price: '¥2000',
        notes: 'Popular ramen district',
        assignedDay: 'day-1',
        dayOrder: 1,
        createdBy: 'user_456',
        createdAt: testDate,
        brainstormIdeas: [testIdea],
      );

      validActivityJson = {
        'id': 'activity_123',
        'tripId': 'trip_456',
        'place': 'Tokyo Station',
        'activityType': 'Food',
        'price': '¥2000',
        'notes': 'Popular ramen district',
        'assignedDay': 'day-1',
        'dayOrder': 1,
        'createdBy': 'user_456',
        'createdAt': testDate.toIso8601String(),
        'brainstormIdeas': [
          {
            'id': 'idea_123',
            'description': 'Try the famous ramen',
            'createdBy': 'user_789',
            'createdAt': testDate.toIso8601String(),
          }
        ],
      };
    });

    test('should create Activity instance with all fields', () {
      expect(testActivity.id, equals('activity_123'));
      expect(testActivity.tripId, equals('trip_456'));
      expect(testActivity.place, equals('Tokyo Station'));
      expect(testActivity.activityType, equals('Food'));
      expect(testActivity.price, equals('¥2000'));
      expect(testActivity.notes, equals('Popular ramen district'));
      expect(testActivity.assignedDay, equals('day-1'));
      expect(testActivity.dayOrder, equals(1));
      expect(testActivity.createdBy, equals('user_456'));
      expect(testActivity.createdAt, equals(testDate));
      expect(testActivity.brainstormIdeas, hasLength(1));
      expect(testActivity.brainstormIdeas.first, equals(testIdea));
    });

    test('should create Activity with optional fields as null', () {
      final activity = Activity(
        id: 'activity_minimal',
        tripId: 'trip_456',
        place: 'Shibuya',
        activityType: 'Sightseeing',
        createdBy: 'user_456',
        createdAt: testDate,
      );

      expect(activity.price, isNull);
      expect(activity.notes, isNull);
      expect(activity.assignedDay, isNull);
      expect(activity.dayOrder, isNull);
      expect(activity.brainstormIdeas, isEmpty);
    });

    test('should create Activity in activity pool (unassigned)', () {
      final poolActivity = testActivity.copyWith(
        assignedDay: null,
        dayOrder: null,
      );

      expect(poolActivity.assignedDay, isNull);
      expect(poolActivity.dayOrder, isNull);
    });

    test('should serialize Activity to JSON correctly', () {
      final json = testActivity.toJson();

      expect(json['id'], equals('activity_123'));
      expect(json['tripId'], equals('trip_456'));
      expect(json['place'], equals('Tokyo Station'));
      expect(json['activityType'], equals('Food'));
      expect(json['price'], equals('¥2000'));
      expect(json['notes'], equals('Popular ramen district'));
      expect(json['assignedDay'], equals('day-1'));
      expect(json['dayOrder'], equals(1));
      expect(json['createdBy'], equals('user_456'));
      expect(json['createdAt'], equals(testDate.toIso8601String()));
      expect(json['brainstormIdeas'], hasLength(1));
    });

    test('should deserialize Activity from JSON correctly', () {
      final activity = Activity.fromJson(validActivityJson);

      expect(activity.id, equals('activity_123'));
      expect(activity.tripId, equals('trip_456'));
      expect(activity.place, equals('Tokyo Station'));
      expect(activity.activityType, equals('Food'));
      expect(activity.price, equals('¥2000'));
      expect(activity.notes, equals('Popular ramen district'));
      expect(activity.assignedDay, equals('day-1'));
      expect(activity.dayOrder, equals(1));
      expect(activity.createdBy, equals('user_456'));
      expect(activity.createdAt, equals(testDate));
      expect(activity.brainstormIdeas, hasLength(1));
      expect(activity.brainstormIdeas.first.id, equals('idea_123'));
    });

    test('should handle JSON serialization round trip', () {
      final json = testActivity.toJson();
      final deserializedActivity = Activity.fromJson(json);

      expect(deserializedActivity, equals(testActivity));
    });

    test('should create copy with updated fields using copyWith', () {
      final updatedActivity = testActivity.copyWith(
        place: 'Shinjuku Station',
        price: '¥3000',
        assignedDay: 'day-2',
        dayOrder: 3,
      );

      expect(updatedActivity.id, equals(testActivity.id));
      expect(updatedActivity.place, equals('Shinjuku Station'));
      expect(updatedActivity.price, equals('¥3000'));
      expect(updatedActivity.assignedDay, equals('day-2'));
      expect(updatedActivity.dayOrder, equals(3));
      expect(updatedActivity.tripId, equals(testActivity.tripId));
      expect(updatedActivity.activityType, equals(testActivity.activityType));
    });

    test('should add brainstorm ideas', () {
      final newIdea = BrainstormIdea(
        id: 'idea_456',
        description: 'Visit early morning',
        createdBy: 'user_101',
        createdAt: testDate.add(const Duration(hours: 1)),
      );

      final updatedActivity = testActivity.copyWith(
        brainstormIdeas: [...testActivity.brainstormIdeas, newIdea],
      );

      expect(updatedActivity.brainstormIdeas, hasLength(2));
      expect(updatedActivity.brainstormIdeas.last, equals(newIdea));
    });

    test('should remove brainstorm ideas', () {
      final updatedActivity = testActivity.copyWith(
        brainstormIdeas: [],
      );

      expect(updatedActivity.brainstormIdeas, isEmpty);
    });

    test('should maintain immutability', () {
      final originalIdeas = testActivity.brainstormIdeas;
      final updatedActivity = testActivity.copyWith(place: 'New Place');

      expect(testActivity.place, equals('Tokyo Station'));
      expect(updatedActivity.place, equals('New Place'));
      expect(testActivity.brainstormIdeas, equals(originalIdeas));
    });

    test('should support equality comparison', () {
      final activity1 = Activity(
        id: 'activity_123',
        tripId: 'trip_456',
        place: 'Tokyo Station',
        activityType: 'Food',
        createdBy: 'user_456',
        createdAt: testDate,
      );

      final activity2 = Activity(
        id: 'activity_123',
        tripId: 'trip_456',
        place: 'Tokyo Station',
        activityType: 'Food',
        createdBy: 'user_456',
        createdAt: testDate,
      );

      final activity3 = activity1.copyWith(place: 'Different Place');

      expect(activity1, equals(activity2));
      expect(activity1.hashCode, equals(activity2.hashCode));
      expect(activity1, isNot(equals(activity3)));
    });

    test('should handle null optional fields in JSON', () {
      final jsonWithNulls = {
        'id': 'activity_123',
        'tripId': 'trip_456',
        'place': 'Tokyo Station',
        'activityType': 'Food',
        'price': null,
        'notes': null,
        'assignedDay': null,
        'dayOrder': null,
        'createdBy': 'user_456',
        'createdAt': testDate.toIso8601String(),
        'brainstormIdeas': <Map<String, dynamic>>[],
      };

      final activity = Activity.fromJson(jsonWithNulls);

      expect(activity.price, isNull);
      expect(activity.notes, isNull);
      expect(activity.assignedDay, isNull);
      expect(activity.dayOrder, isNull);
      expect(activity.brainstormIdeas, isEmpty);
    });
  });
}