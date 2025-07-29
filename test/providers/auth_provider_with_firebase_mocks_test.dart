import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_planner/providers/auth_provider.dart';
import 'package:trip_planner/models/user.dart';

import '../helpers/firebase_mocks.dart';

void main() {
  group('Auth Provider with Firebase Mocks', () {
    late FirebaseMocks firebaseMocks;
    late ProviderContainer container;

    setUp(() {
      firebaseMocks = FirebaseMocks();
      
      container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(firebaseMocks.mockAuthRepository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
      firebaseMocks.dispose();
    });

    test('should start with no authenticated user', () async {
      final authState = container.read(authNotifierProvider);
      
      // Wait for initial state
      await container.pump();
      
      expect(authState.value, isNull);
    });

    test('should handle Google sign in', () async {
      const testUser = TestData.testUser1;
      
      // Configure mock to simulate successful sign in
      firebaseMocks.signInUser(testUser);
      
      // Wait for initial state
      await container.pump();
      
      // Trigger sign in
      await container.read(authNotifierProvider.notifier).signInWithGoogle();
      
      // Wait for state update
      await container.pump();
      
      final authState = container.read(authNotifierProvider);
      expect(authState.value, equals(testUser));
    });

    test('should handle Apple sign in', () async {
      const testUser = TestData.testUser2;
      
      // Configure mock to simulate successful sign in
      firebaseMocks.signInUser(testUser);
      
      // Wait for initial state
      await container.pump();
      
      // Trigger sign in
      await container.read(authNotifierProvider.notifier).signInWithApple();
      
      // Wait for state update
      await container.pump();
      
      final authState = container.read(authNotifierProvider);
      expect(authState.value, equals(testUser));
    });

    test('should handle sign out', () async {
      const testUser = TestData.testUser1;
      
      // First sign in
      firebaseMocks.signInUser(testUser);
      await container.pump();
      await container.read(authNotifierProvider.notifier).signInWithGoogle();
      await container.pump();
      
      // Verify signed in
      var authState = container.read(authNotifierProvider);
      expect(authState.value, equals(testUser));
      
      // Configure mock for sign out
      firebaseMocks.signOutUser();
      
      // Trigger sign out
      await container.read(authNotifierProvider.notifier).signOut();
      await container.pump();
      
      // Verify signed out
      authState = container.read(authNotifierProvider);
      expect(authState.value, isNull);
    });

    test('should handle authentication state changes', () async {
      final authStates = <User?>[];
      
      // Listen to auth state changes
      container.listen(authNotifierProvider, (previous, next) {
        next.when(
          data: (user) => authStates.add(user),
          loading: () => {},
          error: (error, stack) => {},
        );
      });
      
      // Initial state
      await container.pump();
      
      // Sign in
      const testUser = TestData.testUser1;
      firebaseMocks.signInUser(testUser);
      await container.pump();
      
      // Sign out
      firebaseMocks.signOutUser();
      await container.pump();
      
      // Should have captured state changes
      expect(authStates, contains(null));
      expect(authStates, contains(testUser));
    });
  });
}

// Extension to help with async state updates
extension ProviderContainerExtension on ProviderContainer {
  Future<void> pump() async {
    await Future.delayed(Duration.zero);
  }
}