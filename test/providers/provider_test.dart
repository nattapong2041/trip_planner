import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_planner/providers/providers.dart';
import 'package:trip_planner/models/app_error.dart';
import 'package:trip_planner/models/trip.dart';
import 'package:trip_planner/models/activity.dart';

void main() {
  group('Provider Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('AuthNotifier', () {
      test('should be properly initialized', () {
        final authNotifier = container.read(authNotifierProvider.notifier);
        expect(authNotifier, isNotNull);
      });

      test('should have auth repository', () {
        final authRepository = container.read(authRepositoryProvider);
        expect(authRepository, isNotNull);
      });
    });

    group('ErrorNotifier', () {
      test('should start with no error', () {
        final errorState = container.read(errorNotifierProvider);
        expect(errorState, isNull);
      });

      test('should show and clear errors', () {
        final errorNotifier = container.read(errorNotifierProvider.notifier);
        const testError = AppError.network('Test network error');

        errorNotifier.showError(testError);
        expect(container.read(errorNotifierProvider), testError);

        errorNotifier.clearError();
        expect(container.read(errorNotifierProvider), isNull);
      });

      test('should auto-clear errors after delay', () async {
        final errorNotifier = container.read(errorNotifierProvider.notifier);
        const testError = AppError.validation('Test validation error');

        errorNotifier.showErrorWithAutoClear(testError,
            delay: const Duration(milliseconds: 100));
        expect(container.read(errorNotifierProvider), testError);

        // Wait for auto-clear
        await Future.delayed(const Duration(milliseconds: 150));
        expect(container.read(errorNotifierProvider), isNull);
      });
    });

    group('TripListNotifier', () {
      test('should be properly initialized', () {
        final tripNotifier = container.read(tripListNotifierProvider.notifier);
        expect(tripNotifier, isNotNull);
      });

      test('should have trip repository', () {
        final tripRepository = container.read(tripRepositoryProvider);
        expect(tripRepository, isNotNull);
      });
    });

    group('ActivityListNotifier', () {
      test('should be properly initialized', () {
        const tripId = 'trip_1';
        final activityNotifier =
            container.read(activityListNotifierProvider(tripId).notifier);
        expect(activityNotifier, isNotNull);
      });

      test('should have activity repository', () {
        final activityRepository = container.read(activityRepositoryProvider);
        expect(activityRepository, isNotNull);
      });
    });

    group('ActivityGroupsNotifier', () {
      test('should be properly initialized', () {
        const tripId = 'trip_1';
        final activityGroupsNotifier =
            container.read(activityGroupsNotifierProvider(tripId).notifier);
        expect(activityGroupsNotifier, isNotNull);
      });
    });

    group('Provider Integration', () {
      test('should have all required providers available', () {
        // Auth providers
        expect(container.read(authRepositoryProvider), isNotNull);
        expect(container.read(authNotifierProvider.notifier), isNotNull);
        expect(container.read(errorNotifierProvider.notifier), isNotNull);

        // Trip providers
        expect(container.read(tripRepositoryProvider), isNotNull);
        expect(container.read(tripListNotifierProvider.notifier), isNotNull);

        // Activity providers
        expect(container.read(activityRepositoryProvider), isNotNull);
        expect(container.read(activityListNotifierProvider('test').notifier),
            isNotNull);
        expect(container.read(activityGroupsNotifierProvider('test').notifier),
            isNotNull);
      });
    });
  });
}
