import 'package:flutter_test/flutter_test.dart';
import 'package:trip_planner/repositories/mock_auth_repository.dart';
import 'package:trip_planner/models/user.dart';

void main() {
  group('MockAuthRepository Tests', () {
    late MockAuthRepository repository;

    setUp(() {
      repository = MockAuthRepository();
    });

    tearDown(() {
      repository.dispose();
    });

    test('should initialize with no authenticated user', () async {
      expect(repository.currentUser, isNull);
      
      // Wait for initial auth state
      final authState = await repository.authStateChanges.first;
      expect(authState, isNull);
    });

    test('should provide mock users', () {
      final mockUsers = repository.mockUsers;
      expect(mockUsers, isNotEmpty);
      expect(mockUsers.length, greaterThanOrEqualTo(2));
      
      for (final user in mockUsers) {
        expect(user.id, isNotEmpty);
        expect(user.email, isNotEmpty);
        expect(user.displayName, isNotEmpty);
      }
    });

    test('should sign in with Google successfully', () async {
      final user = await repository.signInWithGoogle();
      
      expect(user, isNotNull);
      expect(user!.id, isNotEmpty);
      expect(user.email, isNotEmpty);
      expect(user.displayName, isNotEmpty);
      expect(repository.currentUser, equals(user));
    });

    test('should sign in with Apple successfully', () async {
      final user = await repository.signInWithApple();
      
      expect(user, isNotNull);
      expect(user!.id, isNotEmpty);
      expect(user.email, isNotEmpty);
      expect(user.displayName, isNotEmpty);
      expect(repository.currentUser, equals(user));
    });

    test('should emit auth state changes on sign in', () async {
      final authStateStream = repository.authStateChanges;
      final authStates = <User?>[];
      
      final subscription = authStateStream.listen(authStates.add);
      
      // Wait for initial null state
      await Future.delayed(const Duration(milliseconds: 10));
      
      // Sign in
      await repository.signInWithGoogle();
      
      // Wait for auth state change
      await Future.delayed(const Duration(milliseconds: 10));
      
      expect(authStates, hasLength(2));
      expect(authStates[0], isNull); // Initial state
      expect(authStates[1], isNotNull); // After sign in
      
      await subscription.cancel();
    });

    test('should sign out successfully', () async {
      // First sign in
      await repository.signInWithGoogle();
      expect(repository.currentUser, isNotNull);
      
      // Then sign out
      await repository.signOut();
      expect(repository.currentUser, isNull);
    });

    test('should emit auth state changes on sign out', () async {
      final authStateStream = repository.authStateChanges;
      final authStates = <User?>[];
      
      final subscription = authStateStream.listen(authStates.add);
      
      // Wait for initial state
      await Future.delayed(const Duration(milliseconds: 10));
      
      // Sign in
      await repository.signInWithGoogle();
      await Future.delayed(const Duration(milliseconds: 10));
      
      // Sign out
      await repository.signOut();
      await Future.delayed(const Duration(milliseconds: 10));
      
      expect(authStates, hasLength(3));
      expect(authStates[0], isNull); // Initial state
      expect(authStates[1], isNotNull); // After sign in
      expect(authStates[2], isNull); // After sign out
      
      await subscription.cancel();
    });

    test('should sign in with specific user', () async {
      final mockUsers = repository.mockUsers;
      final targetUser = mockUsers.first;
      
      final user = await repository.signInWithUser(targetUser.id);
      
      expect(user, equals(targetUser));
      expect(repository.currentUser, equals(targetUser));
    });

    test('should fallback to first user for invalid user ID', () async {
      const invalidUserId = 'invalid_user_id';
      final mockUsers = repository.mockUsers;
      
      final user = await repository.signInWithUser(invalidUserId);
      
      expect(user, equals(mockUsers.first));
      expect(repository.currentUser, equals(mockUsers.first));
    });

    test('should handle multiple sign ins', () async {
      // Sign in with Google
      final googleUser = await repository.signInWithGoogle();
      expect(repository.currentUser, equals(googleUser));
      
      // Sign in with Apple (should replace current user)
      final appleUser = await repository.signInWithApple();
      expect(repository.currentUser, equals(appleUser));
      expect(repository.currentUser, isNot(equals(googleUser)));
    });

    test('should maintain auth state across multiple listeners', () async {
      final stream1 = repository.authStateChanges;
      final stream2 = repository.authStateChanges;
      
      final states1 = <User?>[];
      final states2 = <User?>[];
      
      final sub1 = stream1.listen(states1.add);
      final sub2 = stream2.listen(states2.add);
      
      // Wait for initial states
      await Future.delayed(const Duration(milliseconds: 10));
      
      // Sign in
      await repository.signInWithGoogle();
      await Future.delayed(const Duration(milliseconds: 10));
      
      // Both listeners should receive the same states
      expect(states1.length, equals(states2.length));
      expect(states1.last, equals(states2.last));
      expect(states1.last, isNotNull);
      
      await sub1.cancel();
      await sub2.cancel();
    });

    test('should handle rapid sign in/out operations', () async {
      final authStates = <User?>[];
      final subscription = repository.authStateChanges.listen(authStates.add);
      
      // Wait for initial state
      await Future.delayed(const Duration(milliseconds: 10));
      
      // Rapid operations
      await repository.signInWithGoogle();
      await repository.signOut();
      await repository.signInWithApple();
      await repository.signOut();
      
      // Wait for all state changes
      await Future.delayed(const Duration(milliseconds: 50));
      
      expect(authStates.length, greaterThanOrEqualTo(5));
      expect(authStates.first, isNull); // Initial
      expect(authStates.last, isNull); // Final after sign out
      
      await subscription.cancel();
    });

    test('should dispose resources properly', () {
      // This test ensures dispose doesn't throw
      expect(() => repository.dispose(), returnsNormally);
    });
  });
}