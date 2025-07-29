import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:trip_planner/models/user.dart';

import '../helpers/firebase_mocks.dart';

void main() {
  group('Firebase Mocking Examples', () {
    late FirebaseMocks firebaseMocks;

    setUp(() {
      firebaseMocks = FirebaseMocks();
    });

    tearDown(() {
      firebaseMocks.dispose();
    });

    test('should mock auth repository successfully', () async {
      const testUser = TestData.testUser1;
      
      // Configure the mock
      when(firebaseMocks.mockAuthRepository.signInWithGoogle())
          .thenAnswer((_) async => testUser);
      when(firebaseMocks.mockAuthRepository.currentUser)
          .thenReturn(testUser);
      
      // Use the mock
      final result = await firebaseMocks.mockAuthRepository.signInWithGoogle();
      expect(result, equals(testUser));
      expect(firebaseMocks.mockAuthRepository.currentUser, equals(testUser));
      
      // Verify the mock was called
      verify(firebaseMocks.mockAuthRepository.signInWithGoogle()).called(1);
    });

    test('should mock activity repository operations', () async {
      const tripId = 'test-trip-1';
      final testActivity = TestData.testActivity;
      final activities = [testActivity];
      
      // Configure the mock
      when(firebaseMocks.mockActivityRepository.getTripActivities(tripId))
          .thenAnswer((_) => Stream.value(activities));
      when(firebaseMocks.mockActivityRepository.createActivity(any))
          .thenAnswer((_) async => testActivity);
      when(firebaseMocks.mockActivityRepository.getActivityById(testActivity.id))
          .thenAnswer((_) async => testActivity);
      
      // Test stream
      final stream = firebaseMocks.mockActivityRepository.getTripActivities(tripId);
      final streamResult = await stream.first;
      expect(streamResult, equals(activities));
      
      // Test create
      final createResult = await firebaseMocks.mockActivityRepository.createActivity(testActivity);
      expect(createResult, equals(testActivity));
      
      // Test get by ID
      final getResult = await firebaseMocks.mockActivityRepository.getActivityById(testActivity.id);
      expect(getResult, equals(testActivity));
      
      // Verify calls
      verify(firebaseMocks.mockActivityRepository.getTripActivities(tripId)).called(1);
      verify(firebaseMocks.mockActivityRepository.createActivity(any)).called(1);
      verify(firebaseMocks.mockActivityRepository.getActivityById(testActivity.id)).called(1);
    });

    test('should mock trip repository operations', () async {
      const userId = 'test-user-1';
      final testTrip = TestData.testTrip;
      final trips = [testTrip];
      
      // Configure the mock
      when(firebaseMocks.mockTripRepository.getUserTrips(userId))
          .thenAnswer((_) => Stream.value(trips));
      when(firebaseMocks.mockTripRepository.createTrip(any))
          .thenAnswer((_) async => testTrip);
      when(firebaseMocks.mockTripRepository.getTripById(testTrip.id))
          .thenAnswer((_) async => testTrip);
      
      // Test stream
      final stream = firebaseMocks.mockTripRepository.getUserTrips(userId);
      final streamResult = await stream.first;
      expect(streamResult, equals(trips));
      
      // Test create
      final createResult = await firebaseMocks.mockTripRepository.createTrip(testTrip);
      expect(createResult, equals(testTrip));
      
      // Test get by ID
      final getResult = await firebaseMocks.mockTripRepository.getTripById(testTrip.id);
      expect(getResult, equals(testTrip));
      
      // Verify calls
      verify(firebaseMocks.mockTripRepository.getUserTrips(userId)).called(1);
      verify(firebaseMocks.mockTripRepository.createTrip(any)).called(1);
      verify(firebaseMocks.mockTripRepository.getTripById(testTrip.id)).called(1);
    });

    test('should handle auth state changes with stream controller', () async {
      const testUser = TestData.testUser1;
      
      // Listen to auth state changes
      final authStates = <User?>[];
      final subscription = firebaseMocks.authStateController.stream.listen(authStates.add);
      
      // Simulate auth state changes
      firebaseMocks.authStateController.add(null); // Initial state
      await Future.delayed(Duration.zero);
      
      firebaseMocks.authStateController.add(testUser); // Sign in
      await Future.delayed(Duration.zero);
      
      firebaseMocks.authStateController.add(null); // Sign out
      await Future.delayed(Duration.zero);
      
      // Verify state changes were captured
      expect(authStates, hasLength(3));
      expect(authStates[0], isNull);
      expect(authStates[1], equals(testUser));
      expect(authStates[2], isNull);
      
      await subscription.cancel();
    });

    test('should demonstrate error handling with mocks', () async {
      const errorMessage = 'Network error';
      
      // Configure mock to throw error
      when(firebaseMocks.mockAuthRepository.signInWithGoogle())
          .thenThrow(Exception(errorMessage));
      
      // Test error handling
      expect(
        () => firebaseMocks.mockAuthRepository.signInWithGoogle(),
        throwsA(isA<Exception>()),
      );
      
      // Verify the mock was called
      verify(firebaseMocks.mockAuthRepository.signInWithGoogle()).called(1);
    });

    test('should demonstrate complex activity operations', () async {
      final testActivity = TestData.testActivity;
      final brainstormIdea = TestData.testBrainstormIdea;
      final updatedActivity = testActivity.copyWith(
        brainstormIdeas: [brainstormIdea],
      );
      
      // Configure mocks for complex operations
      when(firebaseMocks.mockActivityRepository.getActivityById(testActivity.id))
          .thenAnswer((_) async => testActivity);
      when(firebaseMocks.mockActivityRepository.addBrainstormIdea(testActivity.id, brainstormIdea))
          .thenAnswer((_) async => updatedActivity);
      when(firebaseMocks.mockActivityRepository.assignActivityToDay(
        testActivity.id, 'day-1', 0, timeSlot: '09:00'))
          .thenAnswer((_) async => testActivity.copyWith(
            assignedDay: 'day-1',
            dayOrder: 0,
            timeSlot: '09:00',
          ));
      
      // Test the operations
      final activity = await firebaseMocks.mockActivityRepository.getActivityById(testActivity.id);
      expect(activity, equals(testActivity));
      
      final withIdea = await firebaseMocks.mockActivityRepository.addBrainstormIdea(
        testActivity.id, brainstormIdea);
      expect(withIdea.brainstormIdeas, contains(brainstormIdea));
      
      final assigned = await firebaseMocks.mockActivityRepository.assignActivityToDay(
        testActivity.id, 'day-1', 0, timeSlot: '09:00');
      expect(assigned.assignedDay, equals('day-1'));
      expect(assigned.dayOrder, equals(0));
      expect(assigned.timeSlot, equals('09:00'));
      
      // Verify all calls
      verify(firebaseMocks.mockActivityRepository.getActivityById(testActivity.id)).called(1);
      verify(firebaseMocks.mockActivityRepository.addBrainstormIdea(testActivity.id, brainstormIdea)).called(1);
      verify(firebaseMocks.mockActivityRepository.assignActivityToDay(
        testActivity.id, 'day-1', 0, timeSlot: '09:00')).called(1);
    });
  });
}