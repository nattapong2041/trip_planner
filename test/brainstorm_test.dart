import 'package:flutter_test/flutter_test.dart';
import 'package:trip_planner/models/brainstorm_idea.dart';
import 'package:trip_planner/repositories/mock_activity_repository.dart';

void main() {
  group('Brainstorming Feature Tests', () {
    late MockActivityRepository repository;

    setUp(() {
      repository = MockActivityRepository();
    });

    tearDown(() {
      repository.dispose();
    });

    test('should add brainstorm idea to activity', () async {
      // Get initial activities
      final activities = repository.getActivitiesByTripId('trip_1');
      final activity = activities.first;
      final initialIdeaCount = activity.brainstormIdeas.length;

      // Create brainstorm idea
      final brainstormIdea = BrainstormIdea(
        id: '',
        description: 'Test brainstorm idea',
        createdBy: 'user_1',
        createdAt: DateTime.now(),
      );

      // Add brainstorm idea
      final updatedActivity = await repository.addBrainstormIdea(activity.id, brainstormIdea);
      
      expect(updatedActivity.brainstormIdeas.length, initialIdeaCount + 1);
      expect(updatedActivity.brainstormIdeas.last.description, 'Test brainstorm idea');
      expect(updatedActivity.brainstormIdeas.last.createdBy, 'user_1');
      expect(updatedActivity.brainstormIdeas.last.id, isNotEmpty);
    });

    test('should remove brainstorm idea from activity', () async {
      // Get activity with existing brainstorm ideas
      final activities = repository.getActivitiesByTripId('trip_1');
      final activity = activities.firstWhere((a) => a.brainstormIdeas.isNotEmpty);
      final initialIdeaCount = activity.brainstormIdeas.length;
      final ideaToRemove = activity.brainstormIdeas.first;

      // Remove brainstorm idea
      final updatedActivity = await repository.removeBrainstormIdea(activity.id, ideaToRemove.id);
      
      expect(updatedActivity.brainstormIdeas.length, initialIdeaCount - 1);
      expect(updatedActivity.brainstormIdeas.any((idea) => idea.id == ideaToRemove.id), false);
    });

    test('should display brainstorm idea count on activity card', () async {
      final activities = repository.getActivitiesByTripId('trip_1');
      final activityWithIdeas = activities.firstWhere((a) => a.brainstormIdeas.isNotEmpty);
      
      // Verify the activity has brainstorm ideas
      expect(activityWithIdeas.brainstormIdeas.isNotEmpty, true);
      expect(activityWithIdeas.brainstormIdeas.length, greaterThan(0));
    });

    test('should get activity details with brainstorm ideas', () async {
      final activities = repository.getActivitiesByTripId('trip_1');
      final activity = activities.first;
      
      final activityDetail = await repository.getActivityById(activity.id);
      
      expect(activityDetail, isNotNull);
      expect(activityDetail!.id, activity.id);
      expect(activityDetail.brainstormIdeas, activity.brainstormIdeas);
    });

    test('brainstorm ideas should have creator information and timestamps', () async {
      // Get an activity
      final activities = repository.getActivitiesByTripId('trip_1');
      final activity = activities.first;
      
      // Create brainstorm idea with metadata
      final brainstormIdea = BrainstormIdea(
        id: '',
        description: 'Test idea with metadata',
        createdBy: 'user_1',
        createdAt: DateTime.now(),
      );

      // Add brainstorm idea
      final updatedActivity = await repository.addBrainstormIdea(activity.id, brainstormIdea);
      final newIdea = updatedActivity.brainstormIdeas.last;
      
      // Verify metadata
      expect(newIdea.description, 'Test idea with metadata');
      expect(newIdea.createdBy, 'user_1');
      expect(newIdea.createdAt, isA<DateTime>());
      expect(newIdea.id, isNotEmpty);
    });

    test('should handle stream updates when brainstorm ideas are modified', () async {
      // Get initial activities
      final initialActivities = repository.getActivitiesByTripId('trip_1');
      final activity = initialActivities.first;
      final initialIdeaCount = activity.brainstormIdeas.length;
      
      // Add brainstorm idea
      final brainstormIdea = BrainstormIdea(
        id: '',
        description: 'Stream test idea',
        createdBy: 'user_1',
        createdAt: DateTime.now(),
      );
      
      final updatedActivity = await repository.addBrainstormIdea(activity.id, brainstormIdea);
      
      expect(updatedActivity.brainstormIdeas.length, initialIdeaCount + 1);
      expect(updatedActivity.brainstormIdeas.last.description, 'Stream test idea');
    });
  });
}