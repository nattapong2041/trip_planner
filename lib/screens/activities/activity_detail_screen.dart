import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/activity.dart';
import '../../models/brainstorm_idea.dart';
import '../../providers/activity_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/activity/activity_card.dart';
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
  final TextEditingController _brainstormController = TextEditingController();
  bool _isAddingIdea = false;

  @override
  void dispose() {
    _brainstormController.dispose();
    super.dispose();
  }

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
    return Column(
      children: [
        // Activity Details Card
        Padding(
          padding: EdgeInsets.all(Responsive.getSpacing(context)),
          child: ActivityCard(
            activity: activity,
            showActions: false,
          ),
        ),
        
        // Brainstorm Ideas Section
        Expanded(
          child: _buildBrainstormSection(context, activity),
        ),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context, Activity activity) {
    return Row(
      children: [
        // Left side - Activity Details
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.all(Responsive.getSpacing(context)),
            child: ActivityCard(
              activity: activity,
              showActions: false,
            ),
          ),
        ),
        
        // Right side - Brainstorm Ideas
        Expanded(
          flex: 2,
          child: _buildBrainstormSection(context, activity),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context, Activity activity) {
    return Row(
      children: [
        // Left side - Activity Details (fixed width)
        SizedBox(
          width: 400,
          child: Padding(
            padding: EdgeInsets.all(Responsive.getSpacing(context)),
            child: ActivityCard(
              activity: activity,
              showActions: false,
            ),
          ),
        ),
        
        // Right side - Brainstorm Ideas
        Expanded(
          child: _buildBrainstormSection(context, activity),
        ),
      ],
    );
  }

  Widget _buildBrainstormSection(BuildContext context, Activity activity) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.getSpacing(context),
          ),
          child: Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: Theme.of(context).colorScheme.primary,
                size: Responsive.getIconSize(context, baseSize: 20),
              ),
              SizedBox(width: Responsive.getSpacing(context, baseSpacing: 8.0)),
              Text(
                'Brainstorm Ideas',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '${activity.brainstormIdeas.length}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: Responsive.getSpacing(context)),
        
        // Add Brainstorm Idea Input
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.getSpacing(context),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _brainstormController,
                  decoration: const InputDecoration(
                    hintText: 'Add a brainstorm idea...',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lightbulb_outline),
                  ),
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _addBrainstormIdea(),
                  enabled: !_isAddingIdea,
                ),
              ),
              SizedBox(width: Responsive.getSpacing(context, baseSpacing: 8.0)),
              IconButton(
                onPressed: _isAddingIdea ? null : _addBrainstormIdea,
                icon: _isAddingIdea
                    ? SizedBox(
                        width: Responsive.getIconSize(context, baseSize: 20),
                        height: Responsive.getIconSize(context, baseSize: 20),
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send),
              ),
            ],
          ),
        ),
        SizedBox(height: Responsive.getSpacing(context)),
        
        // Brainstorm Ideas List
        Expanded(
          child: activity.brainstormIdeas.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        size: Responsive.getIconSize(context, baseSize: 48),
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      SizedBox(height: Responsive.getSpacing(context)),
                      Text(
                        'No brainstorm ideas yet',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      SizedBox(height: Responsive.getSpacing(context, baseSpacing: 8.0)),
                      Text(
                        'Add ideas to help plan this activity',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                )
              : _buildBrainstormList(context, activity),
        ),
      ],
    );
  }

  Widget _buildBrainstormList(BuildContext context, Activity activity) {
    if (Responsive.isLargeScreen(context)) {
      // Grid layout for larger screens
      return GridView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.getSpacing(context),
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: Responsive.isDesktop(context) ? 2 : 1,
          crossAxisSpacing: Responsive.getSpacing(context),
          mainAxisSpacing: Responsive.getSpacing(context, baseSpacing: 8.0),
          childAspectRatio: 4,
        ),
        itemCount: activity.brainstormIdeas.length,
        itemBuilder: (context, index) {
          final idea = activity.brainstormIdeas[index];
          return _BrainstormIdeaCard(
            idea: idea,
            onDelete: () => _deleteBrainstormIdea(idea.id),
          );
        },
      );
    } else {
      // List layout for mobile
      return ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.getSpacing(context),
        ),
        itemCount: activity.brainstormIdeas.length,
        itemBuilder: (context, index) {
          final idea = activity.brainstormIdeas[index];
          return Padding(
            padding: EdgeInsets.only(
              bottom: Responsive.getSpacing(context, baseSpacing: 8.0),
            ),
            child: _BrainstormIdeaCard(
              idea: idea,
              onDelete: () => _deleteBrainstormIdea(idea.id),
            ),
          );
        },
      );
    }
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
              try {
                await ref.read(activityListNotifierProvider(widget.tripId).notifier)
                    .deleteActivity(activity.id);
                
                if (mounted) {
                  Navigator.of(context).pop(); // Close dialog
                  context.pop(); // Go back to trip details
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          const SizedBox(width: 8),
                          const Text('Activity deleted successfully'),
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
                if (mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to delete activity: ${error.toString()}'),
                      backgroundColor: Theme.of(context).colorScheme.error,
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

  Future<void> _addBrainstormIdea() async {
    final description = _brainstormController.text.trim();
    if (description.isEmpty) return;

    setState(() {
      _isAddingIdea = true;
    });

    try {
      await ref.read(activityListNotifierProvider(widget.tripId).notifier)
          .addBrainstormIdea(widget.activityId, description);
      
      _brainstormController.clear();
      
      // Refresh the activity details
      ref.invalidate(activityDetailNotifierProvider(widget.activityId));
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add idea: ${error.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAddingIdea = false;
        });
      }
    }
  }

  Future<void> _deleteBrainstormIdea(String ideaId) async {
    try {
      await ref.read(activityListNotifierProvider(widget.tripId).notifier)
          .removeBrainstormIdea(widget.activityId, ideaId);
      
      // Refresh the activity details
      ref.invalidate(activityDetailNotifierProvider(widget.activityId));
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete idea: ${error.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}

class _BrainstormIdeaCard extends ConsumerWidget {
  const _BrainstormIdeaCard({
    required this.idea,
    required this.onDelete,
  });

  final BrainstormIdea idea;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authNotifierProvider).value;
    final canDelete = currentUser?.id == idea.createdBy;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(Responsive.getSpacing(context, baseSpacing: 12.0)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.lightbulb_outline,
              color: Theme.of(context).colorScheme.primary,
              size: Responsive.getIconSize(context, baseSize: 20),
            ),
            SizedBox(width: Responsive.getSpacing(context, baseSpacing: 12.0)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    idea.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: Responsive.getSpacing(context, baseSpacing: 4.0)),
                  Text(
                    'Added ${_formatDate(idea.createdAt)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
            if (canDelete) ...[
              SizedBox(width: Responsive.getSpacing(context, baseSpacing: 8.0)),
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  size: Responsive.getIconSize(context, baseSize: 20),
                ),
                onPressed: onDelete,
                color: Theme.of(context).colorScheme.error,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }
}