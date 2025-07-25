import '../models/trip.dart';
import '../models/user.dart';

/// Abstract repository interface for trip management operations
abstract class TripRepository {
  /// Stream of trips for a specific user
  /// Returns real-time updates of all trips where the user is owner or collaborator
  Stream<List<Trip>> getUserTrips(String userId);
  
  /// Create a new trip
  /// Returns the created trip with generated ID and timestamps
  Future<Trip> createTrip(Trip trip);
  
  /// Update an existing trip
  /// Returns the updated trip with new timestamp
  Future<Trip> updateTrip(Trip trip);
  
  /// Delete a trip by ID
  /// Removes the trip and all associated data
  Future<void> deleteTrip(String tripId);
  
  /// Add a collaborator to a trip by email
  /// Finds user by email and adds them to the trip's collaborator list
  Future<void> addCollaborator(String tripId, String email);
  
  /// Get a single trip by ID
  /// Returns null if trip doesn't exist or user doesn't have access
  Future<Trip?> getTripById(String tripId);
  
  /// Get collaborator information for a trip
  /// Returns list of User objects for all collaborators including owner
  Future<List<User>> getTripCollaborators(String tripId);
  
  /// Remove a collaborator from a trip
  /// Removes the user from the trip's collaborator list
  Future<void> removeCollaborator(String tripId, String userId);
}