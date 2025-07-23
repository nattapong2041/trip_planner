import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/trip_provider.dart';
import '../../providers/activity_provider.dart';
import '../../models/trip.dart';
import '../../models/activity.dart';
import '../../utils/responsive.dart';
import '../../utils/responsive_gestures.dart';
import '../../widgets/activity/enhanced_draggable_activity_card.dart';
import '../../widgets/common/responsive_error_display.dart';

class ResponsiveTripDetailScreen extends ConsumerWidget {
  const ResponsiveTripDetailScreen({
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
          mobile: _MobileTripDetailView(trip: trip, tripId: tripId),
          tablet: _TabletTripDetailView(trip: trip, tripId: tripId),
          desktop: _DesktopTripDetailView(trip: trip, tripId: tripId),
        );
      },
    );
  }
}

class _MobileTripDetailView extends ConsumerWidget {
  const _MobileTripDetailView({
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
          _TripMenuButton(trip: trip),
        ],
      ),
      body: Column(
        children: [
          _TripInfoHeader(trip: trip),
          Expanded(
            child: activitiesAsync.when(
              loading: () => const ResponsiveLoadingIndicator(message: 'Loading activities...'),
              error: (error, stackTrace) => ResponsiveErrorDisplay(
                error: error,
                title: 'Failed to load activities',
                onRetry: () => ref.refresh(activityListNotifierProvider(tripId)),
              ),
              data: (activities) => _MobileTripDaysView(
                trip: trip,
                activities: activities,
                tripId: tripId,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreateActivity(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToCreateActivity(BuildContext context) {
    context.goNamed(
      'activity-create',
      pathParameters: {'tripId': tripId},
    );
  }
}

class _TabletTripDetailView extends ConsumerWidget {
  const _TabletTripDetailView({
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
          _TripMenuButton(trip: trip),
        ],
      ),
      body: ResponsiveContainer(
        child: Column(
          children: [
            _TripInfoHeader(trip: trip),
            Expanded(
              child: activitiesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => _ErrorView(error: error),
                data: (activities) => _TabletTripDaysView(
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
        onPressed: () => _navigateToCreateActivity(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Activity'),
      ),
    );
  }

  void _navigateToCreateActivity(BuildContext context) {
    context.goNamed(
      'activity-create',
      pathParameters: {'tripId': tripId},
    );
  }
}

class _DesktopTripDetailView extends ConsumerWidget {
  const _DesktopTripDetailView({
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
            onPressed: () => _navigateToCreateActivity(context),
            icon: const Icon(Icons.add),
            label: const Text('Add Activity'),
          ),
          const SizedBox(width: 8),
          _TripMenuButton(trip: trip),
        ],
      ),
      body: ResponsiveContainer(
        child: Column(
          children: [
            _TripInfoHeader(trip: trip),
            Expanded(
              child: activitiesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => _ErrorView(error: error),
                data: (activities) => _DesktopTripDaysView(
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

  void _navigateToCreateActivity(BuildContext context) {
    context.goNamed(
      'activity-create',
      pathParameters: {'tripId': tripId},
    );
  }
}

class _TripInfoHeader extends StatelessWidget {
  const _TripInfoHeader({required this.trip});

  final Trip trip;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Responsive.getSpacing(context)),
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
                size: Responsive.getIconSize(context, baseSize: 20),
              ),
              SizedBox(width: Responsive.getSpacing(context, baseSpacing: 8.0)),
              Text(
                '${trip.durationDays} ${trip.durationDays == 1 ? 'day' : 'days'}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              if (trip.collaboratorIds.isNotEmpty) ...[
                Icon(
                  Icons.group,
                  color: Theme.of(context).colorScheme.primary,
                  size: Responsive.getIconSize(context, baseSize: 20),
                ),
                SizedBox(width: Responsive.getSpacing(context, baseSpacing: 4.0)),
                Text(
                  '${trip.collaboratorIds.length + 1}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ],
          ),
          SizedBox(height: Responsive.getSpacing(context, baseSpacing: 8.0)),
          Text(
            'Created ${_formatDate(trip.createdAt)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _TripMenuButton extends ConsumerWidget {
  const _TripMenuButton({required this.trip});

  final Trip trip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
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
              SizedBox(width: Responsive.getSpacing(context, baseSpacing: 8.0)),
              const Text('Edit Trip'),
            ],
          ),
          content: SizedBox(
            width: Responsive.getDialogWidth(context),
            child: Form(
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
                  SizedBox(height: Responsive.getSpacing(context)),
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
                    SizedBox(height: Responsive.getSpacing(context)),
                    const LinearProgressIndicator(),
                  ],
                ],
              ),
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
                              SizedBox(width: Responsive.getSpacing(context, baseSpacing: 8.0)),
                              const Text('Trip updated successfully!'),
                            ],
                          ),
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.all(Responsive.getSpacing(context, baseSpacing: 8.0)),
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
                              SizedBox(width: Responsive.getSpacing(context, baseSpacing: 8.0)),
                              Expanded(
                                child: Text('Failed to update trip: ${error.toString()}'),
                              ),
                            ],
                          ),
                          backgroundColor: Theme.of(context).colorScheme.error,
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.all(Responsive.getSpacing(context, baseSpacing: 8.0)),
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
                  SizedBox(width: Responsive.getSpacing(context, baseSpacing: 8.0)),
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
              SizedBox(width: Responsive.getSpacing(context, baseSpacing: 8.0)),
              const Text('Delete Trip'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Are you sure you want to delete "${trip.name}"?'),
              SizedBox(height: Responsive.getSpacing(context, baseSpacing: 8.0)),
              Text(
                'This action cannot be undone.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              if (isLoading) ...[
                SizedBox(height: Responsive.getSpacing(context)),
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
                            SizedBox(width: Responsive.getSpacing(context, baseSpacing: 8.0)),
                            const Text('Trip deleted successfully'),
                          ],
                        ),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.all(Responsive.getSpacing(context, baseSpacing: 8.0)),
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
                            SizedBox(width: Responsive.getSpacing(context, baseSpacing: 8.0)),
                            Expanded(
                              child: Text('Failed to delete trip: ${error.toString()}'),
                            ),
                          ],
                        ),
                        backgroundColor: Theme.of(context).colorScheme.error,
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.all(Responsive.getSpacing(context, baseSpacing: 8.0)),
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
                  SizedBox(width: Responsive.getSpacing(context, baseSpacing: 8.0)),
                  const Text('Delete'),
                ],
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

// Mobile layout - single column with drag and drop
class _MobileTripDaysView extends ConsumerWidget {
  const _MobileTripDaysView({
    required this.trip,
    required this.activities,
    required this.tripId,
  });

  final Trip trip;
  final List<Activity> activities;
  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupedActivities = _groupActivitiesByDay(activities);
    final unassignedActivities = activities.where((a) => a.assignedDay == null).toList();

    return ListView(
      padding: EdgeInsets.all(Responsive.getSpacing(context)),
      children: [
        // Activity Pool
        _ResponsiveDaySection(
          title: 'Activity Pool',
          subtitle: unassignedActivities.isEmpty 
              ? 'No unassigned activities'
              : '${unassignedActivities.length} ${unassignedActivities.length == 1 ? 'activity' : 'activities'}',
          icon: Icons.inventory_2_outlined,
          activities: unassignedActivities,
          isEmpty: unassignedActivities.isEmpty,
          dayKey: null,
          tripId: tripId,
          isActivityPool: true,
        ),
        SizedBox(height: Responsive.getSpacing(context)),
        
        // Day sections
        ...List.generate(trip.durationDays, (index) {
          final dayNumber = index + 1;
          final dayKey = 'day-$dayNumber';
          final dayActivities = groupedActivities[dayKey] ?? [];
          
          return Padding(
            padding: EdgeInsets.only(
              bottom: Responsive.getSpacing(context),
            ),
            child: _ResponsiveDaySection(
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
            ),
          );
        }),
      ],
    );
  }

  Map<String, List<Activity>> _groupActivitiesByDay(List<Activity> activities) {
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
}

// Tablet layout - two columns
class _TabletTripDaysView extends ConsumerWidget {
  const _TabletTripDaysView({
    required this.trip,
    required this.activities,
    required this.tripId,
  });

  final Trip trip;
  final List<Activity> activities;
  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupedActivities = _groupActivitiesByDay(activities);
    final unassignedActivities = activities.where((a) => a.assignedDay == null).toList();

    return Row(
      children: [
        // Left column - Activity Pool
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.all(Responsive.getSpacing(context)),
            child: _ResponsiveDaySection(
              title: 'Activity Pool',
              subtitle: unassignedActivities.isEmpty 
                  ? 'No unassigned activities'
                  : '${unassignedActivities.length} ${unassignedActivities.length == 1 ? 'activity' : 'activities'}',
              icon: Icons.inventory_2_outlined,
              activities: unassignedActivities,
              isEmpty: unassignedActivities.isEmpty,
              dayKey: null,
              tripId: tripId,
              isActivityPool: true,
            ),
          ),
        ),
        
        // Right column - Days
        Expanded(
          flex: 2,
          child: ListView(
            padding: EdgeInsets.all(Responsive.getSpacing(context)),
            children: List.generate(trip.durationDays, (index) {
              final dayNumber = index + 1;
              final dayKey = 'day-$dayNumber';
              final dayActivities = groupedActivities[dayKey] ?? [];
              
              return Padding(
                padding: EdgeInsets.only(
                  bottom: Responsive.getSpacing(context),
                ),
                child: _ResponsiveDaySection(
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
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Map<String, List<Activity>> _groupActivitiesByDay(List<Activity> activities) {
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
}

// Desktop layout - three columns with enhanced features
class _DesktopTripDaysView extends ConsumerWidget {
  const _DesktopTripDaysView({
    required this.trip,
    required this.activities,
    required this.tripId,
  });

  final Trip trip;
  final List<Activity> activities;
  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupedActivities = _groupActivitiesByDay(activities);
    final unassignedActivities = activities.where((a) => a.assignedDay == null).toList();

    return Row(
      children: [
        // Left sidebar - Activity Pool
        SizedBox(
          width: Responsive.getSidebarWidth(context),
          child: Padding(
            padding: EdgeInsets.all(Responsive.getSpacing(context)),
            child: _ResponsiveDaySection(
              title: 'Activity Pool',
              subtitle: unassignedActivities.isEmpty 
                  ? 'No unassigned activities'
                  : '${unassignedActivities.length} ${unassignedActivities.length == 1 ? 'activity' : 'activities'}',
              icon: Icons.inventory_2_outlined,
              activities: unassignedActivities,
              isEmpty: unassignedActivities.isEmpty,
              dayKey: null,
              tripId: tripId,
              isActivityPool: true,
            ),
          ),
        ),
        
        // Main content - Days in grid
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.all(Responsive.getSpacing(context)),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: Responsive.getSpacing(context),
              mainAxisSpacing: Responsive.getSpacing(context),
              childAspectRatio: 0.8,
            ),
            itemCount: trip.durationDays,
            itemBuilder: (context, index) {
              final dayNumber = index + 1;
              final dayKey = 'day-$dayNumber';
              final dayActivities = groupedActivities[dayKey] ?? [];
              
              return _ResponsiveDaySection(
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
              );
            },
          ),
        ),
      ],
    );
  }

  Map<String, List<Activity>> _groupActivitiesByDay(List<Activity> activities) {
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
}

// Responsive day section with enhanced touch support
class _ResponsiveDaySection extends ConsumerWidget {
  const _ResponsiveDaySection({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.activities,
    required this.isEmpty,
    required this.dayKey,
    required this.tripId,
    required this.isActivityPool,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final List<Activity> activities;
  final bool isEmpty;
  final String? dayKey;
  final String tripId;
  final bool isActivityPool;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(Responsive.getSpacing(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
              ],
            ),
            SizedBox(height: Responsive.getSpacing(context, baseSpacing: 12.0)),
            _buildDragTarget(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildDragTarget(BuildContext context, WidgetRef ref) {
    return EnhancedDragTarget(
      onAccept: (activity) => _handleActivityDrop(context, ref, activity),
      child: _buildActivityList(context, ref),
    );
  }

  Widget _buildActivityList(BuildContext context, WidgetRef ref) {
    if (isEmpty) {
      return SizedBox(
        height: 80,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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

    if (isActivityPool) {
      return Column(
        children: activities.map((activity) => Padding(
          padding: EdgeInsets.only(
            bottom: Responsive.getSpacing(context, baseSpacing: 8.0),
          ),
          child: EnhancedDraggableActivityCard(
            activity: activity,
            onTap: () => _navigateToActivity(context, activity),
            showDragHandle: true,
          ),
        )).toList(),
      );
    } else {
      return ReorderableListView.builder(
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
              onTap: () => _navigateToActivity(context, activity),
              showDragHandle: true,
            ),
          );
        },
      );
    }
  }

  void _navigateToActivity(BuildContext context, Activity activity) {
    context.goNamed(
      'activity-detail',
      pathParameters: {
        'tripId': tripId,
        'activityId': activity.id,
      },
    );
  }

  void _handleActivityDrop(BuildContext context, WidgetRef ref, Activity activity) async {
    try {
      if (isActivityPool) {
        await ref.read(activityListNotifierProvider(tripId).notifier)
            .moveActivityToPool(activity.id);
        
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
        await ref.read(activityListNotifierProvider(tripId).notifier)
            .moveActivityBetweenDays(activity.id, activity.assignedDay, dayKey!, newOrder);
        
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
      await ref.read(activityListNotifierProvider(tripId).notifier)
          .reorderActivitiesInDay(dayKey!, reorderedActivities);
    } catch (error) {
      // Error handling is done in the provider
    }
  }
}

