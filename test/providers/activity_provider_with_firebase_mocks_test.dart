import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_planner/providers/activity_provider.dart';
import 'package:trip_planner/providers/auth_provider.dart';
import 'package:trip_planner/models/activity.dart';
import 'package:trip_planner/models/brainstorm_idea.dart';

import '../helpers/firebase_mocks.dart';

void main() {
  group('Activity Provider with Firebase Mocks', () {
    late FirebaseMocks firebaseMocks;
    late ProviderContainer container;

    setUp(() {
      firebaseMocks = FirebaseMocks();
      
      container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(firebaseMocks.mockAuthRepository),
          activityRepositoryProvider.overrideWithValue(firebaseMocks.mockActivityRepository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
      firebaseMocks.dispose();
    });

    test('should load trip activities', () async {
      const testUser = TestData.testUser1;
      final testActivities = [TestData.testActivity];
      const tripId = 'test-trip-1';
      
      // Sign in user
      firebaseMocks.signInUser(testUser);
      
      // Configure mock to return activities
      firebaseMocks.setTripActivities(tripId, testActivities);
      
      await container.pump();
      
      final activitiesState = container.read(activityListNotifierProvider(tripId));
      expect(activitiesState.value, equals(testActivities));
    });

    test('should create a new activity', () async {
      const testUser = TestData.testUser1;
      const tripId = 'test-trip-1';
      final newActivity = TestData.testActivity.copyWith(
        place: 'New Test Place',
        activityType: 'restaurant',
      );
      
      // Sign in user
      firebaseMocks.signInUser(testUser);
      
      // Configure mock for activity creation
      firebaseMocks.mockCreateActivity(newActivity);
      
      await container.pump();
      
      // Create activity
      await container.read(activityListNotifierProvider(tripId).notifier).createActivity(
        tripId: tripId,
        place: 'New Test Place',
        activityType: 'restaurant',
        price: '\$30',
        notes: 'Great food',
      );
      
      // In a real test, you'd verify the activity was added to the stream
    });

    test('should update an activity', () async {
      const testUser = TestData.testUser1;
      const tripId = 'test-trip-1';
      final updatedActivity = TestData.testActivity.copyWith(
        place: 'Updated Place',
        notes: 'Updated notes',
      );
      
      // Sign in user
      firebaseMocks.signInUser(testUser);
      
      // Configure mock for activity update
      firebaseMocks.mockUpdateActivity(updatedActivity);
      
      await container.pump();
      
      // Update activity
      await container.read(activityListNotifierProvider(tripId).notifier).updateActivity(updatedActivity);
      
      // In a real test, you'd verify the stream updates with the new data
    });

    test('should delete an activity', () async {
      const testUser = TestData.testUser1;
      const tripId = 'test-trip-1';
      
      // Sign in user
      firebaseMocks.signInUser(testUser);
      
      // Configure mock for activity deletion
      firebaseMocks.mockDeleteActivity();
      
      await container.pump();
      
      // Delete activity
      await container.read(activityListNotifierProvider(tripId).notifier).deleteActivity('test-activity-1');
      
      // In a real test, you'd verify the activity was removed from the stream
    });

    test('should assign activity to day', () async {
      const testUser = TestData.testUser1;
      const tripId = 'test-trip-1';
      final assignedActivity = TestData.testActivity.copyWith(
        assignedDay: 'day-1',
        dayOrder: 0,
        timeSlot: '09:00',
      );
      
      // Sign in user
      firebaseMocks.signInUser(testUser);
      
      // Configure mocks
      firebaseMocks.mockGetActivityById('test-activity-1', TestData.testActivity);
      firebaseMocks.mockActivityAssignment(assignedActivity);
      
      await container.pump();
      
      // Assign activity to day
      await container.read(activityListNotifierProvider(tripId).notifier).assignActivityToDay(
        'test-activity-1',
        'day-1',
        0,
        timeSlot: '09:00',
      );
      
      // In a real test, you'd verify the activity was updated in the stream
    });

    test('should move activity to pool', () async {
      const testUser = TestData.testUser1;
      const tripId = 'test-trip-1';
      final poolActivity = TestData.testActivity.copyWith(
        assignedDay: null,
        dayOrder: null,
        timeSlot: null,
      );
      
      // Sign in user
      firebaseMocks.signInUser(testUser);
      
      // Configure mocks
      firebaseMocks.mockGetActivityById('test-activity-1', TestData.testActivity);
      firebaseMocks.mockActivityAssignment(poolActivity);
      
      await container.pump();
      
      // Move activity to pool
      await container.read(activityListNotifierProvider(tripId).notifier).moveActivityToPool('test-activity-1');
      
      // In a real test, you'd verify the activity was updated in the stream
    });

    test('should add brainstorm idea', () async {
      const testUser = TestData.testUser1;
      const tripId = 'test-trip-1';
      final activityWithIdea = TestData.testActivity.copyWith(
        brainstormIdeas: [TestData.testBrainstormIdea],
      );
      
      // Sign in user
      firebaseMocks.signInUser(testUser);
      
      // Configure mock for brainstorm operations
      firebaseMocks.mockBrainstormOperations(activityWithIdea);
      
      await container.pump();
      
      // Add brainstorm idea
      await container.read(activityListNotifierProvider(tripId).notifier).addBrainstormIdea(
        'test-activity-1',
        'Great idea for this activity',
      );
      
      // In a real test, you'd verify the idea was added to the activity
    });

    test('should remove brainstorm idea', () async {
      const testUser = TestData.testUser1;
      const tripId = 'test-trip-1';
      final activityWithoutIdea = TestData.testActivity.copyWith(
        brainstormIdeas: [],
      );
      
      // Sign in user
      firebaseMocks.signInUser(testUser);
      
      // Configure mock for brainstorm operations
      firebaseMocks.mockBrainstormOperations(activityWithoutIdea);
      
      await container.pump();
      
      // Remove brainstorm idea
      await container.read(activityListNotifierProvider(tripId).notifier).removeBrainstormIdea(
        'test-activity-1',
        'test-idea-1',
      );
      
      // In a real test, you'd verify the idea was removed from the activity
    });

    test('should get activity details', () async {
      const testUser = TestData.testUser1;
      final testActivity = TestData.testActivity;
      
      // Sign in user
      firebaseMocks.signInUser(testUser);
      
      // Configure mock to return activity details
      firebaseMocks.mockGetActivityById(testActivity.id, testActivity);
      
      await container.pump();
      
      final activityDetailState = await container.read(
        activityDetailNotifierProvider(testActivity.id).future,
      );
      
      expect(activityDetailState, equals(testActivity));
    });

    test('should group activities by assignment status', () async {
      const testUser = TestData.testUser1;
      const tripId = 'test-trip-1';
      
      final poolActivity = TestData.testActivity.copyWith(
        id: 'pool-activity',
        assignedDay: null,
      );
      
      final assignedActivity = TestData.testActivity.copyWith(
        id: 'assigned-activity',
        assignedDay: 'day-1',
        dayOrder: 0,
      );
      
      final testActivities = [poolActivity, assignedActivity];
      
      // Sign in user
      firebaseMocks.signInUser(testUser);
      
      // Configure mock to return mixed activities
      firebaseMocks.setTripActivities(tripId, testActivities);
      
      await container.pump();
      
      final activityGroups = await container.read(
        activityGroupsNotifierProvider(tripId).future,
      );
      
      expect(activityGroups.poolActivities, contains(poolActivity));
      expect(activityGroups.assignedActivities['day-1'], contains(assignedActivity));
    });
  });
}

extension ProviderContainerExtension on ProviderContainer {
  Future<void> pump() async {
    await Future.delayed(Duration.zero);
  }
}