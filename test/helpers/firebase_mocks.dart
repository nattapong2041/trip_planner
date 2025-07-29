import 'dart:async';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:trip_planner/repositories/auth_repository.dart';
import 'package:trip_planner/repositories/activity_repository.dart';
import 'package:trip_planner/repositories/trip_repository.dart';
import 'package:trip_planner/repositories/firebase_auth_repository.dart';
import 'package:trip_planner/repositories/firebase_activity_repository.dart';
import 'package:trip_planner/repositories/firebase_trip_repository.dart';
import 'package:trip_planner/models/user.dart';
import 'package:trip_planner/models/activity.dart';
import 'package:trip_planner/models/trip.dart';
import 'package:trip_planner/models/brainstorm_idea.dart';

import 'firebase_mocks.mocks.dart';

// Generate mocks for all Firebase repositories
@GenerateMocks([
  AuthRepository,
  ActivityRepository,
  TripRepository,
  FirebaseAuthRepository,
  FirebaseActivityRepository,
  FirebaseTripRepository,
])
void main() {}

/// Helper class to create and configure Firebase repository mocks
class FirebaseMocks {
  late MockAuthRepository mockAuthRepository;
  late MockActivityRepository mockActivityRepository;
  late MockTripRepository mockTripRepository;

  late StreamController<User?> authStateController;
  late StreamController<List<Activity>> activitiesController;
  late StreamController<List<Trip>> tripsController;

  FirebaseMocks() {
    _initializeMocks();
    _setupDefaultBehavior();
  }

  void _initializeMocks() {
    mockAuthRepository = MockAuthRepository();
    mockActivityRepository = MockActivityRepository();
    mockTripRepository = MockTripRepository();

    authStateController = StreamController<User?>.broadcast();
    activitiesController = StreamController<List<Activity>>.broadcast();
    tripsController = StreamController<List<Trip>>.broadcast();
  }

  void _setupDefaultBehavior() {
    // Auth Repository defaults
    when(mockAuthRepository.authStateChanges)
        .thenAnswer((_) => authStateController.stream);
    when(mockAuthRepository.currentUser).thenReturn(null);

    // Activity Repository defaults
    when(mockActivityRepository.getTripActivities(any))
        .thenAnswer((_) => activitiesController.stream);

    // Trip Repository defaults
    when(mockTripRepository.getUserTrips(any))
        .thenAnswer((_) => tripsController.stream);
  }

  /// Configure auth repository to simulate signed-in user
  void signInUser(User user) {
    when(mockAuthRepository.currentUser).thenReturn(user);
    when(mockAuthRepository.signInWithGoogle()).thenAnswer((_) async {
      when(mockAuthRepository.currentUser).thenReturn(user);
      authStateController.add(user);
      return user;
    });
    when(mockAuthRepository.signInWithApple()).thenAnswer((_) async {
      when(mockAuthRepository.currentUser).thenReturn(user);
      authStateController.add(user);
      return user;
    });
  }

  /// Configure auth repository to simulate signed-out state
  void signOutUser() {
    when(mockAuthRepository.currentUser).thenReturn(null);
    when(mockAuthRepository.signOut()).thenAnswer((_) async {
      when(mockAuthRepository.currentUser).thenReturn(null);
      authStateController.add(null);
    });
  }

  /// Add activities to the mock stream
  void setTripActivities(String tripId, List<Activity> activities) {
    when(mockActivityRepository.getTripActivities(tripId))
        .thenAnswer((_) => Stream.value(activities));
  }

  /// Add trips to the mock stream
  void setUserTrips(String userId, List<Trip> trips) {
    when(mockTripRepository.getUserTrips(userId))
        .thenAnswer((_) => Stream.value(trips));
  }

  /// Configure activity creation
  void mockCreateActivity(Activity activity) {
    when(mockActivityRepository.createActivity(any))
        .thenAnswer((_) async => activity);
  }

