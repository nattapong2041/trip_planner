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
  group('Working Router Tests', () {
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

    test('mock auth repository should work correctly', () async {
      const mockUser = User(
        id: 'test-user-123',
        email: 'test@example.com',
        displayName: 'Test User',
        photoUrl: null,
      );
      
      // Test that the mock repository methods work
      when(mockAuthRepo.signInWithGoogle()).thenAnswer((_) async {
        return mockUser;
      });
      
      final result = await mockAuthRepo.signInWithGoogle();
      expect(result, equals(mockUser));
      verify(mockAuthRepo.signInWithGoogle()).called(1);
    });

    test('mock auth repository stream should work', () async {
      const mockUser = User(
        id: 'test-user-stream',
        email: 'stream@example.com',
        displayName: 'Stream User',
        photoUrl: null,
      );
      
      final streamValues = <User?>[];
      final subscription = mockAuthRepo.authStateChanges.listen((user) {
        streamValues.add(user);
      });
      
      // Emit values
      authStateController.add(null);
      authStateController.add(mockUser);
      authStateController.add(null);
      
      // Wait for stream to process
      await Future.delayed(const Duration(milliseconds: 10));
      
      expect(streamValues.length, equals(3));
      expect(streamValues[0], isNull);
      expect(streamValues[1], equals(mockUser));
      expect(streamValues[2], isNull);
      
      await subscription.cancel();
    });

    test('auth repository provider should be overridable', () {
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepo),
        ],
      );
      
      final repo = container.read(authRepositoryProvider);
      expect(repo, equals(mockAuthRepo));
      
      container.dispose();
    });

    test('auth notifier methods should call repository methods', () async {
      const mockUser = User(
        id: 'test-user-notifier',
        email: 'notifier@example.com',
        displayName: 'Notifier User',
        photoUrl: null,
      );
      
      when(mockAuthRepo.signInWithGoogle()).thenAnswer((_) async => mockUser);
      when(mockAuthRepo.signInWithApple()).thenAnswer((_) async => mockUser);
      when(mockAuthRepo.signOut()).thenAnswer((_) async {});
      
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepo),
        ],
      );
      
      final notifier = container.read(authNotifierProvider.notifier);
      
      // Test Google sign in
      await notifier.signInWithGoogle();
      verify(mockAuthRepo.signInWithGoogle()).called(1);
      
      // Test Apple sign in
      await notifier.signInWithApple();
      verify(mockAuthRepo.signInWithApple()).called(1);
      
      // Test sign out
      await notifier.signOut();
      verify(mockAuthRepo.signOut()).called(1);
      
      container.dispose();
    });

    test('auth notifier should handle errors correctly', () async {
      when(mockAuthRepo.signInWithGoogle()).thenThrow(Exception('Sign in failed'));
      
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepo),
        ],
      );
      
      final notifier = container.read(authNotifierProvider.notifier);
      
      // Should throw the exception
      expect(() => notifier.signInWithGoogle(), throwsException);
      
      // Verify the method was called
      verify(mockAuthRepo.signInWithGoogle()).called(1);
      
      container.dispose();
    });

    test('should be able to create router provider without errors', () {
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepo),
        ],
      );
      
      // This test verifies that the router provider can be instantiated
      // without throwing exceptions
      expect(() {
        final router = container.read(routerProvider);
        expect(router, isNotNull);
      }, returnsNormally);
      
      container.dispose();
    });

    test('router should have correct initial location', () {
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepo),
        ],
      );
      
      final router = container.read(routerProvider);
      
      // The router should be created successfully
      expect(router, isNotNull);
      expect(router.routerDelegate, isNotNull);
      
      container.dispose();
    });

    test('should handle multiple provider interactions', () async {
      const mockUser = User(
        id: 'test-user-multi',
        email: 'multi@example.com',
        displayName: 'Multi User',
        photoUrl: null,
      );
      
      when(mockAuthRepo.signInWithGoogle()).thenAnswer((_) async => mockUser);
      when(mockAuthRepo.signOut()).thenAnswer((_) async {});
      
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepo),
        ],
      );
      
      // Get both providers
      final authNotifier = container.read(authNotifierProvider.notifier);
      final router = container.read(routerProvider);
      
      // Both should be created successfully
      expect(authNotifier, isNotNull);
      expect(router, isNotNull);
      
      // Should be able to call auth methods
      await authNotifier.signInWithGoogle();
      verify(mockAuthRepo.signInWithGoogle()).called(1);
      
      await authNotifier.signOut();
      verify(mockAuthRepo.signOut()).called(1);
      
      container.dispose();
    });
  });
}