import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logger/logger.dart';
import 'package:trip_planner/firebase_options.dart';
import 'config/app_config.dart';
import 'screens/app.dart';

// Global logger instance
final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 8,
    lineLength: 120,
    colors: true,
    printEmojis: true,
    printTime: true,
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