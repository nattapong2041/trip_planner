import 'dart:async';
import 'auth_repository.dart';
import '../models/user.dart';
import 'mock_data_generator.dart';

/// Mock implementation of AuthRepository for testing and development
class MockAuthRepository implements AuthRepository {
  User? _currentUser;
  final StreamController<User?> _authStateController = StreamController<User?>.broadcast();
  final List<User> _mockUsers = MockDataGenerator.generateMockUsers();
  
  MockAuthRepository() {
    // Initialize with no authenticated user
    _currentUser = null;
    _authStateController.add(null);
  }
  
  @override
  Stream<User?> get authStateChanges => _authStateController.stream;
  
  @override
  User? get currentUser => _currentUser;
  
  @override
  Future<User?> signInWithGoogle() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Simulate successful Google sign-in with first mock user
    _currentUser = _mockUsers.first;
    _authStateController.add(_currentUser);
    
    return _currentUser;
  }
  
  @override
  Future<User?> signInWithApple() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Simulate successful Apple sign-in with second mock user
    _currentUser = _mockUsers.length > 1 ? _mockUsers[1] : _mockUsers.first;
    _authStateController.add(_currentUser);
    
    return _currentUser;
  }
  
  @override
  Future<void> signOut() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    _currentUser = null;
    _authStateController.add(null);
  }
  
  /// Helper method to simulate signing in with a specific user (for testing)
  Future<User?> signInWithUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    _currentUser = _mockUsers.firstWhere(
      (user) => user.id == userId,
      orElse: () => _mockUsers.first,
    );
    _authStateController.add(_currentUser);
    
    return _currentUser;
  }
  
  /// Get all mock users (for testing purposes)
  List<User> get mockUsers => List.unmodifiable(_mockUsers);
  
  /// Dispose resources
  void dispose() {
    _authStateController.close();
  }
}