import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:trip_planner/services/firebase_service.dart';

// Mock Firebase options for testing
class MockFirebaseOptions extends FirebaseOptions {
  const MockFirebaseOptions()
      : super(
          apiKey: 'test-api-key',
          appId: 'test-app-id',
          messagingSenderId: 'test-sender-id',
          projectId: 'test-project-id',
        );
}

void main() {
  group('FirebaseService Tests', () {
    setUpAll(() async {
      // Initialize Firebase for testing
      TestWidgetsFlutterBinding.ensureInitialized();
      
      // Note: In a real test environment, you would use Firebase emulators
      // For now, we'll test the service structure without actual Firebase calls
    });

    test('should return Firebase project info', () {
      final projectInfo = FirebaseService.getFirebaseProjectInfo();
      
      expect(projectInfo, isA<Map<String, String>>());
      expect(projectInfo['project_id'], equals('trip-planner-f86bc'));
      expect(projectInfo['auth_domain'], equals('trip-planner-f86bc.firebaseapp.com'));
      expect(projectInfo['storage_bucket'], equals('trip-planner-f86bc.firebasestorage.app'));
    });

    test('should have testFirebaseServices method', () {
      expect(FirebaseService.testFirebaseServices, isA<Function>());
    });

    test('should have testAuthConnection method', () {
      expect(FirebaseService.testAuthConnection, isA<Function>());
    });

    test('should have testFirestoreConnection method', () {
      expect(FirebaseService.testFirestoreConnection, isA<Function>());
    });
  });
}