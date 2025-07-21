import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Application configuration class
class AppConfig {
  static const String appName = 'Trip Planner';
  
  /// Firebase configuration options for different platforms
  /// 
  /// Note: These are placeholder values. In a real application, you would:
  /// 1. Create a Firebase project at https://console.firebase.google.com/
  /// 2. Register your app for each platform (Web, Android, iOS)
  /// 3. Download the configuration files and replace these values
  /// 4. For production, use the Firebase CLI or FlutterFire CLI to generate these values
  static FirebaseOptions? get firebaseOptions {
    if (kIsWeb) {
      return const FirebaseOptions(
        apiKey: "YOUR_WEB_API_KEY",
        authDomain: "trip-planner-app.firebaseapp.com",
        projectId: "trip-planner-app",
        storageBucket: "trip-planner-app.appspot.com",
        messagingSenderId: "YOUR_SENDER_ID",
        appId: "YOUR_WEB_APP_ID",
      );
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return const FirebaseOptions(
        apiKey: "YOUR_ANDROID_API_KEY",
        appId: "YOUR_ANDROID_APP_ID",
        messagingSenderId: "YOUR_SENDER_ID",
        projectId: "trip-planner-app",
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return const FirebaseOptions(
        apiKey: "YOUR_IOS_API_KEY",
        appId: "YOUR_IOS_APP_ID",
        messagingSenderId: "YOUR_SENDER_ID",
        projectId: "trip-planner-app",
        iosBundleId: "com.example.tripPlanner",
      );
    } else if (defaultTargetPlatform == TargetPlatform.macOS) {
      return const FirebaseOptions(
        apiKey: "YOUR_MACOS_API_KEY",
        appId: "YOUR_MACOS_APP_ID",
        messagingSenderId: "YOUR_SENDER_ID",
        projectId: "trip-planner-app",
        iosBundleId: "com.example.tripPlanner",
      );
    }
    return null;
  }
}