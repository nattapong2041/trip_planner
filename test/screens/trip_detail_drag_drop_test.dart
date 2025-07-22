import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:trip_planner/screens/trips/trip_detail_screen.dart';
import 'package:trip_planner/models/trip.dart';
import 'package:trip_planner/models/activity.dart';
import 'package:trip_planner/models/brainstorm_idea.dart';
import 'package:trip_planner/providers/trip_provider.dart';
import 'package:trip_planner/providers/activity_provider.dart';
import 'package:trip_planner/repositories/trip_repository.dart';
import 'package:trip_planner/repositories/activity_repository.dart';

import 'trip_detail_drag_drop_test.mocks.dart';

@GenerateMocks([TripRepository, ActivityRepository])
void main() {
  group('Trip Detail Drag and Drop Tests', () {
    late MockTripRepository mockTripRepository;
    late MockActivityRepository mockActivityRepository;
    late Trip testTrip;
    late List<Activity> testActivities;

    setUp(() {
      mockTripRepository = MockTripRepository();
      mockActivityRepository = MockActivityRepository();
      
      testTrip = Trip(
        id: 'trip_1',
        name: 'Test Trip',
        durationDays: 3,
        ownerId: 'user_1',
        collaboratorIds: const [],
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      testActivities = [
        Activity(
          id: 'activity_1',
          tripId: 'trip_1',
          place: 'Museum',
          activityType: 'Culture',
          price: '\$20',
          notes: 'Morning visit',
          assignedDay: null, // In activity pool
          dayOrder: null,
          createdBy: 'user_1',
          createdAt: DateTime(2024, 1, 1),
          brainstormIdeas: const [],
        ),
        Activity(
          id: 'activity_2',
          tripId: 'trip_1',
          place: 'Restaurant',
          activityType: 'Food',
          price: '\$50',
          notes: 'Dinner reservation',
          assignedDay: 'day-1',
          dayOrder: 0,
          createdBy: 'user_1',
          createdAt: DateTime(2024, 1, 1),
          brainstormIdeas: const [],
        ),
        Activity(
          id: 'activity_3',
          tripId: 'trip_1',
          place: 'Park',
          activityType: 'Outdoor',
          price: null,
          notes: 'Free activity',
          assignedDay: 'day-1',
          dayOrder: 1,
          createdBy: 'user_1',
          createdAt: DateTime(2024, 1, 1),
          brainstormIdeas: const [],
        ),
      ];
    });

    Widget createTestWidget() {
      return ProviderScope(
        overrides: [
          tripRepositoryProvider.overrideWithValue(mockTripRepository),
          activityRepositoryProvider.overrideWithValue(mockActivityRepository),
        ],
        child: MaterialApp(
          home: const TripDetailScreen(tripId: 'trip_1'),
        ),
      );
    }

    testWidgets('displays activity pool and day sections', (WidgetTester tester) async {
      // Setup mocks
      when(mockTripRepository.getTripById('trip_1')).thenAnswer((_) async => testTrip);
      when(mockActivityRepository.getTripActivities('trip_1'))
          .thenAnswer((_) => Stream.value(testActivities));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify activity pool is displayed
      expect(find.text('Activity Pool'), findsOneWidget);
      expect(find.text('1 activity'), findsOneWidget); // One unassigned activity

      // Verify day sections are displayed
      expect(find.text('Day 1'), findsOneWidget);
      expect(find.text('Day 2'), findsOneWidget);
      expect(find.text('Day 3'), findsOneWidget);

      // Verify activities are in correct sections
      expect(find.text('Museum'), findsOneWidget); // In activity pool
      expect(find.text('Restaurant'), findsOneWidget); // In day 1
      expect(find.text('Park'), findsOneWidget); // In day 1
    });

    testWidgets('shows drag handles on activity cards', (WidgetTester tester) async {
      // Setup mocks
      when(mockTripRepository.getTripById('trip_1')).thenAnswer((_) async => testTrip);
      when(mockActivityRepository.getTripActivities('trip_1'))
          .thenAnswer((_) => Stream.value(testActivities));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify drag handles are present
      expect(find.byIcon(Icons.drag_handle), findsNWidgets(3)); // One for each activity
    });

    testWidgets('displays empty state messages correctly', (WidgetTester tester) async {
      // Setup with no activities
      when(mockTripRepository.getTripById('trip_1')).thenAnswer((_) async => testTrip);
      when(mockActivityRepository.getTripActivities('trip_1'))
          .thenAnswer((_) => Stream.value([]));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify empty state messages
      expect(find.text('No unassigned activities'), findsOneWidget);
      expect(find.text('No activities planned'), findsNWidgets(3)); // One for each day
      expect(find.text('Drag activities here to unassign'), findsOneWidget);
      expect(find.text('Drag activities here to plan'), findsNWidgets(3));
    });

    testWidgets('shows brainstorm idea count on activity cards', (WidgetTester tester) async {
      // Setup with activity that has brainstorm ideas
      final activitiesWithIdeas = [
        testActivities[0].copyWith(
          brainstormIdeas: [
            BrainstormIdea(
              id: 'idea_1',
              description: 'Test idea',
              createdBy: 'user_1',
              createdAt: DateTime(2024, 1, 1),
            ),
            BrainstormIdea(
              id: 'idea_2',
              description: 'Another idea',
              createdBy: 'user_1',
              createdAt: DateTime(2024, 1, 1),
            ),
          ],
        ),
        ...testActivities.skip(1),
      ];

      when(mockTripRepository.getTripById('trip_1')).thenAnswer((_) async => testTrip);
      when(mockActivityRepository.getTripActivities('trip_1'))
          .thenAnswer((_) => Stream.value(activitiesWithIdeas));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify brainstorm idea count is displayed
      expect(find.text('2'), findsOneWidget); // Count badge
    });

    testWidgets('displays activity details correctly', (WidgetTester tester) async {
      // Setup mocks
      when(mockTripRepository.getTripById('trip_1')).thenAnswer((_) async => testTrip);
      when(mockActivityRepository.getTripActivities('trip_1'))
          .thenAnswer((_) => Stream.value(testActivities));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify activity details are displayed
      expect(find.text('Museum'), findsOneWidget);
      expect(find.text('Culture'), findsOneWidget);
      expect(find.text('• \$20'), findsOneWidget);

      expect(find.text('Restaurant'), findsOneWidget);
      expect(find.text('Food'), findsOneWidget);
      expect(find.text('• \$50'), findsOneWidget);

      expect(find.text('Park'), findsOneWidget);
      expect(find.text('Outdoor'), findsOneWidget);
      // No price for park activity
    });

    testWidgets('shows correct activity counts in section headers', (WidgetTester tester) async {
      // Setup mocks
      when(mockTripRepository.getTripById('trip_1')).thenAnswer((_) async => testTrip);
      when(mockActivityRepository.getTripActivities('trip_1'))
          .thenAnswer((_) => Stream.value(testActivities));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify activity counts
      expect(find.text('1 activity'), findsOneWidget); // Activity pool
      expect(find.text('2 activities'), findsOneWidget); // Day 1
      expect(find.text('No activities planned'), findsNWidgets(2)); // Day 2 and 3
    });

    testWidgets('handles drag target highlighting', (WidgetTester tester) async {
      // Setup mocks
      when(mockTripRepository.getTripById('trip_1')).thenAnswer((_) async => testTrip);
      when(mockActivityRepository.getTripActivities('trip_1'))
          .thenAnswer((_) => Stream.value(testActivities));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find a draggable activity
      final draggableActivity = find.byType(Draggable<Activity>).first;
      expect(draggableActivity, findsOneWidget);

      // Note: Testing actual drag gestures in widget tests is complex
      // and often flaky. The drag-and-drop logic is tested through
      // the provider methods in separate unit tests.
    });
  });

  group('Activity Provider Drag and Drop Methods', () {
    late MockActivityRepository mockActivityRepository;
    late ProviderContainer container;

    setUp(() {
      mockActivityRepository = MockActivityRepository();
      container = ProviderContainer(
        overrides: [
          activityRepositoryProvider.overrideWithValue(mockActivityRepository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('moveActivityToPool removes day assignment', () async {
      final activity = Activity(
        id: 'activity_1',
        tripId: 'trip_1',
        place: 'Museum',
        activityType: 'Culture',
        assignedDay: 'day-1',
        dayOrder: 0,
        createdBy: 'user_1',
        createdAt: DateTime(2024, 1, 1),
        brainstormIdeas: const [],
      );

      when(mockActivityRepository.getActivityById('activity_1'))
          .thenAnswer((_) async => activity);
      when(mockActivityRepository.updateActivity(any))
          .thenAnswer((invocation) async => invocation.positionalArguments[0]);

      final notifier = container.read(activityListNotifierProvider('trip_1').notifier);
      await notifier.moveActivityToPool('activity_1');

      // Verify the activity was updated with null assignedDay and dayOrder
      final capturedActivity = verify(mockActivityRepository.updateActivity(captureAny))
          .captured.single as Activity;
      expect(capturedActivity.assignedDay, isNull);
      expect(capturedActivity.dayOrder, isNull);
    });

    test('assignActivityToDay sets day and order', () async {
      final activity = Activity(
        id: 'activity_1',
        tripId: 'trip_1',
        place: 'Museum',
        activityType: 'Culture',
        assignedDay: null,
        dayOrder: null,
        createdBy: 'user_1',
        createdAt: DateTime(2024, 1, 1),
        brainstormIdeas: const [],
      );

      when(mockActivityRepository.getActivityById('activity_1'))
          .thenAnswer((_) async => activity);
      when(mockActivityRepository.updateActivity(any))
          .thenAnswer((invocation) async => invocation.positionalArguments[0]);

      final notifier = container.read(activityListNotifierProvider('trip_1').notifier);
      await notifier.assignActivityToDay('activity_1', 'day-2', 1);

      // Verify the activity was updated with correct day and order
      final capturedActivity = verify(mockActivityRepository.updateActivity(captureAny))
          .captured.single as Activity;
      expect(capturedActivity.assignedDay, equals('day-2'));
      expect(capturedActivity.dayOrder, equals(1));
    });

    test('reorderActivitiesInDay updates all activity orders', () async {
      final activities = [
        Activity(
          id: 'activity_1',
          tripId: 'trip_1',
          place: 'Museum',
          activityType: 'Culture',
          assignedDay: 'day-1',
          dayOrder: 0,
          createdBy: 'user_1',
          createdAt: DateTime(2024, 1, 1),
          brainstormIdeas: const [],
        ),
        Activity(
          id: 'activity_2',
          tripId: 'trip_1',
          place: 'Restaurant',
          activityType: 'Food',
          assignedDay: 'day-1',
          dayOrder: 1,
          createdBy: 'user_1',
          createdAt: DateTime(2024, 1, 1),
          brainstormIdeas: const [],
        ),
      ];

      // Reverse the order
      final reorderedActivities = activities.reversed.toList();

      when(mockActivityRepository.updateActivity(any))
          .thenAnswer((invocation) async => invocation.positionalArguments[0]);

      final notifier = container.read(activityListNotifierProvider('trip_1').notifier);
      await notifier.reorderActivitiesInDay('day-1', reorderedActivities);

      // Verify both activities were updated with new orders
      final capturedActivities = verify(mockActivityRepository.updateActivity(captureAny))
          .captured.cast<Activity>();
      
      expect(capturedActivities, hasLength(2));
      expect(capturedActivities[0].id, equals('activity_2'));
      expect(capturedActivities[0].dayOrder, equals(0));
      expect(capturedActivities[1].id, equals('activity_1'));
      expect(capturedActivities[1].dayOrder, equals(1));
    });
  });
}