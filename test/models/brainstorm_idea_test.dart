import 'package:flutter_test/flutter_test.dart';
import 'package:trip_planner/models/brainstorm_idea.dart';

void main() {
  group('BrainstormIdea Model Tests', () {
    late DateTime testDate;
    late BrainstormIdea testIdea;
    late Map<String, dynamic> validIdeaJson;

    setUp(() {
      testDate = DateTime(2024, 1, 15, 10, 30);
      
      testIdea = BrainstormIdea(
        id: 'idea_123',
        description: 'Try the famous ramen at this location',
        createdBy: 'user_456',
        createdAt: testDate,
      );

      validIdeaJson = {
        'id': 'idea_123',
        'description': 'Try the famous ramen at this location',
        'createdBy': 'user_456',
        'createdAt': testDate.toIso8601String(),
      };
    });

    test('should create BrainstormIdea instance with all fields', () {
      expect(testIdea.id, equals('idea_123'));
      expect(testIdea.description, equals('Try the famous ramen at this location'));
      expect(testIdea.createdBy, equals('user_456'));
      expect(testIdea.createdAt, equals(testDate));
    });

    test('should serialize BrainstormIdea to JSON correctly', () {
      final json = testIdea.toJson();

      expect(json['id'], equals('idea_123'));
      expect(json['description'], equals('Try the famous ramen at this location'));
      expect(json['createdBy'], equals('user_456'));
      expect(json['createdAt'], equals(testDate.toIso8601String()));
    });

    test('should deserialize BrainstormIdea from JSON correctly', () {
      final idea = BrainstormIdea.fromJson(validIdeaJson);

      expect(idea.id, equals('idea_123'));
      expect(idea.description, equals('Try the famous ramen at this location'));
      expect(idea.createdBy, equals('user_456'));
      expect(idea.createdAt, equals(testDate));
    });

    test('should handle JSON serialization round trip', () {
      final json = testIdea.toJson();
      final deserializedIdea = BrainstormIdea.fromJson(json);

      expect(deserializedIdea, equals(testIdea));
    });

    test('should create copy with updated fields using copyWith', () {
      final updatedIdea = testIdea.copyWith(
        description: 'Updated: Try the famous ramen and tempura',
        createdBy: 'user_789',
      );

      expect(updatedIdea.id, equals(testIdea.id));
      expect(updatedIdea.description, equals('Updated: Try the famous ramen and tempura'));
      expect(updatedIdea.createdBy, equals('user_789'));
      expect(updatedIdea.createdAt, equals(testIdea.createdAt));
    });

    test('should maintain immutability', () {
      final updatedIdea = testIdea.copyWith(description: 'New Description');

      expect(testIdea.description, equals('Try the famous ramen at this location'));
      expect(updatedIdea.description, equals('New Description'));
      expect(testIdea.id, equals(updatedIdea.id));
    });

    test('should support equality comparison', () {
      final idea1 = BrainstormIdea(
        id: 'idea_123',
        description: 'Try the famous ramen',
        createdBy: 'user_456',
        createdAt: testDate,
      );

      final idea2 = BrainstormIdea(
        id: 'idea_123',
        description: 'Try the famous ramen',
        createdBy: 'user_456',
        createdAt: testDate,
      );

      final idea3 = idea1.copyWith(description: 'Different description');

      expect(idea1, equals(idea2));
      expect(idea1.hashCode, equals(idea2.hashCode));
      expect(idea1, isNot(equals(idea3)));
    });

    test('should handle empty description', () {
      final emptyIdea = BrainstormIdea(
        id: 'idea_empty',
        description: '',
        createdBy: 'user_456',
        createdAt: testDate,
      );

      expect(emptyIdea.description, equals(''));
      expect(emptyIdea.description.isEmpty, isTrue);
    });

    test('should handle long description', () {
      final longDescription = 'This is a very long brainstorm idea description that contains multiple sentences and detailed information about what we should do at this location. It includes specific recommendations, timing suggestions, and other useful details for the trip planning process.';
      
      final longIdea = BrainstormIdea(
        id: 'idea_long',
        description: longDescription,
        createdBy: 'user_456',
        createdAt: testDate,
      );

      expect(longIdea.description, equals(longDescription));
      expect(longIdea.description.length, greaterThan(100));
    });

    test('should handle special characters in description', () {
      const specialDescription = 'Try the ramen 🍜 at 3:30 PM! Cost: ¥1,500-2,000 (approx. \$15-20)';
      
      final specialIdea = BrainstormIdea(
        id: 'idea_special',
        description: specialDescription,
        createdBy: 'user_456',
        createdAt: testDate,
      );

      expect(specialIdea.description, equals(specialDescription));
      
      // Test JSON round trip with special characters
      final json = specialIdea.toJson();
      final deserializedIdea = BrainstormIdea.fromJson(json);
      expect(deserializedIdea.description, equals(specialDescription));
    });

    test('should handle invalid JSON gracefully', () {
      final invalidJson = <String, dynamic>{
        'id': 'idea_123',
        // Missing required fields
      };

      expect(() => BrainstormIdea.fromJson(invalidJson), throwsA(isA<TypeError>()));
    });

    test('should handle different date formats in JSON', () {
      final differentDateJson = {
        'id': 'idea_123',
        'description': 'Test idea',
        'createdBy': 'user_456',
        'createdAt': '2024-01-15T10:30:00.000Z',
      };

      final idea = BrainstormIdea.fromJson(differentDateJson);
      expect(idea.createdAt, isA<DateTime>());
      expect(idea.createdAt.year, equals(2024));
      expect(idea.createdAt.month, equals(1));
      expect(idea.createdAt.day, equals(15));
    });
  });
}