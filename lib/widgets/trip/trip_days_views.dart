import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/activity.dart';
import '../../models/trip.dart';
import '../../providers/trip_detail_providers.dart';
import '../../utils/responsive.dart';
import '../../utils/trip_detail_utils.dart';
import 'collapsible_day_section.dart';

class MobileTripDaysView extends ConsumerWidget {
  const MobileTripDaysView({
    super.key,
    required this.trip,
    required this.activities,
    required this.tripId,
  });

  final Trip trip;
  final List<Activity> activities;
  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupedActivities = TripDetailUtils.groupActivitiesByDay(activities);
    final unassignedActivities = TripDetailUtils.getUnassignedActivities(activities);

    return ListView(
      padding: EdgeInsets.all(Responsive.getSpacing(context)),
      children: [
        _buildActivityPool(context, unassignedActivities),
        SizedBox(height: Responsive.getSpacing(context)),
        _buildCollapseExpandButtons(context, ref),
        ..._buildDaySections(context, groupedActivities),
      ],
    );
  }

  Widget _buildActivityPool(BuildContext context, List<Activity> unassignedActivities) {
    return CollapsibleDaySection(
      title: 'Activity Pool',
      subtitle: unassignedActivities.isEmpty
          ? null
          : '${unassignedActivities.length} ${unassignedActivities.length == 1 ? 'activity' : 'activities'}',
      icon: Icons.inventory_2_outlined,
      activities: unassignedActivities,
      isEmpty: unassignedActivities.isEmpty,
      dayKey: null,
      tripId: tripId,
      isActivityPool: true,
      isCollapsible: false,
    );
  }

  Widget _buildCollapseExpandButtons(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(bottom: Responsive.getSpacing(context)),
      child: Row(
        children: [
          TextButton.icon(
            onPressed: () {
              final dayKeys = TripDetailUtils.generateDayKeys(trip.durationDays);
              ref.read(dayCollapseNotifierProvider.notifier).expandAll(dayKeys);
            },
            icon: const Icon(Icons.expand_more),
            label: const Text('Expand All'),
          ),
          const SizedBox(width: 8),
          TextButton.icon(
            onPressed: () {
              final dayKeys = TripDetailUtils.generateDayKeys(trip.durationDays);
              ref.read(dayCollapseNotifierProvider.notifier).collapseAll(dayKeys);
            },
            icon: const Icon(Icons.expand_less),
            label: const Text('Collapse All'),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDaySections(BuildContext context, Map<String, List<Activity>> groupedActivities) {
    return List.generate(trip.durationDays, (index) {
      final dayNumber = index + 1;
      final dayKey = 'day-$dayNumber';
      final dayActivities = groupedActivities[dayKey] ?? [];

      return Padding(
        padding: EdgeInsets.only(bottom: Responsive.getSpacing(context)),
        child: CollapsibleDaySection(
          title: 'Day $dayNumber',
          subtitle: dayActivities.isEmpty
              ? 'No activities planned'
              : '${dayActivities.length} ${dayActivities.length == 1 ? 'activity' : 'activities'}',
          icon: Icons.today,
          activities: dayActivities,
          isEmpty: dayActivities.isEmpty,
          dayKey: dayKey,
          tripId: tripId,
          isActivityPool: false,
          isCollapsible: true,
        ),
      );
    });
  }
}

class TabletTripDaysView extends ConsumerWidget {
  const TabletTripDaysView({
    super.key,
    required this.trip,
    required this.activities,
    required this.tripId,
  });

  final Trip trip;
  final List<Activity> activities;
  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupedActivities = TripDetailUtils.groupActivitiesByDay(activities);
    final unassignedActivities = TripDetailUtils.getUnassignedActivities(activities);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildActivityPoolColumn(context, unassignedActivities),
        _buildDaysColumn(context, groupedActivities),
      ],
    );
  }

  Widget _buildActivityPoolColumn(BuildContext context, List<Activity> unassignedActivities) {
    return Expanded(
      flex: 1,
      child: Container(
        height: double.infinity,
        padding: EdgeInsets.all(Responsive.getSpacing(context)),
        child: CollapsibleDaySection(
          title: 'Activity Pool',
          subtitle: unassignedActivities.isEmpty
              ? null
              : '${unassignedActivities.length} ${unassignedActivities.length == 1 ? 'activity' : 'activities'}',
          icon: Icons.inventory_2_outlined,
          activities: unassignedActivities,
          isEmpty: unassignedActivities.isEmpty,
          dayKey: null,
          tripId: tripId,
          isActivityPool: true,
          isCollapsible: false,
        ),
      ),
    );
  }

  Widget _buildDaysColumn(BuildContext context, Map<String, List<Activity>> groupedActivities) {
    return Expanded(
      flex: 2,
      child: ListView(
        padding: EdgeInsets.all(Responsive.getSpacing(context)),
        children: List.generate(trip.durationDays, (index) {
          final dayNumber = index + 1;
          final dayKey = 'day-$dayNumber';
          final dayActivities = groupedActivities[dayKey] ?? [];

          return Padding(
            padding: EdgeInsets.only(bottom: Responsive.getSpacing(context)),
            child: CollapsibleDaySection(
              title: 'Day $dayNumber',
              subtitle: dayActivities.isEmpty
                  ? 'No activities planned'
                  : '${dayActivities.length} ${dayActivities.length == 1 ? 'activity' : 'activities'}',
              icon: Icons.today,
              activities: dayActivities,
              isEmpty: dayActivities.isEmpty,
              dayKey: dayKey,
              tripId: tripId,
              isActivityPool: false,
              isCollapsible: true,
            ),
          );
        }),
      ),
    );
  }
}

