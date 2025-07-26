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
import '../screens/debug/offline_test_screen.dart';
import 'auth_provider.dart';

part 'router_provider.g.dart';

@riverpod
GoRouter router(Ref ref) {
  // Create a stream controller to notify router of auth changes
  final authStreamController = StreamController<User?>.broadcast();
  
  // Listen to auth state changes and forward to our controller
  ref.listen(authNotifierProvider, (previous, next) {
    next.when(
      data: (user) => authStreamController.add(user),
      loading: () => {},
      error: (error, stack) => authStreamController.add(null),
    );
  });
  
  return GoRouter(
    initialLocation: '/auth',
    redirect: (context, state) {
      try {
        // Get current auth state
        final authState = ref.read(authNotifierProvider);
        
        // Handle loading state - don't redirect while loading
        if (authState.isLoading) {
          return null;
        }
        
        // Handle error state - redirect to auth on auth errors
        if (authState.hasError) {
          return '/auth';
        }
        
        // Check if user is authenticated
        final isAuthenticated = authState.hasValue && authState.value != null;
        final currentLocation = state.matchedLocation;
        final isAuthRoute = currentLocation == '/auth';
        
        // Authentication guards
        if (!isAuthenticated) {
          // User is not authenticated
          if (!isAuthRoute) {
            // Redirect to auth screen if trying to access protected routes
            return '/auth';
          }
          // Already on auth screen, no redirect needed
          return null;
        } else {
          // User is authenticated
          if (isAuthRoute) {
            // Redirect authenticated users away from auth screen
            return '/trips';
          }
          
          // Check if trying to access protected routes
          if (_isProtectedRoute(currentLocation)) {
            // User is authenticated and accessing protected route - allow
            return null;
          }
          
          // For any other routes, allow access
          return null;
        }
      } catch (error) {
        // If there's an error in redirect logic, default to auth
        if (kDebugMode) {
          print('Router redirect error: $error');
        }
        return '/auth';
      }
    },
    refreshListenable: _GoRouterRefreshStream(authStreamController.stream),
    errorBuilder: (context, state) {
      // Handle navigation errors
      return const AuthScreen();
    },
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
      GoRoute(
        path: '/debug/offline-test',
        name: 'offline-test',
        builder: (context, state) => const OfflineTestScreen(),
      ),
    ],
  );
}

/// Helper function to check if a route requires authentication
bool _isProtectedRoute(String location) {
  // All routes except auth are protected
  const publicRoutes = ['/auth'];
  
  // Check if the location starts with any public route
  for (final route in publicRoutes) {
    if (location.startsWith(route)) {
      return false;
    }
  }
  
  return true;
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
