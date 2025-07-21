import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/user.dart';
import '../models/app_error.dart';
import '../repositories/auth_repository.dart';
import '../repositories/mock_auth_repository.dart';

part 'auth_provider.g.dart';

/// Provider for the AuthRepository instance
@riverpod
AuthRepository authRepository(Ref ref) {
  return MockAuthRepository();
}

/// Provider that streams authentication state changes
@riverpod
Stream<User?> authState(Ref ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
}

/// Notifier for managing authentication state and operations
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AsyncValue<User?> build() {
    // Watch auth state changes and return as AsyncValue
    final authState = ref.watch(authStateProvider);
    return authState.when(
      data: (user) => AsyncValue.data(user),
      error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
      loading: () => const AsyncValue.loading(),
    );
  }
  
  /// Sign in with Google authentication
  Future<void> signInWithGoogle() async {
    try {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.signInWithGoogle();
      // State will be updated automatically through authStateProvider
    } catch (error, stackTrace) {
      final appError = _handleAuthError(error);
      // Notify global error handler
      ref.read(errorNotifierProvider.notifier).showError(appError);
      rethrow;
    }
  }
  
  /// Sign in with Apple authentication
  Future<void> signInWithApple() async {
    try {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.signInWithApple();
      // State will be updated automatically through authStateProvider
    } catch (error, stackTrace) {
      final appError = _handleAuthError(error);
      // Notify global error handler
      ref.read(errorNotifierProvider.notifier).showError(appError);
      rethrow;
    }
  }
  
  /// Sign out the current user
  Future<void> signOut() async {
    try {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.signOut();
      // State will be updated automatically through authStateProvider
    } catch (error, stackTrace) {
      final appError = _handleAuthError(error);
      // Notify global error handler
      ref.read(errorNotifierProvider.notifier).showError(appError);
      rethrow;
    }
  }
  

  
  /// Helper method to convert exceptions to AppError
  AppError _handleAuthError(Object error) {
    if (error.toString().contains('network')) {
      return AppError.network('Network error during authentication. Please check your connection.');
    } else if (error.toString().contains('cancelled')) {
      return AppError.authentication('Authentication was cancelled.');
    } else {
      return AppError.authentication('Authentication failed. Please try again.');
    }
  }
}

/// Provider for global error handling
@riverpod
class ErrorNotifier extends _$ErrorNotifier {
  @override
  AppError? build() => null;
  
  /// Show an error globally
  void showError(AppError error) {
    state = error;
  }
  
  /// Clear the current error
  void clearError() {
    state = null;
  }
  
  /// Auto-clear error after a delay
  void showErrorWithAutoClear(AppError error, {Duration delay = const Duration(seconds: 5)}) {
    state = error;
    Future.delayed(delay, () {
      if (ref.mounted && state == error) {
        state = null;
      }
    });
  }
}