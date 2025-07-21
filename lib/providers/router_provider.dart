import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/user.dart';
import '../screens/auth/auth_screen.dart';
import '../screens/trips/trip_list_screen.dart';
import '../screens/trips/trip_detail_screen.dart';
import '../screens/trips/trip_create_screen.dart';
import '../screens/activities/activity_detail_screen.dart';
import '../screens/activities/activity_create_screen.dart';
import 'auth_provider.dart';

part 'router_provider.g.dart';

@riverpod
GoRouter router(Ref ref) {
  // Create a stream controller to notify router of auth changes
  final authStreamController = StreamController<User?>.broadcast();
  
  // Listen to auth state changes and forward to our controller
  ref.listen(authStateProvider, (previous, next) {
    next.when(
      data: (user) => authStreamController.add(user),
      loading: () => {},
      error: (error, stack) => {},
    );
  });
  
  return GoRouter(
    initialLocation: '/trips',
    redirect: (context, state) {
      // Get current auth state
      final authState = ref.read(authNotifierProvider);
      final isAuthenticated = authState.value != null;
      final isAuthRoute = state.matchedLocation.startsWith('/auth');
      
      // If not authenticated and not on auth route, redirect to auth
      if (!isAuthenticated && !isAuthRoute) {
        return '/auth';
      }
      
      // If authenticated and on auth route, redirect to trips
      if (isAuthenticated && isAuthRoute) {
        return '/trips';
      }
      
      // No redirect needed
      return null;
    },
    refreshListenable: _GoRouterRefreshStream(authStreamController.stream),
    routes: [
      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/trips',
        name: 'trips',
        builder: (context, state) => const TripListScreen(),
        routes: [
          GoRoute(
            path: '/create',
            name: 'trip-create',
            builder: (context, state) => const TripCreateScreen(),
          ),
          GoRoute(
            path: '/:tripId',
            name: 'trip-detail',
            builder: (context, state) {
              final tripId = state.pathParameters['tripId']!;
              return TripDetailScreen(tripId: tripId);
            },
            routes: [
              GoRoute(
                path: '/activities/create',
                name: 'activity-create',
                builder: (context, state) {
                  final tripId = state.pathParameters['tripId']!;
                  return ActivityCreateScreen(tripId: tripId);
                },
              ),
              GoRoute(
                path: '/activities/:activityId',
                name: 'activity-detail',
                builder: (context, state) {
                  final tripId = state.pathParameters['tripId']!;
                  final activityId = state.pathParameters['activityId']!;
                  return ActivityDetailScreen(
                    tripId: tripId,
                    activityId: activityId,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

/// Helper class to make GoRouter refresh when auth state changes
class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(Stream<User?> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (User? _) => notifyListeners(),
    );
  }

  late final StreamSubscription<User?> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
