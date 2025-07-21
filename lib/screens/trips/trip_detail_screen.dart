import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/trip_provider.dart';
import '../../providers/activity_provider.dart';
import '../../models/trip.dart';
import '../../models/activity.dart';

class TripDetailScreen extends ConsumerWidget {
  const TripDetailScreen({
    super.key,
    required this.tripId,
  });

  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripAsync = ref.watch(tripDetailNotifierProvider(tripId));
    final activitiesAsync = ref.watch(activityListNotifierProvider(tripId));

    return tripAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text('Trip Details')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to load trip',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
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

        return Scaffold(
          appBar: AppBar(
            title: Text(trip.name),
            actions: [
              PopupMenuButton<String>(
                onSelected: (value) => _handleMenuAction(context, ref, value, trip),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        SizedBox(width: 8),
                        Text('Edit Trip'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete Trip', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: Column(
            children: [
              // Trip Info Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${trip.durationDays} ${trip.durationDays == 1 ? 'day' : 'days'}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const Spacer(),
                        if (trip.collaboratorIds.isNotEmpty) ...[
                          Icon(
                            Icons.group,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${trip.collaboratorIds.length + 1}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Created ${_formatDate(trip.createdAt)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
              // Day-by-day structure
              Expanded(
                child: activitiesAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 32,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Failed to load activities',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  data: (activities) => _TripDaysView(
                    trip: trip,
                    activities: activities,
                    onActivityTap: (activity) {
                      context.goNamed(
                        'activity-detail',
                        pathParameters: {
                          'tripId': tripId,
                          'activityId': activity.id,
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // TODO: Navigate to create activity screen (will be implemented in later tasks)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Activity creation will be implemented in later tasks'),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  void _handleMenuAction(BuildContext context, WidgetRef ref, String action, Trip trip) {
    switch (action) {
      case 'edit':
        _showEditTripDialog(context, ref, trip);
        break;
      case 'delete':
        _showDeleteTripDialog(context, ref, trip);
        break;
    }
  }

  void _showEditTripDialog(BuildContext context, WidgetRef ref, Trip trip) {
    final nameController = TextEditingController(text: trip.name);
    final durationController = TextEditingController(text: trip.durationDays.toString());
    final formKey = GlobalKey<FormState>();
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.edit),
              const SizedBox(width: 8),
              const Text('Edit Trip'),
            ],
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Trip Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.label),
                  ),
                  enabled: !isLoading,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a trip name';
                    }
                    if (value.trim().length < 2) {
                      return 'Trip name must be at least 2 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: durationController,
                  decoration: const InputDecoration(
                    labelText: 'Duration (days)',
                    border: OutlineInputBorder(),
                    suffixText: 'days',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  keyboardType: TextInputType.number,
                  enabled: !isLoading,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter trip duration';
                    }
                    final duration = int.tryParse(value);
                    if (duration == null || duration <= 0) {
                      return 'Please enter a valid number of days';
                    }
                    if (duration > 365) {
                      return 'Trip duration cannot exceed 365 days';
                    }
                    return null;
                  },
                ),
                if (isLoading) ...[
                  const SizedBox(height: 16),
                  const LinearProgressIndicator(),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: isLoading ? null : () async {
                if (formKey.currentState!.validate()) {
                  setState(() {
                    isLoading = true;
                  });
                  
                  try {
                    final updatedTrip = trip.copyWith(
                      name: nameController.text.trim(),
                      durationDays: int.parse(durationController.text.trim()),
                      updatedAt: DateTime.now(),
                    );
                    
                    await ref.read(tripListNotifierProvider.notifier).updateTrip(updatedTrip);
                    
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                              const SizedBox(width: 8),
                              const Text('Trip updated successfully!'),
                            ],
                          ),
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          behavior: SnackBarBehavior.floating,
                          margin: const EdgeInsets.all(8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                      
                      // Refresh trip details
                      ref.invalidate(tripDetailNotifierProvider(trip.id));
                    }
                  } catch (error) {
                    if (context.mounted) {
                      setState(() {
                        isLoading = false;
                      });
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Theme.of(context).colorScheme.onError,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text('Failed to update trip: ${error.toString()}'),
                              ),
                            ],
                          ),
                          backgroundColor: Theme.of(context).colorScheme.error,
                          behavior: SnackBarBehavior.floating,
                          margin: const EdgeInsets.all(8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    }
                  }
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  isLoading 
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  const SizedBox(width: 8),
                  const Text('Save'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteTripDialog(BuildContext context, WidgetRef ref, Trip trip) {
    bool isLoading = false;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(width: 8),
              const Text('Delete Trip'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Are you sure you want to delete "${trip.name}"?'),
              const SizedBox(height: 8),
              Text(
                'This action cannot be undone.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              if (isLoading) ...[
                const SizedBox(height: 16),
                const LinearProgressIndicator(),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              onPressed: isLoading ? null : () async {
                setState(() {
                  isLoading = true;
                });
                
                try {
                  await ref.read(tripListNotifierProvider.notifier).deleteTrip(trip.id);
                  
                  if (context.mounted) {
                    Navigator.of(context).pop(); // Close dialog
                    context.pop(); // Go back to trip list
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            const SizedBox(width: 8),
                            const Text('Trip deleted successfully'),
                          ],
                        ),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  }
                } catch (error) {
                  if (context.mounted) {
                    setState(() {
                      isLoading = false;
                    });
                    
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Theme.of(context).colorScheme.onError,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text('Failed to delete trip: ${error.toString()}'),
                            ),
                          ],
                        ),
                        backgroundColor: Theme.of(context).colorScheme.error,
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  }
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  isLoading 
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Theme.of(context).colorScheme.onError,
                          ),
                        )
                      : const Icon(Icons.delete_forever),
                  const SizedBox(width: 8),
                  const Text('Delete'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _TripDaysView extends StatelessWidget {
  const _TripDaysView({
    required this.trip,
    required this.activities,
    required this.onActivityTap,
  });

  final Trip trip;
  final List<Activity> activities;
  final Function(Activity) onActivityTap;

  @override
  Widget build(BuildContext context) {
    // Group activities by day
    final Map<String, List<Activity>> activitiesByDay = {};
    final List<Activity> unassignedActivities = [];

    for (final activity in activities) {
      if (activity.assignedDay != null) {
        activitiesByDay.putIfAbsent(activity.assignedDay!, () => []).add(activity);
      } else {
        unassignedActivities.add(activity);
      }
    }

    // Sort activities within each day by dayOrder
    for (final dayActivities in activitiesByDay.values) {
      dayActivities.sort((a, b) => (a.dayOrder ?? 0).compareTo(b.dayOrder ?? 0));
    }

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Activity Pool (unassigned activities)
        if (unassignedActivities.isNotEmpty) ...[
          _DaySection(
            title: 'Activity Pool',
            subtitle: 'Unassigned activities',
            icon: Icons.inventory_2_outlined,
            activities: unassignedActivities,
            onActivityTap: onActivityTap,
            isEmpty: false,
          ),
          const SizedBox(height: 16),
        ],
        
        // Day sections
        ...List.generate(trip.durationDays, (index) {
          final dayNumber = index + 1;
          final dayKey = 'day-$dayNumber';
          final dayActivities = activitiesByDay[dayKey] ?? [];
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: _DaySection(
              title: 'Day $dayNumber',
              subtitle: dayActivities.isEmpty 
                  ? 'No activities planned'
                  : '${dayActivities.length} ${dayActivities.length == 1 ? 'activity' : 'activities'}',
              icon: Icons.today,
              activities: dayActivities,
              onActivityTap: onActivityTap,
              isEmpty: dayActivities.isEmpty,
            ),
          );
        }),
      ],
    );
  }
}

class _DaySection extends StatelessWidget {
  const _DaySection({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.activities,
    required this.onActivityTap,
    required this.isEmpty,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final List<Activity> activities;
  final Function(Activity) onActivityTap;
  final bool isEmpty;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
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
              ],
            ),
            if (isEmpty) ...[
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      size: 32,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add activities to get started',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              const SizedBox(height: 12),
              ...activities.map((activity) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: _ActivityCard(
                  activity: activity,
                  onTap: () => onActivityTap(activity),
                ),
              )),
            ],
          ],
        ),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({
    required this.activity,
    required this.onTap,
  });

  final Activity activity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.place,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          activity.activityType,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        if (activity.price != null && activity.price!.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Text(
                            '• ${activity.price}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              if (activity.brainstormIdeas.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${activity.brainstormIdeas.length}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}