import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/trip_provider.dart';
import '../../models/trip.dart';
import '../../utils/responsive.dart';
import '../../widgets/common/responsive_error_display.dart';

class TripListScreen extends ConsumerWidget {
  const TripListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsAsync = ref.watch(tripListNotifierProvider);

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
      body: ResponsiveContainer(
        child: tripsAsync.when(
          loading: () => const ResponsiveLoadingIndicator(message: 'Loading trips...'),
          error: (error, stackTrace) => ResponsiveErrorDisplay(
            error: error,
            title: 'Failed to load trips',
            onRetry: () => ref.invalidate(tripListNotifierProvider),
          ),
          data: (trips) {
            if (trips.isEmpty) {
              return const ResponsiveEmptyState(
                title: 'No trips yet',
                message: 'Create your first trip to get started',
                icon: Icons.luggage_outlined,
              );
            }

            return _ResponsiveTripsList(trips: trips);
          },
        ),
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

class _ResponsiveTripsList extends StatelessWidget {
  const _ResponsiveTripsList({required this.trips});

  final List<Trip> trips;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      mobile: _buildMobileLayout(context),
      tablet: _buildTabletLayout(context),
      desktop: _buildDesktopLayout(context),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(Responsive.getSpacing(context)),
      itemCount: trips.length,
      itemBuilder: (context, index) {
        final trip = trips[index];
        return Padding(
          padding: EdgeInsets.only(
            bottom: Responsive.getSpacing(context, baseSpacing: 12.0),
          ),
          child: _TripCard(
            trip: trip,
            onTap: () => _navigateToTrip(context, trip.id),
          ),
        );
      },
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(Responsive.getSpacing(context)),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: Responsive.getSpacing(context),
        mainAxisSpacing: Responsive.getSpacing(context),
        childAspectRatio: 1.5,
      ),
      itemCount: trips.length,
      itemBuilder: (context, index) {
        final trip = trips[index];
        return _TripCard(
          trip: trip,
          onTap: () => _navigateToTrip(context, trip.id),
          isCompact: true,
        );
      },
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(Responsive.getSpacing(context)),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: Responsive.getSpacing(context),
        mainAxisSpacing: Responsive.getSpacing(context),
        childAspectRatio: 1.3,
      ),
      itemCount: trips.length,
      itemBuilder: (context, index) {
        final trip = trips[index];
        return _TripCard(
          trip: trip,
          onTap: () => _navigateToTrip(context, trip.id),
          isCompact: true,
        );
      },
    );
  }

  void _navigateToTrip(BuildContext context, String tripId) {
    context.goNamed(
      'trip-detail',
      pathParameters: {'tripId': tripId},
    );
  }
}

class _TripCard extends StatelessWidget {
  const _TripCard({
    required this.trip,
    required this.onTap,
    this.isCompact = false,
  });

  final Trip trip;
  final VoidCallback onTap;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: EdgeInsets.all(Responsive.getSpacing(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      trip.name,
                      style: Theme.of(context).textTheme.titleLarge,
                      maxLines: isCompact ? 2 : null,
                      overflow: isCompact ? TextOverflow.ellipsis : null,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: Responsive.getIconSize(context, baseSize: 16),
                  ),
                ],
              ),
              SizedBox(height: Responsive.getSpacing(context, baseSpacing: 8.0)),
              Wrap(
                spacing: Responsive.getSpacing(context),
                runSpacing: Responsive.getSpacing(context, baseSpacing: 4.0),
                children: [
                  _InfoChip(
                    icon: Icons.calendar_today,
                    label: '${trip.durationDays} ${trip.durationDays == 1 ? 'day' : 'days'}',
                  ),
                  if (trip.collaboratorIds.isNotEmpty)
                    _InfoChip(
                      icon: Icons.group,
                      label: '${trip.collaboratorIds.length + 1} ${trip.collaboratorIds.length + 1 == 1 ? 'person' : 'people'}',
                    ),
                ],
              ),
              if (!isCompact) ...[
                SizedBox(height: Responsive.getSpacing(context, baseSpacing: 8.0)),
                Text(
                  'Updated ${_formatDate(trip.updatedAt)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
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

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: Responsive.getIconSize(context, baseSize: 16),
          color: Theme.of(context).colorScheme.outline,
        ),
        SizedBox(width: Responsive.getSpacing(context, baseSpacing: 4.0)),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      ],
    );
  }
}