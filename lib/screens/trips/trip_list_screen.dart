import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_planner/models/app_error.dart';
import '../../providers/auth_provider.dart';
import '../../providers/trip_provider.dart';
import '../../models/trip.dart';

class TripListScreen extends ConsumerWidget {
  const TripListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsAsync = ref.watch(tripListNotifierProvider);
    final errorState = ref.watch(errorNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Trips'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authNotifierProvider.notifier).signOut();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Error display
          if (errorState != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      errorState.when(
                        network: (message) => message,
                        authentication: (message) => message,
                        permission: (message) => message,
                        validation: (message) => message,
                        unknown: (message) => message,
                      ),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                    onPressed: () {
                      ref.read(errorNotifierProvider.notifier).clearError();
                    },
                  ),
                ],
              ),
            ),
          // Trips list
          Expanded(
            child: tripsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
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
                      'Failed to load trips',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please try again later',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              data: (trips) {
                if (trips.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.luggage_outlined,
                          size: 64,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No trips yet',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Create your first trip to get started',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: trips.length,
                  itemBuilder: (context, index) {
                    final trip = trips[index];
                    return _TripCard(
                      trip: trip,
                      onTap: () {
                        context.goNamed(
                          'trip-detail',
                          pathParameters: {'tripId': trip.id},
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.goNamed('trip-create');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TripCard extends StatelessWidget {
  const _TripCard({
    required this.trip,
    required this.onTap,
  });

  final Trip trip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      trip.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${trip.durationDays} ${trip.durationDays == 1 ? 'day' : 'days'}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  const SizedBox(width: 16),
                  if (trip.collaboratorIds.isNotEmpty) ...[
                    Icon(
                      Icons.group,
                      size: 16,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${trip.collaboratorIds.length + 1} ${trip.collaboratorIds.length + 1 == 1 ? 'person' : 'people'}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Updated ${_formatDate(trip.updatedAt)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'just now';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}