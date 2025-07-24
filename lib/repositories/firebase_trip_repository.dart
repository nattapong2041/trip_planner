import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import '../models/trip.dart';

import 'trip_repository.dart';

/// Firebase implementation of TripRepository using Firestore
class FirebaseTripRepository implements TripRepository {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final Logger _logger = Logger();
  
  // Collection references
  static const String _tripsCollection = 'trips';
  static const String _usersCollection = 'users';
  
  @override
  Stream<List<Trip>> getUserTrips(String userId) {
    try {
      _logger.d('Getting trips for user: $userId');
      
      return _firestore
          .collection(_tripsCollection)
          .where(Filter.or(
            Filter('ownerId', isEqualTo: userId),
            Filter('collaboratorIds', arrayContains: userId),
          ))
          .orderBy('updatedAt', descending: true)
          .snapshots()
          .map((snapshot) {
        _logger.d('Received ${snapshot.docs.length} trips for user $userId');
        
        return snapshot.docs.map((doc) {
          try {
            final data = doc.data();
            data['id'] = doc.id; // Ensure ID is set from document ID
            return Trip.fromJson(data);
          } catch (e) {
            _logger.e('Error parsing trip document ${doc.id}: $e');
            rethrow;
          }
        }).toList();
      });
    } catch (e) {
      _logger.e('Error getting user trips: $e');
      rethrow;
    }
  }
  
  @override
  Future<Trip> createTrip(Trip trip) async {
    try {
      _logger.d('Creating trip: ${trip.name}');
      
      final now = DateTime.now();
      final tripData = trip.copyWith(
        createdAt: now,
        updatedAt: now,
      ).toJson();
      
      // Remove the ID field as Firestore will generate it
      tripData.remove('id');
      
      final docRef = await _firestore
          .collection(_tripsCollection)
          .add(tripData);
      
      _logger.i('Trip created with ID: ${docRef.id}');
      
      // Return the trip with the generated ID
      return trip.copyWith(
        id: docRef.id,
        createdAt: now,
        updatedAt: now,
      );
    } catch (e) {
      _logger.e('Error creating trip: $e');
      throw Exception('Failed to create trip: $e');
    }
  }
  
  @override
  Future<Trip> updateTrip(Trip trip) async {
    try {
      _logger.d('Updating trip: ${trip.id}');
      
      if (trip.id.isEmpty) {
        throw Exception('Trip ID cannot be empty for update');
      }
      
      final updatedTrip = trip.copyWith(updatedAt: DateTime.now());
      final tripData = updatedTrip.toJson();
      
      // Remove the ID field as it's not stored in the document
      tripData.remove('id');
      
      await _firestore
          .collection(_tripsCollection)
          .doc(trip.id)
          .update(tripData);
      
      _logger.i('Trip updated: ${trip.id}');
      
      return updatedTrip;
    } catch (e) {
      _logger.e('Error updating trip: $e');
      if (e.toString().contains('not-found')) {
        throw Exception('Trip not found');
      }
      throw Exception('Failed to update trip: $e');
    }
  }
  
  @override
  Future<void> deleteTrip(String tripId) async {
    try {
      _logger.d('Deleting trip: $tripId');
      
      if (tripId.isEmpty) {
        throw Exception('Trip ID cannot be empty for deletion');
      }
      
      // Delete the trip document
      await _firestore
          .collection(_tripsCollection)
          .doc(tripId)
          .delete();
      
      // Note: In a production app, you might also want to delete associated activities
      // This could be done with a batch operation or Cloud Functions
      
      _logger.i('Trip deleted: $tripId');
    } catch (e) {
      _logger.e('Error deleting trip: $e');
      if (e.toString().contains('not-found')) {
        throw Exception('Trip not found');
      }
      throw Exception('Failed to delete trip: $e');
    }
  }
  
  @override
  Future<void> addCollaborator(String tripId, String email) async {
    try {
      _logger.d('Adding collaborator $email to trip: $tripId');
      
      if (tripId.isEmpty) {
        throw Exception('Trip ID cannot be empty');
      }
      
      if (email.isEmpty) {
        throw Exception('Email cannot be empty');
      }
      
      // First, find the user by email
      final userQuery = await _firestore
          .collection(_usersCollection)
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      
      if (userQuery.docs.isEmpty) {
        throw Exception('User not found with email: $email');
      }
      
      final userId = userQuery.docs.first.id;
      
      // Get the current trip to check if user is already a collaborator
      final tripDoc = await _firestore
          .collection(_tripsCollection)
          .doc(tripId)
          .get();
      
      if (!tripDoc.exists) {
        throw Exception('Trip not found');
      }
      
      final tripData = tripDoc.data()!;
      final collaboratorIds = List<String>.from(tripData['collaboratorIds'] ?? []);
      
      // Check if user is already a collaborator or owner
      if (tripData['ownerId'] == userId) {
        throw Exception('User is already the owner of this trip');
      }
      
      if (collaboratorIds.contains(userId)) {
        throw Exception('User is already a collaborator on this trip');
      }
      
      // Add the user to collaborators
      collaboratorIds.add(userId);
      
      await _firestore
          .collection(_tripsCollection)
          .doc(tripId)
          .update({
        'collaboratorIds': collaboratorIds,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      _logger.i('Collaborator $email ($userId) added to trip: $tripId');
    } catch (e) {
      _logger.e('Error adding collaborator: $e');
      rethrow;
    }
  }
  
  @override
  Future<Trip?> getTripById(String tripId) async {
    try {
      _logger.d('Getting trip by ID: $tripId');
      
      if (tripId.isEmpty) {
        throw Exception('Trip ID cannot be empty');
      }
      
      final doc = await _firestore
          .collection(_tripsCollection)
          .doc(tripId)
          .get();
      
      if (!doc.exists) {
        _logger.w('Trip not found: $tripId');
        return null;
      }
      
      final data = doc.data()!;
      data['id'] = doc.id; // Ensure ID is set from document ID
      
      final trip = Trip.fromJson(data);
      _logger.d('Retrieved trip: ${trip.name}');
      
      return trip;
    } catch (e) {
      _logger.e('Error getting trip by ID: $e');
      throw Exception('Failed to get trip: $e');
    }
  }
}