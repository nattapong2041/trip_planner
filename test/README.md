# Testing with Firebase Mocks

This directory contains comprehensive testing utilities for mocking Firebase repositories using Mockito. This approach allows you to test your business logic without connecting to actual Firebase services.

## Overview

Instead of using custom mock repository implementations, we use **Mockito** to create mocks of our Firebase repositories. This provides several advantages:

- **Precise control**: Mock exactly what you need for each test
- **Verification**: Verify that methods were called with expected parameters
- **Error simulation**: Easily simulate error conditions
- **No maintenance overhead**: No need to maintain separate mock implementations

## Quick Start

### 1. Import the Firebase Mocks Helper

```dart
import '../helpers/firebase_mocks.dart';
```

### 2. Set Up Your Test

```dart
void main() {
  group('My Feature Tests', () {
    late FirebaseMocks firebaseMocks;
    late ProviderContainer container;

    setUp(() {
      firebaseMocks = FirebaseMocks();
      
      container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(firebaseMocks.mockAuthRepository),
          activityRepositoryProvider.overrideWithValue(firebaseMocks.mockActivityRepository),
          tripRepositoryProvider.overrideWithValue(firebaseMocks.mockTripRepository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
      firebaseMocks.dispose();
    });

    // Your tests here...
  });
}
```

### 3. Write Your Tests

```dart
test('should create an activity', () async {
  const testUser = TestData.testUser1;
  final newActivity = TestData.testActivity;
  
  // Configure mocks
  firebaseMocks.signInUser(testUser);
  when(firebaseMocks.mockActivityRepository.createActivity(any))
      .thenAnswer((_) async => newActivity);
  
  // Execute the operation
  final result = await firebaseMocks.mockActivityRepository.createActivity(newActivity);
  
  // Verify results
  expect(result, equals(newActivity));
  verify(firebaseMocks.mockActivityRepository.createActivity(any)).called(1);
});
```

## Available Mocks

### AuthRepository Mock

```dart
// Configure sign in
when(firebaseMocks.mockAuthRepository.signInWithGoogle())
    .thenAnswer((_) async => testUser);

// Configure current user
when(firebaseMocks.mockAuthRepository.currentUser)
    .thenReturn(testUser);

// Configure auth state stream
when(firebaseMocks.mockAuthRepository.authStateChanges)
    .thenAnswer((_) => firebaseMocks.authStateController.stream);

// Simulate auth state changes
firebaseMocks.authStateController.add(testUser); // Sign in
firebaseMocks.authStateController.add(null);     // Sign out
```

### ActivityRepository Mock

```dart
// Configure activity stream
when(firebaseMocks.mockActivityRepository.getTripActivities(tripId))
    .thenAnswer((_) => Stream.value([testActivity]));

// Configure CRUD operations
when(firebaseMocks.mockActivityRepository.createActivity(any))
    .thenAnswer((_) async => testActivity);
when(firebaseMocks.mockActivityRepository.updateActivity(any))
    .thenAnswer((_) async => testActivity);
when(firebaseMocks.mockActivityRepository.getActivityById(activityId))
    .thenAnswer((_) async => testActivity);

// Configure brainstorm operations
when(firebaseMocks.mockActivityRepository.addBrainstormIdea(activityId, any))
    .thenAnswer((_) async => activityWithIdea);
```

### TripRepository Mock

```dart
// Configure trip stream
when(firebaseMocks.mockTripRepository.getUserTrips(userId))
    .thenAnswer((_) => Stream.value([testTrip]));

// Configure CRUD operations
when(firebaseMocks.mockTripRepository.createTrip(any))
    .thenAnswer((_) async => testTrip);
when(firebaseMocks.mockTripRepository.getTripById(tripId))
    .thenAnswer((_) async => testTrip);

// Configure collaboration
when(firebaseMocks.mockTripRepository.getTripCollaborators(tripId))
    .thenAnswer((_) async => [testUser1, testUser2]);
```

## Helper Methods

The `FirebaseMocks` class provides convenient helper methods:

### Authentication Helpers

```dart
// Sign in a user (configures multiple auth methods)
firebaseMocks.signInUser(testUser);

// Sign out (configures sign out behavior)
firebaseMocks.signOutUser();
```

### Data Helpers

