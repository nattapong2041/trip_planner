import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/activity.dart';
import '../../providers/activity_provider.dart';
import '../../providers/trip_detail_providers.dart';
import '../../utils/responsive.dart';
import '../../utils/trip_detail_utils.dart';
import '../activity/enhanced_draggable_activity_card.dart';
import 'day_timeline_view.dart';

class CollapsibleDaySection extends ConsumerWidget {
  const CollapsibleDaySection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.activities,
    required this.isEmpty,
    required this.dayKey,
    required this.tripId,
    required this.isActivityPool,
    required this.isCollapsible,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final List<Activity> activities;
  final bool isEmpty;
  final String? dayKey;
  final String tripId;
  final bool isActivityPool;
  final bool isCollapsible;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCollapsed = isCollapsible && dayKey != null
        ? ref.watch(dayCollapseNotifierProvider)[dayKey!] ?? false
        : false;

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, ref, isCollapsed),
          _buildContent(context, ref, isCollapsed),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, bool isCollapsed) {
    return InkWell(
      onTap: isCollapsible && dayKey != null
          ? () => ref.read(dayCollapseNotifierProvider.notifier).toggleDay(dayKey!)
          : null,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(Responsive.getSpacing(context)),
        child: Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: Responsive.getIconSize(context, baseSize: 20),
            ),
            SizedBox(width: Responsive.getSpacing(context, baseSpacing: 8.0)),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Spacer(),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
            if (isCollapsible) ...[
              SizedBox(width: Responsive.getSpacing(context, baseSpacing: 8.0)),
              Icon(
                isCollapsed ? Icons.expand_more : Icons.expand_less,
                color: Theme.of(context).colorScheme.outline,
                size: Responsive.getIconSize(context, baseSize: 20),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, bool isCollapsed) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 300),
      crossFadeState: isCollapsed
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
      firstChild: Padding(
        padding: EdgeInsets.fromLTRB(
          Responsive.getSpacing(context),
          0,
          Responsive.getSpacing(context),
          Responsive.getSpacing(context),
        ),
        child: _buildDragTarget(context, ref),
      ),
      secondChild: const SizedBox.shrink(),
    );
  }

  Widget _buildDragTarget(BuildContext context, WidgetRef ref) {
    return EnhancedDragTarget(
      onAccept: (activity) => _handleActivityDrop(context, ref, activity),
      child: _buildActivityList(context, ref),
    );
  }

  Widget _buildActivityList(BuildContext context, WidgetRef ref) {
    final isTimelineView = ref.watch(timelineViewNotifierProvider);

    if (isEmpty) {
      return _buildEmptyState(context);
    }

    if (isActivityPool) {
      return _buildActivityPool(context);
    }

    // Use timeline view for days when enabled
    if (isTimelineView && dayKey != null) {
      return DayTimelineView(
        tripId: tripId,
        day: dayKey!,
        showTimeSlots: true,
        onActivityTap: (activity) => TripDetailUtils.navigateToActivity(context, tripId, activity),
        onActivityEdit: (activity) => TripDetailUtils.navigateToEditActivity(context, tripId, activity),
        onActivityDelete: (activity) => _showDeleteActivityDialog(context, ref, activity),
      );
    }

    return _buildReorderableList(context, ref);
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 80),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActivityPool ? Icons.inventory_2_outlined : Icons.add_circle_outline,
              size: Responsive.getIconSize(context, baseSize: 24),
              color: Theme.of(context).colorScheme.outline,
            ),
            SizedBox(height: Responsive.getSpacing(context, baseSpacing: 4.0)),
            Text(
              isActivityPool
                  ? 'Drag activities here to unassign'
                  : 'Drag activities here to plan',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityPool(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: activities
          .map((activity) => Padding(
                padding: EdgeInsets.only(
                  bottom: Responsive.getSpacing(context, baseSpacing: 8.0),
                ),
                child: EnhancedDraggableActivityCard(
                  activity: activity,
                  onTap: () => TripDetailUtils.navigateToActivity(context, tripId, activity),
                  showDragHandle: true,
                ),
              ))
          .toList(),
    );
  }

  Widget _buildReorderableList(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: activities.length,
          onReorder: (oldIndex, newIndex) => _handleReorder(ref, oldIndex, newIndex),
          itemBuilder: (context, index) {
            final activity = activities[index];
            return Padding(
              key: ValueKey(activity.id),
              padding: EdgeInsets.only(
                bottom: Responsive.getSpacing(context, baseSpacing: 8.0),
              ),
              child: EnhancedDraggableActivityCard(
                activity: activity,
                onTap: () => TripDetailUtils.navigateToActivity(context, tripId, activity),
                showDragHandle: true,
              ),
            );
          },
        ),
      ],
    );
  }

  void _showDeleteActivityDialog(BuildContext context, WidgetRef ref, Activity activity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Activity'),
        content: Text('Are you sure you want to delete "${activity.place}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () => _handleDeleteActivity(context, ref, activity),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleDeleteActivity(BuildContext context, WidgetRef ref, Activity activity) async {
    try {
      await ref.read(activityListNotifierProvider(tripId).notifier).deleteActivity(activity.id);
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${activity.place} deleted successfully'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (error) {
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete activity: $error'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _handleActivityDrop(BuildContext context, WidgetRef ref, Activity activity) async {
    try {
      if (isActivityPool) {
        await ref.read(activityListNotifierProvider(tripId).notifier).moveActivityToPool(activity.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${activity.place} moved to activity pool'),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(Responsive.getSpacing(context, baseSpacing: 8.0)),
            ),
          );
        }
      } else {
        final newOrder = activities.length;
        await ref.read(activityListNotifierProvider(tripId).notifier).moveActivityBetweenDays(
              activity.id,
              activity.assignedDay,
              dayKey!,
              newOrder,
            );
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${activity.place} moved to $title'),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(Responsive.getSpacing(context, baseSpacing: 8.0)),
            ),
          );
        }
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to move activity: ${error.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(Responsive.getSpacing(context, baseSpacing: 8.0)),
          ),
        );
      }
    }
  }

  void _handleReorder(WidgetRef ref, int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final reorderedActivities = List<Activity>.from(activities);
    final activity = reorderedActivities.removeAt(oldIndex);
    reorderedActivities.insert(newIndex, activity);

    try {
      await ref.read(activityListNotifierProvider(tripId).notifier).reorderActivitiesInDay(dayKey!, reorderedActivities);
    } catch (error) {
      // Error handling is done in the provider
    }
  }
}