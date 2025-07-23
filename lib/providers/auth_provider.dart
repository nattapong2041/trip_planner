import 'dart:async';
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

/// Notifier for managing authentication state and operations
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Stream<User?> build() {
    return ref.watch(authRepositoryProvider).authStateChanges;
  }
  
  /// Sign in with Google authentication
  Future<void> signInWithGoogle() async {
    try {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.signInWithGoogle();
      // State will be updated automatically through the stream
    } catch (error) {
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
      // State will be updated automatically through the stream
    } catch (error) {
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
      // State will be updated automatically through the stream
    } catch (error) {
      final appError = _handleAuthError(error);
      // Notify global error handler
      ref.read(errorNotifierProvider.notifier).showError(appError);
      rethrow;
    }
  }
  

  
  /// Helper method to convert exceptions to AppError
  AppError _handleAuthError(Object error) {
    if (error.toString().contains('network')) {
      return const AppError.network('Network error during authentication. Please check your connection.');
    } else if (error.toString().contains('cancelled')) {
      return const AppError.authentication('Authentication was cancelled.');
    } else {
      return const AppError.authentication('Authentication failed. Please try again.');
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

/// Provider for global success messages
@riverpod
class SuccessNotifier extends _$SuccessNotifier {
  @override
  String? build() => null;
  
  /// Show a success message globally
  void showSuccess(String message) {
    state = message;
  }
  
  /// Clear the current success message
  void clearSuccess() {
    state = null;
  }
  
  /// Auto-clear success message after a delay
  void showSuccessWithAutoClear(String message, {Duration delay = const Duration(seconds: 3)}) {
    state = message;
    Future.delayed(delay, () {
      if (ref.mounted && state == message) {
        state = null;
      }
    });
  }
}

/// Provider for global loading state
@riverpod
class LoadingNotifier extends _$LoadingNotifier {
  @override
  bool build() => false;
  
  /// Set loading state
  void setLoading(bool isLoading) {
    state = isLoading;
  }
  
  /// Show loading with message
  void showLoading() {
    state = true;
  }
  
  /// Hide loading
  void hideLoading() {
    state = false;
  }
}