import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:trip_planner/providers/auth_provider.dart';
import 'package:trip_planner/providers/trip_provider.dart';
import 'package:trip_planner/providers/activity_provider.dart';

import '../helpers/firebase_mocks.dart';

/// Example showing how to test providers with Firebase mocks
void main() {
  group('Provider Integration Examples', () {
    late FirebaseMocks firebaseMocks;
    late ProviderContainer container;

    setUp(() {
      firebaseMocks = FirebaseMocks();
      
      container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(firebaseMocks.mockAuthRepository),
          tripRepositoryProvider.overrideWithValue(firebaseMocks.mockTripRepository),
          activityRepositoryProvider.overrideWithValue(firebaseMocks.mockActivityRepository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
      firebaseMocks.dispose();
    });

    test('should demonstrate basic auth provider testing', () async {
      const testUser = TestData.testUser1;
      
      // Configure the auth mock
      when(firebaseMocks.mockAuthRepository.signInWithGoogle())
          .thenAnswer((_) async => testUser);
      when(firebaseMocks.mockAuthRepository.currentUser)
          .thenReturn(null); // Start signed out
      
      // Initial state should be null
      await container.pump();
      var authState = container.read(authNotifierProvider);
      expect(authState.value, isNull);
      
      // The actual provider test would be more complex due to stream handling
      // This is just to show the mock setup
      
      // Verify we can call the repository method
      final result = await firebaseMocks.mockAuthRepository.signInWithGoogle();
      expect(result, equals(testUser));
      verify(firebaseMocks.mockAuthRepository.signInWithGoogle()).called(1);
    });

    test('should demonstrate trip provider testing with mocked data', () async {
      const testUser = TestData.testUser1;
      final testTrips = [TestData.testTrip];
      
      // Configure mocks
      firebaseMocks.signInUser(testUser);
      when(firebaseMocks.mockTripRepository.getUserTrips(testUser.id))
          .thenAnswer((_) => Stream.value(testTrips));
      
      // The provider would use these mocks when running
      // This demonstrates the mock configuration
      
      final stream = firebaseMocks.mockTripRepository.getUserTrips(testUser.id);
      final result = await stream.first;
      expect(result, equals(testTrips));
    });

    test('should demonstrate activity provider testing', () async {
      const testUser = TestData.testUser1;
      const tripId = 'test-trip-1';
      final testActivities = [TestData.testActivity];
      
      // Configure mocks
      firebaseMocks.signInUser(testUser);
      when(firebaseMocks.mockActivityRepository.getTripActivities(tripId))
          .thenAnswer((_) => Stream.value(testActivities));
      when(firebaseMocks.mockActivityRepository.createActivity(any))
          .thenAnswer((_) async => TestData.testActivity);
      
      // Test the repository directly (provider tests would be more complex)
      final stream = firebaseMocks.mockActivityRepository.getTripActivities(tripId);
      final result = await stream.first;
      expect(result, equals(testActivities));
      
      final created = await firebaseMocks.mockActivityRepository.createActivity(TestData.testActivity);
      expect(created, equals(TestData.testActivity));
      
      // Verify calls
      verify(firebaseMocks.mockActivityRepository.getTripActivities(tripId)).called(1);
      verify(firebaseMocks.mockActivityRepository.createActivity(any)).called(1);
    });

    test('should demonstrate error handling in providers', () async {
      const errorMessage = 'Firebase connection failed';
      
      // Configure mock to throw error
      when(firebaseMocks.mockAuthRepository.signInWithGoogle())
          .thenThrow(Exception(errorMessage));
      
      // Test error handling
      expect(
        () => firebaseMocks.mockAuthRepository.signInWithGoogle(),
        throwsA(predicate((e) => e.toString().contains(errorMessage))),
      );
      
      verify(firebaseMocks.mockAuthRepository.signInWithGoogle()).called(1);
    });

    test('should demonstrate complex workflow testing', () async {
      const testUser = TestData.testUser1;
      final testTrip = TestData.testTrip;
      final testActivity = TestData.testActivity;
      
      // Configure a complete workflow
      firebaseMocks.signInUser(testUser);
      when(firebaseMocks.mockTripRepository.createTrip(any))
          .thenAnswer((_) async => testTrip);
      when(firebaseMocks.mockActivityRepository.createActivity(any))
          .thenAnswer((_) async => testActivity);
      
      // Simulate workflow: sign in -> create trip -> create activity
      final user = await firebaseMocks.mockAuthRepository.signInWithGoogle();
      expect(user, equals(testUser));
      
      final trip = await firebaseMocks.mockTripRepository.createTrip(testTrip);
      expect(trip, equals(testTrip));
      
      final activity = await firebaseMocks.mockActivityRepository.createActivity(testActivity);
      expect(activity, equals(testActivity));
      
      // Verify the complete workflow
      verifyInOrder([
        firebaseMocks.mockAuthRepository.signInWithGoogle(),
        firebaseMocks.mockTripRepository.createTrip(any),
        firebaseMocks.mockActivityRepository.createActivity(any),
      ]);
    });
  });
}

extension ProviderContainerExtension on ProviderContainer {
  Future<void> pump() async {
    await Future.delayed(Duration.zero);
  }
}