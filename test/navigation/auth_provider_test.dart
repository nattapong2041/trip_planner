// import 'dart:async';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:mockito/mockito.dart';
// import 'package:mockito/annotations.dart';
// import 'package:trip_planner/providers/auth_provider.dart';
// import 'package:trip_planner/repositories/auth_repository.dart';
// import 'package:trip_planner/models/user.dart';

// import 'router_test.mocks.dart';

// @GenerateMocks([AuthRepository])
// void main() {
//   group('Auth Provider Tests', () {
//     late MockAuthRepository mockAuthRepo;
//     late StreamController<User?> authStateController;

//     setUp(() {
//       mockAuthRepo = MockAuthRepository();
//       authStateController = StreamController<User?>.broadcast();
      
//       // Setup default mock behavior
//       when(mockAuthRepo.authStateChanges).thenAnswer((_) => authStateController.stream);
//       when(mockAuthRepo.currentUser).thenReturn(null);
//     });

//     tearDown(() {
//       authStateController.close();
//     });

//     test('auth repository provider should return mock repository', () {
//       final container = ProviderContainer(
//         overrides: [
//           authRepositoryProvider.overrideWithValue(mockAuthRepo),
//         ],
//       );
      
//       final repo = container.read(authRepositoryProvider);
//       expect(repo, equals(mockAuthRepo));
      
//       container.dispose();
//     });

//     test('auth state provider should stream user changes', () async {
//       final mockUser = User(
//         id: 'test-user-123',
//         email: 'test@example.com',
//         displayName: 'Test User',
//         photoUrl: null,
//       );
      
//       final container = ProviderContainer(
//         overrides: [
//           authRepositoryProvider.overrideWithValue(mockAuthRepo),
//         ],
//       );
      
//       // Start listening to auth state
//       final authStateListener = container.listen(authStateProvider, (previous, next) {});
      
//       // Initially emit null
//       authStateController.add(null);
//       await container.pump();
      
//       var authState = container.read(authStateProvider);
//       expect(authState.value, isNull);
      
//       // Emit a user
//       authStateController.add(mockUser);
//       await container.pump();
      
//       authState = container.read(authStateProvider);
//       expect(authState.value, equals(mockUser));
      
//       // Emit null again (sign out)
//       authStateController.add(null);
//       await container.pump();
      
//       authState = container.read(authStateProvider);
//       expect(authState.value, isNull);
      
//       container.dispose();
//     });

//     test('auth notifier should handle sign in with Google', () async {
//       final mockUser = User(
//         id: 'test-user-google',
//         email: 'google@example.com',
//         displayName: 'Google User',
//         photoUrl: null,
//       );
      
//       when(mockAuthRepo.signInWithGoogle()).thenAnswer((_) async {
//         // Simulate the repository updating its stream
//         authStateController.add(mockUser);
//         return mockUser;
//       });
      
//       final container = ProviderContainer(
//         overrides: [
//           authRepositoryProvider.overrideWithValue(mockAuthRepo),
//         ],
//       );
      
//       // Start with null state
//       authStateController.add(null);
//       await container.pump();
      
//       // Call sign in
//       await container.read(authNotifierProvider.notifier).signInWithGoogle();
//       await container.pump();
      
//       // Verify the method was called
//       verify(mockAuthRepo.signInWithGoogle()).called(1);
      
//       // Check that the auth notifier was updated
//       final authNotifier = container.read(authNotifierProvider);
//       expect(authNotifier.value, equals(mockUser));
      
//       container.dispose();
//     });

//     test('auth notifier should handle sign in with Apple', () async {
//       final mockUser = User(
//         id: 'test-user-apple',
//         email: 'apple@example.com',
//         displayName: 'Apple User',
//         photoUrl: null,
//       );
      
//       when(mockAuthRepo.signInWithApple()).thenAnswer((_) async {
//         // Simulate the repository updating its stream
//         authStateController.add(mockUser);
//         return mockUser;
//       });
      
