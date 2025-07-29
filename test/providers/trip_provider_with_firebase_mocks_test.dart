import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_planner/providers/trip_provider.dart';
import 'package:trip_planner/providers/auth_provider.dart';
import 'package:trip_planner/models/trip.dart';
import 'package:trip_planner/models/user.dart';

import '../helpers/firebase_mocks.dart';

void main() {
  group('Trip Provider with Firebase Mocks', () {
    late FirebaseMocks firebaseMocks;
    late ProviderContainer container;

    setUp(() {
      firebaseMocks = FirebaseMocks();
      
      container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(firebaseMocks.mockAuthRepository),
          tripRepositoryProvider.overrideWithValue(firebaseMocks.mockTripRepository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
      firebaseMocks.dispose();
    });

    test('should return empty list when user is not authenticated', () async {
      // Ensure user is not authenticated
      firebaseMocks.signOutUser();
      await container.pump();
      
      final tripListState = container.read(tripListNotifierProvider);
      
      await container.pump();
      
      expect(tripListState.value, equals([]));
    });

    test('should load user trips when authenticated', () async {
      const testUser = TestData.testUser1;
      final testTrips = [TestData.testTrip];
      
      // Sign in user
      firebaseMocks.signInUser(testUser);
      
      // Configure mock to return trips
      firebaseMocks.setUserTrips(testUser.id, testTrips);
      
      await container.pump();
      
      final tripListState = container.read(tripListNotifierProvider);
      expect(tripListState.value, equals(testTrips));
    });

    test('should create a new trip', () async {
      const testUser = TestData.testUser1;
      final newTrip = TestData.testTrip.copyWith(
        name: 'New Test Trip',
        durationDays: 7,
      );
      
      // Sign in user
      firebaseMocks.signInUser(testUser);
      
      // Configure mock for trip creation
      firebaseMocks.mockCreateTrip(newTrip);
      
      await container.pump();
      
      // Create trip
      await container.read(tripListNotifierProvider.notifier).createTrip(
        name: 'New Test Trip',
        durationDays: 7,
      );
      
      // Verify the mock was called (in a real test, you'd verify the trip was added to the list)
      // This is a simplified example - in practice you'd want to verify the stream updates
    });

    test('should update an existing trip', () async {
      const testUser = TestData.testUser1;
      final updatedTrip = TestData.testTrip.copyWith(
        name: 'Updated Trip Name',
      );
      
      // Sign in user
      firebaseMocks.signInUser(testUser);
      
      // Configure mock for trip update
      firebaseMocks.mockUpdateTrip(updatedTrip);
      
      await container.pump();
      
      // Update trip
      await container.read(tripListNotifierProvider.notifier).updateTrip(updatedTrip);
      
      // In a real test, you'd verify the stream updates with the new data
    });

    test('should delete a trip', () async {
      const testUser = TestData.testUser1;
      
      // Sign in user
      firebaseMocks.signInUser(testUser);
      
      // Configure mock for trip deletion
      firebaseMocks.mockDeleteTrip();
      
      await container.pump();
      
      // Delete trip
      await container.read(tripListNotifierProvider.notifier).deleteTrip('test-trip-1');
      
      // In a real test, you'd verify the trip was removed from the stream
    });

    test('should get trip details', () async {
      const testUser = TestData.testUser1;
      final testTrip = TestData.testTrip;
      
      // Sign in user
      firebaseMocks.signInUser(testUser);
      
      // Configure mock to return trip details
      firebaseMocks.mockGetTripById(testTrip.id, testTrip);
      
      await container.pump();
      
      final tripDetailState = await container.read(tripDetailNotifierProvider(testTrip.id).future);
      expect(tripDetailState, equals(testTrip));
    });

    test('should handle trip collaboration', () async {
      const testUser = TestData.testUser1;
      const collaborators = [TestData.testUser1, TestData.testUser2];
      
      // Sign in user
      firebaseMocks.signInUser(testUser);
      
      // Configure mock for collaboration
      firebaseMocks.mockTripCollaboration(collaborators);
      
      await container.pump();
      
      // Add collaborator
      await container.read(tripListNotifierProvider.notifier).addCollaborator(
        'test-trip-1',
        'newuser@example.com',
      );
      
      // Get collaborators
      final tripCollaborators = await container.read(
        tripCollaboratorsNotifierProvider('test-trip-1').future,
      );
      
      expect(tripCollaborators, equals(collaborators));
    });
  });
}

extension ProviderContainerExtension on ProviderContainer {
  Future<void> pump() async {
    await Future.delayed(Duration.zero);
  }
}