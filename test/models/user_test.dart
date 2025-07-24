import 'package:flutter_test/flutter_test.dart';
import 'package:trip_planner/models/user.dart';

void main() {
  group('User Model Tests', () {
    late User testUser;
    late Map<String, dynamic> validUserJson;

    setUp(() {
      testUser = const User(
        id: 'user_123',
        email: 'john.doe@example.com',
        displayName: 'John Doe',
        photoUrl: 'https://example.com/photo.jpg',
      );

      validUserJson = {
        'id': 'user_123',
        'email': 'john.doe@example.com',
        'displayName': 'John Doe',
        'photoUrl': 'https://example.com/photo.jpg',
      };
    });

    test('should create User instance with all fields', () {
      expect(testUser.id, equals('user_123'));
      expect(testUser.email, equals('john.doe@example.com'));
      expect(testUser.displayName, equals('John Doe'));
      expect(testUser.photoUrl, equals('https://example.com/photo.jpg'));
    });

    test('should create User with null photoUrl', () {
      const user = User(
        id: 'user_456',
        email: 'jane.doe@example.com',
        displayName: 'Jane Doe',
      );

      expect(user.id, equals('user_456'));
      expect(user.email, equals('jane.doe@example.com'));
      expect(user.displayName, equals('Jane Doe'));
      expect(user.photoUrl, isNull);
    });

    test('should serialize User to JSON correctly', () {
      final json = testUser.toJson();

      expect(json['id'], equals('user_123'));
      expect(json['email'], equals('john.doe@example.com'));
      expect(json['displayName'], equals('John Doe'));
      expect(json['photoUrl'], equals('https://example.com/photo.jpg'));
    });

    test('should deserialize User from JSON correctly', () {
      final user = User.fromJson(validUserJson);

      expect(user.id, equals('user_123'));
      expect(user.email, equals('john.doe@example.com'));
      expect(user.displayName, equals('John Doe'));
      expect(user.photoUrl, equals('https://example.com/photo.jpg'));
    });

    test('should handle JSON serialization round trip', () {
      final json = testUser.toJson();
      final deserializedUser = User.fromJson(json);

      expect(deserializedUser, equals(testUser));
    });

    test('should create copy with updated fields using copyWith', () {
      final updatedUser = testUser.copyWith(
        displayName: 'John Smith',
        photoUrl: 'https://example.com/new-photo.jpg',
      );

      expect(updatedUser.id, equals(testUser.id));
      expect(updatedUser.email, equals(testUser.email));
      expect(updatedUser.displayName, equals('John Smith'));
      expect(updatedUser.photoUrl, equals('https://example.com/new-photo.jpg'));
    });

    test('should maintain immutability', () {
      final updatedUser = testUser.copyWith(displayName: 'New Name');

      expect(testUser.displayName, equals('John Doe'));
      expect(updatedUser.displayName, equals('New Name'));
      expect(testUser.id, equals(updatedUser.id));
    });

    test('should support equality comparison', () {
      const user1 = User(
        id: 'user_123',
        email: 'john.doe@example.com',
        displayName: 'John Doe',
        photoUrl: 'https://example.com/photo.jpg',
      );

      const user2 = User(
        id: 'user_123',
        email: 'john.doe@example.com',
        displayName: 'John Doe',
        photoUrl: 'https://example.com/photo.jpg',
      );

      final user3 = user1.copyWith(displayName: 'Different Name');

      expect(user1, equals(user2));
      expect(user1.hashCode, equals(user2.hashCode));
      expect(user1, isNot(equals(user3)));
    });

    test('should handle null photoUrl in JSON', () {
      final jsonWithNullPhoto = {
        'id': 'user_123',
        'email': 'john.doe@example.com',
        'displayName': 'John Doe',
        'photoUrl': null,
      };

      final user = User.fromJson(jsonWithNullPhoto);

      expect(user.id, equals('user_123'));
      expect(user.email, equals('john.doe@example.com'));
      expect(user.displayName, equals('John Doe'));
      expect(user.photoUrl, isNull);
    });

    test('should handle missing photoUrl in JSON', () {
      final jsonWithoutPhoto = {
        'id': 'user_123',
        'email': 'john.doe@example.com',
        'displayName': 'John Doe',
      };

      final user = User.fromJson(jsonWithoutPhoto);

      expect(user.id, equals('user_123'));
      expect(user.email, equals('john.doe@example.com'));
      expect(user.displayName, equals('John Doe'));
      expect(user.photoUrl, isNull);
    });

    test('should handle invalid JSON gracefully', () {
      final invalidJson = <String, dynamic>{
        'id': 'user_123',
        // Missing required fields
      };

      expect(() => User.fromJson(invalidJson), throwsA(isA<TypeError>()));
    });

    test('should validate email format in real usage', () {
      // Note: The model itself doesn't validate email format,
      // but we can test that it stores any string value
      const userWithInvalidEmail = User(
        id: 'user_123',
        email: 'not-an-email',
        displayName: 'Test User',
      );

      expect(userWithInvalidEmail.email, equals('not-an-email'));
    });
  });
}