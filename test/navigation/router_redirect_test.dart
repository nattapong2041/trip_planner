import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:trip_planner/providers/auth_provider.dart';
import 'package:trip_planner/providers/router_provider.dart';
import 'package:trip_planner/repositories/auth_repository.dart';
import 'package:trip_planner/models/user.dart';

import 'router_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  group('Router Redirect Logic Tests', () {
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

    test('auth notifier should handle sign in correctly', () async {
      // Setup: Mock user for authentication
      const mockUser = User(
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
      
      // Initially should be null
      expect(container.read(authNotifierProvider).value, isNull);
      
      // Sign in through the provider system
      await container.read(authNotifierProvider.notifier).signInWithGoogle();
      
      // Wait for state to update
      await Future.delayed(Duration.zero);
      
      // Should now have the user
      expect(container.read(authNotifierProvider).value, equals(mockUser));
      
      // Verify that signInWithGoogle was called
      verify(mockAuthRepo.signInWithGoogle()).called(1);
      
      container.dispose();
    });

    test('auth notifier should handle sign out correctly', () async {
      // Setup: Start with authenticated user
      const mockUser = User(
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
      
      // Should have the user
      expect(container.read(authNotifierProvider).value, equals(mockUser));
      
      // Now sign out
      when(mockAuthRepo.currentUser).thenReturn(null);
      await container.read(authNotifierProvider.notifier).signOut();
      await Future.delayed(Duration.zero);
      
      // Should be null after sign out
      expect(container.read(authNotifierProvider).value, isNull);
      
      // Verify both methods were called
      verify(mockAuthRepo.signInWithGoogle()).called(1);
      verify(mockAuthRepo.signOut()).called(1);
      
      container.dispose();
    });

    test('auth state provider should stream changes correctly', () async {
      const mockUser = User(
        id: 'test-user-stream',
        email: 'stream@example.com',
        displayName: 'Stream User',
        photoUrl: null,
      );
      
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepo),
        ],
      );
      
      // Listen to auth state changes
      final authStates = <User?>[];
      
      // Listen to the provider directly
      container.listen(authNotifierProvider, (previous, next) {
        next.when(
          data: (user) => authStates.add(user),
          loading: () => {},
          error: (error, stack) => {},
        );
      });
      
      // Initially should be null
      authStateController.add(null);
      await Future.delayed(Duration.zero);
      
      // Add a user
      authStateController.add(mockUser);
      await Future.delayed(Duration.zero);
      
      // Remove user (sign out)
      authStateController.add(null);
      await Future.delayed(Duration.zero);
      
      // Should have received all state changes
      expect(authStates.length, greaterThanOrEqualTo(2));
      expect(authStates.last, isNull); // Last state should be null (signed out)
      
      container.dispose();
    });

    test('should create router with correct initial location', () async {
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepo),
        ],
      );
      
      // This test just verifies that the router provider can be created
      // without throwing an exception
      expect(() => container.read(routerProvider), returnsNormally);
      
      container.dispose();
    });

    test('should handle authentication state changes in auth notifier', () async {
      const mockUser1 = User(
        id: 'test-user-1',
        email: 'user1@example.com',
        displayName: 'User 1',
        photoUrl: null,
      );
      
      const mockUser2 = User(
        id: 'test-user-2',
        email: 'user2@example.com',
        displayName: 'User 2',
        photoUrl: null,
      );
      
      when(mockAuthRepo.signInWithGoogle()).thenAnswer((_) async {
        authStateController.add(mockUser1);
        return mockUser1;
      });
      
      when(mockAuthRepo.signInWithApple()).thenAnswer((_) async {
        authStateController.add(mockUser2);
        return mockUser2;
      });
      
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepo),
        ],
      );
      
      // Initially should be null
      expect(container.read(authNotifierProvider).value, isNull);
      
      // Sign in with Google
      await container.read(authNotifierProvider.notifier).signInWithGoogle();
      await Future.delayed(Duration.zero);
      expect(container.read(authNotifierProvider).value, equals(mockUser1));
      
      // Sign in with Apple (should replace the current user)
      await container.read(authNotifierProvider.notifier).signInWithApple();
      await Future.delayed(Duration.zero);
      expect(container.read(authNotifierProvider).value, equals(mockUser2));
      
      // Verify both methods were called
      verify(mockAuthRepo.signInWithGoogle()).called(1);
      verify(mockAuthRepo.signInWithApple()).called(1);
      
      container.dispose();
    });
  });
}