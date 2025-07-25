import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/activity.dart';
import '../../utils/time_slot_utils.dart';
import '../../providers/activity_provider.dart';
import '../common/time_slot_picker.dart';

/// A card widget that displays an activity with its time slot
class TimeSlotActivityCard extends ConsumerWidget {
  final Activity activity;
  final bool isDragging;
  final bool isPlaceholder;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TimeSlotActivityCard({
    super.key,
    required this.activity,
    this.isDragging = false,
    this.isPlaceholder = false,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Card(
      elevation: isDragging ? 8 : 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: isPlaceholder 
          ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.5)
          : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Time slot display
              Container(
                width: 80,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: activity.timeSlot != null 
                      ? colorScheme.primaryContainer
                      : colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: activity.timeSlot != null 
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      activity.timeSlot != null 
                          ? TimeSlotUtils.formatTimeSlot(activity.timeSlot!)
                          : 'No time',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: activity.timeSlot != null 
                            ? colorScheme.onPrimaryContainer
                            : colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Activity details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.place,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isPlaceholder 
                            ? colorScheme.onSurface.withValues(alpha: 0.5)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      activity.activityType,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isPlaceholder 
                            ? colorScheme.onSurface.withValues(alpha: 0.5)
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (activity.price != null && activity.price!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        activity.price!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    if (activity.brainstormIdeas.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            size: 14,
                            color: colorScheme.tertiary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${activity.brainstormIdeas.length} ideas',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.tertiary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              
              // Action buttons
              if (!isPlaceholder) ...[
                const SizedBox(width: 8),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Time edit button
                    IconButton(
                      onPressed: () => _showTimeSlotPicker(context, ref),
                      icon: Icon(
                        Icons.schedule,
                        size: 20,
                        color: colorScheme.primary,
                      ),
                      tooltip: 'Set time',
                      visualDensity: VisualDensity.compact,
                    ),
                    
                    // More options menu
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case 'edit':
                            onEdit?.call();
                            break;
                          case 'delete':
                            onDelete?.call();
                            break;
                          case 'remove_time':
                            _removeTimeSlot(ref);
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 18),
                              SizedBox(width: 8),
                              Text('Edit activity'),
                            ],
                          ),
                        ),
                        if (activity.timeSlot != null)
                          const PopupMenuItem(
                            value: 'remove_time',
                            child: Row(
                              children: [
                                Icon(Icons.schedule_outlined, size: 18),
                                SizedBox(width: 8),
                                Text('Remove time'),
                              ],
                            ),
                          ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 18, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Delete', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                      icon: Icon(
                        Icons.more_vert,
                        size: 20,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showTimeSlotPicker(BuildContext context, WidgetRef ref) async {
    final currentTime = activity.timeSlot != null 
        ? TimeSlotUtils.timeSlotToTimeOfDay(activity.timeSlot!)
        : TimeOfDay.now();
    
    final selectedTime = await showDialog<TimeOfDay>(
      context: context,
      builder: (context) => TimeSlotPicker(
        initialTime: currentTime,
        title: 'Set time for ${activity.place}',
      ),
    );
    
    if (selectedTime != null) {
      final timeSlot = TimeSlotUtils.timeOfDayToTimeSlot(selectedTime);
      await _updateTimeSlot(ref, timeSlot);
    }
  }

  Future<void> _updateTimeSlot(WidgetRef ref, String timeSlot) async {
    try {
      await ref.read(activityListNotifierProvider(activity.tripId).notifier)
          .updateActivityTimeSlot(activity.id, timeSlot);
    } catch (e) {
      // Handle error - could show a snackbar or error dialog
      debugPrint('Error updating time slot: $e');
    }
  }

  Future<void> _removeTimeSlot(WidgetRef ref) async {
    try {
      await ref.read(activityListNotifierProvider(activity.tripId).notifier)
          .updateActivityTimeSlot(activity.id, null);
    } catch (e) {
      // Handle error
      debugPrint('Error removing time slot: $e');
    }
  }
}