  /// Configure trip creation
  void mockCreateTrip(Trip trip) {
    when(mockTripRepository.createTrip(any)).thenAnswer((_) async => trip);
  }

  /// Configure activity update
  void mockUpdateActivity(Activity activity) {
    when(mockActivityRepository.updateActivity(any))
        .thenAnswer((_) async => activity);
  }

  /// Configure trip update
  void mockUpdateTrip(Trip trip) {
    when(mockTripRepository.updateTrip(any)).thenAnswer((_) async => trip);
  }

  /// Configure activity deletion
  void mockDeleteActivity() {
    when(mockActivityRepository.deleteActivity(any)).thenAnswer((_) async {});
  }

  /// Configure trip deletion
  void mockDeleteTrip() {
    when(mockTripRepository.deleteTrip(any)).thenAnswer((_) async {});
  }

  /// Configure get activity by ID
  void mockGetActivityById(String activityId, Activity? activity) {
    when(mockActivityRepository.getActivityById(activityId))
        .thenAnswer((_) async => activity);
  }

  /// Configure get trip by ID
  void mockGetTripById(String tripId, Trip? trip) {
    when(mockTripRepository.getTripById(tripId)).thenAnswer((_) async => trip);
  }

  /// Configure brainstorm idea operations
  void mockBrainstormOperations(Activity activity) {
    when(mockActivityRepository.addBrainstormIdea(any, any))
        .thenAnswer((_) async => activity);
    when(mockActivityRepository.removeBrainstormIdea(any, any))
        .thenAnswer((_) async => activity);
    when(mockActivityRepository.reorderBrainstormIdeas(any, any))
        .thenAnswer((_) async => activity);
  }

  /// Configure activity assignment operations
  void mockActivityAssignment(Activity activity) {
    when(mockActivityRepository.assignActivityToDay(any, any, any,
            timeSlot: anyNamed('timeSlot')))
        .thenAnswer((_) async => activity);
    when(mockActivityRepository.moveActivityToPool(any))
        .thenAnswer((_) async => activity);
    when(mockActivityRepository.reorderActivitiesInDay(any, any, any))
        .thenAnswer((_) async {});
  }

  /// Configure trip collaboration operations
  void mockTripCollaboration(List<User> collaborators) {
    when(mockTripRepository.getTripCollaborators(any))
        .thenAnswer((_) async => collaborators);
    when(mockTripRepository.addCollaborator(any, any)).thenAnswer((_) async {});
    when(mockTripRepository.removeCollaborator(any, any))
        .thenAnswer((_) async {});
  }

  /// Clean up resources
  void dispose() {
    authStateController.close();
    activitiesController.close();
    tripsController.close();
  }
}

/// Create sample test data
class TestData {
  static const testUser1 = User(
    id: 'test-user-1',
    email: 'test1@example.com',
    displayName: 'Test User 1',
    photoUrl: 'https://example.com/avatar1.jpg',
  );

  static const testUser2 = User(
    id: 'test-user-2',
    email: 'test2@example.com',
    displayName: 'Test User 2',
    photoUrl: 'https://example.com/avatar2.jpg',
  );

  static final testTrip = Trip(
    id: 'test-trip-1',
    name: 'Test Trip',
    durationDays: 5,
    ownerId: testUser1.id,
    collaboratorIds: [testUser2.id],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  static final testActivity = Activity(
    id: 'test-activity-1',
    tripId: testTrip.id,
    place: 'Test Place',
    activityType: 'sightseeing',
    price: '\$50',
    notes: 'Test notes',
    assignedDay: null,
    dayOrder: null,
    timeSlot: null,
    createdBy: testUser1.id,
    createdAt: DateTime.now(),
    brainstormIdeas: [],
  );

  static final testBrainstormIdea = BrainstormIdea(
    id: 'test-idea-1',
    description: 'Test brainstorm idea',
    createdBy: testUser1.id,
    createdAt: DateTime.now(),
  );
}
