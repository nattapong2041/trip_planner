import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logger/logger.dart';
import 'package:trip_planner/firebase_options.dart';
import 'screens/app.dart';
import 'services/firebase_service.dart';

// Global logger instance
final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 8,
    lineLength: 120,
    colors: true,
    printEmojis: true,
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
  ),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    logger.i('Firebase initialized successfully');
    
    // Test Firebase connection and basic operations
    final testResults = await FirebaseService.testFirebaseServices();
    logger.i('Firebase services test results: $testResults');
    
    if (testResults['auth'] == true && testResults['firestore'] == true) {
      logger.i('All Firebase services are working correctly');
    } else {
      logger.w('Some Firebase services may not be working properly');
    }
  } catch (e) {
    logger.e('Failed to initialize Firebase: $e');
    // In a real app, you might want to handle this more gracefully
    // For now, we'll continue with the app initialization
  }
  
  runApp(
    const ProviderScope(
      child: TripPlannerApp(),
    ),
  );
}