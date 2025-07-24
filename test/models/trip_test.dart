import 'package:flutter_test/flutter_test.dart';
import 'package:trip_planner/models/trip.dart';

void main() {
  group('Trip Model Tests', () {
    late DateTime testDate;
    late Map<String, dynamic> validTripJson;
    late Trip testTrip;

    setUp(() {
      testDate = DateTime(2024, 1, 15, 10, 30);
      validTripJson = {
        'id': 'trip_123',
        'name': 'Tokyo Adventure',
        'durationDays': 7,
        'ownerId': 'user_456',
        'collaboratorIds': ['user_789', 'user_101'],
        'createdAt': testDate.toIso8601String(),
        'updatedAt': testDate.toIso8601String(),
      };
      
      testTrip = Trip(
        id: 'trip_123',
        name: 'Tokyo Adventure',
        durationDays: 7,
        ownerId: 'user_456',
        collaboratorIds: const ['user_789', 'user_101'],
        createdAt: testDate,
        updatedAt: testDate,
      );
    });

    test('should create Trip instance with required fields', () {
      expect(testTrip.id, equals('trip_123'));
      expect(testTrip.name, equals('Tokyo Adventure'));
      expect(testTrip.durationDays, equals(7));
      expect(testTrip.ownerId, equals('user_456'));
      expect(testTrip.collaboratorIds, equals(['user_789', 'user_101']));
      expect(testTrip.createdAt, equals(testDate));
      expect(testTrip.updatedAt, equals(testDate));
    });

    test('should create Trip with empty collaborators list', () {
      final trip = Trip(
        id: 'trip_solo',
        name: 'Solo Trip',
        durationDays: 3,
        ownerId: 'user_solo',
        collaboratorIds: const [],
        createdAt: testDate,
        updatedAt: testDate,
      );

      expect(trip.collaboratorIds, isEmpty);
    });

    test('should serialize Trip to JSON correctly', () {
      final json = testTrip.toJson();

      expect(json['id'], equals('trip_123'));
      expect(json['name'], equals('Tokyo Adventure'));
      expect(json['durationDays'], equals(7));
      expect(json['ownerId'], equals('user_456'));
      expect(json['collaboratorIds'], equals(['user_789', 'user_101']));
      expect(json['createdAt'], equals(testDate.toIso8601String()));
      expect(json['updatedAt'], equals(testDate.toIso8601String()));
    });

    test('should deserialize Trip from JSON correctly', () {
      final trip = Trip.fromJson(validTripJson);

      expect(trip.id, equals('trip_123'));
      expect(trip.name, equals('Tokyo Adventure'));
      expect(trip.durationDays, equals(7));
      expect(trip.ownerId, equals('user_456'));
      expect(trip.collaboratorIds, equals(['user_789', 'user_101']));
      expect(trip.createdAt, equals(testDate));
      expect(trip.updatedAt, equals(testDate));
    });

    test('should handle JSON serialization round trip', () {
      final json = testTrip.toJson();
      final deserializedTrip = Trip.fromJson(json);

      expect(deserializedTrip, equals(testTrip));
    });

    test('should create copy with updated fields using copyWith', () {
      final updatedTrip = testTrip.copyWith(
        name: 'Updated Tokyo Adventure',
        durationDays: 10,
        collaboratorIds: ['user_789', 'user_101', 'user_202'],
      );

      expect(updatedTrip.id, equals(testTrip.id));
      expect(updatedTrip.name, equals('Updated Tokyo Adventure'));
      expect(updatedTrip.durationDays, equals(10));
      expect(updatedTrip.ownerId, equals(testTrip.ownerId));
      expect(updatedTrip.collaboratorIds, equals(['user_789', 'user_101', 'user_202']));
      expect(updatedTrip.createdAt, equals(testTrip.createdAt));
      expect(updatedTrip.updatedAt, equals(testTrip.updatedAt));
    });

    test('should maintain immutability', () {
      final originalCollaborators = testTrip.collaboratorIds;
      final updatedTrip = testTrip.copyWith(name: 'New Name');

      expect(testTrip.name, equals('Tokyo Adventure'));
      expect(updatedTrip.name, equals('New Name'));
      expect(testTrip.collaboratorIds, equals(originalCollaborators));
    });

    test('should handle invalid JSON gracefully', () {
      final invalidJson = <String, dynamic>{
        'id': 'trip_123',
        'name': 'Tokyo Adventure',
        // Missing required fields
      };

      expect(() => Trip.fromJson(invalidJson), throwsA(isA<TypeError>()));
    });

    test('should support equality comparison', () {
      final trip1 = Trip(
        id: 'trip_123',
        name: 'Tokyo Adventure',
        durationDays: 7,
        ownerId: 'user_456',
        collaboratorIds: const ['user_789'],
        createdAt: testDate,
        updatedAt: testDate,
      );

      final trip2 = Trip(
        id: 'trip_123',
        name: 'Tokyo Adventure',
        durationDays: 7,
        ownerId: 'user_456',
        collaboratorIds: const ['user_789'],
        createdAt: testDate,
        updatedAt: testDate,
      );

      final trip3 = trip1.copyWith(name: 'Different Name');

      expect(trip1, equals(trip2));
      expect(trip1.hashCode, equals(trip2.hashCode));
      expect(trip1, isNot(equals(trip3)));
    });
  });
}