import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/activity.dart';
import '../../providers/activity_provider.dart';
import '../../widgets/activity/activity_card.dart';
import '../../widgets/activity/activity_image_gallery.dart';
import '../../widgets/activity/reorderable_brainstorm_ideas.dart';
import '../../utils/responsive.dart';
import 'activity_edit_screen.dart';

class ActivityDetailScreen extends ConsumerStatefulWidget {
  const ActivityDetailScreen({
    super.key,
    required this.tripId,
    required this.activityId,
  });

  final String tripId;
  final String activityId;

  @override
  ConsumerState<ActivityDetailScreen> createState() => _ActivityDetailScreenState();
}

class _ActivityDetailScreenState extends ConsumerState<ActivityDetailScreen> {

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final activityAsync = ref.watch(activityDetailNotifierProvider(widget.activityId));

    return activityAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text('Activity Details')),
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
                'Failed to load activity',
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
      data: (activity) {
        if (activity == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Activity Details')),
            body: const Center(
              child: Text('Activity not found'),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(activity.place),
            actions: [
              if (Responsive.isLargeScreen(context))
                ElevatedButton.icon(
                  onPressed: () => _navigateToEdit(activity),
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                )
              else
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _navigateToEdit(activity),
                ),
              PopupMenuButton<String>(
                onSelected: (value) => _handleMenuAction(context, value, activity),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete Activity', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: ResponsiveContainer(
            child: ResponsiveBuilder(
              mobile: _buildMobileLayout(context, activity),
              tablet: _buildTabletLayout(context, activity),
              desktop: _buildDesktopLayout(context, activity),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMobileLayout(BuildContext context, Activity activity) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Activity Details Card
          Padding(
            padding: EdgeInsets.all(Responsive.getSpacing(context)),
            child: ActivityCard(
              activity: activity,
              showActions: false,
            ),
          ),
          
          // Image Gallery Section - Constrained height for mobile
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Responsive.getSpacing(context)),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 140, // Reduced from 160 to prevent overflow
                minHeight: 100,
              ),
              child: ActivityImageGallery(
                key: ValueKey('gallery_${activity.id}_${activity.images.length}'),
                activityId: activity.id,
                allowReordering: true,
                showAddButton: true,
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Brainstorm Ideas Section - Remove Expanded and let it size naturally
          _buildBrainstormSection(context, activity),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context, Activity activity) {
    return Row(
      children: [
        // Left side - Activity Details and Images
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(Responsive.getSpacing(context)),
              child: Column(
                children: [
                  // Activity Details Card
                  ActivityCard(
                    activity: activity,
                    showActions: false,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Image Gallery
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 160,
                      minHeight: 120,
                    ),
                    child: ActivityImageGallery(
                      key: ValueKey('gallery_tablet_${activity.id}_${activity.images.length}'),
                      activityId: activity.id,
                      allowReordering: true,
                      showAddButton: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // Right side - Brainstorm Ideas
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            child: _buildBrainstormSection(context, activity),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context, Activity activity) {
    return Row(
      children: [
        // Left side - Activity Details and Images (fixed width)
        SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(Responsive.getSpacing(context)),
              child: Column(
                children: [
                  // Activity Details Card
                  ActivityCard(
                    activity: activity,
                    showActions: false,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Image Gallery
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 160,
                      minHeight: 120,
                    ),
                    child: ActivityImageGallery(
                      key: ValueKey('gallery_desktop_${activity.id}_${activity.images.length}'),
                      activityId: activity.id,
                      allowReordering: true,
                      showAddButton: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // Right side - Brainstorm Ideas
        Expanded(
          child: SingleChildScrollView(
            child: _buildBrainstormSection(context, activity),
          ),
        ),
      ],
    );
  }

  Widget _buildBrainstormSection(BuildContext context, Activity activity) {
    return Padding(
      padding: EdgeInsets.all(Responsive.getSpacing(context)),
      child: ReorderableBrainstormIdeas(
        activity: activity,
        allowReordering: true,
        allowEditing: true,
      ),
    );
  }



  void _navigateToEdit(Activity activity) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ActivityEditScreen(
          tripId: widget.tripId,
          activity: activity,
        ),
      ),
    );
  }

  void _handleMenuAction(BuildContext context, String action, Activity activity) {
    switch (action) {
      case 'delete':
        _showDeleteActivityDialog(activity);
        break;
    }
  }

  void _showDeleteActivityDialog(Activity activity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.delete, color: Colors.red),
            SizedBox(width: 8),
            Text('Delete Activity'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to delete "${activity.place}"?'),
            const SizedBox(height: 8),
            const Text(
              'This action cannot be undone.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
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
            onPressed: () async {
              final navigator = Navigator.of(context);
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              final theme = Theme.of(context);
              final goRouter = GoRouter.of(context);
              
              try {
                await ref.read(activityListNotifierProvider(widget.tripId).notifier)
                    .deleteActivity(activity.id);
                
                if (mounted) {
                  navigator.pop(); // Close dialog
                  goRouter.pop(); // Go back to trip details
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: theme.colorScheme.onPrimary,
                          ),
                          const SizedBox(width: 8),
                          const Text('Activity deleted successfully'),
                        ],
                      ),
                      backgroundColor: theme.colorScheme.primary,
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                }
              } catch (error) {
                if (mounted) {
                  navigator.pop();
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text('Failed to delete activity: ${error.toString()}'),
                      backgroundColor: theme.colorScheme.error,
                    ),
                  );
                }
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }


}

