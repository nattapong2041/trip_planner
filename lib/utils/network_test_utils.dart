import 'package:logger/logger.dart';
import '../config/firestore_config.dart';

/// Utility class for testing network scenarios and offline persistence
class NetworkTestUtils {
  static final Logger _logger = Logger();

  /// Simulate a brief network interruption for testing
  /// This disables the network for a short period and then re-enables it
  static Future<void> simulateNetworkInterruption({
    Duration duration = const Duration(seconds: 2),
  }) async {
    _logger.i('Simulating network interruption for ${duration.inSeconds} seconds');
    
    try {
      // Disable network
      await FirestoreConfig.disableNetwork();
      _logger.d('Network disabled');
      
      // Wait for the specified duration
      await Future.delayed(duration);
      
      // Re-enable network
      await FirestoreConfig.enableNetwork();
      _logger.d('Network re-enabled');
      
      _logger.i('Network interruption simulation completed');
    } catch (e) {
      _logger.e('Error during network interruption simulation: $e');
      // Always try to re-enable network in case of error
      try {
        await FirestoreConfig.enableNetwork();
      } catch (enableError) {
        _logger.e('Failed to re-enable network: $enableError');
      }
      rethrow;
    }
  }

  /// Test offline functionality by performing operations while offline
  static Future<T> testOfflineOperation<T>(
    Future<T> Function() operation, {
    Duration offlineDuration = const Duration(seconds: 1),
  }) async {
    _logger.i('Testing offline operation');
    
    try {
      // Disable network
      await FirestoreConfig.disableNetwork();
      _logger.d('Network disabled for offline test');
      
      // Wait briefly to ensure offline state
      await Future.delayed(offlineDuration);
      
      // Perform the operation while offline
      final result = await operation();
      
      // Re-enable network
      await FirestoreConfig.enableNetwork();
      _logger.d('Network re-enabled after offline test');
      
      _logger.i('Offline operation test completed successfully');
      return result;
    } catch (e) {
      _logger.e('Error during offline operation test: $e');
      // Always try to re-enable network in case of error
      try {
        await FirestoreConfig.enableNetwork();
      } catch (enableError) {
        _logger.e('Failed to re-enable network: $enableError');
      }
      rethrow;
    }
  }

  /// Test that real-time streams continue to work after network restoration
  static Future<void> testStreamResilience<T>(
    Stream<T> stream, {
    Duration testDuration = const Duration(seconds: 5),
    Duration interruptionDuration = const Duration(seconds: 2),
  }) async {
    _logger.i('Testing stream resilience during network interruption');
    
    final streamResults = <T>[];
    late final subscription = stream.listen(
      (data) {
        streamResults.add(data);
        _logger.d('Stream received data: ${streamResults.length} items');
      },
      onError: (error) {
        _logger.e('Stream error: $error');
      },
    );
    
    try {
      // Wait for initial data
      await Future.delayed(const Duration(milliseconds: 500));
      final initialCount = streamResults.length;
      _logger.d('Initial stream data count: $initialCount');
      
      // Simulate network interruption
      await simulateNetworkInterruption(duration: interruptionDuration);
      
      // Wait for stream to recover
      await Future.delayed(testDuration - interruptionDuration);
      
      final finalCount = streamResults.length;
      _logger.d('Final stream data count: $finalCount');
      
      // Stream should have continued working (may have same or more data)
      if (finalCount >= initialCount) {
        _logger.i('Stream resilience test passed');
      } else {
        _logger.w('Stream resilience test: data count decreased');
      }
      
    } finally {
      await subscription.cancel();
    }
  }

  /// Verify that cached data is available during offline periods
  static Future<bool> verifyCachedDataAvailability<T>(
    Future<T?> Function() dataRetrieval,
    T expectedData,
    bool Function(T?, T) comparator,
  ) async {
    _logger.i('Verifying cached data availability during offline period');
    
    try {
      // First, ensure we have data online
      final onlineData = await dataRetrieval();
      if (onlineData == null || !comparator(onlineData, expectedData)) {
        _logger.w('Online data verification failed');
        return false;
      }
      
      // Disable network
      await FirestoreConfig.disableNetwork();
      _logger.d('Network disabled for cache test');
      
      // Try to retrieve data from cache
      final cachedData = await dataRetrieval();
      
      // Re-enable network
      await FirestoreConfig.enableNetwork();
      _logger.d('Network re-enabled after cache test');
      
      // Verify cached data matches expected data
      final cacheValid = cachedData != null && comparator(cachedData, expectedData);
      
      if (cacheValid) {
        _logger.i('Cached data availability test passed');
      } else {
        _logger.w('Cached data availability test failed');
      }
      
      return cacheValid;
      
    } catch (e) {
      _logger.e('Error during cached data availability test: $e');
      // Always try to re-enable network in case of error
      try {
        await FirestoreConfig.enableNetwork();
      } catch (enableError) {
        _logger.e('Failed to re-enable network: $enableError');
      }
      return false;
    }
  }

  /// Test that changes made offline are synced when network is restored
  static Future<bool> testOfflineToOnlineSync<T>(
    Future<T> Function() offlineOperation,
    Future<T?> Function() verificationRetrieval,
    bool Function(T, T?) verificationComparator,
  ) async {
    _logger.i('Testing offline to online sync');
    
    try {
      // Disable network
      await FirestoreConfig.disableNetwork();
      _logger.d('Network disabled for sync test');
      
      // Perform operation while offline
      final offlineResult = await offlineOperation();
      _logger.d('Offline operation completed');
      
      // Re-enable network
      await FirestoreConfig.enableNetwork();
      _logger.d('Network re-enabled for sync test');
      
      // Wait for sync to complete
      await Future.delayed(const Duration(seconds: 2));
      
      // Verify the change was synced
      final syncedData = await verificationRetrieval();
      final syncSuccessful = verificationComparator(offlineResult, syncedData);
      
      if (syncSuccessful) {
        _logger.i('Offline to online sync test passed');
      } else {
        _logger.w('Offline to online sync test failed');
      }
      
      return syncSuccessful;
      
    } catch (e) {
      _logger.e('Error during offline to online sync test: $e');
      // Always try to re-enable network in case of error
      try {
        await FirestoreConfig.enableNetwork();
      } catch (enableError) {
        _logger.e('Failed to re-enable network: $enableError');
      }
      return false;
    }
  }
}