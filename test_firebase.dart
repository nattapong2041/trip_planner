import 'package:firebase_core/firebase_core.dart';
import 'package:trip_planner/firebase_options.dart';
import 'package:trip_planner/services/firebase_service.dart';

/// Simple script to test Firebase connection
/// Run with: dart run test_firebase.dart
void main() async {
  print('🔥 Testing Firebase Configuration...\n');

  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized successfully');

    // Get project info
    final projectInfo = FirebaseService.getFirebaseProjectInfo();
    print('📋 Project Info:');
    projectInfo.forEach((key, value) {
      print('   $key: $value');
    });
    print('');

    // Test Firebase services
    print('🧪 Testing Firebase services...');
    final results = await FirebaseService.testFirebaseServices();

    print('\n📊 Test Results:');
    results.forEach((service, success) {
      final status = success ? '✅' : '❌';
      print('   $status $service: ${success ? 'PASS' : 'FAIL'}');
    });

    final allPassed = results.values.every((result) => result);
    print(
        '\n🎯 Overall Result: ${allPassed ? '✅ ALL TESTS PASSED' : '❌ SOME TESTS FAILED'}');

    if (allPassed) {
      print('\n🚀 Firebase is ready for development!');
    } else {
      print('\n⚠️  Some Firebase services may not be working properly.');
      print(
          '   Check your Firebase project configuration and network connection.');
    }
  } catch (e) {
    print('❌ Failed to initialize Firebase: $e');
    print('\n💡 Make sure you have:');
    print('   1. A valid Firebase project configured');
    print('   2. Proper network connection');
    print('   3. Correct Firebase configuration files');
  }
}
