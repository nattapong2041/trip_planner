import 'dart:io';

/// Simple script to verify Firebase configuration files exist
/// Run with: dart run verify_firebase_config.dart
void main() {
  print('🔥 Verifying Firebase Configuration Files...\n');
  
  final configFiles = [
    'lib/firebase_options.dart',
    'android/app/google-services.json',
    'ios/Runner/GoogleService-Info.plist',
  ];
  
  bool allFilesExist = true;
  
  for (final filePath in configFiles) {
    final file = File(filePath);
    if (file.existsSync()) {
      print('✅ $filePath - EXISTS');
    } else {
      print('❌ $filePath - MISSING');
      allFilesExist = false;
    }
  }
  
  print('\n📋 Checking pubspec.yaml dependencies...');
  final pubspecFile = File('pubspec.yaml');
  if (pubspecFile.existsSync()) {
    final content = pubspecFile.readAsStringSync();
    final firebaseDeps = [
      'firebase_core',
      'firebase_auth',
      'cloud_firestore',
      'google_sign_in',
      'sign_in_with_apple',
    ];
    
    for (final dep in firebaseDeps) {
      if (content.contains('$dep:')) {
        print('✅ $dep - CONFIGURED');
      } else {
        print('❌ $dep - MISSING');
        allFilesExist = false;
      }
    }
  }
  
  print('\n📱 Checking platform configurations...');
  
  // Check Android configuration
  final androidBuildFile = File('android/app/build.gradle.kts');
  if (androidBuildFile.existsSync()) {
    final content = androidBuildFile.readAsStringSync();
    if (content.contains('com.google.gms.google-services')) {
      print('✅ Android Google Services plugin - CONFIGURED');
    } else {
      print('❌ Android Google Services plugin - MISSING');
      allFilesExist = false;
    }
  }
  
  // Check Android settings
  final androidSettingsFile = File('android/settings.gradle.kts');
  if (androidSettingsFile.existsSync()) {
    final content = androidSettingsFile.readAsStringSync();
    if (content.contains('com.google.gms.google-services')) {
      print('✅ Android settings Google Services - CONFIGURED');
    } else {
      print('❌ Android settings Google Services - MISSING');
      allFilesExist = false;
    }
  }
  
  print('\n🎯 Overall Result: ${allFilesExist ? '✅ ALL CONFIGURATIONS PRESENT' : '❌ SOME CONFIGURATIONS MISSING'}');
  
  if (allFilesExist) {
    print('\n🚀 Firebase configuration appears to be complete!');
    print('   You can now run the app to test Firebase connection.');
    print('   Use: flutter run');
  } else {
    print('\n⚠️  Some Firebase configurations are missing.');
    print('   Please ensure all required files and dependencies are in place.');
  }
}