import 'dart:async';
import 'trip_repository.dart';
import '../models/trip.dart';
import '../models/user.dart';
import 'mock_data_generator.dart';

/// Mock implementation of TripRepository for testing and development
class MockTripRepository implements TripRepository {
  final Map<String, Trip> _trips = {};
  final Map<String, StreamController<List<Trip>>> _userTripControllers = {};
  final List<User> _mockUsers = MockDataGenerator.generateMockUsers();
  
  MockTripRepository() {
    _initializeMockData();
  }
  
  void _initializeMockData() {
    // Generate mock trips for each user
    for (final user in _mockUsers) {
      final userTrips = MockDataGenerator.generateMockTrips(user.id);
      for (final trip in userTrips) {
        _trips[trip.id] = trip;
      }
    }
  }
  
  @override
  Stream<List<Trip>> getUserTrips(String userId) {
    if (!_userTripControllers.containsKey(userId)) {
      _userTripControllers[userId] = StreamController<List<Trip>>.broadcast();
    }
    // Emit current trips for the user asynchronously to ensure listeners receive the event
    final userTrips = _trips.values
        .where((trip) => trip.ownerId == userId || trip.collaboratorIds.contains(userId))
        .toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    Future.microtask(() {
      _userTripControllers[userId]!.add(userTrips);
    });
    return _userTripControllers[userId]!.stream;
  }
  
  @override
  Future<Trip> createTrip(Trip trip) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    final now = DateTime.now();
    final newTrip = trip.copyWith(
      id: MockDataGenerator.generateId(),
      createdAt: now,
      updatedAt: now,
    );
    
    _trips[newTrip.id] = newTrip;
    _notifyUserTripUpdates(newTrip.ownerId);
    
    return newTrip;
  }
  
  @override
  Future<Trip> updateTrip(Trip trip) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));
    
    if (!_trips.containsKey(trip.id)) {
      throw Exception('Trip not found');
    }
    
    final updatedTrip = trip.copyWith(updatedAt: DateTime.now());
    _trips[trip.id] = updatedTrip;
    
    // Notify owner and collaborators
    _notifyUserTripUpdates(updatedTrip.ownerId);
    for (final collaboratorId in updatedTrip.collaboratorIds) {
      _notifyUserTripUpdates(collaboratorId);
    }
    
    return updatedTrip;
  }
  
  @override
  Future<void> deleteTrip(String tripId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));
    
    final trip = _trips[tripId];
    if (trip == null) {
      throw Exception('Trip not found');
    }
    
    _trips.remove(tripId);
    
    // Notify owner and collaborators
    _notifyUserTripUpdates(trip.ownerId);
    for (final collaboratorId in trip.collaboratorIds) {
      _notifyUserTripUpdates(collaboratorId);
    }
  }
  
  @override
  Future<void> addCollaborator(String tripId, String email) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    final trip = _trips[tripId];
    if (trip == null) {
      throw Exception('Trip not found');
    }
    
    // Find user by email
    final user = _mockUsers.firstWhere(
      (user) => user.email == email,
      orElse: () => throw Exception('User not found'),
    );
    
    if (trip.collaboratorIds.contains(user.id)) {
      throw Exception('User is already a collaborator');
    }
    
    final updatedTrip = trip.copyWith(
      collaboratorIds: [...trip.collaboratorIds, user.id],
      updatedAt: DateTime.now(),
    );
    
    _trips[tripId] = updatedTrip;
    
    // Notify owner and all collaborators
    _notifyUserTripUpdates(updatedTrip.ownerId);
    for (final collaboratorId in updatedTrip.collaboratorIds) {
      _notifyUserTripUpdates(collaboratorId);
    }
  }
  
  @override
  Future<Trip?> getTripById(String tripId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1000));
    
    return _trips[tripId];
  }
  
  void _notifyUserTripUpdates(String userId) {
    if (_userTripControllers.containsKey(userId)) {
      final userTrips = _trips.values
          .where((trip) => trip.ownerId == userId || trip.collaboratorIds.contains(userId))
          .toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      
      _userTripControllers[userId]!.add(userTrips);
    }
  }
  
  /// Get all trips (for testing purposes)
  List<Trip> get allTrips => List.unmodifiable(_trips.values);
  
  /// Dispose resources
  void dispose() {
    for (final controller in _userTripControllers.values) {
      controller.close();
    }
    _userTripControllers.clear();
  }
}