//       final container = ProviderContainer(
//         overrides: [
//           authRepositoryProvider.overrideWithValue(mockAuthRepo),
//         ],
//       );
      
//       // Start with null state
//       authStateController.add(null);
//       await container.pump();
      
//       // Call sign in
//       await container.read(authNotifierProvider.notifier).signInWithApple();
//       await container.pump();
      
//       // Verify the method was called
//       verify(mockAuthRepo.signInWithApple()).called(1);
      
//       // Check that the auth notifier was updated
//       final authNotifier = container.read(authNotifierProvider);
//       expect(authNotifier.value, equals(mockUser));
      
//       container.dispose();
//     });

//     test('auth notifier should handle sign out', () async {
//       final mockUser = User(
//         id: 'test-user-signout',
//         email: 'signout@example.com',
//         displayName: 'Sign Out User',
//         photoUrl: null,
//       );
      
//       when(mockAuthRepo.signOut()).thenAnswer((_) async {
//         // Simulate the repository updating its stream
//         authStateController.add(null);
//       });
      
//       final container = ProviderContainer(
//         overrides: [
//           authRepositoryProvider.overrideWithValue(mockAuthRepo),
//         ],
//       );
      
//       // Start with authenticated user
//       authStateController.add(mockUser);
//       await container.pump();
      
//       var authState = container.read(authStateProvider);
//       expect(authState.value, equals(mockUser));
      
//       // Call sign out
//       await container.read(authNotifierProvider.notifier).signOut();
//       await container.pump();
      
//       // Verify the method was called
//       verify(mockAuthRepo.signOut()).called(1);
      
//       // Check that the auth notifier was updated to null
//       final authNotifier = container.read(authNotifierProvider);
//       expect(authNotifier.value, isNull);
      
//       container.dispose();
//     });

//     test('auth notifier should handle authentication errors', () async {
//       when(mockAuthRepo.signInWithGoogle()).thenThrow(Exception('Authentication failed'));
      
//       final container = ProviderContainer(
//         overrides: [
//           authRepositoryProvider.overrideWithValue(mockAuthRepo),
//         ],
//       );
      
//       // Start with null state
//       authStateController.add(null);
//       await container.pump();
      
//       // Call sign in and expect it to throw
//       expect(
//         () => container.read(authNotifierProvider.notifier).signInWithGoogle(),
//         throwsException,
//       );
      
//       // Verify the method was called
//       verify(mockAuthRepo.signInWithGoogle()).called(1);
      
//       container.dispose();
//     });

//     test('should handle multiple authentication state changes', () async {
//       final user1 = User(
//         id: 'user-1',
//         email: 'user1@example.com',
//         displayName: 'User 1',
//         photoUrl: null,
//       );
      
//       final user2 = User(
//         id: 'user-2',
//         email: 'user2@example.com',
//         displayName: 'User 2',
//         photoUrl: null,
//       );
      
//       final container = ProviderContainer(
//         overrides: [
//           authRepositoryProvider.overrideWithValue(mockAuthRepo),
//         ],
//       );
      
//       // Track state changes
//       final stateChanges = <User?>[];
//       container.listen(authStateProvider, (previous, next) {
//         next.when(
//           data: (user) => stateChanges.add(user),
//           loading: () => {},
//           error: (error, stack) => {},
//         );
//       });
      
//       // Emit sequence of state changes
//       authStateController.add(null);
//       await container.pump();
      
//       authStateController.add(user1);
//       await container.pump();
      
//       authStateController.add(user2);
//       await container.pump();
      
//       authStateController.add(null);
//       await container.pump();
      
//       // Should have captured all state changes
//       expect(stateChanges.length, greaterThanOrEqualTo(3));
//       expect(stateChanges, contains(null));
//       expect(stateChanges, contains(user1));
//       expect(stateChanges, contains(user2));
      
//       container.dispose();
//     });
//   });
// }

// extension ProviderContainerExtension on ProviderContainer {
//   Future<void> pump() async {
//     await Future.delayed(Duration.zero);
//   }
// }