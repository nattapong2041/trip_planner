import '../models/user.dart';
import '../models/trip.dart';
import '../models/activity.dart';
import '../models/brainstorm_idea.dart';

/// Utility class for generating realistic mock data for testing
class MockDataGenerator {
  static int _idCounter = 1;
  
  /// Generate a unique ID for mock data
  static String generateId() => 'mock_${_idCounter++}';
  
  /// Generate mock users
  static List<User> generateMockUsers() {
    return [
      const User(
        id: 'user_1',
        email: 'john.doe@example.com',
        displayName: 'John Doe',
        photoUrl: 'https://example.com/avatar1.jpg',
      ),
      const User(
        id: 'user_2',
        email: 'jane.smith@example.com',
        displayName: 'Jane Smith',
        photoUrl: 'https://example.com/avatar2.jpg',
      ),
      const User(
        id: 'user_3',
        email: 'mike.wilson@example.com',
        displayName: 'Mike Wilson',
        photoUrl: 'https://example.com/avatar3.jpg',
      ),
    ];
  }
  
  /// Generate mock trips for a user
  static List<Trip> generateMockTrips(String userId) {
    final now = DateTime.now();
    return [
      Trip(
        id: 'trip_1',
        name: 'Tokyo Adventure',
        durationDays: 7,
        ownerId: userId,
        collaboratorIds: ['user_2'],
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
      Trip(
        id: 'trip_2',
        name: 'European Summer',
        durationDays: 14,
        ownerId: userId,
        collaboratorIds: ['user_2', 'user_3'],
        createdAt: now.subtract(const Duration(days: 20)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      Trip(
        id: 'trip_3',
        name: 'Weekend Getaway',
        durationDays: 3,
        ownerId: userId,
        collaboratorIds: [],
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(hours: 6)),
      ),
    ];
  }
  
  /// Generate mock activities for a trip
  static List<Activity> generateMockActivities(String tripId, String userId) {
    final now = DateTime.now();
    return [
      Activity(
        id: 'activity_1',
        tripId: tripId,
        place: 'Senso-ji Temple',
        activityType: 'Sightseeing',
        price: '¥500',
        notes: 'Visit early morning to avoid crowds',
        assignedDay: 'day-1',
        dayOrder: 1,
        createdBy: userId,
        createdAt: now.subtract(const Duration(days: 3)),
        brainstormIdeas: [
          BrainstormIdea(
            id: 'idea_1',
            description: 'Take photos at the main gate',
            createdBy: userId,
            createdAt: now.subtract(const Duration(days: 2)),
          ),
          BrainstormIdea(
            id: 'idea_2',
            description: 'Try traditional snacks nearby',
            createdBy: 'user_2',
            createdAt: now.subtract(const Duration(days: 1)),
          ),
        ],
      ),
      Activity(
        id: 'activity_2',
        tripId: tripId,
        place: 'Tokyo Skytree',
        activityType: 'Sightseeing',
        price: '¥2,100',
        notes: 'Book tickets in advance',
        assignedDay: 'day-1',
        dayOrder: 2,
        createdBy: 'user_2',
        createdAt: now.subtract(const Duration(days: 2)),
        brainstormIdeas: [
          BrainstormIdea(
            id: 'idea_3',
            description: 'Visit at sunset for best views',
            createdBy: 'user_2',
            createdAt: now.subtract(const Duration(hours: 12)),
          ),
        ],
      ),
      Activity(
        id: 'activity_3',
        tripId: tripId,
        place: 'Tsukiji Fish Market',
        activityType: 'Food',
        price: '¥3,000',
        notes: 'Go early for fresh sushi',
        assignedDay: null, // In activity pool
        dayOrder: null,
        createdBy: userId,
        createdAt: now.subtract(const Duration(days: 1)),
        brainstormIdeas: [],
      ),
      Activity(
        id: 'activity_4',
        tripId: tripId,
        place: 'Shibuya Crossing',
        activityType: 'Experience',
        price: 'Free',
        notes: 'Best experienced during rush hour',
        assignedDay: 'day-2',
        dayOrder: 1,
        createdBy: 'user_2',
        createdAt: now.subtract(const Duration(hours: 18)),
        brainstormIdeas: [
          BrainstormIdea(
            id: 'idea_4',
            description: 'Take video of the crossing',
            createdBy: userId,
            createdAt: now.subtract(const Duration(hours: 6)),
          ),
          BrainstormIdea(
            id: 'idea_5',
            description: 'Visit Hachiko statue',
            createdBy: 'user_2',
            createdAt: now.subtract(const Duration(hours: 4)),
          ),
          BrainstormIdea(
            id: 'idea_6',
            description: 'Explore nearby shopping areas',
            createdBy: 'user_3',
            createdAt: now.subtract(const Duration(hours: 2)),
          ),
        ],
      ),
    ];
  }
  
  /// Generate mock brainstorm ideas
  static List<BrainstormIdea> generateMockBrainstormIdeas(String createdBy) {
    final now = DateTime.now();
    return [
      BrainstormIdea(
        id: generateId(),
        description: 'Check opening hours beforehand',
        createdBy: createdBy,
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      BrainstormIdea(
        id: generateId(),
        description: 'Bring comfortable walking shoes',
        createdBy: createdBy,
        createdAt: now.subtract(const Duration(hours: 1)),
      ),
    ];
  }
}