class DesktopTripDaysView extends ConsumerWidget {
  const DesktopTripDaysView({
    super.key,
    required this.trip,
    required this.activities,
    required this.tripId,
  });

  final Trip trip;
  final List<Activity> activities;
  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupedActivities = TripDetailUtils.groupActivitiesByDay(activities);
    final unassignedActivities = TripDetailUtils.getUnassignedActivities(activities);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildActivityPoolSidebar(context, unassignedActivities),
        _buildMainContent(context, ref, groupedActivities),
      ],
    );
  }

  Widget _buildActivityPoolSidebar(BuildContext context, List<Activity> unassignedActivities) {
    return Expanded(
      flex: 1,
      child: Container(
        height: double.infinity,
        padding: EdgeInsets.all(Responsive.getSpacing(context)),
        child: CollapsibleDaySection(
          title: 'Activity Pool',
          subtitle: unassignedActivities.isEmpty
              ? null
              : '${unassignedActivities.length} ${unassignedActivities.length == 1 ? 'activity' : 'activities'}',
          icon: Icons.inventory_2_outlined,
          activities: unassignedActivities,
          isEmpty: unassignedActivities.isEmpty,
          dayKey: null,
          tripId: tripId,
          isActivityPool: true,
          isCollapsible: false,
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, WidgetRef ref, Map<String, List<Activity>> groupedActivities) {
    return Expanded(
      flex: 2,
      child: ListView(
        padding: EdgeInsets.all(Responsive.getSpacing(context)),
        children: [
          _buildCollapseExpandButtons(context, ref),
          ..._buildDaySections(context, groupedActivities),
        ],
      ),
    );
  }

  Widget _buildCollapseExpandButtons(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(bottom: Responsive.getSpacing(context)),
      child: Row(
        children: [
          TextButton.icon(
            onPressed: () {
              final dayKeys = TripDetailUtils.generateDayKeys(trip.durationDays);
              ref.read(dayCollapseNotifierProvider.notifier).expandAll(dayKeys);
            },
            icon: const Icon(Icons.expand_more),
            label: const Text('Expand All'),
          ),
          const SizedBox(width: 8),
          TextButton.icon(
            onPressed: () {
              final dayKeys = TripDetailUtils.generateDayKeys(trip.durationDays);
              ref.read(dayCollapseNotifierProvider.notifier).collapseAll(dayKeys);
            },
            icon: const Icon(Icons.expand_less),
            label: const Text('Collapse All'),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDaySections(BuildContext context, Map<String, List<Activity>> groupedActivities) {
    return List.generate(trip.durationDays, (index) {
      final dayNumber = index + 1;
      final dayKey = 'day-$dayNumber';
      final dayActivities = groupedActivities[dayKey] ?? [];

      return Padding(
        padding: EdgeInsets.only(bottom: Responsive.getSpacing(context)),
        child: CollapsibleDaySection(
          title: 'Day $dayNumber',
          subtitle: dayActivities.isEmpty
              ? 'No activities planned'
              : '${dayActivities.length} ${dayActivities.length == 1 ? 'activity' : 'activities'}',
          icon: Icons.today,
          activities: dayActivities,
          isEmpty: dayActivities.isEmpty,
          dayKey: dayKey,
          tripId: tripId,
          isActivityPool: false,
          isCollapsible: true,
        ),
      );
    });
  }
}