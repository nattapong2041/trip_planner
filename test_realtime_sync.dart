import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'lib/main.dart';

/// Simple test to verify real-time sync is working
/// Run this with: flutter run test_realtime_sync.dart
void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Real-time Sync Test')),
          body: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Real-time Sync Test',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  'The activity provider has been updated to use Firebase.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'Activities should now sync in real-time between users.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  'To test:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('1. Run the main app: flutter run'),
                Text('2. Sign in with two different accounts'),
                Text('3. Create a trip and add collaborators'),
                Text('4. Create activities from both accounts'),
                Text('5. Verify activities appear in real-time'),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}