```dart
// Set trip activities
firebaseMocks.setTripActivities(tripId, [activity1, activity2]);

// Set user trips
firebaseMocks.setUserTrips(userId, [trip1, trip2]);

// Configure single operations
firebaseMocks.mockCreateActivity(newActivity);
firebaseMocks.mockUpdateTrip(updatedTrip);
firebaseMocks.mockGetActivityById(activityId, activity);
```

## Test Data

Use the `TestData` class for consistent test data:

```dart
const testUser = TestData.testUser1;
final testTrip = TestData.testTrip;
final testActivity = TestData.testActivity;
final testBrainstormIdea = TestData.testBrainstormIdea;
```

## Error Testing

Simulate errors easily:

```dart
// Configure mock to throw an error
when(firebaseMocks.mockAuthRepository.signInWithGoogle())
    .thenThrow(Exception('Network error'));

// Test error handling
expect(
  () => firebaseMocks.mockAuthRepository.signInWithGoogle(),
  throwsA(isA<Exception>()),
);
```

## Stream Testing

Test real-time updates with stream controllers:

```dart
// Listen to stream changes
final results = <List<Activity>>[];
final subscription = firebaseMocks.activitiesController.stream.listen(results.add);

// Emit data
firebaseMocks.activitiesController.add([activity1]);
firebaseMocks.activitiesController.add([activity1, activity2]);

// Verify stream updates
expect(results, hasLength(2));
expect(results[1], hasLength(2));

await subscription.cancel();
```

## Verification

Verify that your code calls the expected methods:

```dart
// Verify method was called
verify(firebaseMocks.mockActivityRepository.createActivity(any)).called(1);

// Verify method was called with specific parameters
verify(firebaseMocks.mockActivityRepository.assignActivityToDay(
  'activity-1', 'day-1', 0, timeSlot: '09:00')).called(1);

// Verify method was never called
verifyNever(firebaseMocks.mockActivityRepository.deleteActivity(any));

// Verify call order
verifyInOrder([
  firebaseMocks.mockActivityRepository.getActivityById('activity-1'),
  firebaseMocks.mockActivityRepository.updateActivity(any),
]);
```

## Best Practices

### 1. Use Descriptive Test Names

```dart
test('should create activity and add to trip when user is authenticated', () async {
  // Test implementation
});
```

### 2. Arrange, Act, Assert Pattern

```dart
test('should update activity successfully', () async {
  // Arrange
  const testUser = TestData.testUser1;
  final updatedActivity = TestData.testActivity.copyWith(place: 'New Place');
  firebaseMocks.signInUser(testUser);
  when(firebaseMocks.mockActivityRepository.updateActivity(any))
      .thenAnswer((_) async => updatedActivity);
  
  // Act
  final result = await firebaseMocks.mockActivityRepository.updateActivity(updatedActivity);
  
  // Assert
  expect(result.place, equals('New Place'));
  verify(firebaseMocks.mockActivityRepository.updateActivity(any)).called(1);
});
```

### 3. Test Edge Cases

```dart
test('should handle activity not found error', () async {
  when(firebaseMocks.mockActivityRepository.getActivityById('invalid-id'))
      .thenAnswer((_) async => null);
  
  final result = await firebaseMocks.mockActivityRepository.getActivityById('invalid-id');
  expect(result, isNull);
});
```

### 4. Clean Up Resources

Always dispose of resources in `tearDown`:

```dart
tearDown(() {
  container.dispose();
  firebaseMocks.dispose();
});
```

## Examples

See the following files for complete examples:

- `test/examples/firebase_mocking_example_test.dart` - Basic mocking examples
- `test/providers/auth_provider_with_firebase_mocks_test.dart` - Auth provider testing
- `test/providers/trip_provider_with_firebase_mocks_test.dart` - Trip provider testing
- `test/providers/activity_provider_with_firebase_mocks_test.dart` - Activity provider testing

## Generating New Mocks

If you add new repository methods or create new repositories, regenerate the mocks:

```bash
dart run build_runner build --delete-conflicting-outputs
```

This will update the `test/helpers/firebase_mocks.mocks.dart` file with new mock classes.

## Integration with CI/CD

These tests run completely offline and don't require Firebase configuration, making them perfect for CI/CD pipelines. They're fast, reliable, and don't depend on external services.

```bash
# Run all tests
flutter test

# Run only mock tests
flutter test test/helpers/
flutter test test/examples/
flutter test test/providers/
```