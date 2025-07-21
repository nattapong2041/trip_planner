import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_planner/providers/router_provider.dart';
import 'package:trip_planner/providers/auth_provider.dart';
import 'package:trip_planner/models/user.dart';
import 'package:trip_planner/repositories/mock_auth_repository.dart';

void main() {
  group('Router Navigation Tests', () {
    testWidgets('should redirect to auth when not authenticated', (tester) async {
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(MockAuthRepository()),
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
      expect(router.routerDelegate.currentConfiguration.uri.toString(), '/auth');
    });

    testWidgets('should navigate to trip detail with correct parameters', (tester) async {
      final mockAuthRepo = MockAuthRepository();
      // Sign in a mock user
      await mockAuthRepo.signInWithGoogle();
      
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
      
      // Navigate to trip detail
      router.goNamed('trip-detail', pathParameters: {'tripId': 'test-trip-123'});
      await tester.pumpAndSettle();
      
      expect(router.routerDelegate.currentConfiguration.uri.toString(), '/trips/test-trip-123');
    });

    testWidgets('should navigate to activity detail with correct parameters', (tester) async {
      final mockAuthRepo = MockAuthRepository();
      // Sign in a mock user
      await mockAuthRepo.signInWithGoogle();
      
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
      
      // Navigate to activity detail
      router.goNamed('activity-detail', pathParameters: {
        'tripId': 'test-trip-123',
        'activityId': 'test-activity-456'
      });
      await tester.pumpAndSettle();
      
      expect(router.routerDelegate.currentConfiguration.uri.toString(), 
             '/trips/test-trip-123/activities/test-activity-456');
    });

    testWidgets('should navigate to trip create screen', (tester) async {
      final mockAuthRepo = MockAuthRepository();
      // Sign in a mock user
      await mockAuthRepo.signInWithGoogle();
      
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
      
      // Navigate to trip create
      router.goNamed('trip-create');
      await tester.pumpAndSettle();
      
      expect(router.routerDelegate.currentConfiguration.uri.toString(), '/trips/create');
    });
  });
}