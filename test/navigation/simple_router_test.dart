import 'dart:async';
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
  group('Router Logic Tests', () {
    late MockAuthRepository mockAuthRepo;
    late StreamController<User?> authStateController;

    setUp(() {
      mockAuthRepo = MockAuthRepository();
      authStateController = StreamController<User?>.broadcast();
      
      // Setup default mock behavior
      when(mockAuthRepo.authStateChanges).thenAnswer((_) => authStateController.stream);
      when(mockAuthRepo.currentUser).thenReturn(null);
    });

    tearDown(() {
      authStateController.close();
    });

    test('router should redirect to auth when not authenticated', () async {
      // Setup: User is not authenticated
      authStateController.add(null);
      
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepo),
        ],
      );
      
      final router = container.read(routerProvider);
      
      // Test redirect logic
      final redirectResult = router.routerDelegate.currentConfiguration.uri.toString();
      
      // Should redirect to auth when accessing protected route
      expect(redirectResult.contains('/auth') || redirectResult == '/auth', isTrue);
      
      container.dispose();
    });

    test('should allow access to trips when authenticated', () async {
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
      
      // Wait for auth state to propagate
      await Future.delayed(Duration.zero);
      
      final router = container.read(routerProvider);
      
      // Navigate to trips
      router.go('/trips');
      
      // Should be able to access trips when authenticated
      expect(router.routerDelegate.currentConfiguration.uri.toString(), '/trips');
      
      // Verify that signInWithGoogle was called
      verify(mockAuthRepo.signInWithGoogle()).called(1);
      
      container.dispose();
    });

    test('should handle route parameters correctly', () async {
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
      
      // Wait for auth state to propagate
      await Future.delayed(Duration.zero);
      
      final router = container.read(routerProvider);
      
      // Test different route patterns
      router.go('/trips/test-trip-123');
      expect(router.routerDelegate.currentConfiguration.uri.toString(), '/trips/test-trip-123');
      
      router.go('/trips/test-trip-123/activities/test-activity-456');
      expect(router.routerDelegate.currentConfiguration.uri.toString(), 
             '/trips/test-trip-123/activities/test-activity-456');
      
      router.go('/trips/create');
      expect(router.routerDelegate.currentConfiguration.uri.toString(), '/trips/create');
      
      // Verify that signInWithGoogle was called
      verify(mockAuthRepo.signInWithGoogle()).called(1);
      
      container.dispose();
    });

    test('should redirect to auth after sign out', () async {
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
      await Future.delayed(Duration.zero);
      
      final router = container.read(routerProvider);
      
      // Navigate to trips
      router.go('/trips');
      expect(router.routerDelegate.currentConfiguration.uri.toString(), '/trips');
      
      // Now sign out
      when(mockAuthRepo.currentUser).thenReturn(null);
      await container.read(authNotifierProvider.notifier).signOut();
      await Future.delayed(Duration.zero);
      
      // Should redirect to auth screen after sign out
      // Note: The redirect might not happen immediately in unit tests,
      // but the router should have the redirect logic in place
      final currentRoute = router.routerDelegate.currentConfiguration.uri.toString();
      expect(currentRoute == '/auth' || currentRoute.contains('auth'), isTrue);
      
      // Verify both methods were called
      verify(mockAuthRepo.signInWithGoogle()).called(1);
      verify(mockAuthRepo.signOut()).called(1);
      
      container.dispose();
    });

    test('should handle named routes correctly', () async {
      // Setup: Mock user for authentication
      final mockUser = User(
        id: 'test-user-named',
        email: 'named@example.com',
        displayName: 'Named Route User',
        photoUrl: null,
      );
      
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
      await Future.delayed(Duration.zero);
      
      final router = container.read(routerProvider);
      
      // Test named routes
      router.goNamed('trips');
      expect(router.routerDelegate.currentConfiguration.uri.toString(), '/trips');
      
      router.goNamed('trip-detail', pathParameters: {'tripId': 'test-trip-123'});
      expect(router.routerDelegate.currentConfiguration.uri.toString(), '/trips/test-trip-123');
      
      router.goNamed('activity-detail', pathParameters: {
        'tripId': 'test-trip-123',
        'activityId': 'test-activity-456'
      });
      expect(router.routerDelegate.currentConfiguration.uri.toString(), 
             '/trips/test-trip-123/activities/test-activity-456');
      
      router.goNamed('trip-create');
      expect(router.routerDelegate.currentConfiguration.uri.toString(), '/trips/create');
      
      router.goNamed('activity-create', pathParameters: {'tripId': 'test-trip-123'});
      expect(router.routerDelegate.currentConfiguration.uri.toString(), 
             '/trips/test-trip-123/activities/create');
      
      // Verify that signInWithGoogle was called
      verify(mockAuthRepo.signInWithGoogle()).called(1);
      
      container.dispose();
    });
  });
}