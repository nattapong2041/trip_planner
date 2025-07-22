import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:trip_planner/providers/router_provider.dart';
import 'package:trip_planner/providers/auth_provider.dart';
import 'package:trip_planner/repositories/auth_repository.dart';
import 'package:trip_planner/models/user.dart';

import 'router_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  group('Router Navigation Tests', () {
    late MockAuthRepository mockAuthRepo;
    late StreamController<User?> authStateController;

    setUp(() {
      mockAuthRepo = MockAuthRepository();
      authStateController = StreamController<User?>.broadcast();

      // Setup default mock behavior
      when(mockAuthRepo.authStateChanges)
          .thenAnswer((_) => authStateController.stream);
      when(mockAuthRepo.currentUser).thenReturn(null);
    });

    tearDown(() {
      authStateController.close();
    });

    testWidgets('should redirect to auth when not authenticated',
        (tester) async {
      // Setup: User is not authenticated
      authStateController.add(null);

      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepo),
        ],
      );

      final router = container.read(routerProvider);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should be on auth screen when not authenticated
      expect(
          router.routerDelegate.currentConfiguration.uri.toString(), '/auth');
    });

    testWidgets('should navigate to trip detail with correct parameters',
        (tester) async {
      // Setup: Mock user for authentication
      final mockUser = User(
        id: 'test-user-123',
        email: 'test@example.com',
        displayName: 'Test User',
        photoUrl: null,
      );

      // Setup mock to return authenticated user
      when(mockAuthRepo.signInWithGoogle()).thenAnswer((_) async {
        authStateController.add(mockUser);
        return mockUser;
      });
      when(mockAuthRepo.currentUser).thenReturn(mockUser);

      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepo),
        ],
      );

      // Sign in through the provider system
      await container.read(authNotifierProvider.notifier).signInWithGoogle();

      final router = container.read(routerProvider);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Navigate to trip detail
      router
          .goNamed('trip-detail', pathParameters: {'tripId': 'test-trip-123'});
      await tester.pumpAndSettle();

      expect(router.routerDelegate.currentConfiguration.uri.toString(),
          '/trips/test-trip-123');

      // Verify that signInWithGoogle was called
      verify(mockAuthRepo.signInWithGoogle()).called(1);
    });

    testWidgets('should navigate to activity detail with correct parameters',
        (tester) async {
      // Setup: Mock user for authentication
      final mockUser = User(
        id: 'test-user-456',
        email: 'test2@example.com',
        displayName: 'Test User 2',
        photoUrl: null,
      );

      // Setup mock to return authenticated user
      when(mockAuthRepo.signInWithGoogle()).thenAnswer((_) async {
        authStateController.add(mockUser);
        return mockUser;
      });
      when(mockAuthRepo.currentUser).thenReturn(mockUser);

      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepo),
        ],
      );

      // Sign in through the provider system
      await container.read(authNotifierProvider.notifier).signInWithGoogle();

      final router = container.read(routerProvider);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Navigate to activity detail
      router.goNamed('activity-detail', pathParameters: {
        'tripId': 'test-trip-123',
        'activityId': 'test-activity-456'
      });
      await tester.pumpAndSettle();

      expect(router.routerDelegate.currentConfiguration.uri.toString(),
          '/trips/test-trip-123/activities/test-activity-456');

      // Verify that signInWithGoogle was called
      verify(mockAuthRepo.signInWithGoogle()).called(1);
    });

    testWidgets('should navigate to trip create screen', (tester) async {
      // Setup: Mock user for authentication
      final mockUser = User(
        id: 'test-user-789',
        email: 'test3@example.com',
        displayName: 'Test User 3',
        photoUrl: null,
      );

      // Setup mock to return authenticated user
      when(mockAuthRepo.signInWithGoogle()).thenAnswer((_) async {
        authStateController.add(mockUser);
        return mockUser;
      });
      when(mockAuthRepo.currentUser).thenReturn(mockUser);

      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepo),
        ],
      );

      // Sign in through the provider system
      await container.read(authNotifierProvider.notifier).signInWithGoogle();

      final router = container.read(routerProvider);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Navigate to trip create
      router.goNamed('trip-create');
      await tester.pumpAndSettle();

      expect(router.routerDelegate.currentConfiguration.uri.toString(),
          '/trips/create');

      // Verify that signInWithGoogle was called
      verify(mockAuthRepo.signInWithGoogle()).called(1);
    });

    testWidgets('should handle sign out and redirect to auth', (tester) async {
      // Setup: Start with authenticated user
      final mockUser = User(
        id: 'test-user-signout',
        email: 'signout@example.com',
        displayName: 'Sign Out User',
        photoUrl: null,
      );

      when(mockAuthRepo.signInWithGoogle()).thenAnswer((_) async {
        authStateController.add(mockUser);
        return mockUser;
      });
      when(mockAuthRepo.signOut()).thenAnswer((_) async {
        authStateController.add(null);
      });
      when(mockAuthRepo.currentUser).thenReturn(mockUser);

      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepo),
        ],
      );

      // Sign in first
      await container.read(authNotifierProvider.notifier).signInWithGoogle();

      final router = container.read(routerProvider);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should be on trips screen when authenticated
      expect(
          router.routerDelegate.currentConfiguration.uri.toString(), '/trips');

      // Now sign out
      when(mockAuthRepo.currentUser).thenReturn(null);
      await container.read(authNotifierProvider.notifier).signOut();
      await tester.pumpAndSettle();

      // Should redirect to auth screen after sign out
      expect(
          router.routerDelegate.currentConfiguration.uri.toString(), '/auth');

      // Verify both methods were called
      verify(mockAuthRepo.signInWithGoogle()).called(1);
      verify(mockAuthRepo.signOut()).called(1);
    });
  });
}
