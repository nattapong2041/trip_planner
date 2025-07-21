import '../models/user.dart';

/// Abstract repository interface for user authentication operations
abstract class AuthRepository {
  /// Stream of authentication state changes
  /// Returns the current user when authenticated, null when not
  Stream<User?> get authStateChanges;
  
  /// Sign in with Google authentication
  /// Returns the authenticated user or null if sign-in fails
  Future<User?> signInWithGoogle();
  
  /// Sign in with Apple authentication
  /// Returns the authenticated user or null if sign-in fails
  Future<User?> signInWithApple();
  
  /// Sign out the current user
  Future<void> signOut();
  
  /// Get the currently authenticated user
  /// Returns null if no user is authenticated
  User? get currentUser;
}