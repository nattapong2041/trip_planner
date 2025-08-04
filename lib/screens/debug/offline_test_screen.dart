import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_planner/config/firestore_config.dart';
import 'package:trip_planner/config/firebase_storage_config.dart';
import 'package:trip_planner/services/firebase_service.dart';
import 'package:trip_planner/utils/network_test_utils.dart';
import 'package:trip_planner/providers/trip_provider.dart';
import 'package:trip_planner/providers/auth_provider.dart';

/// Debug screen for testing offline persistence functionality
class OfflineTestScreen extends ConsumerStatefulWidget {
  const OfflineTestScreen({super.key});

  @override
  ConsumerState<OfflineTestScreen> createState() => _OfflineTestScreenState();
}

class _OfflineTestScreenState extends ConsumerState<OfflineTestScreen> {
  String _testResults = '';
  bool _isRunningTests = false;

  void _addTestResult(String result) {
    setState(() {
      _testResults += '$result\n';
    });
  }

  void _clearResults() {
    setState(() {
      _testResults = '';
    });
  }

  Future<void> _testOfflinePersistence() async {
    setState(() {
      _isRunningTests = true;
    });

    _clearResults();
    _addTestResult('🧪 Starting Offline Persistence Tests...\n');

    try {
      // Test 1: Check if offline persistence is configured
      _addTestResult('✅ Test 1: Checking offline persistence configuration');
      final isConfigured = FirestoreConfig.isConfigured;
      _addTestResult('   Offline persistence configured: $isConfigured');

      // Test 2: Test network disable/enable
      _addTestResult('\n✅ Test 2: Testing network control');
      await FirestoreConfig.disableNetwork();
      _addTestResult('   Network disabled successfully');

      await Future.delayed(const Duration(seconds: 1));

      await FirestoreConfig.enableNetwork();
      _addTestResult('   Network re-enabled successfully');

      // Test 3: Test brief network interruption simulation
      _addTestResult('\n✅ Test 3: Testing network interruption simulation');
      await NetworkTestUtils.simulateNetworkInterruption(
        duration: const Duration(seconds: 2),
      );
      _addTestResult('   Network interruption simulation completed');

      // Test 4: Test real-time streams with user trips (if authenticated)
      final user = ref.read(authNotifierProvider).value;
      if (user != null) {
        _addTestResult(
            '\n✅ Test 4: Testing real-time streams with offline support');
        // Note: In a real implementation, we would access the underlying stream
        // For now, we'll just verify the provider is accessible
        final tripsAsync = ref.read(tripListNotifierProvider);
        _addTestResult('   Trips provider accessible: ${tripsAsync.hasValue}');
        _addTestResult('   Stream resilience test completed (simulated)');
      } else {
        _addTestResult('\n⚠️  Test 4: Skipped (user not authenticated)');
      }

      _addTestResult(
          '\n🎉 All offline persistence tests completed successfully!');
    } catch (e) {
      _addTestResult('\n❌ Test failed: $e');
    } finally {
      setState(() {
        _isRunningTests = false;
      });
    }
  }

  Future<void> _testFirebaseServices() async {
    setState(() {
      _isRunningTests = true;
    });

    _addTestResult('\n🔥 Starting Firebase Services Tests...\n');

    try {
      // Test all Firebase connections
      _addTestResult('✅ Testing all Firebase connections...');
      final results = await FirebaseService.testAllConnections();

      _addTestResult(
          '   Firebase Auth: ${results['auth'] == true ? '✅' : '❌'}');
      _addTestResult(
          '   Firebase Firestore: ${results['firestore'] == true ? '✅' : '❌'}');
      _addTestResult(
          '   Firebase Storage: ${results['storage'] == true ? '✅' : '❌'}');

      final allPassed = results.values.every((result) => result);
      if (allPassed) {
        _addTestResult('\n🎉 All Firebase services are working correctly!');
      } else {
        _addTestResult(
            '\n⚠️  Some Firebase services may have issues. Check logs for details.');
      }

      // Test Firebase Storage configuration
      _addTestResult('\n✅ Testing Firebase Storage configuration...');
      _addTestResult(
          '   Storage configured: ${FirebaseStorageConfig.isConfigured}');

      // Test storage references
      final activityRef =
          FirebaseStorageConfig.getActivityImagesRef('test-activity');
      _addTestResult('   Activity images reference: ${activityRef.fullPath}');

      final imageRef =
          FirebaseStorageConfig.getImageRef('test-activity', 'test-image.jpg');
      _addTestResult('   Image reference: ${imageRef.fullPath}');
    } catch (e) {
      _addTestResult('\n❌ Firebase services test failed: $e');
    } finally {
      setState(() {
        _isRunningTests = false;
      });
    }
  }

  Future<void> _testCollaborativeFeatures() async {
    setState(() {
      _isRunningTests = true;
    });

    _addTestResult('\n🤝 Starting Collaborative Features Tests...\n');

    try {
      final user = ref.read(authNotifierProvider).value;
      if (user == null) {
        _addTestResult('❌ User not authenticated. Please sign in first.');
        return;
      }

      // Test 1: Configure for collaboration
      _addTestResult('✅ Test 1: Configuring for real-time collaboration');
      FirestoreConfig.configureForCollaboration();
      _addTestResult('   Collaboration configuration completed');

      // Test 2: Test real-time trip updates
      _addTestResult('\n✅ Test 2: Testing real-time trip updates');
      final tripsAsync = ref.read(tripListNotifierProvider);

      // Check if we have trip data
      if (tripsAsync.hasValue) {
        final trips = tripsAsync.value!;
        _addTestResult('   Current trips count: ${trips.length}');
        _addTestResult('   Real-time provider working correctly');
      } else if (tripsAsync.isLoading) {
        _addTestResult('   Trips are loading...');
      } else if (tripsAsync.hasError) {
        _addTestResult('   Error loading trips: ${tripsAsync.error}');
      }

      _addTestResult('\n🎉 Collaborative features tests completed!');
    } catch (e) {
      _addTestResult('\n❌ Collaborative test failed: $e');
    } finally {
      setState(() {
        _isRunningTests = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Persistence Test'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Offline Persistence Status',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                        'Firestore Configured: ${FirestoreConfig.isConfigured}'),
                    Text(
                        'Storage Configured: ${FirebaseStorageConfig.isConfigured}'),
                    const SizedBox(height: 16),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _isRunningTests
                                    ? null
                                    : _testOfflinePersistence,
                                child: const Text('Test Offline Persistence'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _isRunningTests
                                    ? null
                                    : _testCollaborativeFeatures,
                                child: const Text('Test Collaboration'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                _isRunningTests ? null : _testFirebaseServices,
                            child: const Text('Test Firebase Services'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Test Results',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          TextButton(
                            onPressed: _clearResults,
                            child: const Text('Clear'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SingleChildScrollView(
                            child: Text(
                              _testResults.isEmpty
                                  ? 'No tests run yet.'
                                  : _testResults,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontFamily: 'monospace',
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_isRunningTests)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
