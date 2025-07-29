import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/activity.dart';

class TripDetailUtils {
  /// Groups activities by their assigned day
  static Map<String, List<Activity>> groupActivitiesByDay(List<Activity> activities) {
    final Map<String, List<Activity>> grouped = {};
    for (final activity in activities) {
      if (activity.assignedDay != null) {
        grouped.putIfAbsent(activity.assignedDay!, () => []).add(activity);
      }
    }

    // Sort activities within each day
    for (final dayActivities in grouped.values) {
      dayActivities.sort((a, b) => (a.dayOrder ?? 0).compareTo(b.dayOrder ?? 0));
    }

    return grouped;
  }

  /// Gets unassigned activities (activity pool)
  static List<Activity> getUnassignedActivities(List<Activity> activities) {
    return activities.where((a) => a.assignedDay == null).toList();
  }

  /// Generates day keys for a trip
  static List<String> generateDayKeys(int durationDays) {
    return List.generate(durationDays, (index) => 'day-${index + 1}');
  }

  /// Formats date for display
  static String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Navigation helpers
  static void navigateToCreateActivity(BuildContext context, String tripId) {
    context.goNamed(
      'activity-create',
      pathParameters: {'tripId': tripId},
    );
  }

  static void navigateToActivity(BuildContext context, String tripId, Activity activity) {
    context.goNamed(
      'activity-detail',
      pathParameters: {
        'tripId': tripId,
        'activityId': activity.id,
      },
    );
  }

  static void navigateToEditActivity(BuildContext context, String tripId, Activity activity) {
    context.goNamed(
      'activity-edit',
      pathParameters: {
        'tripId': tripId,
        'activityId': activity.id,
      },
    );
  }
}