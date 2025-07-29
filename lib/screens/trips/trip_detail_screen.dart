import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/trip_provider.dart';
import '../../utils/responsive.dart';
import '../../widgets/common/responsive_error_display.dart';
import '../../widgets/trip/trip_detail_views.dart';

class TripDetailScreen extends ConsumerWidget {
  const TripDetailScreen({
    super.key,
    required this.tripId,
  });

  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripAsync = ref.watch(tripDetailNotifierProvider(tripId));

    return tripAsync.when(
      loading: () => const Scaffold(
        body: ResponsiveLoadingIndicator(message: 'Loading trip details...'),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text('Trip Details')),
        body: ResponsiveErrorDisplay(
          error: error,
          title: 'Failed to load trip',
          onRetry: () => context.pop(),
        ),
      ),
      data: (trip) {
        if (trip == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Trip Details')),
            body: const Center(
              child: Text('Trip not found'),
            ),
          );
        }

        return ResponsiveBuilder(
          mobile: MobileTripDetailView(trip: trip, tripId: tripId),
          tablet: TabletTripDetailView(trip: trip, tripId: tripId),
          desktop: DesktopTripDetailView(trip: trip, tripId: tripId),
        );
      },
    );
  }
}
