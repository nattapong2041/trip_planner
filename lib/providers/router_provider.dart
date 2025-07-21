import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../screens/auth/auth_screen.dart';
import '../screens/trips/trip_list_screen.dart';

part 'router_provider.g.dart';

@riverpod
GoRouter router(Ref ref) {
  // This will be enhanced with auth state later
  return GoRouter(
    initialLocation: '/auth',
    routes: [
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/trips',
        builder: (context, state) => const TripListScreen(),
      ),
    ],
  );
}
