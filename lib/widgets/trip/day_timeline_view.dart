import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/activity.dart';
import '../../utils/time_slot_utils.dart';
import '../../providers/activity_provider.dart';
import '../activity/time_slot_activity_card.dart';
import '../activity/enhanced_draggable_activity_card.dart';

/// A timeline view that displays activities for a specific day in chronological order
class DayTimelineView extends ConsumerWidget {
  final String tripId;
  final String day;
  final bool showTimeSlots;
  final Function(Activity)? onActivityTap;
  final Function(Activity)? onActivityEdit;
  final Function(Activity)? onActivityDelete;

  const DayTimelineView({
    super.key,
    required this.tripId,
    required this.day,
    this.showTimeSlots = true,
    this.onActivityTap,
    this.onActivityEdit,
    this.onActivityDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activitiesAsync = ref.watch(activityListNotifierProvider(tripId));
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return activitiesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error loading activities: $error'),
      ),
      data: (activities) {
        // Filter activities for this day
        final dayActivities = activities
            .where((activity) => activity.assignedDay == day)
            .toList();

        if (dayActivities.isEmpty) {
          return _buildEmptyDayView(context);
        }

        // Separate timed and untimed activities
        final separatedActivities = TimeSlotUtils.separateActivitiesByTime(dayActivities);
        final timedActivities = separatedActivities['timed']!;
        final untimedActivities = separatedActivities['untimed']!;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Day header
              _buildDayHeader(context, day, dayActivities.length),
              
              const SizedBox(height: 16),
              
              // Timeline for timed activities
              if (timedActivities.isNotEmpty && showTimeSlots) ...[
                Text(
                  'Scheduled Activities',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 12),
                _buildTimeline(context, timedActivities),
                
                if (untimedActivities.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                ],
              ],
              
              // Untimed activities section
              if (untimedActivities.isNotEmpty) ...[
                Text(
                  timedActivities.isNotEmpty ? 'Unscheduled Activities' : 'Activities',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 12),
                ...untimedActivities.map((activity) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: showTimeSlots
                      ? TimeSlotActivityCard(
                          activity: activity,
                          onTap: () => onActivityTap?.call(activity),
                        )
                      : EnhancedDraggableActivityCard(
                          activity: activity,
                          onTap: () => onActivityTap?.call(activity),
                        ),
                )),
              ],
              
              // Add activity prompt
              const SizedBox(height: 16),
              _buildAddActivityPrompt(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDayHeader(BuildContext context, String day, int activityCount) {
    final theme = Theme.of(context);
    final dayNumber = day.split('-').last;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.primaryContainer.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                dayNumber,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Day $dayNumber',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$activityCount ${activityCount == 1 ? 'activity' : 'activities'}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(BuildContext context, List<Activity> timedActivities) {
    return Column(
      children: timedActivities.asMap().entries.map((entry) {
        final index = entry.key;
        final activity = entry.value;
        final isLast = index == timedActivities.length - 1;
        
        return _buildTimelineItem(context, activity, isLast);
      }).toList(),
    );
  }

  Widget _buildTimelineItem(BuildContext context, Activity activity, bool isLast) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 60,
                  color: colorScheme.outline.withValues(alpha: 0.3),
                ),
            ],
          ),
          
          const SizedBox(width: 16),
          
          // Activity card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TimeSlotActivityCard(
                activity: activity,
                onTap: () => onActivityTap?.call(activity),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyDayView(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_available,
              size: 64,
              color: colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No activities planned',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Drag activities from the pool or create new ones',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddActivityPrompt(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.3),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.add_circle_outline,
            size: 32,
            color: colorScheme.primary,
          ),
          const SizedBox(height: 8),
          Text(
            'Add more activities',
            style: theme.textTheme.titleSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Drag from activity pool or create new activities',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// A compact version of the day timeline for use in overview screens
class CompactDayTimelineView extends ConsumerWidget {
  final String tripId;
  final String day;
  final int maxActivities;

  const CompactDayTimelineView({
    super.key,
    required this.tripId,
    required this.day,
    this.maxActivities = 3,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activitiesAsync = ref.watch(activityListNotifierProvider(tripId));
    final theme = Theme.of(context);
    
    return activitiesAsync.when(
      loading: () => const SizedBox(
        height: 60,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => SizedBox(
        height: 60,
        child: Center(child: Text('Error: $error')),
      ),
      data: (activities) {
        final dayActivities = activities
            .where((activity) => activity.assignedDay == day)
            .toList();
        
        if (dayActivities.isEmpty) {
          return SizedBox(
            height: 60,
            child: Center(
              child: Text(
                'No activities',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          );
        }
        
        final separatedActivities = TimeSlotUtils.separateActivitiesByTime(dayActivities);
        final timedActivities = separatedActivities['timed']!;
        final untimedActivities = separatedActivities['untimed']!;
        
        // Show timed activities first, then untimed
        final displayActivities = [
          ...timedActivities,
          ...untimedActivities,
        ].take(maxActivities).toList();
        
        final hasMore = dayActivities.length > maxActivities;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...displayActivities.map((activity) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  if (activity.timeSlot != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        TimeSlotUtils.formatTimeSlot(activity.timeSlot!),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Text(
                      activity.place,
                      style: theme.textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            )),
            if (hasMore)
              Text(
                '+${dayActivities.length - maxActivities} more',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
          ],
        );
      },
    );
  }
}