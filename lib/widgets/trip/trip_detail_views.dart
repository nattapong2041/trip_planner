import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/trip.dart';
import '../../providers/activity_provider.dart';
import '../../utils/responsive.dart';
import '../../utils/trip_detail_utils.dart';
import '../common/responsive_error_display.dart';
import 'timeline_toggle_button.dart';
import 'trip_info_header.dart';
import 'trip_menu_button.dart';
import 'trip_days_views.dart';

class MobileTripDetailView extends ConsumerWidget {
  const MobileTripDetailView({
    super.key,
    required this.trip,
    required this.tripId,
  });

  final Trip trip;
  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activitiesAsync = ref.watch(activityListNotifierProvider(tripId));

    return Scaffold(
      appBar: AppBar(
        title: Text(trip.name),
        actions: [
          const TimelineToggleButton(),
          TripMenuButton(trip: trip),
        ],
      ),
      body: Column(
        children: [
          TripInfoHeader(trip: trip),
          Expanded(
            child: activitiesAsync.when(
              loading: () => const ResponsiveLoadingIndicator(message: 'Loading activities...'),
              error: (error, stackTrace) => ResponsiveErrorDisplay(
                error: error,
                title: 'Failed to load activities',
                onRetry: () => ref.refresh(activityListNotifierProvider(tripId)),
              ),
              data: (activities) => MobileTripDaysView(
                trip: trip,
                activities: activities,
                tripId: tripId,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => TripDetailUtils.navigateToCreateActivity(context, tripId),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TabletTripDetailView extends ConsumerWidget {
  const TabletTripDetailView({
    super.key,
    required this.trip,
    required this.tripId,
  });

  final Trip trip;
  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activitiesAsync = ref.watch(activityListNotifierProvider(tripId));

    return Scaffold(
      appBar: AppBar(
        title: Text(trip.name),
        actions: [
          const TimelineToggleButton(),
          TripMenuButton(trip: trip),
        ],
      ),
      body: ResponsiveContainer(
        child: Column(
          children: [
            TripInfoHeader(trip: trip),
            Expanded(
              child: activitiesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => _ErrorView(error: error),
                data: (activities) => TabletTripDaysView(
                  trip: trip,
                  activities: activities,
                  tripId: tripId,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => TripDetailUtils.navigateToCreateActivity(context, tripId),
        icon: const Icon(Icons.add),
        label: const Text('Add Activity'),
      ),
    );
  }
}

class DesktopTripDetailView extends ConsumerWidget {
  const DesktopTripDetailView({
    super.key,
    required this.trip,
    required this.tripId,
  });

  final Trip trip;
  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activitiesAsync = ref.watch(activityListNotifierProvider(tripId));

    return Scaffold(
      appBar: AppBar(
        title: Text(trip.name),
        actions: [
          ElevatedButton.icon(
            onPressed: () => TripDetailUtils.navigateToCreateActivity(context, tripId),
            icon: const Icon(Icons.add),
            label: const Text('Add Activity'),
          ),
          const SizedBox(width: 8),
          const TimelineToggleButton(),
          TripMenuButton(trip: trip),
        ],
      ),
      body: ResponsiveContainer(
        child: Column(
          children: [
            TripInfoHeader(trip: trip),
            Expanded(
              child: activitiesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => _ErrorView(error: error),
                data: (activities) => DesktopTripDaysView(
                  trip: trip,
                  activities: activities,
                  tripId: tripId,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: Responsive.getIconSize(context, baseSize: 32),
            color: Theme.of(context).colorScheme.error,
          ),
          SizedBox(height: Responsive.getSpacing(context, baseSpacing: 8.0)),
          Text(
            'Failed to load activities',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}